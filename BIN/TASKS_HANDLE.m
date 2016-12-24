% ECG FINAL FEATURES
data_path = 'C:\Nguyen Pham\MY THESIS\database\longst\';
% recordings = [20221 20271 20272 20021 20271 20421 20431 20441 20451 20461 20541 20551 20561];
recordings = [20221];
% SPSS Compatible Data Output
www = [];
for i = 1:length(recordings)
    filename = ['s' num2str(recordings(i))];
    % filename = '327';
    % filename = 's20274';
    % s20221    -    ML2    -    Note: T inverted       
    % s20271    -    ECGv1  -    Note:   
    % s20272    -    ECGv1  -    Note:  
    % s20021    -    MLIII  -    Note:                  
    % s20271    -    ECGv2  -    Note:        
    % s20421    -    ECGv2  -    Note: normal data      
    % s20431    -    ECGv2  -    Note: normal ST, baseline drift
    % 327       -    ECGv2  -    Note: STE              
    % chf01     -    ML2    -    Note: T inverted
    % [fname path]=uigetfile('abnormal/300m_C.mat');
    % fname=strcat(path,fname);

    ECGw = ECGwrapper( 'recording_name', [data_path filename '.hea']);
    load([data_path filename '_ECG_delineation.mat']);
    resp = [];
    ann = ECGw.ECG_annotations;
    hea = ECGw.ECG_header;
    sig = ECGw.read_signal(1,hea.nsamp);
    sig1 = sig(:,1);
    sig2 = sig(:,2);
    % NORMALIZATION CODES--------------------------------
    sig1 = sig1 - mean(sig1);
    L = length(sig1);
    Ex = 1/L * sum(abs(sig1).^2);
    sig1 = sig1 / Ex;
    % ---------------------------------------------------
    QRS = wavedet;
    fields = fieldnames(QRS);
    fieldname = getfield(QRS,fields{1});
    % General parameters
    % ---------------
    fs = hea.freq;
    ts = 1/fs;
    beatNum = length(fieldname.Pon);
    annNum = length(ann.anntyp);
    % FFT parameters
    % FFT_beat_step changes according to different records to yeild best result
    % ---------------
    FFT_beat_step = 30;
    FFT_part_of_total_data_used = 10;
    envelope_size = 26;
    smooth_type = 'loess';
    smooth_span = .06;
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

    % NOTE: THESE SCRIPT RUN IN ORDER
    % MORPHOLOGICAL_FEATURES_EXTRACTION;
    % VISUAL_INSPECT_ECG_DELINEATION;
    % FFT_VISUAL_INSPECTION;
    IFFT_test;
    % FFT_FEATURES_EXTRACTION;
    % STA_ANALYSIS;
    % FINAL_RESPONSE;
end;



