% FFT FEATURES EXTRACTION
fft_features = [];
lfhf_bin = [];
series = [];
scores = [];
fband = [];
L = hea.nsamp;
seg = [];
Tmag = [];
Tmag_bin = [];
Tmag_tem = 0;
STslope = [];
STslope_bin = [];
STslope_tem = 0;

count = 0;

countmax = length(fieldname.QRSon)/(FFT_beat_step*FFT_part_of_total_data_used);

for i = 1:FFT_beat_step:floor(length(fieldname.QRSon)/FFT_part_of_total_data_used)
    
  %  if ~isnan(fieldname.P(i)) && ~isnan(fieldname.Q(i)) && ~isnan(fieldname.R(i)) && ...
  %     ~isnan(fieldname.S(i)) && ~isnan(fieldname.T(i)) && ~isnan(fieldname.Pon(i)) && ... 
  %     ~isnan(fieldname.Poff(i)) && ~isnan(fieldname.QRSoff(i))&& ~isnan(fieldname.Ton(i))&& ...
  %     ~isnan(fieldname.Toff(i + FFT_beat_step)) && ~isnan(fieldname.QRSon(i));
     if ~isnan(fieldname.QRSon(i)) && ~isnan(fieldname.QRSon(i + FFT_beat_step)) %&& ...
                %~isnan(fieldname.QRSoff(i)) && ~isnan(fieldname.Ton(i)) && ...
                %((sig1(fieldname.Ton(i)) - sig1(fieldname.QRSoff(i))) / ((fieldname.Ton(i) - fieldname.QRSoff(i)) * ts * 1000)) > 2
                % --------------------------------------------------------
            % CODE to calculate T magnitude average
            for k = i:i+FFT_beat_step
                if ~isnan(fieldname.QRSoff(i)) && ~isnan(fieldname.Ton(i)) && ~isnan(fieldname.T(i))
                    Tmag_tem = sig1(fieldname.T(i)) - sig1(fieldname.Ton(i));
                    Tmag_bin(end + 1) = Tmag_tem;
                    STdur_temp = (fieldname.Ton(i) - fieldname.QRSoff(i)) * ts * 1000;
                    
                    STseg = sig1(fieldname.QRSoff(i):fieldname.Ton(i));
                    times = 0:(length(STseg)-1);
                    
                    STslope_tem = (sig1(fieldname.Ton(i)) - sig1(fieldname.QRSoff(i))) / STdur_temp;
                    STslope_bin(end + 1) = trapz(times, STseg);
                end;
            end;    
            Tmag(end + 1) = mean(Tmag_bin);
            STslope(end + 1) = mean(STslope_bin);
            Tmag_bin = [];
            STslope_bin = [];
            % CODE to calculate FBAND and SCORE average
            seg = sig1(fieldname.QRSon(i):fieldname.QRSon(i + FFT_beat_step));            
            seg = seg(:,1);
            L = length(seg);
            
            % ------------------------------------------------------------
            % ATTENTION: In order to get good FBAND result, SMOOTH the
            % signal BEFORE FFT
            % ------------------------------------------------------------
            % seg = smooth(seg,10);
            % ------------------------------------------------------------
            series = [series; seg];
            
            % Compute the Fourier transform of the signal.
            Y = fft(seg);

            % Compute the two-sided spectrum P2. 
            P2 = abs(Y/L);

            % Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            % -----------------------------------------------------------------------
            % SMOOTHING: CHANGE MOVING AVARAGE HERE
            % -----------------------------------------------------------------------
            f = fs*(0:(L/2))/L;
            
            [lfhf, lf, hf] = calc_lfhf(f,P1);
            lfhf_bin(end + 1) = lfhf;
            
            Psmooth = smooth(f,P1,smooth_span,smooth_type);
            [xmax,imax,xmin,imin] = extrema(Psmooth);

            
            
            endpoint = 1;
            % sort descending
            xmax_sorted = sort(-xmax);
            xmin_sorted = sort(-xmin);
            for o = 1:length(xmax_sorted)
                highestMax_mag = xmax_sorted(1);
                if length(xmax_sorted) > o
                    secondMax_mag = xmax_sorted(o + 1);
                    HFLF = highestMax_mag/secondMax_mag;
                    if HFLF > 10
                        break;
                    else
                        continue;
                    end;
                else
                    break;
                end;
                
            end;
            for m = 1:length(imin)-1
            % -----------------------------------------------------------------------
            % THRESHOLD TO DETECT FIRST FFT MINIMUM = 4.5
            % -----------------------------------------------------------------------
                if f(imin(m)) > 12 && -(xmin(m) / xmax_sorted(1)) < 1/6
                    endpoint = m;    
                    score = trapz(f(imin(endpoint):length(f)),P1(imin(endpoint):length(P1))) / trapz(f,P1) * 1000;
                    scores(end+1) = score;
                    break;
                else
                    continue;
                end;
            end;
            fband(end+1) = floor(f(imin(endpoint)));
            % title(strcat(beatANN,{' fband'},{': '},num2str(floor(f(imin(endpoint)))),{'Hz, HFLF: '},num2str(HFLF)));
     end;        
     count = count + 1;
     disp(strcat(num2str(count), {'/'}, num2str(floor(countmax))));
end;
fband_shortened = fband < 32;
% series = smooth(series,10);
figure4 = figure;
set(figure4,'name','HFLF AND FBAND SERIES','numbertitle','off');
subplot(3,2,1);plot(fband);title('FBAND (Hz)');hold on;plot(smooth(fband,.08,'loess'));
subplot(3,2,2);plot(scores);title('AREA of High Freq');hold on;plot(smooth(scores,.08,'loess'));
subplot(3,2,3);plot(lfhf_bin);title('LFHF');hold on;plot(smooth(lfhf_bin,.08,'loess'));
subplot(3,2,4);plot(STslope);title('ST Slope');hold on;plot(smooth(STslope,.08,'loess'));
subplot(3,2,[5,6]);plot(seg);title('Segment');
maxfig(figure4,1);