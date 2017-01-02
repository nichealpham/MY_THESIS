STD_HR = meanSTD./meanHR;
spss = [meanSTD stdSTD ENTROPY meanHR stdHR DFA1 LFHF FBAND ENERGY_RATIO ENTROPY_CUTOFF Tinv STATUS STD_HR];
for i = 1:length(spss)
    if abs(spss(i,1)) > 10 % STE or STD
        spss(i,12) = 1;
    elseif spss(i,11) < -5
        spss(i,12) = 1;
    else
        spss(i,12) = 0;
    end;
end;