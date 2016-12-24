function plotout = patchFromThisBeatToThisBeat(ind2start,ind2stop,fieldname,sig1)
    for i = ind2start:ind2stop
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
        plotout = 1;
    end;
end