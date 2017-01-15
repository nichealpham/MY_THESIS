%-CONFIGURATION------------------------------------------------------------
beat_start = 1;
span = 10;
%-PARAMETERS---------------------------------------------------------------
HR = [];
FFT = [];
LFHF = [];
DFA = [];
FBAND = [];
ENTROPY = []; % Correlate good with DFA, con giu
STDeviation = [];
FFT_app = [];
FFT_det = [];
Tinv = [];
ToR = [];
% Cut off frequency = 40Hz, can be changed
ENERGY_RATIO = [];
ENTROPY_CUTOFF = [];
%--------------------------------------------------------------------------
number_of_samples = span * fs;
index2start = fieldname.qrs(beat_start);
index2end = index2start + number_of_samples;
% CALCULATE NUMBER OF BEATS COVERED----------------------------------------
number_of_beat_covered = 0;
for i = beat_start:length(fieldname.qrs)
    if (fieldname.qrs(i) < index2end)
        number_of_beat_covered = number_of_beat_covered + 1;
    else
        break;
    end;
end;
mean_HR = floor(number_of_beat_covered / (span / 60));
beat_end = beat_start + number_of_beat_covered;
%-SEGMENTATION-------------------------------------------------------------
seg = sig1(index2start:index2end);
%-CALDULATE STslope--------------------------------------------------------
STslope = [];
for km = beat_start:beat_end
    if ~isnan(fieldname.qrs(km)) && ~isnan(fieldname.T(km))
        leng = floor((fieldname.T(km) - fieldname.qrs(km))/4);
        pheight = (sig1(fieldname.qrs(km) + floor(2.6 * leng)) - sig1(fieldname.qrs(km) + floor(1.6 * leng))) / sig1(fieldname.qrs(km)) * 100;
        width = floor(2.6 * leng) - floor(1.6 * leng);
        STslope(end + 1) = pheight / width * 10;
        Tinv(end + 1) = (sig1(fieldname.T(km)) - sig1(fieldname.T(km) - floor(0.5 * leng))) * 10;
        ToR(end + 1) = sig1(fieldname.T(km)) / sig1(fieldname.qrs(km)) * 100;
    end;
end;
%-CALDULATE STDeviation----------------------------------------------------
for km = beat_start:beat_end
    if ~isnan(fieldname.qrs(km)) && ~isnan(fieldname.T(km))
        leng = floor((fieldname.T(km) - fieldname.qrs(km))/4);
        pdata = sig1((fieldname.qrs(km) + floor(1.6 * leng)):(fieldname.qrs(km) + floor(2.6 * leng)));
        %reference = sig1((fieldname.qrs(km)-25):(fieldname.qrs(km)+25));
        RRinterval = fieldname.qrs(km + 1) - fieldname.qrs(km);
        iso = ones(length(pdata),1) * sig1(fieldname.qrs(km) + floor(0.5 * RRinterval));
        %Normalize STD with its data length
        STDeviation(end + 1) = (trapz(pdata) - trapz(iso)) / length(pdata) * 100 * 10;
        %STDeviation(end + 1) = (trapz(pdata));
    end;
end;
%STDeviation = imresize(STDeviation,[1 (number_of_beat_covered + 1)]);
STDeviation = STDeviation';
STDeviation_bin = [STDeviation_bin; STDeviation];
figure2 = figure;
set(figure2,'name',filename,'numbertitle','off');
subplot(3,4,[9,10]);yyaxis left;plot(STDeviation);title(['STD: ' num2str(mean(STDeviation)) ' - slope: ' num2str(mean(STslope)) ' - Tinv: ' num2str(mean(Tinv))]);
yyaxis right;plot(STslope);
%-THEN PLOT THE SIGNAL---------------------
subplot(3,4,[1,2]);plot(seg);title(['ECG' ' - ' num2str(mean_HR) ' bpm']);
axis([0 500 min(seg) max(seg)]);
%-CALCULATE HR-------------------------------------------------------------
for i = beat_start:beat_end
   step_size = fieldname.qrs(i+1) - fieldname.qrs(i);
   hr = 60 / (step_size / 250);
   HR(end + 1) = hr;
end;
HR = HR';
HR_bin = [HR_bin; HR];

%-CALCULATE DFA------------------------------------------------------------
for i = beat_start:beat_end
   data = sig1(fieldname.qrs(i):fieldname.qrs(i+1));
   dfa = DetrendedFluctuation(data);
   DFA(end + 1) = dfa;
end;
DFA = DFA';
DFA_bin = [DFA_bin; DFA];
subplot(3,4,[3,4]);yyaxis left;plot(HR);title(['HR: ' num2str(mean(HR)) ' - DFA: ' num2str(mean(DFA))]);
yyaxis right;plot(DFA);
%-CALCULATE FFT------------------------------------------------------------
%-beat-to-beat FFT------------------------
data = sig1(fieldname.qrs(beat_start):fieldname.qrs(beat_start + 1));
L = length(data);
f = fs*(0:(floor(L/2)))/L;
Y = fft(data);
P2 = abs(Y/L);
P1 = P2(1:floor(L/2)+1);
P1(2:end-1) = 2*P1(2:end-1);
sss = find(f>=40 & f<=(fs/2));
P40 = P1(sss);
aloha = SampEn(2, 0.15*std(P40), P40, 1);
aloho = DetrendedFluctuation(P40);
subplot(3,4,5);plot(f,P1);title(['SE = ' num2str(aloha) ', DFA = ' num2str(aloho)]);
axis([40 fs/2 0 max(P40)]);
[app, det] = wavelet_decompose(P40, 3, 'db4');
FFT_app = app(:,3);
FFT_det = P40 - FFT_app;
FFT_app_DFA = DetrendedFluctuation(FFT_app);
subplot(3,4,7);plot(FFT_app);title(['DFA = ' num2str(FFT_app_DFA)]);
axis([1 length(FFT_app) 0 max(FFT_app)]);
FFT_det_SA = SampEn(2, 0.15*std(FFT_det), FFT_det, 1);
subplot(3,4,8);plot(FFT_det);title(['SE = ' num2str(FFT_det_SA)]);
%-series-FFT--------------------------------
data = sig1(fieldname.qrs(beat_start):fieldname.qrs(beat_end));
L = length(data);
f = fs*(0:(floor(L/2)))/L;
Y = fft(data);
P2 = abs(Y/L);
P1 = P2(1:floor(L/2)+1);
P1(2:end-1) = 2*P1(2:end-1);
P1_smooth = smooth(P1,20/L,'rloess');
P1_smooth = resample(P1_smooth,length(P1_smooth),length(f));
aloha = SampEn(2, 0.15*std(P1_smooth), P1_smooth, 1);
aloho = DetrendedFluctuation(P1_smooth);
subplot(3,4,6);plot(P1(find(f >= 60)));title(['SE = ' num2str(aloha) ', DFA = ' num2str(aloho)]);
%-CALCULATE LFHF-----------------------------------------------------------
%for i = beat_start:beat_end
%   data = sig1(fieldname.qrs(i-15):fieldname.qrs(i+15));
%   L = length(data);
%   f = fs*(0:(floor(L/2)))/L;
%   Y = fft(data);
%   P2 = abs(Y/L);
%   P1 = P2(1:floor(L/2)+1);
%   P1(2:end-1) = 2*P1(2:end-1);        
%   [lfhf, lf, hf] = calc_lfhf(f,P1);
%   LFHF(end + 1) = lfhf;
%end;
%LFHF = LFHF';
%LFHF_bin = [LFHF_bin; LFHF];
%subplot(3,4,[7,8]);plot(LFHF);title(['LFHF / DFA']);hold on;
%-CALCULATE FBAND-+-ENTROPY------------------------------------------------
for i = beat_start:beat_end
   data = sig1(fieldname.qrs(i):fieldname.qrs(i+1));
   L = length(data);
   f = fs*(0:(floor(L/2)))/L;
   Y = fft(data);
   P2 = abs(Y/L);
   P1 = P2(1:floor(L/2)+1);
   P1(2:end-1) = 2*P1(2:end-1);        
   total_energy = trapz(P1);
   cutoff_energy = 1/5 * total_energy;
   for k = 1:length(P1)
       energy = trapz(P1(k:end));
       if energy < cutoff_energy
           FBAND(end + 1) = f(k);
           samp = P1(k:end);
           %-Method 2: complexity from fband > 20Hz
           %-samp = P1(20:end);
           entropy = SampEn(6, 0.5*std(samp), samp, 1);
           ENTROPY(end + 1) = entropy;
           break;
       else
           continue;
       end;
   end;
end;
%-Convert inf and nan into max(ENTROPY)----------
for i = 1:length(ENTROPY)
    if isnan(ENTROPY(i)) || isinf(ENTROPY(i))
        ENTROPY(i) = max(ENTROPY(ENTROPY < inf));
    end;
end;
FBAND = FBAND';
ENTROPY = ENTROPY';
FBAND_bin = [FBAND_bin; FBAND];
ENTROPY_bin = [ENTROPY_bin; ENTROPY];
%-CALCULATE ENERGY_RATIO---------------------------------------------------
for i = beat_start:beat_end
   data = sig1(fieldname.qrs(i):fieldname.qrs(i+1));
   L = length(data);
   f = fs*(0:(floor(L/2)))/L;
   Y = fft(data);
   P2 = abs(Y/L);
   P1 = P2(1:floor(L/2)+1);
   P1(2:end-1) = 2*P1(2:end-1);
   %P1 = smooth(P1,0.1,'rloess');
   temp = P1(find(f>=40));
   ENERGY_RATIO(end + 1) = trapz(temp) / trapz(P1);
   temp2 = SampEn(2, 0.15*std(temp), temp, 1);
   %temp2 = DetrendedFluctuation(temp);
   ENTROPY_CUTOFF(end + 1) = temp2;
end;
%subplot(3,4,[11,12]);yyaxis left;plot(FBAND);title(['FBAND / ENTROPY']);
%yyaxis right;plot(ENTROPY);
ENERGY_RATIO = ENERGY_RATIO';
ENTROPY_CUTOFF = ENTROPY_CUTOFF';
ENERGY_RATIO_bin = [ENERGY_RATIO_bin; ENERGY_RATIO];
ENTROPY_CUTOFF_bin = [ENTROPY_CUTOFF_bin; ENTROPY_CUTOFF];
subplot(3,4,[11,12]);yyaxis left;plot(ENERGY_RATIO);title(['ENERY RATIO: ' num2str(mean(ENERGY_RATIO)) ' - ENTROPY CUTOFF: ' num2str(mean(ENTROPY_CUTOFF(~isinf(ENTROPY_CUTOFF))))]);
axis([0 inf 0.02 0.12]);
yyaxis right;plot(ENTROPY_CUTOFF);
axis([0 inf 0.3 2.8]);
maxfig(figure2,1);