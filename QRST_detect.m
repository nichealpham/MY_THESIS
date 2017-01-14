try
std_thres = 3;
sqrt_operation = 2;
thres_start = 3;
thres_stop = 10;
isothres = 10;
signal_filtered = signal;
need_to_remove = [];
% GENERAL PARAMETERS-------------------------------------------------------
QRS_amps = [];
QRS_locs = [];
T_amps = [];
T_locs = [];
%-QRS DETECTION------------------------------------------------------------
[qrs_amp_raw,qrs_i_raw,delay,ecg_h]=pan_tompkin(signal,250,0);
for pan = 1:length(qrs_i_raw)
    ind = qrs_i_raw(pan);
    QRS_locs(end + 1) = ind;
    QRS_amps(end + 1) = signal_filtered(ind);
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
%-SMOOTH-----------------------------------------------------------
moving_average = ones(1,24)./24;
sig = conv(sig, moving_average);
sig = sig(12:end);
%-ZEROLIZING EACH BEAT INTERVAL--------------------------------------------
for hk = 1:length(QRS_locs) - 1
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
    for tp = length(locs):-1:1
        if pks(tp) > T_threshold
            ind = locs(tp);
            break;
        end;
    end;
    T_locs(end + 1) = QRS_locs(hk) + thres_start * leng + ind;
    T_amps(end + 1) = signal_filtered(QRS_locs(hk) + thres_start * leng + ind);
end;
catch
    disp('An error occured during this calibration');
end;