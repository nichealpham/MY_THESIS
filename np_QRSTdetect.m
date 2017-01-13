function [QRS_amps, QRS_locs, T_amps, T_locs, signal_filtered] = np_QRSTdetect(signal,fs)
%==========================================================================
% IMPORTANT NOTES:
% For improved accuracy, only use this function for limp leads
%==========================================================================
% Prerequisite files:
% This function is inspired from Pan Thompkin algorithm
% and applied Discrete Wavelet Transformation to filter the signal
% wavelet_decompose.m
%==========================================================================
% EKG signal_filtered R peak and T peak detection
% given time series 'signal_filtered'.
% INPUTS:
% + signal    : The given scalar time series
% + fs        : Sampling frequency
% OUTPUTS
% + QRS_amps        : Array of Q wave amplitudes
% + QRS_locs        : Array of Q wave location
% + T_amps          : Array of T wave amplitudes
% + T_locs          : Array of T wave location
% + signal_filtered : Signal filtered out baseline and noise
%==========================================================================
% v 1.0 2017/01/11 22:09:14  Nguyen Pham
% This is part of my university project: https://github.com/nguyenpham95/MY_THESIS
%==========================================================================
% Copyright (C) 2017 by Nguyen Pham 
% <phamkhoinguyen1995@gmail.com>
%==========================================================================
% Version: 1.0
% LICENSE:
%     This program is free software; you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation; either version 3 of the License, or
%     any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program. If not, see http://www.gnu.org/licenses/>.
%==========================================================================
% Methodologies:
% Link: https://github.com/nguyenpham95/MY_THESIS
% Find documentation at directory ~/research/prethesis/HK2/PRETHESIS REPORT.pdf
%==========================================================================
% For more references and information, please visit
% Link: https://github.com/nguyenpham95/MY_THESIS
%==========================================================================
signal_filtered = signal;
std_thres = 3;
sqrt_operation = 6;
thres_start = 1;
thres_stop = 6;
isothres = 5;
%PREPROCESSING------------------------------------------------------------
%-BASELINE REMOVAL---------------------------------------------------------
[approx, detail] = wavelet_decompose(signal_filtered, 8, 'db4');
signal_filtered = signal_filtered - approx(:,8);
%-NOISE ESTIMATION REMOVAL-----------------------------------------
[approx, detail] = wavelet_decompose(signal_filtered, 11, 'sym2');
noise_level = detail(:,1);
noise_variance = 1.483 * median(noise_level);
noise_threshold = noise_variance * sqrt(2 * log(length(noise_level)));
for hkn = 1:length(noise_level)
    if abs(noise_level(hkn)) < noise_threshold
       noise_level(hkn) = 0;
    end;
end;
%-DENOISING--------------------------------------------------------
signal_filtered = signal_filtered - noise_level;
%-NORMALIZATION CODES------------------------------------------------------
signal_filtered = signal_filtered - mean(signal_filtered);
L = length(signal_filtered);
Ex = 1/L * sum(abs(signal_filtered).^2);
signal_filtered = signal_filtered / Ex;
%-NORMALIZA THE SIGNAL FROM 0 TO 1
signal_filtered = signal_filtered + abs(min(signal_filtered));
signal_filtered = signal_filtered / max(signal_filtered);
%-GENERAL PARAMETERS-------------------------------------------------------
QRS_amps = [];
QRS_locs = [];
T_amps = [];
T_locs = [];
%-CALCULATE NUMBER OF LOOP-------------------------------------------------
span_in_seconds = 2;
data_length = floor(span_in_seconds * fs);
number_of_loop = floor(length(signal_filtered) / data_length);
index_start = 1;
delay = 0;
%-LOOPING------------------------------------------------------------------
if number_of_loop > 1
   for loop = 1:number_of_loop
       index_end = data_length * loop;
       %-READ SIGNAL-------------------------------------------------------
       segment = signal_filtered(index_start:index_end);           
       %-QRS DETECTION-----------------------------------------------------
       %% bandpass filter for Noise cancelation of other sampling frequencies(Filtering)
       f1=5;                    %cuttoff low frequency to get rid of baseline wander
       f2=15;                   %cuttoff frequency to discard high frequency noise
       Wn=[f1, f2]*2/fs;        %cutt off based on fs
       N = 4;                   %order of 3 less processing
       [a,b] = butter(N,Wn);    %bandpass filtering
       ecg_h = filtfilt(a,b,segment);
       ecg_h = ecg_h/ max( abs(ecg_h));
       delay = delay + 2;
       %% derivative filter H(z) = (1/8T)(-z^(-2) - 2z^(-1) + 2z + z^(2))
       h_d = [-1 -2 0 2 1]*(1/8);       %1/8*fs
       ecg_d = conv (ecg_h ,h_d);
       ecg_d = ecg_d/max(ecg_d);
       delay = delay + 5;               % delay of derivative filter 2 samples
       %% obtained the data for QRS detection
       segment = ecg_d(delay:end);
       %-BRING THE signal_filtered ABOVE 0---------------------------------
       if min(segment) < 0
           segment = segment + abs(min(segment));
       end;
       segment = segment.^sqrt_operation;    
       thres_mean = (mean(segment) + std_thres * std(segment)) * ones(1,length(segment));
       [pks, locs] = findpeaks(segment,'MinPeakDistance',100);
       for i = 1:length(locs)
           if pks(i) > thres_mean(1)
              ind = locs(i) + index_start - 1;
              if ind <= length(signal)
                 QRS_amps(end + 1) = signal_filtered(ind);
                 QRS_locs(end + 1) = ind;
              end;
            end;
       end;
       %-UPDATE INDEX START FOR NEXT LOOP----------------------------------
       index_start = index_end;
       delay = 0;
    end;
else
    %-READ signal_filtered-------------------------------------------------
    segment = signal_filtered;
    %% bandpass filter for Noise cancelation of other sampling frequencies(Filtering)
       f1=5;                    %cuttoff low frequency to get rid of baseline wander
       f2=15;                   %cuttoff frequency to discard high frequency noise
       Wn=[f1, f2]*2/fs;        %cutt off based on fs
       N = 4;                   %order of 3 less processing
       [a,b] = butter(N,Wn);    %bandpass filtering
       ecg_h = filtfilt(a,b,segment);
       ecg_h = ecg_h/ max( abs(ecg_h));
       delay = delay + 2;
       %% derivative filter H(z) = (1/8T)(-z^(-2) - 2z^(-1) + 2z + z^(2))
       h_d = [-1 -2 0 2 1]*(1/8);       %1/8*fs
       ecg_d = conv (ecg_h ,h_d);
       ecg_d = ecg_d/max(ecg_d);
       delay = delay + 2;               % delay of derivative filter 2 samples
       %% obtained the data for QRS detection
       segment = ecg_d(delay:end);
       %-BRING THE signal_filtered ABOVE 0---------------------------------
       if min(segment) < 0
           segment = segment + abs(min(segment));
       end;
       segment = segment.^sqrt_operation;  
    thres_mean = (mean(segment) + std_thres * std(segment)) * ones(1,length(segment));
    [pks, locs] = findpeaks(segment,'MinPeakDistance',100);
    for i = 1:length(locs)
        if pks(i) > thres_mean(1)
           ind = locs(i);
           QRS_amps(end + 1) = signal(ind);
           QRS_locs(end + 1) = ind;
        end;
    end;
end;
%-T WAVE DETECTION---------------------------------------------------------
sig = signal_filtered;
%-LOW PASS FILTER TO REMOVE OTHER WAVES------------------------------------
filt = fir1(24,10/(fs/2),'low');
sig = conv(filt, sig);
sig = sig(12:end);
%-ZEROLIZING EACH BEAT INTERVAL--------------------------------------------
for hk = 1:length(QRS_locs) - 1
    data = sig(QRS_locs(hk):QRS_locs(hk + 1));
    leng = floor((QRS_locs(hk + 1) - QRS_locs(hk)) / 10);
    isoelec = sig(QRS_locs(hk) + isothres * leng);
    data = data - isoelec;
    data = data.^sqrt_operation;
    data = data(thres_start * leng:thres_stop * leng);
    [pks, locs] = findpeaks(data);
    max_peak = max(pks);
    max_peak_ind = locs(find(pks == max_peak));
    ind = max_peak_ind(end);
    T_locs(end + 1) = QRS_locs(hk) + thres_start * leng + ind;
    T_amps(end + 1) = signal_filtered(QRS_locs(hk) + thres_start * leng + ind);
end;
%-END OF T DETECTION-------------------------------------------------------
%-PLOTTING SECTION---------------------------------------------------------
%figure1 = figure;
%set(figure1,'name','RT detection','numbertitle','off');
%plot(signal_filtered);title('signal_filtered');
%hold on;plot(QRS_locs,QRS_amps,'o');
%hold on;plot(T_locs,T_amps,'^');