clc;
clear;
warning('off','all');
%data_path = 'database\euro\';
data_path = 'E:\MY_THESIS\database\euro\';
%-EUROPE-------------------------------------------------------------------
% recordings =  [103 104 105 112 118 121 139 162 161 154 613 612 704 801 808];
% leads =       [001 002 001 002 001 001 002 002 002 002 001 002 002 002 002];
% recordings =  [112];
% leads =       [002];
%-LONG ST------------------------------------------------------------------
%recordings = [20011 20221 20271 20272 20274 20461 20161 20361];
recordings =    [103 104 105 106 112 113 118 121 129 133 136 139 154 161 162 163 170 105 108 112 115 123 129 133 147 154 104 112 118 122 154 161 612 801 808];
leads =         [001 002 001 002 002 002 001 001 002 002 002 002 002 002 002 002 001 001 001 002 002 002 002 002 002 002 001 002 002 002 001 002 002 002 002];

for record = 1:length(recordings)
%     try
        filename = ['e0' num2str(recordings(record))];
        %filename = ['rec_' num2str(record)];
        disp(filename);
        full_path = [data_path filename '.hea'];
        ECGw = ECGwrapper( 'recording_name', full_path);
        % READ SIGANL AND ANNOTATION---------------------------------------
        hea = ECGw.ECG_header;
        sig = ECGw.read_signal(1,hea.nsamp/20);
        sig1_raw = sig(:,1);
        sig1_raw = sig1_raw(1:end);     
        % BASELINE REMOVE USING Wavelet_decompose--------------------------
        [approx, detail] = wavelet_decompose(sig1_raw, 8, 'db4');
        sig1_raw = sig1_raw - approx(:,8);
        % NORMALIZATION CODES----------------------------------------------
        sig1_raw = sig1_raw - mean(sig1_raw);
        L = length(sig1_raw);
        Ex = 1/L * sum(abs(sig1_raw).^2);
        sig1_raw = sig1_raw / Ex;
        % NORMALIZA THE SIGNAL FROM 0 TO 1
        sig1_raw = sig1_raw + abs(min(sig1_raw));
        sig1_raw = sig1_raw / max(sig1_raw);  
        % GENERAL PARAMETERS-----------------------------------------------
        fs = hea.freq;
        ts = 1/fs;       
        signal = sig1_raw(1:20000);
        % CODING-----------------------------------------------------------
        [wfdb_rr, wfdb_time] = ann2rr([data_path filename],'a');
        % PLOTING SECTION--------------------------------------------------
        figure1 = figure;
        set(figure1,'name',filename,'numbertitle','off');
        subplot(3,1,1);plot(wfdb_time, wfdb_rr);title('WFDB RR');
        axis([0 length(wfdb_rr) 0 inf]);
        
%     catch
%         disp('error occured.');
%     end;
end;

