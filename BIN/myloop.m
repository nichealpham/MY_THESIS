function y = myloop(ind2start,ind2stop,fieldname,sig1)
    field = fieldname;
    sig = sig1;
    for i = ind2start:ind2stop
        if ~isnan(fieldname.P(i)) && ~isnan(fieldname.Q(i)) && ~isnan(fieldname.R(i)) && ...
           ~isnan(fieldname.S(i)) && ~isnan(fieldname.T(i)) && ~isnan(fieldname.Pon(i)) && ... 
           ~isnan(fieldname.Poff(i)) && ~isnan(fieldname.QRSoff(i)) && ~isnan(fieldname.Ton(i)) && ...
           ~isnan(fieldname.Toff(i)) && ~isnan(fieldname.QRSon(i));
            if i == ind2stop
                patchFromThisBeatToThisBeat(ind2start,ind2stop,field,sig);
                
                break;
            end;
        else
            myloop(ind2start + 1, ind2stop + 1,field);
            break;
        end;
    end;
    y = 1;
end