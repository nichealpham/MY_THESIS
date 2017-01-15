function zM = IAAFTsur(xV,nsur)
% zM = IAAFTsur(xV,nsur)
% IAAFT: Iterated Amplitude Adjusted Fourier Transform surrogates
% This function generates 'nsur' IAAFT-surrogate time series 
% and stores them in the matrix 'zM' (columnwise). These surrogates
% are supposed to have the same amplitude distribution (marginal cdf) 
% and autocorrelation as the given time series 'xV'. 
% The IAAFT algorithm is proposed in 
% Schreiber, T. and Schmitz, A. (1996) "Improved Surrogate Data for 
% Nonlinearity Tests", Physical Review Letters, Vol 77, 635-638.
% The IAAFT is an improvement of the AAFT. Iteratively, it fits the 
% amplitudes and at each step improves the spectral phases and then 
% reorders the derived time series at each step until convergence of 
% both spectral density and amplitude distribution is reached. 
% The algorithm terminates if complete convergence (same reordering in 
% two consecutive steps) is succeeded or if the 'maxi' number of 
% iterations is reached. 
% INPUT
% - xV  : the given time series
% - nsur: the number of surrogate time series (default is 1)
% OUTPUT
% - zM  : the n x nsur matrix of 'nsur' IAAFT surrogate time series
%========================================================================
%     <IAAFTsur.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
maxi = 1000;
if nargin == 1
    nsur = 1;
end
n = length(xV);
zM = NaN*ones(n,nsur);
if rem(n,2) == 0
    n2 = n/2;
else
    n2 = (n-1)/2;
end
% Fourier transform of the original and smoothing of spectrum
zV = fft(xV);
S = abs(zV); 

for isur=1:nsur
    % permutation of the original series 'xV'
    rV = xV(randperm(n));
    % First comparison of spectrum of 'rV' to that of 'xV' using the 
    % smoothed spectra.
    wV = fft(rV);
    RS = abs(wV);
    rphV = angle(wV);
    k=1;
    [xoV, iVold] = sort(xV); 
    converge = 0;
    while k<=maxi & converge == 0 
        wwV = S.*exp(rphV.*i); 
        tmpV = real(ifft(wwV));
        [tmpV, indV] = sort(tmpV);
        [tmpV,iVnew] = sort(indV);
        rV = xoV(iVnew);
        wV = fft(rV);
        rphV = angle(wV);
        if iVnew == iVold
            converge = 1;
        else
            iVold = iVnew;
            k=k+1;
        end
    end
    zM(:,isur) = rV;
end


