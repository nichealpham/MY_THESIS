function [Q_amps, Q_locs, T_amps, T_locs] = nguyenpham_RTdetection(signal,fs)
%=========================================================================
% IMPORTANT NOTES:
% For improved accuracy, only use this function for limp leads
%=========================================================================
% Prerequisite files:
% This file can be found together with the this file when extracting the archive
% wavelet_decompose.m
%=========================================================================
% EKG signal R peak and T peak detection
% given time series 'signal'.
% INPUTS:
% - signal    : The given scalar time series
% - fs        : Sampling frequency
% OUTPUTS
% - Q_amps  : Array of Q wave amplitudes
% - Q_locs  : Array of Q wave location
% - T_amps  : Array of T wave amplitudes
% - T_locs  : Array of T wave location
%========================================================================
% v 1.0 2017/01/11 22:09:14  Nguyen Pham
% This is part of my university project: https://github.com/nguyenpham95/MY_THESIS
%========================================================================
% Copyright (C) 2017 by Nguyen Pham 
%                       <phamkhoinguyen1995@gmail.com>
%========================================================================
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
%=========================================================================
% Methodologies:
% Link: https://github.com/nguyenpham95/MY_THESIS
% Find documentation at directory ~/research/prethesis/HK2/PRETHESIS REPORT.pdf
%=========================================================================
% For more references and information, please visit
% Link: https://github.com/nguyenpham95/MY_THESIS
%=========================================================================
%-DELINEATION----------------------------------------------------------
    %-READ SIGNAL----------------------------------------------------------
        seg = signal;
        %-SIGNAL PREPROCESSING---------------------------------------------
        %-BASELINE REMOVAL-------------------------------------------------
        [approx, detail] = wavelet_decompose(seg, 11, 'db11');
        seg = seg - approx(:,11);
        baseline = approx(:,11);
        %-NOISE ESTIMATION REMOVAL-----------------------------------------
        [approx, detail] = wavelet_decompose(seg, 1, 'sym2');
        noise_level = detail(:,1);
        noise_variance = 1.483 * median(noise_level);
        noise_threshold = noise_variance * sqrt(2 * log(length(noise_level)));
        for hkn = 1:length(noise_level)
            if abs(noise_level(hkn)) < noise_threshold
                noise_level(hkn) = 0;
            end;
        end;
        %-DENOISING--------------------------------------------------------
        seg = seg - noise_level;
        % GENERAL PARAMETERS-----------------------------------------------
        Q_amps = [];
        Q_locs = [];
        T_amps = [];
        T_locs = [];
        %-QRS DETECTION----------------------------------------------------
        %-Filter 10 - 25Hz to remove other waves---------------------------
        filt = fir1(24, [10/(fs/2) 25/(fs/2)],'bandpass');
        seg2 = conv(filt,seg);
        seg2 = seg2(12:end,1);
        %-BRING THE SIGNAL ABOVE 0-----------------------------------------
        seg2 = seg2 + abs(min(seg2));
        seg2 = seg2.^12;    
        thres_mean = (mean(seg2) + std(seg2)) * ones(1,length(seg2));
        [pks, locs] = findpeaks(seg2,'MinPeakDistance',100);
        for i = 1:length(locs)
            if pks(i) > thres_mean(1)
                ind = locs(i);
                Q_amps(end + 1) = seg(ind);
                Q_locs(end + 1) = ind;
            end;
        end;
        %-T WAVE DETECTION-----------------------------------------------------
        sig = seg - seg2(14:end);
        %-ZEROLIZING EACH BEAT INTERVAL-------------------------------------------
        for hk = 1:length(Q_locs) - 1
            data = sig(Q_locs(hk):Q_locs(hk + 1));
            leng = floor((Q_locs(hk + 1) - Q_locs(hk)) / 10);
            isoelec = seg(Q_locs(hk) + 6 * leng);
            data = data - isoelec;
            data = abs(data);
            data = data.^12;
            if length(data) > 220
                thres2 = 2;
            else
                thres2 = 3;
            end;
            data = data(thres2 * leng:6 * leng);
            [val, ind] = max(data);
            T_locs(end + 1) = Q_locs(hk) + thres2 * leng + ind;
            T_amps(end + 1) = seg(Q_locs(hk) + thres2 * leng + ind);
        end;
    % END OF DELENIATION---------------------------------------------------
    %-PLOTTING SECTION-----------------------------------------------------
    figure1 = figure;
    set(figure1,'name','RT detection','numbertitle','off');
    subplot(4,1,1);plot(seg(1:Q_locs(end)));title('sig');
    hold on;plot(Q_locs,Q_amps,'o');
    hold on;plot(T_locs,T_amps,'^');
    subplot(4,1,2);plot(seg2);title('QRS peaks');
    hold on;plot(thres_mean);
    subplot(4,1,3);plot(noise_level);title('noise level');
    subplot(4,1,4);plot(baseline);title('Baseline wander');