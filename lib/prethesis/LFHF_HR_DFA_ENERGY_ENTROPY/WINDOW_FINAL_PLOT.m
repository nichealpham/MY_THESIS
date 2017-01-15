disp('Running final plot');
analysis = [meanSTDeviation_bin stdSTDeviation_bin ENTROPY_bin meanHR_bin stdHR_bin DFA_bin LFHF_bin FBAND_bin ENERGY_RATIO_bin ENTROPY_CUTOFF_bin Twave_bin STslope_bin];
% Sau khi gan xong bo data nay, detect any nan or inf value and destroy
% them
analysis_fina = [];
for hm = 1:length(analysis)
    if ~isnan(analysis(hm,1:end))
        analysis_fina = [analysis_fina;analysis(hm,1:end)];
    end;
end;
analysis_final = [];
for hm = 1:length(analysis_fina)
    if ~isinf(analysis_fina(hm,1:end))
        analysis_final = [analysis_final;analysis_fina(hm,1:end)];
    end;
end;
disp('Smoothing...');
meanSTDeviation_bin_smooth = smooth(analysis_final(:,1),smooth_span,smooth_type);
stdSTDeviation_bin_smooth = smooth(analysis_final(:,2),smooth_span,smooth_type);
ENTROPY_bin_smooth = smooth(analysis_final(:,3),smooth_span,smooth_type);
meanHR_bin_smooth = smooth(analysis_final(:,4),smooth_span,smooth_type);
stdHR_bin_smooth = smooth(analysis_final(:,5),smooth_span,smooth_type);
DFA_bin_smooth = smooth(analysis_final(:,6),smooth_span,smooth_type);
LFHF_bin_smooth = smooth(analysis_final(:,7),smooth_span,smooth_type);
FBAND_bin_smooth = smooth(analysis_final(:,8),smooth_span,smooth_type);
ENERGY_RATIO_bin_smooth = smooth(analysis_final(:,9),smooth_span,smooth_type);
ENTROPY_CUTOFF_bin_smooth = smooth(analysis_final(:,10),smooth_span,smooth_type);
Twave_bin_smooth = smooth(analysis_final(:,11),smooth_span,smooth_type);
STslope_bin_smooth = smooth(analysis_final(:,12),smooth_span,smooth_type);
figure3 = figure;
set(figure3,'name','Cross record combined','numbertitle','off');
subplot(3,4,[9,10]);yyaxis left;plot(meanSTDeviation_bin_smooth);title('ST Deviation / T mag');
yyaxis right;plot(Twave_bin_smooth);
subplot(3,4,[1,2]);
%yyaxis left;plot(ENTROPY_bin);title(['ENTROPY']);
%yyaxis right;plot(ENTROPY_CUTOFF_bin);
plot(ENTROPY_bin_smooth);hold on;plot(ENTROPY_CUTOFF_bin_smooth);title(['ENTROPY / ENTROPY_CUTOFF']);
subplot(3,4,[3,4]);plot(meanHR_bin_smooth);title(['meanHR']);
subplot(3,4,[5,6]);plot(DFA_bin_smooth);title(['DFA']);
subplot(3,4,[7,8]);plot(LFHF_bin_smooth);title(['LFHF']);
subplot(3,4,[11,12]);
%yyaxis left;plot(FBAND_bin);title(['FBAND']);
%yyaxis right;plot(ENERGY_RATIO_bin);
yyaxis left;plot(FBAND_bin_smooth);
yyaxis right;plot(ENERGY_RATIO_bin_smooth);title(['FBAND / ENERGY RATIO']);
analysis_smooth = [meanSTDeviation_bin_smooth stdSTDeviation_bin_smooth ENTROPY_bin_smooth meanHR_bin_smooth stdHR_bin_smooth DFA_bin_smooth LFHF_bin_smooth FBAND_bin_smooth ENERGY_RATIO_bin_smooth ENTROPY_CUTOFF_bin_smooth Twave_bin_smooth STslope_bin_smooth];
class = [];
for i = 1:length(analysis_smooth)
    if analysis_smooth(i,11) < 5;
        class(end+1) = -1; % T inverted
    elseif analysis_smooth(i,1) > 3
        class(end + 1) = 1;% ST Elevated
    else
        class(end + 1) = 0;% Normal
    end;
end
class = class';
analysis_smooth = [analysis_smooth class];
analysis_final = [analysis_final class];
