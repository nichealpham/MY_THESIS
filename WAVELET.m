QRS_std_thres = 1;
span = 15;
for soloop = 1:1
    inputloop = soloop;
    %-READ SIGNAL----------------------------------------------------------
    data_length = span * fs;
    startpoint = (inputloop - 1) * data_length + 1;
    endpoint = inputloop * data_length;
    seg = sig1(startpoint:endpoint);
    %-SIGNAL PREPROCESSING-------------------------------------------------
    %-BASELINE REMOVAL-----------------------------------------------------
    [approx, detail] = wavelet_decompose(seg, 11, 'db11');
    seg = seg - approx(:,11);
    baseline = approx(:,11);
    %-NOISE ESTIMATION REMOVAL---------------------------------------------
    [approx, detail] = wavelet_decompose(seg, 1, 'sym2');
    noise_level = detail(:,1);
    noise_variance = 1.483 * median(noise_level);
    noise_threshold = noise_variance * sqrt(2 * log(length(noise_level)));
    for hkn = 1:length(noise_level)
        if abs(noise_level(hkn)) < noise_threshold
            noise_level(hkn) = 0;
        end;
    end;
    %-DENOISING------------------------------------------------------------
    seg = seg - noise_level;
    %-GENERAL PARAMETERS---------------------------------------------------
    QRS_amps = [];
    QRS_locs = [];
    QRS_amps2 = [];
    QRS_locs2 = [];
    T_amps = [];
    T_locs = [];
    %-QRS DETECTION--------------------------------------------------------
    %-Filter 10 - 25Hz to remove other waves-------------------------------
    filt = fir1(24, [10/(fs/2) 25/(fs/2)],'bandpass');
    seg2 = conv(filt,seg);
    seg2 = seg2(12:end,1);
    %-BRING THE SIGNAL ABOVE 0---------------------------------------------
    seg2 = seg2 + abs(min(seg2));
    seg2 = seg2.^12;    
    thres_mean = (mean(seg2) + QRS_std_thres * std(seg2)) * ones(1,length(seg2));
    [pks, locs] = findpeaks(seg2,'MinPeakDistance',100);
    for i = 1:length(locs)
        if pks(i) > thres_mean(1)
            ind = locs(i);
            QRS_amps(end + 1) = seg(ind);
            QRS_locs(end + 1) = ind;
        end;
    end;
    %-T WAVE DETECTION-----------------------------------------------------
    sig = seg;
    %-ZEROING EACH BEAT INTERVAL-------------------------------------------
    for hk = 1:length(QRS_locs) - 1
        data = sig(QRS_locs(hk):QRS_locs(hk + 1));
        leng = floor((QRS_locs(hk + 1) - QRS_locs(hk)) / 10);
        isoelec = seg(QRS_locs(hk) + 6 * leng);
        data = data - isoelec;
        data = abs(data);
        data = data.^12;
        data = data(2 * leng:6 * leng);
%         [val, ind] = findpeaks(data);
%         max_peaks = max(val);
%         ind = ind(find(val == max_peaks));
        [val, ind] = max(data);
        T_locs(end + 1) = QRS_locs(hk) + 2 * leng + ind;
        T_amps(end + 1) = seg(QRS_locs(hk) + 2 * leng + ind);
    end;
    %-REJECTION CRITERIA---------------------------------------------------
%     for rjloop = 2:length(QRS_locs)
%         condition = QRS_locs(rjloop) - QRS_locs(rjloop - 1);
%         if condition > 450
%             continue;
%         end;
%     end;
%     for rjloop = 2:length(T_locs)
%         condition = T_locs(rjloop) - T_locs(rjloop - 1);
%         if condition > 450
%             continue;
%         end;
%     end;
%     for rjloop = 1:length(T_locs)
%         condition = T_locs(rjloop) - QRS_locs(rjloop);
%         if condition > 250 || condition < 25
%             continue;
%         end;
%     end;
    %-PLOTTING SECTION-----------------------------------------------------
    figure4 = figure;
    set(figure4,'name',[filename ' - ' num2str(soloop)],'numbertitle','off');
    subplot(4,1,1);plot(seg(1:QRS_locs(end)));title('sig');
    hold on;plot(QRS_locs,QRS_amps,'o');
    hold on;plot(T_locs,T_amps,'^');
    subplot(4,1,2);plot(seg2);title('QRS peaks');
    hold on;plot(thres_mean);
    subplot(4,1,3);plot(noise_level);title('noise level');
    subplot(4,1,4);plot(baseline);title('Baseline wander');
    maxfig(figure4,1);
end;

