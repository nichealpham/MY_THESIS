std_thres = 3;
sqrt_operation = 6;
thres_start = 1;
thres_stop = 6;
isothres = 5;
signal_filtered = signal;
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