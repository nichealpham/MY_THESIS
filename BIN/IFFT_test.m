for i = 1:length(fieldname.QRSon)
    if ~isnan(fieldname.QRSon(i)) && ~isnan(fieldname.QRSoff(i+FFT_beat_step))
fs = 250;
Ylow = [];
Yhigh = [];
endpoint = 0;

seg = sig1(fieldname.QRSon(i):fieldname.QRSoff(i+FFT_beat_step));
L = length(seg);
f = fs*(0:(L/2))/L;
Y = fft(seg);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
% Calculate lfhf ratio with Power array P1 and Frequency range f
[lfhf, lf, hf] = calc_lfhf(f,P1);

figure6 = figure;
set(figure6,'name','IFFT TEST','numbertitle','off');

% Psmooth = smooth(f,P1,smooth_span,smooth_type);
[Psmooth, P_under_envelope] = envelope(P1,envelope_size,'peak');
[xmax,imax,xmin,imin] = extrema(Psmooth);
xmax_sorted = sort(-xmax);
xmin_sorted = sort(-xmin);


for m = 1:length(imin)-1
    % -----------------------------------------------------------------------
    % THRESHOLD TO DETECT FIRST FFT MINIMUM = 4.5
    % -----------------------------------------------------------------------
         if f(imin(m)) > 12 && -(xmin(m) / xmax_sorted(1)) < 1/2
              endpoint = m;                                       
              break;
         else
              continue;
         end;
end;
for i = 1:length(Y)
    if i <= imin(endpoint)
          Ylow(end + 1) = Y(i);
          Yhigh(end + 1) = 0;
    else
          Ylow(end + 1) = 0;
          Yhigh(end + 1) = Y(i);
    end;
end;
subplot(3,3,[1,2,3]);plot(seg);title(['Signal' '-' num2str(lfhf)]);
subplot(3,3,4);yyaxis left;plot(f,P1);title('Spectral');axis([0 inf 0 inf]);hold on;yyaxis right;plot(f,Psmooth,'r');axis([0 inf 0 inf]);
% hold on;
% fill(f(1:imin(endpoint)),Psmooth(1:imin(endpoint)),'b');
hold on;
plot(f(imax(1)),-xmax_sorted(1),'r*',f(imin(endpoint)),xmin(endpoint),'g*');
subplot(3,3,5);plot(Y);hold on;plot(Ylow);title('Ylow');
subplot(3,3,6);plot(Y);hold on;plot(Yhigh);title('Yhigh');
subplot(3,3,7);plot(ifft(Ylow,length(Y)));title('Recontructed Ylow');
subplot(3,3,8);plot(ifft(Yhigh,length(Y)));title('Recontructed Yhigh');
subplot(3,3,9);plot(ifft(Ylow + Yhigh));title('Recontructed');
break;
    else
        continue;
    end;
end;
maxfig(figure6,1);
