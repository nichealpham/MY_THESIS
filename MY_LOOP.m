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
beat_end = beat_start + number_of_beat_covered;
%-SEGMENTATION-------------------------------------------------------------
seg = sig1(index2start:index2end);
%-CALDULATE STDeviation----------------------------------------------------
%VALIDATE2;
%meanSTDeviation(end + 1) = mean(STDeviation);
%stdSTDeviation(end + 1) = std(STDeviation);
%-CALDULATE STDeviation----------------------------------------------------
STDeviation = [];
Twave_temp = [];
for km = beat_start:beat_end
    if ~isnan(fieldname.qrs(km)) && ~isnan(fieldname.T(km))
        leng = floor((fieldname.T(km) - fieldname.qrs(km))/3);
        data = sig1((fieldname.qrs(km)+leng):(fieldname.qrs(km)+2*leng));
        %iso = ones(length(data),1) * sig1(fieldname.qrs(km)+leng);
        %STDeviation(end + 1) = (trapz(data) - trapz(iso))*100;
        STDeviation(end + 1) = (trapz(data))*100;
        data2 = sig1((fieldname.qrs(km)+2*leng):fieldname.T(km));
        Tiso = ones(length(data2),1) * sig1((fieldname.qrs(km)+2*leng));
        Twave_temp(end + 1) = (trapz(data2) - trapz(Tiso)) * 100;
    end;
end;
%for km = beat_start:beat_end
%    if ~isnan(fieldname.qrs(km)) && ~isnan(fieldname.T(km))
%        leng = floor((fieldname.T(km) - fieldname.qrs(km))/3);
%        height = sig1(fieldname.qrs(km)+2*leng) - sig1(fieldname.qrs(km)+leng);
%        width = leng;
%        STDeviation(end + 1) = height / width *100;
%    end;
%end;
meanSTDeviation(end + 1) = mean(STDeviation);
stdSTDeviation(end + 1) = std(STDeviation);
Twave(end + 1) = mean(Twave_temp);
%-CALDULATE STslope--------------------------------------------------------
STslope_temp = [];
for km = beat_start:beat_end
    if ~isnan(fieldname.qrs(km)) && ~isnan(fieldname.T(km))
        leng = floor((fieldname.T(km) - fieldname.qrs(km))/3);
        height = leng;
        width = sig1(fieldname.qrs(km)+2*leng) - sig1(fieldname.qrs(km)+leng);
        STslope_temp(end + 1) = width / height * 10^8;
    end;
end;
STslope(end + 1) = mean(STslope_temp);
%-GET ANN------------------------------------------------------------------
%ann_temp = [];
%for hm = beat_start:beat_end
%    if ~isnan(ann.anntyp(hm))
%        ann_temp(end + 1) = ann.anntyp(hm);
%    end;
%end;
%ANN(end + 1) = mode(ann_temp);
%disp([mode(ann_temp)]);
%-CALDULATE HR-------------------------------------------------------------
for i = beat_start:beat_end
   step_size = fieldname.qrs(i+1) - fieldname.qrs(i);
   hr = 60 / (step_size / 250);
   HR(end + 1) = hr;
end;
meanHR(end + 1) = mean(HR);
stdHR(end + 1) = std(HR);
%-CALCULATE LFHF-----------------------------------------------------------
data = sig1(fieldname.qrs(beat_start):fieldname.qrs(beat_end));
L = length(data);
f = fs*(0:(floor(L/2)))/L;
Y = fft(data);
P2 = abs(Y/L);
P1 = P2(1:floor(L/2)+1);
P1(2:end-1) = 2*P1(2:end-1);        
[lfhf, lf, hf] = calc_lfhf(f,P1);
LFHF(end + 1) = lfhf;
%-CALCULATE DFA------------------------------------------------------------
data = sig1(fieldname.qrs(beat_start):fieldname.qrs(beat_end));
dfa = DetrendedFluctuation(data);
DFA(end + 1) = dfa;
%-CALCULATE FBAND-+-ENTROPY------------------------------------------------

   data = sig1(fieldname.qrs(beat_start):fieldname.qrs(beat_end));
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
           entropy = SampEn(5, 0.2*std(samp), samp, 1);
           ENTROPY(end + 1) = entropy;
           break;
       else
           continue;
       end;
   end;

%-Convert inf and nan into max(ENTROPY)----------
%for i = 1:length(ENTROPY)
%    if isnan(ENTROPY(i)) || isinf(ENTROPY(i))
%        ENTROPY(i) = max(ENTROPY(ENTROPY < inf));
%    end;
%end;

%-CALCULATE ENERGY_RATIO---------------------------------------------------

   data = sig1(fieldname.qrs(beat_start):fieldname.qrs(beat_end));
   L = length(data);
   f = fs*(0:(floor(L/2)))/L;
   Y = fft(data);
   P2 = abs(Y/L);
   P1 = P2(1:floor(L/2)+1);
   P1(2:end-1) = 2*P1(2:end-1);        
   temp = P1(find(f>=40));
   ENERGY_RATIO(end + 1) = trapz(temp) / trapz(P1);
   % Co 2 cach tinh entropy
   % Cach 1: entropy dua theo envelop
   %[temp_smooth, temp_under_envelope] = envelope(temp,1,'peak');
   % Cach 2: entropy dua theo smooth
   %temp_smooth = smooth(temp,smooth_span,smooth_type);
   temp2 = SampEn(5, 0.2*std(temp), temp, 1);
   ENTROPY_CUTOFF(end + 1) = temp2;

