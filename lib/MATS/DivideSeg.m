function xM = DivideSeg(xV,n,s,first)
% xM = DivideSeg(xV,n,s,first)
% DIVIDESEG takes a time series 'xV' and splits in segments of length 'n'. 
% The segments either overlap if 's' is smaller than 'n' or not (otherwise).
% If the length of 'xV' is not multiple of 'n', then the remainder segment 
% is omitted either from the beginning of 'xV' when 'first' is 1, or from
% the end (otherwise).
% INPUTS:
% - xV      : vector of a scalar time series
% - n       : length of each of the segments splitting 'xV'.
% - s       : the sliding window if 0<s<n, otherwise use consecutive
%             segments. Defaults is n. 
% - first   : if 1, ignore the remainder segment (only if length(xV) is not
%             multiple of n) from the beginning of 'xV', otherwise from the
%             end of 'xV'. Default is 1.
% OUTPUTS:
% - xM      : a matrix of size n x floor(length(xV)/n) of the segments.

% Give default values to input variables if not set
%========================================================================
%     <DivideSeg.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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

if nargin == 3
    first = 1;
elseif nargin == 2
    first = 1;
    s = n;
end
if isempty(first), first=1; end
if isempty(s), s=n; end
if s<=0 | s>n, s=n; end

nbig = length(xV);
if n>nbig
    return;
end

% Make splitting if no-overlapping is given and then when 0<s<n
if s==n
    nseg = floor(nbig / n);
    nrest=nbig - nseg*n;
    if nrest>0
        switch first
            case 1
                xV = xV(1+nrest:nbig);
            otherwise
                xV = xV(1:nbig-nrest);
        end
    end
    xM = reshape(xV,n,nseg);
else
    nseg = floor((nbig-n)/s)+1;
    nrest = nbig - (n+(nseg-1)*s);
    if nrest>0
        switch first
            case 1
                xV = xV(1+nrest:nbig);
            otherwise
                xV = xV(1:nbig-nrest);
        end
    end
    xM = NaN*ones(n,nseg);
    for iseg=1:nseg
        xM(:,iseg)=xV(1+(iseg-1)*s:n+(iseg-1)*s);
    end
end
    