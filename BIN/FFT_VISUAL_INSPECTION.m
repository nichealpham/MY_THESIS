% FFT VISUAL INSPECTION
% --------------------------------------------------
% FFT VERSUS ITS SIGNAL INSPECTION
% --------------------------------------------------
L = hea.nsamp;
seg = [];
databin = [];
%	from	: =3 means window starts at the third beat
%	to	: =5 means window ends at the 5 beat
%	FFT_beat_step	: =2 means each window contains 2 beats
beat_start = 1;
% beat_off = 15;
beat_off = length(fieldname.QRSon)-31;
desired_count = 0;
limit = 8;
bin = desired_count;
k = limit - desired_count + 1;
figure2 = figure;
set(figure2,'name','FFT_VISUAL_INSPECTION','numbertitle','off');
beatANN = 'APAKA';
data_high = [];
data_low = [];
data_high_bin = [];
data_low_bin = [];
for i = beat_start:FFT_beat_step:beat_off
    if desired_count <= limit
        if ~isnan(fieldname.QRSon(i)) && ~isnan(fieldname.QRSon(i + FFT_beat_step)) %&& ...
                %~isnan(fieldname.QRSoff(i)) && ~isnan(fieldname.Ton(i)) && ...
                %((sig1(fieldname.Ton(i)) - sig1(fieldname.QRSoff(i))) / ((fieldname.Ton(i) - fieldname.QRSoff(i)) * ts * 1000)) > 2
                % --------------------------------------------------------
            seg = sig1(fieldname.QRSon(i):fieldname.QRSon(i + FFT_beat_step));
            seg = seg(:,1);
            L = length(seg);
            % NORMALIZATION CODES-----------------
            seg = seg - mean(seg);
            Ex = 1/L * sum(abs(seg).^2);
            seg = seg / Ex;
            % ------------------------------------
            databin = [databin; seg];
            % ------------------------------------------------------------
            % ATTENTION: In order to get good FBAND result, SMOOTH the
            % signal BEFORE FFT
            % ------------------------------------------------------------
            % seg = smooth(seg,10);
            % ------------------------------------------------------------
            % CODE TO GET THE ANNOTATION FOR THIS BEAT
            Qindex = fieldname.QRSon(i);
            for mn = 2:length(ann.time)
                if ann.time(mn) > Qindex
                    beatANN = ann.anntyp(mn - 1);
                    break;
                else
                    continue;
                end;
            end;
            
            % Compute the Fourier transform of the signal.
            % -----------------------------------------------------------
            % SMOOTH THE SIGNAL FIRST
            % -----------------------------------------------------------
            % seg = smooth(seg,4);
            Y = fft(seg);
            % Now smooth the frequency response
            % -----------------------------------------------------------------------
            % ATTENTION: smoothing will shorten the frequency banwidth, do not used
            % -----------------------------------------------------------------------
            % references: https://www.mathworks.com/help/signal/examples/signal-smoothing.html
            % h = [1/2 1/2];
            % binomialCoeff = conv(h,h);
            % for n = 1:4
            %    binomialCoeff = conv(binomialCoeff,h);
            % end;
            % fDelay = (length(binomialCoeff)-1)/2;
            % Y = filter(binomialCoeff, 1, Y);

            % Compute the two-sided spectrum P2. 
            P2 = abs(Y/L);

            % Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            % -----------------------------------------------------------------------
            % SMOOTHING: CHANGE MOVING AVARAGE HERE
            % -----------------------------------------------------------------------
            f = fs*(0:(L/2))/L;
            Psmooth = smooth(f,P1,smooth_span,smooth_type);
            [xmax,imax,xmin,imin] = extrema(Psmooth);
            % -----------------------------------------------------------------------
            %[xmax,imax] = findpeaks(Psmooth);
            % Flip the signal downward
            %for n = 1:length(Psmooth)
            %    Psmooth(n) = 0 - Psmooth(n);
            %end;
            % FInd the local minima
            %[xmin,imin] = findpeaks(Psmooth);
            % reverse the signal again
            %for n = 1:length(Psmooth)
            %    Psmooth(n) = 0 - Psmooth(n);
            %end;
            % plot(f(imax),xmax,'r*',f(imin),xmin,'g*');
            % Plot the spectral response
            % -----------------------------------------------------------------------
            subplot(2,k,desired_count + 1);
            
            plot(f,Psmooth);
            hold on;

            endpoint = 0;
            % sort descending
            xmax_sorted = sort(-xmax);
            xmin_sorted = sort(-xmin);
            for o = 1:length(xmax_sorted)
                highestMax_mag = xmax_sorted(1);
                secondMax_mag = xmax_sorted(o + 1);
                HFLF = highestMax_mag/secondMax_mag;
                if HFLF > 10
                    break;
                else
                    continue;
                end;
            end;

            for m = 1:length(imin)-1
            % -----------------------------------------------------------------------
            % THRESHOLD TO DETECT FIRST FFT MINIMUM = 4.5
            % -----------------------------------------------------------------------
                if f(imin(m)) > 15 && -(xmin(m) / xmax_sorted(1)) < 1/8
                    
                    endpoint = m;
                    data_low = ifft(P1(1:imin(m)),length(seg));
                    data_high = ifft(P1(imin(m):end),length(seg));
                    data_low_bin = [data_low_bin; data_low];
                    data_high_bin = [data_high_bin; data_high];
                    plot(f(imax(1)),-xmax_sorted(1),'r*',f(imin(m)),xmin(m),'g*');
                    score = trapz(f(imin(endpoint):length(f)),P1(imin(endpoint):length(P1))) / trapz(f,P1) * 1000;
                    break;
                else
                    continue;
                end;
            end;
            title(strcat(beatANN,{'-'},num2str(floor(f(imin(endpoint)))),{'-'},num2str(floor(HFLF)),{'-'},num2str(floor(score))));
            xlabel('f (Hz)');
            ylabel('|P1(f)|');
            % beat_start = beat_start + 1;
            desired_count = desired_count + 1;
        end;        
    else
        
        if desired_count == limit
            break;
        else
            continue;
        end;
    end;


end;

subplot(2,k,(k+1):2*k);
plot(databin);
figure(2);
subplot(3,1,1);plot(databin);
subplot(3,1,2);plot(data_high_bin);
subplot(3,1,3);plot(data_low_bin);
% --------------------------------------------------