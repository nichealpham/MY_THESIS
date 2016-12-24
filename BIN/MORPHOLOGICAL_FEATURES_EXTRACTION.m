% ----------------------
% MORPHOLOGICAL FEATURES
% ----------------------

% -----------------------------------------------------------------------
% FEATURES LIST
% -----------------------------------------------------------------------
% -----------------------------------------------------------------------
% MORPHOLOGICALS FEATURES
% -----------------------------------------------------------------------
Qmag = [];
Qdur = [];
RQmag = [];
RSmag = [];
QRSdur = [];
STdur = [];
STslope = [];
Tmag = [];
Tdur = [];
HFLFratio = [];
annScore = [];
QRSdur = [];
insHR = [];
% ---------------
if annNum < length(fieldname.Pon)
for i = 1:annNum;
    if ~isnan(fieldname.P(i)) && ~isnan(fieldname.Q(i)) && ~isnan(fieldname.R(i)) && ...
       ~isnan(fieldname.S(i)) && ~isnan(fieldname.T(i)) && ~isnan(fieldname.Pon(i)) && ... 
       ~isnan(fieldname.Poff(i)) && ~isnan(fieldname.QRSoff(i))&& ~isnan(fieldname.Ton(i))&& ...
       ~isnan(fieldname.Toff(i)) && ~isnan(fieldname.QRSon(i));
            % Morphology features
            Qmag(end + 1) = sig1(fieldname.P(i));
            Qdur(end + 1) = (fieldname.Poff(i) - fieldname.Pon(i)) * ts * 1000;
            Qpeak = sig1(fieldname.Q(i));
            Rpeak = sig1(fieldname.R(i));
            Speak = sig1(fieldname.S(i));
            RQmag(end + 1) = Rpeak - Qpeak;
            RSmag(end + 1) = Rpeak - Speak;
            annScore(end + 1) = uint8(ann.anntyp(i));
            STdur_temp = (fieldname.Ton(i) - fieldname.QRSoff(i)) * ts * 1000;
            STdur(end + 1) = STdur_temp;
            STslope(end + 1) = (sig1(fieldname.Ton(i)) - sig1(fieldname.QRSoff(i))) / STdur_temp;
            Tmag(end + 1) = sig1(fieldname.T(i)) - sig1(fieldname.Ton(i));
            Tdur(end + 1) = (fieldname.Toff(i) - fieldname.Ton(i)) * ts * 1000;
            if i == 1;
                insHR(end + 1) = 60/((fieldname.R(i + 1) - fieldname.R(i)) * ts);
            else 
                insHR(end + 1) = 60/((fieldname.R(i) - fieldname.R(i - 1)) * ts);
            end;
            QRSdur(end + 1) = (fieldname.QRSoff(i) - fieldname.QRSon(i)) * ts * 1000;
            % Frequency features
            
    end;
end;
else
    for i = 1:length(fieldname.Pon);
    if ~isnan(fieldname.P(i)) && ~isnan(fieldname.Q(i)) && ~isnan(fieldname.R(i)) && ...
       ~isnan(fieldname.S(i)) && ~isnan(fieldname.T(i)) && ~isnan(fieldname.Pon(i)) && ... 
       ~isnan(fieldname.Poff(i)) && ~isnan(fieldname.QRSoff(i))&& ~isnan(fieldname.Ton(i))&& ...
       ~isnan(fieldname.Toff(i)) && ~isnan(fieldname.QRSon(i));
            % Morphology features
            Qmag(end + 1) = sig1(fieldname.P(i));
            Qdur(end + 1) = (fieldname.Poff(i) - fieldname.Pon(i)) * ts * 1000;
            Qpeak = sig1(fieldname.Q(i));
            Rpeak = sig1(fieldname.R(i));
            Speak = sig1(fieldname.S(i));
            RQmag(end + 1) = Rpeak - Qpeak;
            RSmag(end + 1) = Rpeak - Speak;
            annScore(end + 1) = uint8(ann.anntyp(i));
            STdur_temp = (fieldname.Ton(i) - fieldname.QRSoff(i)) * ts * 1000;
            STdur(end + 1) = STdur_temp;
            STslope(end + 1) = (sig1(fieldname.Ton(i)) - sig1(fieldname.QRSoff(i))) / STdur_temp;
            Tmag(end + 1) = sig1(fieldname.T(i));
            Tdur(end + 1) = (fieldname.Toff(i) - fieldname.Ton(i)) * ts * 1000;
            if i == 1;
                insHR(end + 1) = 60/((fieldname.R(i + 1) - fieldname.R(i)) * ts);
            else 
                insHR(end + 1) = 60/((fieldname.R(i) - fieldname.R(i - 1)) * ts);
            end;
            QRSdur(end + 1) = (fieldname.QRSoff(i) - fieldname.QRSon(i)) * ts * 1000;
            % Frequency features
            
    end;
end;
end;
res = [Qmag' Qdur' RQmag' RSmag' STdur' STslope' Tmag' Tdur' insHR' annScore' QRSdur'];
resp = [resp;res];
figure1 = figure;
set(figure1,'name','MORPHOLOGICAL_FEATURES_EXTRACTION','numbertitle','off');
subplot(2,5,1);plot(Qmag);title('Qmag');
subplot(2,5,2);plot(Qdur);title('Qdur');
subplot(2,5,3);plot(RSmag);title('RSmag');
subplot(2,5,4);plot(RQmag);title('RQmag');
subplot(2,5,5);plot(QRSdur);title('QRSdur');
subplot(2,5,6);plot(STdur);title('STdur');
subplot(2,5,7);plot(STslope);title('STslope');
subplot(2,5,8);plot(Tmag);title('Tmag');
subplot(2,5,9);plot(Tdur);title('Tdur');
subplot(2,5,10);plot(insHR);title('HR');

