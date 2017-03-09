function [R_value, R_loc, Q_value, Q_loc, S_value, S_loc, J_value, J_loc, T_value, T_loc, P_value, P_loc, RR, PR, QT, BPM, tqrs, trr, tpr, tqt] = ecg_extraction(data,fs)
%This function is used to extract features of ECG
%Input:
%   data:   ECG signal
%   fs:     sample frequency
%Output:
%   R_value, R_loc: value and location of R peak
%   Q_value, Q_loc: value and location of Q peak
%   S_value, S_loc: value and location of S peak
%   J_value, J_loc: value and location of J peak
%   T_value, T_loc: value and location of T peak
%   P_value, P_loc: value and location of P peak
%   RR:             RR interval
%   PR:             PR segment
%   QT:             QT segment
%   BPM:            Beat per min
%   tqrs:           duration of QRS complex
%   trr:            duration of RR interval
%   tpr:            duration of PR segment
%   tqt:            duration of QT segment

d=data;
Fs = fs;
t=[0:length(d)-1]/Fs;

need_to_remove = [];

if isrow(d) == 0
    d = d';
end

%% ============================ filter baseline ===========================
[a b]=butter(5,[0.5 40]/(Fs/2));
c = filtfilt(a,b,d);
c = c + abs(min(c));
c = c / max(c);
%% ============================ bandpass filter =========================== 

%LPF
b=[1 0 0 0 0 0 -2 0 0 0 0 0 1];
a=[1 -2 1];
h_LP=filter(b,a,[1 zeros(1,12)]);

x2 = conv (c ,h_LP);
x2 = x2 (6+[1: length(d)]); %cancle delay
x2 = x2 / max(x2);

%HPF
b = [-1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 -32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
a = [1 -1];

h_HP=filter(b,a,[1 zeros(1,32)]); % impulse response of HPF
 
x3 = conv (x2 ,h_HP);
x3 = x3 (16+[1: length(d)]); %cancle delay
x3 = x3 / max(x3);

%% ======================== Make impulse response =========================
h = [-1 -2 0 2 1]/8;

% Apply filter
x4 = conv (c ,h);
x4 = x4 (2+[1: length(d)]);
x4 = x4 / max(x4);

%% ============================== Squaring ================================ 
x5 = x4 .^2;
x5 = x5/ max( abs(x5 ));

%% ======================= Make impulse response ========================== 
h = ones (1 ,31)/31;
Delay = 15; % Delay in samples

% Apply filter
x6 = conv (x5 ,h);
x6 = x6 (15+[1: length(d)]);
x6 = x6 / max(x6);

max_h = max(x6);
thresh = mean (x6 );
poss_reg =(x6>thresh*max_h);

left = find(diff([0 poss_reg])==1);
right = find(diff([poss_reg 0])==-1);

%% ============= R peak detection and rejection the fail peak =============
% ====== detect R peak ======
for i=1:length(left)
    
    [R_value(i) R_loc(i)] = max(c(left(i):right(i)) );
    R_loc(i) = R_loc(i) - 1 + left(i); % add offset
end

% ====== reject fail peak ======
for i = 5:length(R_loc)
    value1 = (R_loc(i - 2) - R_loc(i - 3)) / (R_loc(i - 3) - R_loc(i - 4));
    value2 = (R_loc(i - 1) - R_loc(i - 3)) / (R_loc(i - 3) - R_loc(i - 4));
    value3 = (R_loc(i) - R_loc(i - 1)) / (R_loc(i - 3) - R_loc(i - 4));
    if value1 < 0.5 && abs(value2 - value3) < 0.75
             need_to_remove(end + 1) = i;
    end;
end;

R_value(need_to_remove) = [];
R_loc(need_to_remove) = [];
left(need_to_remove) = [];
right(need_to_remove) = [];

%% =================== detect other peaks and interval ====================
for i = 1:length(R_loc)
    % ====== Q peak ======
    [Q_value(i) Q_loc(i)] = min(c(left(i):R_loc(i)) );
    Q_loc(i) = Q_loc(i) - 1 + left(i); % add offset

    % ====== S peak ======
    [S_value(i) S_loc(i)] = min(c(R_loc(i):right(i)) );
    S_loc(i) = S_loc(i) + R_loc(i); % add offset
    
    % ====== J point ======
    J_loc(i) = right(i);
    J_value(i) = c(J_loc(i));
    
    % ====== QRS duration ====== 
    tqrs(i) = (right(i)-left(i))/Fs;
    
    if i ~= 1
        % ====== RR interval ====== 
        RR(i-1) = R_loc(i)-R_loc(i-1);
        trr(i-1) = RR(i-1)/Fs;
        
        % ====== BPM (vent rate) ====== 
        BPM(i-1) = 60/trr(i-1);

        % ====== T peak ====== 
        [T_value(i-1) T_loc(i-1)] = max(c(floor(R_loc(i-1)+(0.15*RR(i-1))):floor(R_loc(i-1)+(0.55*RR(i-1)))));
        T_loc(i-1) = T_loc(i-1)+ R_loc(i-1) + floor(0.15*RR(i-1)); % add offset

        % ====== P peak ====== 
        [P_value(i-1) P_loc(i-1)] = max(c(floor(left(i) - 0.15*RR(i-1)):Q_loc(i)));
        P_loc(i-1) = P_loc(i-1) + floor(left(i) - 0.15*RR(i-1)); % add offset
        
        % ====== PR interval ====== 
        PR(i-1) = R_loc(i) - P_loc(i-1);
        tpr(i-1) = PR(i-1)/Fs;
        
        % ====== QT interval ====== 
        QT(i-1) = (T_loc(i-1)+(trr(i-1)*0.13)-(Q_loc(i-1)-0.005*Fs));
        tqt(i-1) = QT(i-1)/Fs;
        tqt(i-1) = tqt(i-1)/(Fs*sqrt(trr(i-1)));
    end   
end

