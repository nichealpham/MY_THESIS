function [EbandV,errormsg] = EnergyBand2(freqV,psV,bandM,leftcutoff)
% [EbandV,errormsg] = EnergyBand2(freqV,psV,bandM,leftcutoff)
% ENERGYBAND2 computes the energy in the frequency band given by 'bandM' 
% when the frequency and power spectrum are given in 'freqV' and 'psV'. 
% The lower frequency is given by 'leftcutoff'. The energy in the 
% given frequency band is simply the fraction of the sum of the values of 
% the power spectrum at the discrete frequencies within the band to the
% energy over the entire frequency band (constraint left by 'leftcutoff').
% A number of 'k' bands can be given in a 'k'x2 matrix 'bandM'. 
% INPUT 
% - freqV   : the frequencies for which the power spectrum is evaluated.
% - psV     : the power spectrum. 
% - bandM   : a k x 2 matrix where k bands are given with the left and
%             right limit in the first and second column, respectively.
% - leftcutoff: the left cutoff of frequency (to avoid the effect of drifts 
%               in the signal).
% OUTPUT
% - EbandV   : a k x 1 vector of the energy in the k bands.
% - errormsg: a string of error message in case output cannot be generated.
%========================================================================
%     <EnergyBand2.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
%     This is part of the MATS-Toolkit http://eeganalysis.web.auth.gr/

%========================================================================
% Copyright (C) 2010 by Dimitris Kugiumtzis and Alkiviadis Tsimpiris 
%                       <dkugiu@gen.auth.gr>

%========================================================================
% Version: 1.0

% LICENSE:
%     This program is free software; you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation; either version 3 of the License, or
%     any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program. If not, see http://www.gnu.org/licenses/>.

%=========================================================================
% Reference : D. Kugiumtzis and A. Tsimpiris, "Measures of Analysis of Time Series (MATS): 
% 	          A Matlab  Toolkit for Computation of Multiple Measures on Time Series Data Bases",
%             Journal of Statistical Software, in press, 2010

% Link      : http://eeganalysis.web.auth.gr/
%========================================================================= if nargin==3
    leftcutoff = 0;
end
errormsg = [];
[k,tmp]=size(bandM);
if tmp~=2 
    errormsg = 'Wrong format of the input for the frequency bands.';
end
nband=size(bandM,1);
EbandV = NaN*ones(nband,1);
if length((find(isnan(psV))))==0
    totalenergy = sum(psV(find(freqV>=leftcutoff)));
    for i=1:nband
        EbandV(i)=sum(psV(find(freqV>=bandM(i,1) & freqV<=bandM(i,2))))/totalenergy;
    end
else
    errormsg = 'The given periodogram contains NaN values.';
end
