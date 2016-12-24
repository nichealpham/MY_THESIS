function zM = AAFTsur(xV,nsur)
% zM = AAFTsur(xV,nsur)
% AAFTsur: Amplitude Adjusted Fourier Transform Surrogates
% This function generates 'nsur' AAFT-surrogate time series and stores them 
% in the matrix 'zM' (columnwise). The AAFT surrogates are supposed to have 
% the same amplitude distribution (marginal cdf) and autocorrelation as the 
% given time series 'xV'. 
% The algorithm is according to 
% Theiler, J. et al (1992), "Testing for Nonlinearity in Time Series: 
% the Method of Surrogate Data", Physica D, Vol 58, 77-94.
% Refer also to the Appendix in 
% Theiler, J. et al (1992), "Using Surrogate Data to Detect Nonlinearity 
% in Time Series", in "Nonlinear Modeling and Forecasting", edited by
% Casdagli, M. and Eubank, S., Addison-Wesley, Reading, MA, 163-188.
% INPUT
% - xV  : the given time series
% - nsur: the number of surrogate time series (default is 1)
% OUTPUT
% - zM  : the n x nsur matrix of 'nsur' AAFT surrogate time series

%========================================================================
%     <AAFTsur.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
n = length(xV);
zM = NaN*ones(n,nsur);
[oxV,T] = sort(xV);  
[T,ixV] = sort(T); 
for isur=1:nsur
    % Rank order a white noise time series 'wV' to match the ranks of 'xV' 
    wV = randn(n,1) * std(xV);
    [owV,T]= sort(wV); 
    yV = owV(ixV);
    % Fourier transform, phase randomization, inverse Fourier transform
    if rem(n,2) == 0
        n2 = n/2;
    else
        n2 = (n-1)/2;
    end
    tmpV = fft(yV,2*n2);
    magnV = abs(tmpV);
    fiV = angle(tmpV);
    rfiV = rand(n2-1,1)*2*pi;
    nfiV = [0; rfiV; fiV(n2+1); -flipud(rfiV)];
    tmpV = [magnV(1:n2+1)' flipud(magnV(2:n2))']';
    tmpV = tmpV .* exp(nfiV .* i); 
    yftV=real(ifft(tmpV,n));  % Transform back to time domain
    % Rank order the 'xV' to match the ranks of the phase randomized time series 
    [T,T2] = sort(yftV); 
    [T,iyftV] = sort(T2);
    zM(:,isur) = oxV(iyftV);  % the AAFT surrogate of xV
end
