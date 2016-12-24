% --------------------------------------------------
% FFT THEN PLOT WITH SIGNAL
% --------------------------------------------------
L = hea.nsamp;
seg = [];
%	from	: =3 means window starts at the third beat
%	to	: =5 means window ends at the 5 beat
%	step	: =2 means each window contains 2 beats
from = 3;
to = 5;
step = 0;
k = to - from + 1;
for i = from:to
seg = sig1(QRS.ML2.Pon(i):QRS.ML2.Toff(i + step));
seg = seg(:,1);
L = length(seg);
% Compute the Fourier transform of the signal.
Y = fft(seg);

% Compute the two-sided spectrum P2. 
P2 = abs(Y/L);

% Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

% Plot the spectral response
subplot(2,k,(i - from + 1));
f = fs*(0:(L/2))/L;
plot(f,P1);
title('Single-Sided Amplitude Spectrum of X(t)');
xlabel('f (Hz)');
ylabel('|P1(f)|');
end;
for i = from:to
seg = sig1(QRS.ML2.Pon(i):QRS.ML2.Toff(i + step));
seg = seg(:,1);
subplot(2,k,(i - from + 1 + k));
plot(seg);
end;
% --------------------------------------------------