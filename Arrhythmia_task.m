warning('off','all');
clear all; close all; clc
%% ============================ Add path ==================================
data_path = 'database\arrhythmia\';

%% ====================== Calling arrhythmia records ======================
recordings = [103];% 101 103 106 109 112 113 115 116 118 119 121 122 123 124 200 201 202 203 205 207 208 209 210 212 213 214 215 217 219 220 221 222 223 228 230 232 233 234];
leads =      [001];% 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001];

%% =========================== New parameters =============================
mean_PR_ratio = [];
std_PR_ratio = [];

mean_HRV_all = [];
std_HRV_all = [];

%% ============================= Processing ===============================
for record = 1:length(recordings)
    full_data = [];
    R_value_all = []; R_loc_all = [];   % value and location of R peak
    P_value_all = []; P_loc_all = [];   % value and location of P peak
    HRV_all = [0];                   % beat per min
    PR_ratio = []; 
    PR_all = [0];
    mean_PR = [];
    std_HRV_all = [];
    mean_HRV_all = [];
    PR_ratio_all = [0];
    diagnosis = [];
    std_PR = [];
    std_PR_all = [];
    mean_PR_all = [];
        
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
    
    arrhythmia_peak = find((ANNOT ~= 1) & (ANNOT ~= 28) & (ANNOT ~= 14))';
   
    windowl = 5*fs;
    for i = 1:windowl:length(sig1)-windowl
        data = sig1(i+1:i+windowl);
        % ====== feature extraction ======
        [c,R_value, R_loc, Q_value, Q_loc, S_value, S_loc, J_value, J_loc, T_value, T_loc, P_value, P_loc, RR, PR, QT, HRV, tqrs, trr, tpr, tqt] = ecg_extraction(data,fs);

            % ====== R peak ======
            R_value_all = [R_value_all;R_value']; 
            R_loc_all = [R_loc_all;(R_loc + i-1)'];
            
            % ====== P peak ======
            P_value_all = [P_value_all;P_value']; 
            P_loc_all = [P_loc_all;(P_loc + i-1)'];
            
            % ====== PR ratio ======  
            std_PR = std(PR);
            std_PR_all = [std_PR_all;std_PR];
            mean_PR = mean(PR);
            mean_PR_all = [mean_PR_all;mean_PR];
            PR = [PR_all(end) PR];
            PR_all = [PR_all;PR'];
            
            PR_ratio = mean(P_value)/mean(R_value);
%             PR_ratio = [PR_ratio_all(end) PR_ratio];
            PR_ratio_all = [PR_ratio_all;PR_ratio'];
                     
            % ====== HRV ======
            std_HRV = std(HRV);
            std_HRV_all = [std_HRV_all;std_HRV];
            mean_HRV = mean(HRV);
            mean_HRV_all = [mean_HRV_all;mean_HRV];
            HRV = [HRV_all(end) HRV];
            HRV_all = [HRV_all;HRV'];
            
            sign_window = zeros(1,length(HRV));
            if std_HRV >= 5
                for peak = 2:length(HRV)-1
                    if HRV(peak) >= mean_HRV && HRV(peak+1) <= mean_HRV
                        sign_window(peak+1) = 1;
                    end
                end
            end
            diagnosis = [diagnosis sign_window];
           
            % ====== full data ======
            full_data = [full_data c];
    end
    
    std_PR_ratio = [std_PR_ratio;std(PR_ratio)];
    mean_PR_ratio = [mean_PR_ratio;mean(PR_ratio)];
    
    std_HRV_all = [std_HRV_all;std(std_HRV_all)];
    mean_HRV_all = [mean_HRV_all;mean(mean_HRV_all)];
        
%     for i = 1 : length(diagnosis)
%         if diagnosis(i) == 1
%             if PR_ratio_all(i) <= 0.3
%                 diagnosis(i) = 1;
%             else
%                 diagnosis(i) = 0;
%             end
%         end
%     end 
    a = find(diagnosis == 1);
end;
% t = [0:length(full_data)-1]/fs;
% figure
% plot(t,full_data)
% hold on
% plot(t(1:length(a)),a);
