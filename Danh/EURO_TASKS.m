clear all; close all
%% ============================ Add path ==================================
warning('off','all');
%data_path = 'C:\Nguyen Pham\MY THESIS\database\longst\';
%data_path = 'C:\Nguyen Pham\MY THESIS\database\stchange\';
data_path = 'database\euro\';
%data_path = 'C:\Nguyen Pham\MY THESIS\database\ecgid\pt1\';

% ====== ECGID ======
%leads = ones(1,20) * 2;

% ====== CAD ======
%recordings = [20011 20221 20271 20272 20273 20274 20461 20161 20361];
%leads = [2 1 2 2 2 2 1 1 2];
%recordings = [20011];
%leads = [2];
% recordings = [20011 20431 20221 20271 20272 20273 20274 20451 20461 20151 20161];
% SPSS Compatible Data Output
% recordings = [20431 20221 20271 20272 20273 20274 20451 20461 20151];

% ====== LONG ST ======
%recordings = [20011 20431 20221 20271 20272 20151]; 
%leads = [2 1 1 2 2 1];
% R2 = 80%, 10s, 1/10 partition
% R2 = 70%, 30s, 1/10 partition -> Calculate STD
% R2 = 84.5%, 10s, 1/10 partition, trapz only -> Calculate STD
analysis = [];

% ====== ST CHANGES ======
%recordings = [300 302 303 306 317];
%recordings = [302 306 312];
%leads = [1 1 1 1 1];

%% ========================= Calling EURO records =========================
% ====== EUROPE ======
% recordings =  [103 104 105 106 112 118 121 129 139 133 162 161 154 613 612 704 801 808];
% leads =       [001 002 001 002 002 001 001 002 002 002 002 002 002 001 002 002 002 002];
% recordings = [122 154 161];
% leads = [2 1 2];
% recordings = [103 106 113 121 136 163 170 105 108 112 115 123 129 133 147 154 104 112 118 122 154 161];
% leads = [1 2 2 1 2 2 1 1 1 2 2 2 2 2 2 2 1 2 2 2 1 2];
recordings =    [103 104 105 106 112 113 118 121 129 133 136 139 154 161 162 163 170 105 108 112 115 123 129 133 147 154 104 112 118 122 154 161 612 801 808];
leads =         [001 002 001 002 002 002 001 001 002 002 002 002 002 002 002 002 001 001 001 002 002 002 002 002 002 002 001 002 002 002 001 002 002 002 002];
% recordings = 100:900;
% leads = ones(1,length(recordings)) * 2;

%% ============================= PARAMETERS ===============================
HR_bin = [];
meanHR_bin = []; % <----- For sliding window only
stdHR_bin = [];  % <----- For sliding window only
FFT_bin = [];
LFHF_bin = [];
DFA_bin = [];
Twave_bin = [];
ANN_bin = [];
FBAND_bin = [];
ENTROPY_bin = [];
STDeviation_bin = [];
meanSTDeviation_bin = []; % <----- For sliding window only
stdSTDeviation_bin = [];  % <----- For sliding window only
STslope_bin = [];
ENERGY_RATIO_bin = [];
ENTROPY_CUTOFF_bin = [];

% ====== REPORT PARAMETERS ======
RP_STslope_bin = [];
RP_STdev_bin = [];
RP_HR_bin = [];
RP_DFA_bin = [];
RP_ENERGY_RATIO_bin = [];
RP_ENTROPY_CUTOFF_bin = [];
RP_Tinv_bin = [];
RP_ToR_bin = [];
score_bin = [];
failed_records = {};

% ====== New report parameters ======
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
BPM = [];                   % beat per min
tqrs = [];                  % duartion of QRS complex
trr = [];                   % duration of RR segment
tqr = [];                   % duration of QR segment
tqt = [];                   % duration of QT segment
PR_ratio = [];              % P/S ratio for checking arrhythmia

% ====== HRV PARAMETERS ======
HRV_std_bin = [];
HRV_minmax_bin = [];
HRV_min_bin = [];
HRV_max_bin = [];
HRV_DFA_bin = [];

% ====== QUALIFYING DETECTION CODDE ======
accepted = 0;
rejected = 0;

%% ============================= Processing ===============================
for record = 1:length(recordings)
% %for record = 1:20
%     try
        %filename = ['s' num2str(recordings(record))];
        %filename = num2str(recordings(record));
        filename = ['e0' num2str(recordings(record))];
        %filename = ['rec_' num2str(record)];
        disp(filename);
        full_path = [data_path filename '.hea'];
        ECGw = ECGwrapper( 'recording_name', full_path);
        %load([data_path filename '_ECG_delineation.mat']);
        
        % ====== READ SIGANL AND ANNOTATION ======
        ann = ECGw.ECG_annotations;
        hea = ECGw.ECG_header;
        sig = ECGw.read_signal(1,hea.nsamp);
        sig1_raw = sig(:,leads(record));
        sig1_raw = sig1_raw(1:end);
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
        % ====== QRS DETECTION ======
        %if exist('wqrs_ECGv1','var')
        %    QRS = wqrs_ECGv1.time;
        %elseif exist('wqrs_V4','var')
        %    QRS = wqrs_V4.time;
        %elseif exist('wqrs_V1','var')
        %    QRS = wqrs_V1.time;
        %elseif exist('wqrs_MLII','var')
        %    QRS = wqrs_MLII.time;
        %elseif exist('wqrs_MV2','var')
        %    QRS = wqrs_MV2.time;
        %elseif exist('wqrs_MV1','var')
        %    QRS = wqrs_MV1.time;
        %end;
        %QRS = wavedet;
        %fields = fieldnames(QRS);
        %fieldname = getfield(QRS,fields{leads(record)});
        
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
%           try
%             REPORT;
%             %WAVELET;
%         catch
%             disp('An error occured while calibrating this record');
%             failed_records{end + 1} = filename;
%         end;
%     catch
%         disp(['record ' filename ' not found. Proceed to next one']);
%     end;
end;
% SCATTER_PLOT;
% STATS;