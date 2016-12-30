data_path = 'C:\Nguyen Pham\MY THESIS\database\longst\';
%data_path = 'C:\Nguyen Pham\MY THESIS\database\stchange\';
%data_path = 'C:\Nguyen Pham\MY THESIS\database\euro\';
%data_path = 'C:\Nguyen Pham\MY THESIS\database\ecgid\pt1\';
% ECGID--------------------------------------------------------------------
%leads = ones(1,20) * 2;
% CAD----------------------------------------------------------------------
%recordings = [20011 20221 20271 20272 20274 20461 20161 20361];
%recordings = [20274 20461];
%leads = [2 1 2 2 2 1 1 2];
recordings = [20011 20021 20031 20041 20051 20061 20071 20081 20091 20101 20111 20121 20131 20141 20151 20161 20171 20181 20191 20201 20211 20221 20231 20241 20251 20261 20271 20272 20274 20461 20161 20361];
leads = ones(1,length(recordings));
%recordings = [20011];
%leads = [2];
% recordings = [20011 20431 20221 20271 20272 20273 20274 20451 20461 20151 20161];
% SPSS Compatible Data Output
% recordings = [20431 20221 20271 20272 20273 20274 20451 20461 20151];
%-LONG ST------------------------------------------------------------------
%recordings = [20011 20431 20221 20271 20272 20151]; 
%leads = [2 1 1 2 2 1];
% R2 = 80%, 10s, 1/10 partition
% R2 = 70%, 30s, 1/10 partition -> Calculate STD
% R2 = 84.5%, 10s, 1/10 partition, trapz only -> Calculate STD
analysis = [];
%-ST CHANGES---------------------------------------------------------------
%recordings = [300 302 303 306 317];
%recordings = [302 306 312];
%leads = [1 1 1 1 1];
%-EUROPE-------------------------------------------------------------------
%recordings = [103 112 118 111 121 119 129 139 133 162 161 154];
%recordings = [103 118 111];
%leads = [1 1 1];
%recordings = [103 112 118 111];
%leads = [1 2 1 1 1 2 2 2 2 2 2 2];
% ANN, 92%, 5 features
% k-NN, 96,8%, 2 cai HR, FBAND, ENERGY_RATIO, 50-50
%-PARAMETERS-------------------------------
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
%REPORT PARAMETERS-------------------------
RP_STslope_bin = [];
RP_STdev_bin = [];
RP_HR_bin = [];
RP_DFA_bin = [];
RP_ENERGY_RATIO_bin = [];
RP_ENTROPY_CUTOFF_bin = [];
RP_Tinv_bin = [];
RP_ToR_bin = [];
score_bin = [];
% QUALIFYING DETECTION CODDE-----------------------------------------------
accepted = 0;
rejected = 0;
%------------------------------------------
for record = 1:length(recordings)
%for record = 1:20
    filename = ['s' num2str(recordings(record))];
    %filename = num2str(recordings(record));
    %filename = ['e0' num2str(recordings(record))];
    %filename = ['rec_' num2str(record)];
    disp(filename);
    full_path = [data_path filename '.hea'];
    ECGw = ECGwrapper( 'recording_name', full_path);
    %load([data_path filename '_ECG_delineation.mat']);
    % READ SIGANL AND ANNOTATION-------------------------
    ann = ECGw.ECG_annotations;
    hea = ECGw.ECG_header;
    sig = ECGw.read_signal(1,hea.nsamp);
    sig1_raw = sig(:,leads(record));
    sig1_raw = sig1_raw(1:end);
    % NORMALIZATION CODES--------------------------------
    sig1_raw = sig1_raw - mean(sig1_raw);
    L = length(sig1_raw);
    Ex = 1/L * sum(abs(sig1_raw).^2);
    sig1_raw = sig1_raw / Ex;
    % BASELINE REMOVE USING Wavelet_decompose------------
    [approx, detail] = wavelet_decompose(sig1_raw, 8, 'db4');
    sig1 = sig1_raw - approx(:,8);
    %sig1 = sig1_raw;
    sig_backup = sig1;
    % NORMALIZA THE SIGNAL FROM 0 TO 1
    sig1 = sig1 + abs(min(sig1));
    sig1 = sig1 / max(sig1);
    % QRS DETECTION--------------------------------------
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
    % GENERAL PARAMETERS---------------------------------
    fs = hea.freq;
    ts = 1/fs;
    %beatNum = length(QRS);
    %annNum = length(ann.anntyp);
    % FFT PARAMETERS-------------------------------------
    FFT_beat_step = 30;
    FFT_part_of_total_data_used = 10;
    envelope_size = 26;
    smooth_type = 'loess';
    smooth_span = .01;
    % ---------------
    %       Pon: [111614x1 double]
    %         P: [111614x1 double]
    %      Poff: [111614x1 double]
    %     Ptipo: [111614x1 double]
    %     QRSon: [111614x1 double]
    %       qrs: [111614x1 double]
    %         Q: [111614x1 double]
    %         R: [111614x1 double]
    %         S: [111614x1 double]
    %    QRSoff: [111614x1 double]
    %       Ton: [111614x1 double]
    %         T: [111614x1 double]
    %    Tprima: [111614x1 double]
    %      Toff: [111614x1 double]
    %     Ttipo: [111614x1 double]
    %BEAT_TO_BEAT;
    %SLIDING_WINDOW;
    %WAVELET;
    REPORT;
end;
%FINAL_PLOT;
%WINDOW_FINAL_PLOT;
aaaa = [RP_STslope_bin RP_STdev_bin RP_HR_bin RP_DFA_bin ...
        RP_ENERGY_RATIO_bin RP_ENTROPY_CUTOFF_bin ...
        RP_Tinv_bin RP_ToR_bin score_bin];
STATUS = [];
for i = 1:length(aaaa)
    if aaaa(i,9) >= 2
        STATUS(end + 1) = 1;
    else
        STATUS(end + 1) = 0;
    end;
end;
STATUS = STATUS';
aaaa = [aaaa STATUS];
%-SCATTER PLOT-------------------------------------------------------------
STdev1 = RP_STdev_bin(STATUS > 0);
STdev2 = RP_STdev_bin(STATUS == 0);
STslope1 = RP_STslope_bin(STATUS > 0);
STslope2 = RP_STslope_bin(STATUS == 0);
Tinv1 = RP_Tinv_bin(STATUS > 0);
Tinv2 = RP_Tinv_bin(STATUS == 0);
figure(1000);
subplot(1,2,1);scatter3(STdev1,STslope1,Tinv1);hold on;scatter3(STdev2,STslope2,Tinv2);
STdev1 = RP_STdev_bin(RP_DFA_bin > 1);
STdev2 = RP_STdev_bin(RP_DFA_bin < 1);
STslope1 = RP_STslope_bin(RP_DFA_bin > 1);
STslope2 = RP_STslope_bin(RP_DFA_bin < 1);
Tinv1 = RP_Tinv_bin(RP_DFA_bin > 1);
Tinv2 = RP_Tinv_bin(RP_DFA_bin < 1);
subplot(1,2,2);scatter3(STdev1,STslope1,Tinv1);hold on;scatter3(STdev2,STslope2,Tinv2);
xlabel('STdev');
ylabel('STslope');
zlabel('Tinv');
%-SCATTER PLOT-------------------------------------------------------------
STdev0 = RP_STdev_bin(score_bin == 0);
STdev1 = RP_STdev_bin(score_bin == 1);
STdev2 = RP_STdev_bin(score_bin == 2);
STdev3 = RP_STdev_bin(score_bin == 3);
STdev4 = RP_STdev_bin(score_bin == 4);
STdev5 = RP_STdev_bin(score_bin == 5);
STslope0 = RP_STslope_bin(score_bin == 0);
STslope1 = RP_STslope_bin(score_bin == 1);
STslope2 = RP_STslope_bin(score_bin == 2);
STslope3 = RP_STslope_bin(score_bin == 3);
STslope4 = RP_STslope_bin(score_bin == 4);
STslope5 = RP_STslope_bin(score_bin == 5);
Tinv0 = RP_Tinv_bin(score_bin == 0);
Tinv1 = RP_Tinv_bin(score_bin == 1);
Tinv2 = RP_Tinv_bin(score_bin == 2);
Tinv3 = RP_Tinv_bin(score_bin == 3);
Tinv4 = RP_Tinv_bin(score_bin == 4);
Tinv5 = RP_Tinv_bin(score_bin == 5);
figure(1001);
scatter3(STdev0,STslope0,Tinv0);hold on;scatter3(STdev1,STslope1,Tinv1);hold on;scatter3(STdev2,STslope2,Tinv2);hold on;scatter3(STdev3,STslope3,Tinv3);hold on;scatter3(STdev4,STslope4,Tinv4);hold on;scatter3(STdev5,STslope5,Tinv5);
xlabel('STdev');
ylabel('STslope');
zlabel('Tinv');