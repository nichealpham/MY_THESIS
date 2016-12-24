STA_bin = [];
STTA_bin = [];
level_bin = [];
soring_bin = [];
beat_bin = [];
for i = 1:length(fieldname.QRSon)/20
    if ~isnan(fieldname.QRSoff(i)) && ~isnan(fieldname.Ton(i))
        disp([num2str(floor(i / length(fieldname.QRSon) * 100)) ' %']);
        % CALCULATE TOTAL SPECTRAL POWER-----------SP--------
        beat_data = sig1(fieldname.QRSoff(i):fieldname.QRSoff(i+1));
        beat_bin = [beat_bin; beat_data];
        L = length(beat_data);
        Y = fft(beat_data);
        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        f = fs*(0:(L/2))/L;
        SP = trapz(f,P1);
        % ---------------------------------------------------
        % CALCULATE ST AREA-----------------------STA--------
        seg = sig1(fieldname.QRSoff(i):fieldname.Ton(i));
        curve_1 = seg;
        curve_2 = ones(length(seg),1) * sig1(fieldname.QRSoff(i));
        STA = trapz(curve_1) - trapz(curve_2);
        STA_bin = [STA_bin; STA];
        % ---------------------------------------------------
        % CALCULATE LEVEL OF INJURY---------------level------
        height = sig1(fieldname.QRSoff(i)) - 0; % Assume baseline at 0V
        width = length(seg);
        level = abs(width * height);
        level_bin = [level_bin; level];
        % ---------------------------------------------------
        % CALCULATE STTA AND SORING---------------STTA-soring
        if sig1(fieldname.QRSoff(i)) < 0 %  OTHER WORDS: level < 0
            % this indicate the ST is below the iso-electric baseline
            % then magnify the area
            STTA = STA - level;
            STTA_bin = [STTA_bin; STTA];
            soring = STTA * level;
            soring_bin = [soring_bin; soring];
        else
            STTA = STA + level;
            STTA_bin = [STTA_bin; STTA];
            soring = STTA * level;
            soring_bin = [soring_bin; soring];
        end;       
        % ---------------------------------------------------
        % NORMALIZE BY SPECTRAL POWER------------------------
        % STA_bin = STA_bin / SP;
        % STTA_bin = STTA_bin / SP;
        % soring_bin = soring_bin / (SP^2);
        % ---------------------------------------------------
        % ACCESSING AND NORMALIZING DATA
        
        % ------------------------------
        clc;
    end;
end;
% GRAPHING-------------------------------------------
figure8 = figure;
set(figure8,'name',['STTA vs Sig: ' filename],'numbertitle','off');
subplot(3,3,[1,2,3]);plot(beat_bin);title('Data');
subplot(3,3,[4,5,6]);plot(STA_bin);title('STA');
subplot(3,3,[7,8,9]);plot(soring_bin);title('soring');
maxfig(figure8,1);
% ---------------------------------------------------