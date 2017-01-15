function [pautV] = PartialAutocorrelation(xV,tauV)
% [pautV] = PartialAutocorrelation(xV,tauV)
% PARTIALAUTOCORRELATION computes the partial autocorrelation on the time
% series 'xV' for given delays in 'tauV'.
% INPUT
% - xV      : a vector for the time series
% - tauV    : a vector of the delays to be evaluated for
% OUTPUT
% - pauV    : the vector of the partial autocorrelations for the given delays
%========================================================================
%     <PartialAutocorrelation.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
tauV = sort(tauV);
ntau = length(tauV);
taumax = tauV(end);
n = length(xV);
if n<taumax+1
    return;
end
xM = NaN*ones(n-taumax,taumax);
for i=1:taumax
    xM(i+1:n,i)=xV(1:n-i);
end
pautV = NaN*ones(ntau,1);
for itau=1:ntau
    tau = tauV(itau);
    [Q,R]=qr([ones(n-tau,1) xM(tau+1:n,1:tau)],0);
    bV =  R\(Q'*xV(tau+1:n));
    pautV(itau) = bV(end);
end
