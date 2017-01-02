%-CONFIGURATION------------------------------------------------------------
start_beat = 1;
span = 2;
partition = 50/100;
beat_end = start_beat - 1;
%-PARAMETERS---------------------------------------------------------------
HR = [];
meanHR = []; % <------------
stdHR = [];  % <------------
FFT = [];
LFHF = [];
DFA = [];
Twave = [];
FBAND = [];
%ANN = [];
ENTROPY = []; 
STDeviation = [];
meanSTDeviation = []; % <------------
stdSTDeviation = [];  % <------------
STslope = [];
ENERGY_RATIO = [];
ENTROPY_CUTOFF = [];
%-INDEX OF THE LAST SAMPLE-------------------------------------------------
indLastSample = floor(length(sig1) * partition + fieldname.qrs(start_beat));
numberOfLoop = floor((indLastSample - fieldname.qrs(start_beat)) / (span * fs));
for k = 1:numberOfLoop
    clc;
    disp([num2str(record) '/' num2str(length(recordings)) '.' filename ' : ' num2str(floor(k / numberOfLoop * 100)) '%']);
    beat_start = beat_end + 1;
    MY_LOOP;
end;

meanSTDeviation = meanSTDeviation';
stdSTDeviation = stdSTDeviation';
meanSTDeviation_bin = [meanSTDeviation_bin; meanSTDeviation];
stdSTDeviation_bin = [stdSTDeviation_bin; stdSTDeviation];

%ANN = ANN';
%ANN_bin = [ANN_bin; ANN];

Twave = Twave';
Twave_bin = [Twave_bin; Twave];

STslope = STslope';
STslope_bin = [STslope_bin; STslope];

meanHR = meanHR';
stdHR = stdHR';
meanHR_bin = [meanHR_bin; meanHR];
stdHR_bin = [stdHR_bin; stdHR];

LFHF = LFHF';
LFHF_bin = [LFHF_bin; LFHF];

DFA = DFA';
DFA_bin = [DFA_bin; DFA];

FBAND = FBAND';
ENTROPY = ENTROPY';
FBAND_bin = [FBAND_bin; FBAND];
ENTROPY_bin = [ENTROPY_bin; ENTROPY];

ENERGY_RATIO = ENERGY_RATIO';
ENTROPY_CUTOFF = ENTROPY_CUTOFF';
ENERGY_RATIO_bin = [ENERGY_RATIO_bin; ENERGY_RATIO];
ENTROPY_CUTOFF_bin = [ENTROPY_CUTOFF_bin; ENTROPY_CUTOFF];