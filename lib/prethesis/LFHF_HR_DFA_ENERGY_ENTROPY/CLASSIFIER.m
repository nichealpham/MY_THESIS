analysis_smooth = [meanSTD stdSTD ENTROPY meanHR stdHR DFA LFHF FBAND ENERGY_RATIO ENTROPY_CUTOFF Tinv STslope STATUS meanSTD./meanHR];
spss = analysis_smooth;
for i = 1:length(spss)
    if spss(i,1) > 3 || spss(i,12) > 40000
        spss(i,13) = 1;         % Transient ST Elevation
    elseif spss(i,1) < -3 || spss(i,12) < -40000
        spss(i,13) = 1;         % Transient ST Depression
    elseif spss(i,11) < 10
        spss(i,13) = 1;         % T inverted or absence
    elseif spss(i,4) > 110      % High HR
        spss(i,13) = 1;
    elseif spss(i,4) < 50       % Low HR
        spss(i,13) = 1;         
    elseif spss(i,5)/spss(i,4) > 1/3
        spss(i,13) = 1;
    else
        spss(i,13) = 0;
    end;
end;