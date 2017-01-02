% FIRST NORMALIZE SIGNAL FROM 0 TO 1
% This step is done in the TASKS_HANDLE, muc dich de quare tin hieu
% R peaks xuat hien ro net nhat ma k bi nhieu
data_length = span * fs;
startpoint = (inputloop - 1) * data_length + 1;
endpoint = inputloop * data_length;
seg = sig1(startpoint:endpoint);
% FIRST SMOOTH THE SIGNAL
[approx, detail] = wavelet_decompose(seg, 11, 'db11');
seg = seg - approx(:,11);
baseline = approx(:,11);
%[approx, detail] = wavelet_decompose(seg, 8, 'db4');
%seg = seg - approx(:,8);
%baseline = approx(:,8);
%filt = fir1(24, 40/(250/2),'low');
%seg = conv(filt,seg);
%seg = seg(24:end,1);
% GENERAL PARAMETERS
QRS_amps = [];
QRS_locs = [];
QRS_amps2 = [];
QRS_locs2 = [];
T_amps = [];
T_locs = [];
seg2 = seg + abs(min(seg));
%seg1 = seg2;
% APPLY TEARU TRANSFORMATION, BIEN seg2
%for qrsind = 3:length(seg1)-2
%    seg2(qrsind) = seg1(qrsind)^4 - seg1(qrsind-2)*seg1(qrsind-1)*seg1(qrsind+1)*seg1(qrsind+2);
%end;
seg2 = seg2.^12;
thres_mean = (mean(seg2) + 0 * std(seg2)) * ones(1,length(seg2));
%thres_mean = mean(seg2) * ones(1,length(seg2));
[pks, locs] = findpeaks(seg2,'MinPeakDistance',100);
for i = 1:length(locs)
    if pks(i) > thres_mean(1)
        ind = locs(i);
        QRS_amps(end + 1) = seg(ind);
        QRS_locs(end + 1) = ind;
    end;
end;
sig = seg;
% FILTER WITH LOWPASS
%filt = fir1(24, 40/(250/2),'low');
%sig = conv(filt,sig);
%sig = sig(12:end,1);
% FILTER WITH WAVELET
%sig = sig - detail(:,9) - detail(:,8);
for i = 2:length(QRS_locs)
    leng = floor((QRS_locs(i) - QRS_locs(i - 1))/4);
    %leng = (QRS_locs(i) - QRS_locs(i - 1));
    %sig((QRS_locs(i - 1) + floor(.5 * leng)):(QRS_locs(i) + floor(1/5 * leng))) = 0;
    sig((QRS_locs(i - 1):(QRS_locs(i - 1)  + leng - 15))) = 0;
    sig((QRS_locs(i - 1) + floor(2 * leng)):(QRS_locs(i))) = 0;
end;
sig(1 : QRS_locs(1) + leng) = 0;
if (QRS_locs(end) + floor(1 * leng) - 15) >= length(seg)
    sig(QRS_locs(end) - 10 : end) = 0;
else
    sig(QRS_locs(end) : QRS_locs(end) + floor(1* leng) - 15) = 0;
end;
sig_based = sig;
if abs(min(sig)) > abs(max(sig))            % T wave inv
    sig = sig.^2;
else
    sig = sig + abs(min(sig));
    sig = sig.^2;
end;
%thres_T = (mean(sig) + T_std_thres * std(sig)) * ones(1,length(sig));
thres_T = mean(sig) * ones(1,length(sig));
[pks, locs] = findpeaks(sig,'MinPeakDistance',100);
for i = 1:length(locs)
    if pks(i) > thres_T(1) && locs(i) < length(seg)
        ind = locs(i);
        T_amps(end + 1) = seg(ind);
        T_locs(end + 1) = ind;
    end;
end;
if length(QRS_locs) ~= length(T_locs)
    continue;
end;



