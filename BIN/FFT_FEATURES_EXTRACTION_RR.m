% FFT FEATURES EXTRACTION RR interval
fft_features = [];
hflf = [];
fband = [];
L = hea.nsamp;
seg = [];
%	from	: =3 means window starts at the third beat
%	to	: =5 means window ends at the 5 beat
%	step	: =2 means each window contains 2 beats
% beat_start = 1;
% number_of_beat_to_display = 4;
step = 0;

for i = 1:length(fieldname.Pon)-1
    
    if ~isnan(fieldname.R(i)) && ~isnan(fieldname.R(i + step + 1))
            seg = sig1(fieldname.R(i):fieldname.R(i + step + 1));
            seg = seg(:,1);
            L = length(seg);
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
            Psmooth = smooth(P1,8,'loess');
            [xmax,imax,xmin,imin] = extrema(Psmooth);

            f = fs*(0:(L/2))/L;
            
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
            hflf(end + 1) = HFLF;
            for m = 2:length(imin)-1
            % -----------------------------------------------------------------------
            % THRESHOLD TO DETECT FIRST FFT MINIMUM = 4.5
            % -----------------------------------------------------------------------
                if f(imin(m)) > 12 && -(xmin(m) / xmax_sorted(1)) < 1/10
                    endpoint = m;                 
                    break;
                else
           
                    continue;
                end;
            end;
            fband(end+1) = floor(f(imin(endpoint)));
            % title(strcat(beatANN,{' fband'},{': '},num2str(floor(f(imin(endpoint)))),{'Hz, HFLF: '},num2str(HFLF)));
     end;        

end;
fband_shortened = fband < 32;
fft_features = [hflf' fband' fband_shortened'];

figure4 = figure;
set(figure4,'name','HFLF AND FBAND SERIES','numbertitle','off');
subplot(1,3,1);plot(hflf);title('HFLF Series');
subplot(1,3,2);plot(fband);title('fband');
subplot(1,3,3);plot(Tmag);title('Tmag');