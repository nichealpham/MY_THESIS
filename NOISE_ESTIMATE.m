clc;
clear;
warning('off','all');
data_path = 'database\euro\';
%data_path = 'E:\DATABASE\database\longst\';
%-EUROPE-------------------------------------------------------------------
% recordings =  [103 104 105 112 118 121 139 162 161 154 613 612 704 801 808];
% leads =       [001 002 001 002 001 001 002 002 002 002 001 002 002 002 002];
recordings =  [112];
leads =       [002];
%-LONG ST------------------------------------------------------------------
% recordings = [20011 20021 20031 20041 20051 20061 20071 20081 20091 20101 20111 20121 20131 20141 20151 20171 20181 20191 20201 20211 20221 20231 20241 20251 20261 20271 20272 20274 20461 20161 20361];
% recordings = 20011:20361;
% leads = ones(1,length(recordings));
for record = 1:length(recordings)
        filename = ['e0' num2str(recordings(record))];
        %filename = ['s' num2str(recordings(record))];
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
        signal = sig1_raw(1:6000);
        signal_filtered = signal;
        % NOISE ESTIMATE USING WAVELET-------------------------------------
        [approx, detail] = wavelet_decompose(signal_filtered, 1, 'db11');
        signal_filtered = signal_filtered - detail(:,1);
        [approx, detail] = wavelet_decompose(signal_filtered, 1, 'sym12');
        signal_filtered = signal_filtered - detail(:,1);
        [approx, detail] = wavelet_decompose(signal_filtered, 1, 'sym10');
        signal_filtered = signal_filtered - detail(:,1);
        [approx, detail] = wavelet_decompose(signal_filtered, 1, 'db10');
        signal_filtered = signal_filtered - detail(:,1);
        [approx, detail] = wavelet_decompose(signal_filtered, 1, 'coif5');
        signal_filtered = signal_filtered - detail(:,1);   
        %-CONVENTIONAL FIR DESIGN------------------------------------------
        filt = fir1(24,[5/(fs/2), 15/(fs/2)],'bandpass');
        signal_bp = conv(filt,signal);
        signal_bp = signal_bp(12:end);
        %-SMOOTH-----------------------------------------------------------
        moving_average = ones(1,12)./12;
        signal_smooth = conv(signal, moving_average);
        signal_smooth = signal_smooth(6:end);
        %-CORRELATION------------------------------------------------------
        correlation = corrcoef(signal,signal_filtered);  
        % PLOT SECTION-----------------------------------------------------
        figure1 = figure;
        set(figure1,'name',filename,'numbertitle','off');
        subplot(2,1,1);plot(signal_bp);title('signal');
        axis([0 length(signal_bp) 0 1]);
        set(figure1,'name',filename,'numbertitle','off');
        subplot(2,1,2);plot(signal_filtered);title('filtered');
        axis([0 length(signal_filtered) 0 1]);
        %-DISPLAY----------------------------------------------------------
        disp([filename ': ' num2str(correlation(1,end))]);
end;

