clc;
clear;
warning('off','all');
data_path = 'E:\DATABASE\database\longst\';
%-EUROPE-------------------------------------------------------------------
recordings = [20011 20221 20271 20272 20274 20461 20161 20361];
leads = ones(1,length(recordings));
for record = 1:length(recordings)
%     try
        filename = ['s' num2str(recordings(record))];
        disp(filename);
        full_path = [data_path filename '.hea'];
        ECGw = ECGwrapper( 'recording_name', full_path);
        % READ SIGANL AND ANNOTATION---------------------------------------
        hea = ECGw.ECG_header;
        sig = ECGw.read_signal(1,hea.nsamp/20);
        sig1_raw = sig(:,1);
        sig1_raw = sig1_raw(1:end);
        % GENERAL PARAMETERS-----------------------------------------------
        fs = hea.freq;
        ts = 1/fs;       
        signal = sig1_raw(1:20000);
        % CODING-----------------------------------------------------------
        [wfdb_rr,wfdb_time]=ann2rr([data_path filename],'sta');
        % PLOTING SECTION--------------------------------------------------
        figure1 = figure;
        set(figure1,'name',filename,'numbertitle','off');
        subplot(3,1,1);plot(wfdb_time, wfdb_rr);title('WFDB RR');
        axis([0 length(wfdb_rr) 0 inf]);
        
%     catch
%         disp('error occured.');
%     end;
end;

