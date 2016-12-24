function [yM,lagV] = LagDifference(xV,lagV)
% yV = LagDifference(xV,lagV)
% LAGDIFFERENCE takes a time series 'xV' and computes the time series 'yV'
% of the differences at given lags in 'lagV', i.e. y(t)=x(t)-x(t-lag),
% t=lag+1,...n, where 'n' is the length of 'xV' and 'lag' is a component of
% 'lagV'. 
% INPUTS:
% - xV      : vector of a scalar time series
% - lagV    : vector of lags (can be a single lag as well)
% OUTPUTS:
% - yM      : a matrix of the lag differenced time series.
% - lagV    : the vector of valid lags (in case given lags are <=0)
%========================================================================
%     <LagDifference.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
xV = xV(:);
n = length(xV);
lagV = lagV(lagV>0 & lagV<n/2);
if isempty(lagV) 
    yM=[];
else
    nlag = length(lagV);
    yM = NaN*ones(n,nlag);
    for ilag=1:nlag
        yM(1:n-lagV(ilag),ilag) = xV(lagV(ilag)+1:n)-xV(1:n-lagV(ilag));
    end
end
