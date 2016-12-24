disp('Running final plot');
analysis = [STDeviation_bin ENTROPY_bin HR_bin DFA_bin LFHF_bin FBAND_bin ENERGY_RATIO_bin ENTROPY_CUTOFF_bin];
analysis_final = [];
disp('Smoothing...');
STDeviation_bin_smooth = smooth(STDeviation_bin,smooth_span,smooth_type);
ENTROPY_bin_smooth = smooth(ENTROPY_bin,smooth_span,smooth_type);
HR_bin_smooth = smooth(HR_bin,smooth_span,smooth_type);
DFA_bin_smooth = smooth(DFA_bin,smooth_span,smooth_type);
LFHF_bin_smooth = smooth(LFHF_bin,smooth_span,smooth_type);
FBAND_bin_smooth = smooth(FBAND_bin,smooth_span,smooth_type);
ENERGY_RATIO_bin_smooth = smooth(ENERGY_RATIO_bin,smooth_span,smooth_type);
ENTROPY_CUTOFF_bin_smooth = smooth(ENTROPY_CUTOFF_bin,smooth_span,smooth_type);
figure3 = figure;
set(figure3,'name','Cross record combined','numbertitle','off');
subplot(3,4,[9,10]);plot(STDeviation_bin);title('ST Deviation');
hold on;plot(STDeviation_bin_smooth);
subplot(3,4,[1,2]);
%yyaxis left;plot(ENTROPY_bin);title(['ENTROPY']);
%yyaxis right;plot(ENTROPY_CUTOFF_bin);
plot(ENTROPY_bin);hold on;plot(ENTROPY_CUTOFF_bin);title(['ENTROPY']);
subplot(3,4,[3,4]);plot(HR_bin);title(['HR']);
hold on;plot(HR_bin_smooth);
subplot(3,4,[5,6]);plot(DFA_bin);title(['DFA']);
hold on;plot(DFA_bin_smooth);
subplot(3,4,[7,8]);plot(LFHF_bin);title(['LFHF']);
subplot(3,4,[11,12]);
%yyaxis left;plot(FBAND_bin);title(['FBAND']);
%yyaxis right;plot(ENERGY_RATIO_bin);
plot(FBAND_bin);
hold on;plot(ENERGY_RATIO_bin);title(['FBAND']);
hold on;plot(FBAND_bin_smooth);

analysis_smooth = [STDeviation_bin_smooth ENTROPY_bin_smooth HR_bin_smooth DFA_bin_smooth LFHF_bin_smooth FBAND_bin_smooth ENERGY_RATIO_bin_smooth ENTROPY_CUTOFF_bin_smooth];
for i = 1:length(analysis)
    row = analysis(i,:);
    if ~isnan(row(8)) && ~isinf(row(8))
        analysis_final = [analysis_final; row];
    end;
end;