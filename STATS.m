%-PREDEFINCE---------------------------------------------------------------
% Used when data imported, comment out when performed after REPORT.m-------
% RP_DFA_bin = DFA;
% RP_ENERGY_RATIO_bin = ENERGY;
% RP_ENTROPY_CUTOFF_bin = SAMEN;
% RP_Tinv_bin = Tinv;
% RP_ToR_bin = ToR;
% score_bin = SCORE;
% RP_STslope_bin = STslope;
% RP_STdev_bin = STdev;
% RP_HR_bin = HR;
% RP_STATUS_bin = STATUS;
% aaaa = [RP_STslope_bin RP_STdev_bin RP_HR_bin RP_DFA_bin ...
%         RP_ENERGY_RATIO_bin RP_ENTROPY_CUTOFF_bin ...
%         RP_Tinv_bin RP_ToR_bin score_bin RP_STATUS_bin];
%-INNITIALIE VARIABLES-----------------------------------------------------
total_DFA_1 = 0;
accurate_DFA_1 = 0;
total_DFA_0 = 0;
accurate_DFA_0 = 0;
%-CALCULATE DFA SENSITIVITY------------------------------------------------
for i = 1:length(aaaa)
    if aaaa(i, 4) > 1                           % DFA > 1
        total_DFA_1 = total_DFA_1 + 1;
        if aaaa(i, 10) > 0                      % STATUS = 1
            accurate_DFA_1 = accurate_DFA_1 + 1;
        end;
    end;
end;
sensitivity_DFA = accurate_DFA_1 / total_DFA_1;
disp(['DFA sensitivity: ' num2str(sensitivity_DFA)]);
%-CALCULATE DFA SPECIFICITY------------------------------------------------
for i = 1:length(aaaa)
    if aaaa(i, 4) < 1                           % DFA < 1
        total_DFA_0 = total_DFA_0 + 1;
        if aaaa(i, 10) < 1                      % STATUS = 0
            accurate_DFA_0 = accurate_DFA_0 + 1;
        end;
    end;
end;
specificity_DFA = accurate_DFA_0 / total_DFA_0;
disp(['DFA specificity: ' num2str(specificity_DFA)]);