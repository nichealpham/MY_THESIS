clc;
clear;
warning('off','all');
data_path = 'database\euro\';
%data_path = 'E:\DATABASE\database\longst\';
%-EUROPE-------------------------------------------------------------------
recordings =  [103 104 105 112 118 121 139 162 161 154 613 612 704 801 808];
leads =       [001 002 001 002 001 001 002 002 002 002 001 002 002 002 002];
% recordings =  [112];
% leads =       [002];
%-LONG ST------------------------------------------------------------------
% recordings = [20011 20021 20031 20041 20051 20061 20071 20081 20091 20101 20111 20121 20131 20141 20151 20171 20181 20191 20201 20211 20221 20231 20241 20251 20261 20271 20272 20274 20461 20161 20361];
% leads = ones(1,length(recordings));
for record = 1:length(recordings)
    try
        filename = ['e0' num2str(recordings(record))];
        %filename = ['s' num2str(recordings(record))];
        disp(filename);
        full_path = [data_path filename '.hea'];
        ECGw = ECGwrapper( 'recording_name', full_path);
        % READ SIGANL AND ANNOTATION---------------------------------------
        ann = ECGw.ECG_annotations;
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
        [qrs_amp_raw,qrs_i_raw,delay,ecg_h]=pan_tompkin(signal,fs,0);
        [QRS_amps, QRS_locs, T_amps, T_locs, signal_filtered] = np_QRSTdetect(signal,fs);
        figure1 = figure;
        set(figure1,'name',filename,'numbertitle','off');
        subplot(3,1,1);plot(signal_filtered);title('Nguyen Pham QRS');
        axis([0 length(signal_filtered) 0 1]);
        hold on;plot(QRS_locs,QRS_amps,'o');
        subplot(3,1,2);plot(signal_filtered);title('Nguyen Pham T');
        axis([0 length(signal_filtered) 0 1]);
        hold on;plot(T_locs,T_amps,'^');
        subplot(3,1,3);plot(ecg_h);title('Pan Thompkin QRS');
        hold on;plot(qrs_i_raw,qrs_amp_raw,'o');
    catch
        disp('error occured.');
    end;
end;

