warning('off','all');
STA_bin = [];
beat_bin = [];
SP_bin = [];
BSLD_bin = [];
LVL_bin = [];
num = floor(length(fieldname.QRSon)/10);
for i = 1:num
    if ~isnan(fieldname.QRSoff(i)) && ~isnan(fieldname.T(i)) && ~isnan(fieldname.QRSon(i))
        disp([num2str(floor(i/num * 100)) '%']);
        % CALCULATE TOTAL SPECTRAL POWER-----------SP--------
        beat_data = sig1(fieldname.qrs(i):fieldname.qrs(i+1));
        beat_bin = [beat_bin; beat_data];
        L = length(beat_data);
        Y = fft(beat_data);
        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        f = fs*(0:(L/2))/L;
        SP = trapz(f,P1);
        SP_bin(end + 1) = SP;
        % ---------------------------------------------------
        % CALCULATE ST AREA-----------------------STA--------
        seg = sig1(fieldname.QRSoff(i):fieldname.T(i));
        curve_1 = seg;
        curve_2 = ones(length(seg),1) * sig1(fieldname.QRSoff(i));
        STA = trapz(curve_1) - trapz(curve_2);
        % SCALING FACTOR is the Spectral Power of that beat--
        STA = STA / SP;
        % NORMALIZE THE RESULT with total area of the whole beat
        % STA = STA / trapz(beat_data) * 100;
        STA_bin = [STA_bin; STA];
        % ---------------------------------------------------
        % CALCULATE BASELINE DRIFT-----------------BSLD------
        height = sig1(fieldname.QRSoff(i)) - sig1(fieldname.QRSon(i)); % Assume baseline at QRSon
        width = length(seg);
        BSLD = width * height;
        % SCALING FACTOR is the Spectral Power of that beat--
        BSLD = BSLD / SP;
        BSLD_bin(end + 1) = BSLD;
        % ---------------------------------------------------
        % CALCULATE LEVEL OF INJURY-----------------LVL------
        LVL_bin(end + 1) = abs(STA) + abs(BSLD);
        % ---------------------------------------------------
        clc;
    end;
end;
% GRAPHING-------------------------------------------
figure8 = figure;
set(figure8,'name',filename,'numbertitle','off');
%subplot(3,1,1);plot(beat_bin);hold on;plot(smooth(beat_bin,.04,'loess'));title('Time Series Data');
%subplot(3,1,2);plot(STA_bin);hold on;plot(smooth(STA_bin,.04,'loess'));title('ST Area Normalized');
%subplot(3,1,3);plot(SP_bin);hold on;plot(smooth(SP_bin,.04,'loess'));title('Spectral Power');
subplot(4,1,1);plot(beat_bin);hold on;plot(zeros(length(beat_bin),1));title('TIME SERIES');
subplot(4,1,2);plot(STA_bin);hold on;plot(zeros(length(STA_bin),1));title('ST LEVEL');
subplot(4,1,3);plot(LVL_bin);title('LEVEL OF INJURY');
subplot(4,1,4);plot(SP_bin);title('SPECTRAL POWER');
maxfig(figure8,1);
% ---------------------------------------------------