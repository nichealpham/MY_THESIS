% DELINEATION VISUAL INSPECTION
% --------------------------------------------------
% MORPHOLOGY INSPECTION
% --------------------------------------------------
samp2plot = 1500;
ind2plot = 5;
% sam2plot : number of sample to plot
% ind2plot : number of beat to be inspected
figure3 = figure;
set(figure3,'name','VISUAL_INSPECT_ECG_DELINEATION','numbertitle','off');
plot(sig1(1:samp2plot));
hold on;
for i = 1:ind2plot
    if ~isnan(fieldname.Pon(i)) && ~isnan(fieldname.Poff(i)) && ...
       ~isnan(fieldname.QRSoff(i))&& ~isnan(fieldname.Ton(i))&& ...
       ~isnan(fieldname.Toff(i)) && ~isnan(fieldname.QRSon(i));
            x1 = fieldname.Pon(i):fieldname.Poff(i);
            y1 = sig1(x1);
            patch(x1,y1,'b');
            x2 = fieldname.QRSon(i):fieldname.QRSoff(i);
            y2 = sig1(x2);
            patch(x2,y2,'r');
            x3 = fieldname.Ton(i):fieldname.Toff(i);
            y3 = sig1(x3);
            patch(x3,y3,'g');
            x4 = fieldname.QRSoff(i):fieldname.Ton(i);
            y4 = sig1(x4);
            patch(x4,y4,'y');
    end;
end;
% --------------------------------------------------