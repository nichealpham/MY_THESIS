% final response

% fband = fband(1:length(Qdur));
% hflf = hflf(1:length(Qdur));
fband_shortened = fband < 40;
Tinverted = Tmag < 0;
scores = smooth(scores,.08,'loess');
STslope = smooth(STslope,.08,'loess');
analysis = [fband' lfhf_bin' fband_shortened' Tinverted' scores Tmag' STslope];
www = [www; analysis];