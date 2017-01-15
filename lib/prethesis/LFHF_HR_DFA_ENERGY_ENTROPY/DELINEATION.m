% --------------------------------------------------
% BASIC CALL
% --------------------------------------------------
data_path = 'C:\Nguyen Pham\MY THESIS\database\ecgid\pt1\';
%recordings = [103 107 112 118 111 110 121 119 129 136 139 133 162 161 154];
recordings = [];

%for i = 1:length(recordings);
for i = 1:20
  %  file = ['s' num2str(recordings(i))];
  %  file = num2str(i);
  %  file = ['e0' num2str(recordings(i))];
    file = ['rec_' num2str(i)];
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
%ECGw.ECGtaskHandle = 'QRS_detection';
%ECGw.ECGtaskHandle.only_ECG_leads = true;
% just restrict the run to the three algorithms
%ECGw.ECGtaskHandle.detectors = {'wqrs'};
%ECGw.Run;
ECGw.ECGtaskHandle = 'ECG_delineation';
ECGw.ECGtaskHandle.only_ECG_leads = true;
% just restrict the run to the three algorithms
cached_filenames = ECGw.GetCahchedFileName({'QRS_corrector' 'QRS_detection'});
%ECGw.ECGtaskHandle.payload = load(cached_filenames{1});
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
