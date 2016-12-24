function [MedFreq,errormsg] = MedianFrequency(xV,leftcutoff,rightcutoff)
% [MedFreq,errormsg] = MedianFrequency(xV,leftcutoff,rightcutoff)
% MEDIANFREQUENCY computes the median frequency in a frequency range given 
% by 'leftcutoff' and 'rightcuroff' for a given time series 'xV'. 
% The standard periodogram is called to compute the power spectrum assuming 
% frequency=1, so that the largest frequency the power spectrum is computed 
% for is 0.5 if 'rightcuroff' is specified. The lower frequency is given 
% by 'leftcutoff' or 0 if 'leftcutoff' is not specified. The frequency 
% resolution is given by the length of the time series. 
% INPUT 
% - xV      : the given time series
% - leftcutoff: the left cutoff of frequency (to avoid the effect of drifts 
%               in the signal).
% - rightcutoff: the right cutoff of frequency (to avoid the effect of  
%                high frequency elements in the signal).
% OUTPUT
% - MedFreq : The median frequency
% - errormsg: a string of error message in case output cannot be generated.
%========================================================================
%     <MedianFrequency.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
%========================================================================= 
if nargin==2
    rightcutoff = 0.5;
elseif nargin==1
    rightcutoff = 0.5;
    leftcutoff = 0.0;
end
errormsg = [];
[psV,freqV]=periodogram(xV); 
MedFreq = [];
if length((find(isnan(psV))))==0
    d=length(psV(find(freqV<leftcutoff)));
    op=find(cumsum(psV(find(freqV>=leftcutoff)))>0.5*sum(psV(find(freqV>=leftcutoff & freqV<=rightcutoff))));
    if length(op)>0
        MedFreq=freqV(op(1)+d);
    end
else
    errormsg = 'The periodogram could not be computed or cutoff values are not proper.';
end
