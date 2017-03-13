warning('off','all');
clear all; close all; clc
%% ============================ Add path ==================================
data_path = 'E:\MY_THESIS\database\normal\';

%% ========================= Calling normal records =========================
recordings = [19140 19830];%[16483 16539 16773 16786 16795 17052 17453 19088 19090 19140 19830];
leads =      [00001 00001];%[00001 00001 00001 00001 00001 00001 00001 00001 00001 00001 00001];

%% ============================= PARAMETERS ===============================
PR_normal = [];
min_HRV_normal = [];
max_HRV_normal = [];
std_HRV_normal = [];
changed_HRV_normal = [];

R_value = []; R_loc = [];   % value and location of R peak
Q_value = []; Q_loc = [];   % value and location of Q peak
S_value = []; S_loc = [];   % value and location of S peak
J_value = []; J_loc = [];   % value and location of J peak
T_value = []; T_loc = [];   % value and location of T peak
P_value = []; P_loc = [];   % value and location of P peak
RR = [];                    % RR interval
PR = [];                    % PR segment
QT = [];                    % QT segment
BPM = [];                   % beat per min
tqrs = [];                  % duartion of QRS complex
trr = [];                   % duration of RR segment
tqr = [];                   % duration of QR segment
tqt = [];                   % duration of QT segment
PR_ratio = [];              % P/S ratio for checking arrhythmia

%% ============================= Processing ===============================
for record = 1:length(recordings)
    full_data = [];
    R_value_all = []; R_loc_all = [];   % value and location of R peak
    Q_value_all = []; Q_loc_all = [];   % value and location of Q peak
    S_value_all = []; S_loc_all = [];   % value and location of S peak
    J_value_all = []; J_loc_all = [];   % value and location of J peak
    T_value_all = []; T_loc_all = [];   % value and location of T peak
    P_value_all = []; P_loc_all = [];   % value and location of P peak
    RR_all = [];                    % RR interval
    PR_all = [];                    % PR segment
    QT_all = [];                    % QT segment
    HRV_all = [];                   % beat per min
    tqrs_all = [];                  % duartion of QRS complex
    trr_all = [];                   % duration of RR segment
    tpr_all = [];                   % duration of QR segment
    tqt_all = [];                   % duration of QT segment
    PR_ratio_all = [];
    
    filename = num2str(recordings(record));

    disp(filename);
    full_path = [data_path filename '.hea'];
    ECGw = ECGwrapper( 'recording_name', full_path);

    % ====== READ SIGANL AND ANNOTATION ======
    ann = ECGw.ECG_annotations;
    hea = ECGw.ECG_header;
    sig = ECGw.read_signal(1,hea.nsamp);
    sig1_raw = sig(:,leads(record));
    sig1_raw = sig1_raw;

    % ====== NORMALIZATION CODES ======
    sig1_raw = sig1_raw - mean(sig1_raw);
    L = length(sig1_raw);
    Ex = 1/L * sum(abs(sig1_raw).^2);
    sig1_raw = sig1_raw / Ex;

    % ====== BASELINE REMOVE USING Wavelet_decompose ======
    [approx, detail] = wavelet_decompose(sig1_raw, 8, 'db4');
    sig1 = sig1_raw - approx(:,8);
    %sig1 = sig1_raw;
    sig_backup = sig1;

    % ====== NORMALIZA THE SIGNAL FROM 0 TO 1 ======
    sig1 = sig1 + abs(min(sig1));
    sig1 = sig1 / max(sig1);

    % ====== GENERAL PARAMETERS ======
    fs = hea.freq;
    ts = 1/fs;
    t = [0:length(sig1)-1]/fs;
%------ LOAD ATTRIBUTES DATA ----------------------------------------------
    full_path = [data_path filename '.atr'];      % attribute file with annotation data
    fid3=fopen(full_path,'r');
    A= fread(fid3, [2, length(sig1)], 'uint8')';
    fclose(fid3);
    ATRTIME=[];
    ANNOT=[];
    sa=size(A);
    saa=sa(1);
    i=1;
    while i<=saa
        annoth=bitshift(A(i,2),-2);
        if annoth==59
            ANNOT=[ANNOT;bitshift(A(i+3,2),-2)];
            ATRTIME=[ATRTIME;A(i+2,1)+bitshift(A(i+2,2),8)+...
                    bitshift(A(i+1,1),16)+bitshift(A(i+1,2),24)];
            i=i+3;
        elseif annoth==60
            % nothing to do!
        elseif annoth==61
            % nothing to do!
        elseif annoth==62
            % nothing to do!
        elseif annoth==63
            hilfe=bitshift(bitand(A(i,2),3),8)+A(i,1);
            hilfe=hilfe+mod(hilfe,2);
            i=i+hilfe/2;
        else
            ATRTIME=[ATRTIME;bitshift(bitand(A(i,2),3),8)+A(i,1)];
            ANNOT=[ANNOT;bitshift(A(i,2),-2)];
       end;
       i=i+1;
    end;
    ANNOT(length(ANNOT))=[];       % last line = EOF (=0)
    ATRTIME(length(ATRTIME))=[];   % last line = EOF
    clear A;
    ATRTIME= cumsum(ATRTIME)/360;
    ind= find(ATRTIME <= t(end));
    ATRTIMED= ATRTIME(ind);
    ANNOT=round(ANNOT);
    ANNOTD= ANNOT(ind);
    
    windowl = 5*fs;
    for i = 1:windowl:length(sig1)-windowl
        data = sig1(i+1:i+windowl);
        % ====== feature extraction ======
        [c,R_value, R_loc, Q_value, Q_loc, S_value, S_loc, J_value, J_loc, T_value, T_loc, P_value, P_loc, RR, PR, QT, HRV, tqrs, trr, tpr, tqt] = ecg_extraction(data,fs);
        R_value_all = [R_value_all R_value]; 
        R_loc_all = [R_loc_all (R_loc + i-1)];

        P_value_all = [P_value_all P_value]; 
        P_loc_all = [P_loc_all (P_loc + i-1)];
        
        HRV_all = [HRV_all HRV];
        
        full_data = [full_data c];
    end
    t = [0:length(full_data)-1]/fs;
    figure
    plot(t(1:length(full_data)),full_data)
    hold on
    plot(t(P_loc_all), P_value_all, 'o',t(R_loc_all),R_value_all,'^r')
   
%     plot(BPM_need)
    % ====== base on file annotation to collect the arrhythmia's peak ======
    abnormal_sig = find((ANNOT ~= 1) & (ANNOT ~= 28) & (ANNOT ~= 14))';
    normal_sig = find(((ANNOT == 1) | (ANNOT == 28)) & (ANNOT ~= 14))';
    for i = 1:length(abnormal_sig)
        HRV_abnormal =  HRV_all(abnormal_sig <= length(HRV_all));
        HRV_normal =    HRV_all(normal_sig <= length(HRV_all));

        P_abnormal_value = P_value_all(abnormal_sig <= length(P_value_all));
        P_abnormal_loc = P_loc_all(abnormal_sig <= length(P_loc_all));
        P_normal_value = P_value_all(normal_sig <= length(P_value_all));
        P_normal_value = P_value_all(abnormal_sig <= length(P_value_all));

        R_abnormal_value = R_value_all(abnormal_sig <= length(R_value_all));
        R_abnormal_loc = R_loc_all(abnormal_sig <= length(R_value_all));
        R_normal_value = R_value_all(normal_sig <= length(R_value_all));
        R_normal_loc = R_loc_all(normal_sig <= length(R_value_all));
    end

    % ====== checking for arrhythmia =====
        % P/R ratio
    PR_abnormal = [PR_abnormal;mean(P_abnormal_value)/mean(R_abnormal_value)]; 
    PR_normal = [PR_normal;mean(P_normal_value)/mean(R_normal_value)];

    min_HRV_abnormal = [min_HRV_abnormal;min(HRV_abnormal)];
    max_HRV_abnormal = [max_HRV_abnormal;max(HRV_abnormal)];
    std_HRV_abnormal = [std_HRV_abnormal;std(HRV_abnormal)];
    changed_HRV_abnormal = [changed_HRV_abnormal;mean(abs(diff(HRV_abnormal)))];
    
    min_HRV_normal = [min_HRV_normal;min(HRV_normal)];
    max_HRV_normal = [max_HRV_normal;max(HRV_normal)];
    std_HRV_normal = [std_HRV_normal;std(HRV_normal)];
    changed_HRV_normal = [changed_HRV_normal;mean(abs(diff(HRV_normal)))];
end;