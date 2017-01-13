clc;
clear;
warning('off','all');
data_path = 'database\euro\';
%-EUROPE-------------------------------------------------------------------
recordings =  [103 104 105 112 118 121 139 162 161 154 613 612 704 801 808];
leads =       [001 002 001 002 001 001 002 002 002 002 001 002 002 002 002];
% recordings =    [103 104 105];
leads =         [001 002 001];
for record = 1:length(recordings)
        filename = ['e0' num2str(recordings(record))];
        disp(filename);
        full_path = [data_path filename '.hea'];
        ECGw = ECGwrapper( 'recording_name', full_path);
        % READ SIGANL AND ANNOTATION---------------------------------------
        ann = ECGw.ECG_annotations;
        hea = ECGw.ECG_header;
        sig = ECGw.read_signal(1,hea.nsamp);
        sig1_raw = sig(:,1);
        sig1_raw = sig1_raw(1:end); 
        % GENERAL PARAMETERS-----------------------------------------------
        fs = hea.freq;
        ts = 1/fs;       
        signal = sig1_raw(1:10000);
        [qrs_amp_raw,qrs_i_raw,delay,ecg_h]=pan_tompkin(signal,250,0);
        %[QRS_amps, QRS_locs, T_amps, T_locs, signal_filtered] = np_QRSTdetect(signal,250);
        np_QRSTdetect_code;
        figure1 = figure;
        set(figure1,'name',filename,'numbertitle','off');
        subplot(3,1,1);plot(signal_filtered);title('Nguyen Pham QRS');
        axis([0 length(signal_filtered) 0 1]);
        hold on;plot(QRS_locs,QRS_amps,'o');
        subplot(3,1,2);plot(signal_filtered);title('Nguyen Pham T');
        axis([0 length(signal_filtered) 0 1]);
        hold on;plot(T_locs,T_amps,'^');
        subplot(3,1,3);plot(ecg_h);title('Pan Thompkin');
        hold on;plot(qrs_i_raw,qrs_amp_raw,'o');
end;

