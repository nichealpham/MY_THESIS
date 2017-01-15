function [QRS_amps, QRS_locs, T_amps, T_locs, signal_filtered] = np_QRSTdetect(signal,fs)
%==========================================================================
% IMPORTANT NOTES:
% + For improved accuracy, use this function for limp leads
% + This function is inspired by Pan Thompkin algorithm
% + Discrete Wavelet Transformation is applied to filter the signal
%==========================================================================
% Prerequisite files: wavelet_decompose.m
%==========================================================================
% EKG signal R peak and T peak detection
% INPUTS:
% + signal    : The given scalar time series ECG
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
%==========================================================================
% For more references and information, please visit
% Link: https://github.com/nguyenpham95/MY_THESIS
%==========================================================================
signal_filtered = signal;
std_thres = 1;
sqrt_operation = 4;
thres_start = 3;
thres_stop = 10;
isothres = 10;
min_peak_distance = floor(0.4 * fs);
need_to_remove = [];
%% PREPROCESSING-----------------------------------------------------------
%-BASELINE REMOVAL---------------------------------------------------------
[approx, detail] = wavelet_decompose(signal_filtered, 8, 'db4');
signal_filtered = signal_filtered - approx(:,8);   
%-CLEAN THE SIGNAL---------------------------------------------------------
filt = fir1(24,[5/(fs/2), 15/(fs/2)],'bandpass');
signal_filtered = conv(signal_filtered, filt);
signal_filtered = signal_filtered(12:end);
%-NORMALIZATION CODES------------------------------------------------------
signal_filtered = signal_filtered - mean(signal_filtered);
L = length(signal_filtered);
Ex = 1/L * sum(abs(signal_filtered).^2);
signal_filtered = signal_filtered / Ex;
%-NORMALIZA THE SIGNAL FROM 0 TO 1
if min(signal_filtered) < 0
    signal_filtered = signal_filtered + abs(min(signal_filtered));
    signal_filtered = signal_filtered / max(signal_filtered);
end;
%% GENERAL PARAMETERS-------------------------------------------------------
QRS_amps = [];
QRS_locs = [];
T_amps = [];
T_locs = [];
delay = 0;
%-QRS DETECTION-------------------------------------------------         
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
delay = delay + 6;               % delay of derivative filter 2 samples
%% obtained the data for QRS detection
segment = ecg_d(delay:end);
%-BRING THE signal_filtered ABOVE 0----------------------------------------
if min(segment) < 0
   segment = segment + abs(min(segment));
end;
segment = segment.^sqrt_operation;  
thres_mean = (mean(segment) + std_thres * std(segment)) * ones(1,length(segment));
[pks, locs] = findpeaks(segment,'MinPeakDistance',min_peak_distance);
for i = 1:length(locs)
    if pks(i) > thres_mean(1)
       ind = locs(i);
       QRS_amps(end + 1) = signal_filtered(ind);
       QRS_locs(end + 1) = ind;
    end;
end;
%-REJECTION CRITERIA-------------------------------------------------------
for i = 3:length(QRS_locs) - 2
    value1 = (QRS_locs(i) - QRS_locs(i - 1)) / (QRS_locs(i - 1) - QRS_locs(i - 2));
    value2 = (QRS_locs(i + 1) - QRS_locs(i - 1)) / (QRS_locs(i - 1) - QRS_locs(i - 2));
    value3 = (QRS_locs(i + 2) - QRS_locs(i + 1)) / (QRS_locs(i - 1) - QRS_locs(i - 2));
    if value1 < 0.5 && abs(value2 - value3) < 0.75
        need_to_remove(end + 1) = i;
    end;
end;
for i = 1:length(need_to_remove)
    QRS_amps(need_to_remove(i)) = [];
    QRS_locs(need_to_remove(i)) = [];
end;
%-T WAVE DETECTION---------------------------------------------------------
sig = signal_filtered;
%-LOW PASS FILTER TO REMOVE OTHER WAVES------------------------------------
filt = fir1(24,5/(fs/2),'low');
sig = conv(filt, sig);
sig = sig(12:end);
%-SMOOTHING----------------------------------------------------------------
moving_average = ones(1,24)./24;
sig = conv(sig, moving_average);
sig = sig(12:end);
%-ZEROLIZING EACH BEAT INTERVAL--------------------------------------------
for hk = 1:length(QRS_locs) - 1
    try
        data = sig(QRS_locs(hk):QRS_locs(hk + 1));
        leng = floor((QRS_locs(hk + 1) - QRS_locs(hk)) / 20);
        if leng == 0
            leng = 1;
        end;
        isoelec = sig(QRS_locs(hk) + isothres * leng);
        data = data - isoelec;
        data = data.^sqrt_operation;
        data = data(thres_start * leng:thres_stop * leng);
        [pks, locs] = findpeaks(data);
        T_threshold = mean(data) + 1 * std(data);
        if ~isempty(locs)
            for tp = length(locs):-1:1
                if pks(tp) > T_threshold
                    ind = locs(tp);
                    break;
                end;
            end;
        else
            ind = floor((thres_stop - thres_start) / 2 * leng);
        end;
        if isempty(ind)
            ind = floor((thres_stop - thres_start) / 2 * leng);
        end;
        T_locs(end + 1) = QRS_locs(hk) + thres_start * leng + ind;
        T_amps(end + 1) = signal_filtered(QRS_locs(hk) + thres_start * leng + ind);
    catch
       disp('An error occur during T peak detection.');
    end;
end;
%-END OF T DETECTION-------------------------------------------------------
%-PLOTTING SECTION---------------------------------------------------------
%figure1 = figure;
%set(figure1,'name','RT detection','numbertitle','off');
%plot(signal_filtered);title('signal_filtered');
%hold on;plot(QRS_locs,QRS_amps,'o');
%hold on;plot(T_locs,T_amps,'^');