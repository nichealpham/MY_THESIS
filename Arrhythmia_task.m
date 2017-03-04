warning('off','all');
clear all; close all; clc
%% ============================ Add path ==================================
data_path = 'database\arrhythmia\';

%% ========================= Calling arrhythmia records =========================
recordings = [234];%   [100 101 103 106 109 112 113 115 116 118 119 121 122 123 124 200 201 202 203 205 207 208 209 210 212 213 214 215 217 219 220 221 222 223 228 230 232 233 234];
leads =      [001];%   [001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001];
%106
%% ============================= PARAMETERS ===============================
PR_abnormal = []; 
PR_normal = [];
min_HRV_abnormal = [];
max_HRV_abnormal = [];
std_HRV_abnormal = [];
changed_HRV_abnormal = [];
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
HRV = [];                   % beat per min
tqrs = [];                  % duartion of QRS complex
trr = [];                   % duration of RR segment
tqr = [];                   % duration of QR segment
tqt = [];                   % duration of QT segment
PR_ratio = [];              % P/S ratio for checking arrhythmia

%% ============================= Processing ===============================
for record = 1:length(recordings)
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
    
    % ====== feature extraction ======
    [R_value, R_loc, Q_value, Q_loc, S_value, S_loc, J_value, J_loc, T_value, T_loc, P_value, P_loc, RR, PR, QT, HRV, tqrs, trr, tpr, tqt] = ecg_extraction(sig1,fs);
    HRV(find(HRV >= 200)) = [];
%     figure
%     plot(t(1:length(sig1)),sig1)
%     hold on
%     plot(t(P_loc), P_value, 'o',t(R_loc),R_value,'^r')
   
%     plot(BPM_need)
    % ====== base on file annotation to collect the arrhythmia's peak ======
    abnormal_sig = find((ANNOT ~= 1) & (ANNOT ~= 28) & (ANNOT ~= 14))';
    normal_sig = find((ANNOT == 1) | (ANNOT == 28) | (ANNOT == 14))';
    for i = 1:length(abnormal_sig)
        HRV_abnormal =  HRV(abnormal_sig <= length(HRV));
        HRV_normal =    HRV(normal_sig <= length(HRV));

        P_abnormal_value = P_value(abnormal_sig <= length(P_value));
        P_abnormal_loc = P_loc(abnormal_sig <= length(P_loc));
        P_normal_value = P_value(normal_sig <= length(P_value));
        P_normal_value = P_value(abnormal_sig <= length(P_value));

        R_abnormal_value = R_value(abnormal_sig <= length(R_value));
        R_abnormal_loc = R_loc(abnormal_sig <= length(R_value));
        R_normal_value = R_value(normal_sig <= length(R_value));
        R_normal_loc = R_loc(normal_sig <= length(R_value));
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
    
%     result = [PR_abnormal;PR_normal; min_HRV_abnormal;max_HRV_abnormal;std_HRV_abnormal;changed_HRV_abnormal;min_HRV_normal;max_HRV_normal;std_HRV_normal;changed_HRV_normal]

%     % ====== FFT PARAMETERS ======
%     FFT_beat_step = 30;
%     FFT_part_of_total_data_used = 10;
%     envelope_size = 26;
%     smooth_type = 'loess';
%     smooth_span = .01;
end;
