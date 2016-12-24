function zM = FourierTransform(xV,nsur)
% zM = FourierTransform(xV,nsur)
% FOURIERTRANSFORM generates a given number of Fourier Transform (FT) 
% surrogates for the given time series 'xV'. FT suggests that the phases of
% the Fourier transform of 'xV' are randomized and the inverse Fourier 
% transform gives the surrogate time series.
% INPUT
% - xV  : the given time series
% - nsur: the number of surrogate time series (default is 1)
% OUTPUT
% - zM  : the n x nsur matrix of 'nsur' FT surrogate time series
%========================================================================
%     <FourierTransform.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
if nargin==1
    nsur=1;
end
n=length(xV);
if rem(n,2) == 0
    n2 = n/2;
else
    n2 = (n-1)/2;
end
nfreq = n2;  
fxV = fft(xV,2*nfreq);
magnV = abs(fxV);
% The magnitudes of the Fourier transform
mV = [magnV(1:nfreq+1)' flipud(magnV(2:nfreq))']';
fiV = angle(fxV);
zM = NaN*ones(n,nsur);
for isur=1:nsur
    % The random phases
    rfiV = rand(nfreq-1,1) * 2 * pi;
    nfiV = [0; rfiV; fiV(nfreq+1); -flipud(rfiV)];
    fzV = mV .* exp(nfiV .* i); 
    % The inverse transform
    zM(:,isur)=real(ifft(fzV,n));
end
