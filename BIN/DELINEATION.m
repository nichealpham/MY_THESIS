% --------------------------------------------------
% BASIC CALL
% --------------------------------------------------
data_path = 'C:\Nguyen Pham\MY THESIS\database\longst\';
output_path = 'C:\Nguyen Pham\MY THESIS\recordings\';
recordings = [20221 20271 20272 20021 20271 20421 20431 20441 20451 20461 20541 20551 20561];

for i = 1:length(recordings);
    
    file = ['s' num2str(recordings(i))];
    filename = [file '.hea'];
    disp(['Reading records ' filename '...']);
    
% ---------------
% RESULTS FILE NAME
% ---------------
deli_result = [data_path file '_ECG_delineation.mat'];
QRS_result = [data_path file '_QRS_detection.mat'];
% ---------------
% ECG DELINEATION CODE
% ---------------
ECGw = ECGwrapper( 'recording_name', [data_path filename]);
% ann = ECGw.ECG_annotations;
% hea = ECGw.ECG_header;
% sig = ECGw.read_signal(1,hea.nsamp);
% sig1 = sig(:,1);
% sig2 = sig(:,2);
ECGw.ECGtaskHandle = 'QRS_detection';
ECGw.ECGtaskHandle.only_ECG_leads = true;
% just restrict the run to the three algorithms
ECGw.ECGtaskHandle.detectors = {'wqrs'};
ECGw.Run;
ECGw.ECGtaskHandle = 'ECG_delineation';
ECGw.ECGtaskHandle.only_ECG_leads = true;
% just restrict the run to the three algorithms
cached_filenames = ECGw.GetCahchedFileName({'QRS_corrector' 'QRS_detection'});
ECGw.ECGtaskHandle.payload = load(cached_filenames{1});
ECGw.Run;
% load(deli_result);
% QRS = wavedet;
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
% ---------------
end;
% TASKS_HANDLE;
