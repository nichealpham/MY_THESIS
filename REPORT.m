T_std_thres = 1;
span = 10;
fraction = 1/2;
% CALCULATE SOLOOP---------------------------------------------------------
total_length = length(sig1);
window_length = fs * span;
number_of_loop = floor(total_length * fraction / window_length);
for soloop = 1:number_of_loop
%for soloop = 1:5
    %-DISPLAY SOME TEXT ON THE SCREEN------------------------------------------
    clc;
    percent = soloop / number_of_loop;
    disp([num2str(record) '/' num2str(length(recordings)) '. ' filename ': ' num2str(floor(percent * 100)) '%']);
    inputloop = soloop;
    %-DELINEATION----------------------------------------------------------
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
        % REJECTION CRITERIA-----------------------------------------------
        if length(QRS_locs) ~= length(T_locs)
            rejected = rejected + 1;
            continue;
        end;
        for rjloop = 2:length(QRS_locs)
            condition = QRS_locs(rjloop) - QRS_locs(rjloop - 1);
            if condition > 450
                rejected = rejected + 1;
                continue;
            end;
        end;
        for rjloop = 2:length(T_locs)
            condition = T_locs(rjloop) - T_locs(rjloop - 1);
            if condition > 450
                rejected = rejected + 1;
                continue;
            end;
        end;
        for rjloop = 1:length(T_locs)
            condition = T_locs(rjloop) - QRS_locs(rjloop);
            if condition > 250 || condition < 25
                rejected = rejected + 1;
                continue;
            end;
        end;
        %-END OF REJECTION CRITERIA----------------------------------------
    % END OF DELENIATION---------------------------------------------------
    beat_start = 1;
    beat_end = length(QRS_locs);
    %-PARAMETERS-----------------------------------------------------------
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
    ST_on_locs = [];
    ST_off_locs = [];
    ST_on_amps = [];
    ST_off_amps = [];
    %----------------------------------------------------------------------
    number_of_samples = span * fs;
    index2start = (inputloop - 1) * number_of_samples + 1;
    index2end = inputloop * number_of_samples;
    % CALCULATE NUMBER OF BEATS COVERED------------------------------------
    number_of_beat_covered = beat_end - beat_start;
    mean_HR = floor(number_of_beat_covered / (span / 60));
    beat_end = beat_start + number_of_beat_covered - 1;
    %-CALDULATE STslope----------------------------------------------------
    STslope = [];
    for km = beat_start:beat_end-1
        if ~isnan(QRS_locs(km)) && ~isnan(T_locs(km))
            leng = floor((T_locs(km) - QRS_locs(km))/4);
            pheight = (seg(QRS_locs(km) + floor(2.6 * leng)) - seg(QRS_locs(km) + floor(1.6 * leng))) / seg(QRS_locs(km)) * 100;
            width = floor(2.6 * leng) - floor(1.6 * leng);
            STslope(end + 1) = pheight / width * 10;
            Tinv(end + 1) = seg(T_locs(km));
            ToR(end + 1) = abs(seg(T_locs(km))) / abs(seg(QRS_locs(km))) * 100;
            ST_on_locs(end + 1) = QRS_locs(km) + floor(1.6 * leng);
            ST_on_amps(end + 1) = seg(QRS_locs(km) + floor(1.6 * leng));
            ST_off_locs(end + 1) = QRS_locs(km) + floor(2.6 * leng);
            ST_off_amps(end + 1) = seg(QRS_locs(km) + floor(2.6 * leng));
        end;
    end;
    %-CALDULATE STDeviation------------------------------------------------
    for km = beat_start:beat_end-1
        if ~isnan(QRS_locs(km)) && ~isnan(T_locs(km))
            leng = floor((T_locs(km) - QRS_locs(km))/4);
            pdata = seg((QRS_locs(km) + floor(1.6 * leng)):(QRS_locs(km) + floor(2.6 * leng)));
            %reference = seg((QRS_locs(km)-25):(QRS_locs(km)+25));
            RRinterval = QRS_locs(km + 1) - QRS_locs(km);
            iso = ones(length(pdata),1) * seg(QRS_locs(km) + floor(0.5 * RRinterval));
            %Normalize STD with its data length
            STDeviation(end + 1) = (trapz(pdata) - trapz(iso)) / length(pdata) * 100 * 10;
            %STDeviation(end + 1) = (trapz(pdata));
        end;
    end;
    %-CALCULATE HR---------------------------------------------------------
    for i = beat_start:beat_end
       step_size = QRS_locs(i+1) - QRS_locs(i);
       hr = 60 / (step_size / 250);
       HR(end + 1) = hr;
    end;
    %-CALCULATE DFA--------------------------------------------------------
    for i = beat_start:beat_end
       data = seg(QRS_locs(i):QRS_locs(i+1));
       dfa = DetrendedFluctuation(data);
       DFA(end + 1) = dfa;
    end;
    %-CALCULATING THE SCORE------------------------------------------------
    score = 0;
    mean_STD = mean(STDeviation);
    mean_STS = mean(STslope);
    mean_HR = mean(HR);
    mean_ToR = mean(ToR);
    mean_Tinv = mean(Tinv);
    mean_DFA = mean(DFA);
    if mean_STD > 60 || mean_STD < -40
        score = score + 1;
    end;
    if abs(mean_STS) > 6
        score = score + 1;
    end;
    if mean_Tinv < 0.01
        score = score + 1;
    end;
    %if mean_HR > 100 || mean_HR < 50
    %    score = score + 1;
    %end;
    if mean_DFA > 1
        score = score + 2;
    end;
    %-CALCULATE ENERGY_RATIO-----------------------------------------------
    for i = beat_start:beat_end
       data = seg(QRS_locs(i):QRS_locs(i+1));
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
    %-PLOTTING SECTION-----------------------------------------------------
    %figure2 = figure;
    %set(figure2,'name',filename,'numbertitle','off');
    %subplot(3,4,[9,10]);yyaxis left;plot(STDeviation);title(['STD: ' num2str(mean(STDeviation)) ' - slope: ' num2str(mean(STslope)) ' - Tinv: ' num2str(mean(Tinv)) ' - ToR: ' num2str(mean(ToR))]);yyaxis right;plot(STslope);
    %-THEN PLOT THE SIGNAL---------------------
    %subplot(3,4,[1,2]);plot(seg);title(['ECG' ' - ' num2str(mean_HR) ' bpm - score: ' num2str(score)]);axis([0 500 min(seg) max(seg)]);hold on;plot(QRS_locs,QRS_amps,'o');hold on;plot(T_locs,T_amps,'^');hold on;plot(ST_on_locs,ST_on_amps,'*');hold on;plot(ST_off_locs,ST_off_amps,'*');
    %subplot(3,4,[3,4]);yyaxis left;plot(HR);title(['HR: ' num2str(mean(HR)) ' - DFA: ' num2str(mean(DFA))]);yyaxis right;plot(DFA);
    %-CALCULATE FFT--------------------------------------------------------
    %-beat-to-beat FFT------------------------
    data = seg(QRS_locs(beat_start):QRS_locs(beat_start + 1));
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
    %subplot(3,4,5);plot(f,P1);title(['SE = ' num2str(aloha) ', DFA = ' num2str(aloho)]);axis([40 fs/2 0 max(P40)]);
    [app, det] = wavelet_decompose(P40, 3, 'db4');
    FFT_app = app(:,3);
    FFT_det = P40 - FFT_app;
    FFT_app_DFA = DetrendedFluctuation(FFT_app);
    %subplot(3,4,7);plot(FFT_app);title(['DFA = ' num2str(FFT_app_DFA)]);axis([1 length(FFT_app) 0 max(FFT_app)]);
    FFT_det_SA = SampEn(2, 0.15*std(FFT_det), FFT_det, 1);
    %subplot(3,4,8);plot(FFT_det);title(['SE = ' num2str(FFT_det_SA)]);
    %-series-FFT--------------------------------
    data = seg(QRS_locs(beat_start):QRS_locs(beat_end));
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
    %subplot(3,4,6);plot(P1(find(f >= 60)));title(['SE = ' num2str(aloha) ', DFA = ' num2str(aloho)]);
    %-CALCULATE LFHF-------------------------------------------------------
    %for i = beat_start:beat_end
    %   data = seg(QRS_locs(i-15):QRS_locs(i+15));
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
    %%subplot(3,4,[7,8]);plot(LFHF);title(['LFHF / DFA']);hold on;
    %%subplot(3,4,[11,12]);yyaxis left;plot(FBAND);title(['FBAND / ENTROPY']);
    %yyaxis right;plot(ENTROPY);
    %subplot(3,4,[11,12]);yyaxis left;plot(ENERGY_RATIO);title(['ENERY: ' num2str(mean(ENERGY_RATIO)) ' - ENTROPY: ' num2str(mean(ENTROPY_CUTOFF(~isinf(ENTROPY_CUTOFF))))]);axis([0 inf 0.02 0.12]);yyaxis right;plot(ENTROPY_CUTOFF);axis([0 inf 0.3 2.6]);maxfig(figure2,1);
    %-DATA SAVING SeCTION--------------------------------------------------

    STslope = STslope';
    RP_STslope_bin = [RP_STslope_bin; mean(STslope)];

    STDeviation = STDeviation';
    RP_STdev_bin = [RP_STdev_bin; mean(STDeviation)];

    HR = HR';
    RP_HR_bin = [RP_HR_bin; mean(HR)];

    DFA = DFA';
    RP_DFA_bin = [RP_DFA_bin; mean(DFA)];

    ENERGY_RATIO = ENERGY_RATIO';
    RP_ENERGY_RATIO_bin = [RP_ENERGY_RATIO_bin; mean(ENERGY_RATIO)];

    ENTROPY_CUTOFF = ENTROPY_CUTOFF';
    RP_ENTROPY_CUTOFF_bin = [RP_ENTROPY_CUTOFF_bin; mean(ENTROPY_CUTOFF)];

    Tinv = Tinv';
    RP_Tinv_bin = [RP_Tinv_bin; mean(Tinv)];

    ToR = ToR';
    RP_ToR_bin = [RP_ToR_bin; mean(ToR)];
    
        
    score_bin = [score_bin; score];
    
    accepted = accepted + 1;
    
    
end;

