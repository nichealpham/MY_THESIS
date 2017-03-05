function [ecgout baseline] = baseline_subtract(ecgin, iso_t, fs, cfs);
% [ecgout baseline] = baseline_subtract(ecgin, iso_t, fs, cfs);
%
% Function to remove baseline wander from the ECG using 
% a cubic spline procedure. 
% Parameters:
%             ecgin : Single channel of ECG
%             iso_t : time stamps of where the iso-electric points are 
%                fs : Sampling Frequency of ECG recording (default = 1kHz)
%               cfs : The cubic spline resampling frequency (default 5Hz)
% Notes: 
%       -After cubic spline interpolation, the baseline is resampled from 
%        cfs Hz to fs Hz using an antialiasing filtering procedure. 
%       -Therefore, fs/cfs should be a whole number
%
% Written by G. Clifford gari@ieee.org and made available under the 
% GNU general public license. If you have not received a copy of this 
% license, please download a copy from http://www.gnu.org/
%
% Please distribute (and modify) freely, commenting
% where you have added modifications. 
% The author would appreciate correspondence regarding
% corrections, modifications, improvements etc.
%
% (C) G. D. Clifford 2005 gari at mit dot edu

% plotflag=1 ... plot data.
plotflag =1;

if nargin<1
 error('You must supply an ecg vector')    
end
if nargin<4
cfs = 5; 
end
if nargin < 3
fs = 1000;
end
if (round(fs/cfs)~=(fs/cfs))
     fprintf('fs/cfs is not a whole number - resampling may not work\n')
end

if nargin <2
 ecgin = [];
end

t = [1:1:length(ecgin)]/fs;

if(isempty(iso_t))
 [hrv, R_t, R_amp, R_index, S_t, S_amp] = rpeakdetect(ecgin, fs, 0.5, 0);
 a=50;
 iso_t = t(R_index-a); 
end

iso_x=ecgin(R_index-a);
baseline_t = iso_t;
baseline_x = iso_x;

% cubic spline construction at cfs Hz
[baseline_t,baseline_x] =  interp_RR(baseline_t,baseline_x,cfs,3);

% resample to input sample frequency
baseline = resample(baseline_x,fs,cfs);

% remove baseline
ecgtmp = ecgin(R_index(1):R_index(length(R_index)));
ecgout = ecgtmp-baseline(1:length(ecgtmp)); %'


if plotflag==1
% for visualisation:
plot(t,ecgin); hold on
plot(t(R_index),ecgin(R_index),'>k')
plot(baseline_t, baseline_x,'m');
newt = [1:1:length(ecgtmp)];
isox = zeros(1,length(ecgtmp));
figure;
plot(newt,ecgtmp,'c');                    % original ECG
hold on;
plot(newt,ecgout);                        % Baseline subtracted ECG
plot(newt,isox,'r');                      % isoelectric line
plot(newt,baseline(1:length(isox)),'m');  % splined baseline that was subtracted

legend('Original ECG','Baseline subtracted ECG','Iso-electric line','Baseline')
end
