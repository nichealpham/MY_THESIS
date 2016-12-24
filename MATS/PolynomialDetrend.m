function [yM,poldegreeV] = PolynomialDetrend(xV,poldegreeV)
% yV = PolynomialDetrend(xV,poldegree)
% POLYNOMIALDETREND takes a time series 'xV' and fits polynomials of 
% given degree in 'poldegreeV'. The residual time series of the fits are
% given to the output as the detrended time series. 
% INPUTS:
% - xV      : vector of a scalar time series
% - poldegreeV : vector of polynomial degrees (can be a single degree as well)
% OUTPUTS:
% - yM      : a matrix of the detrended time series.
% - poldegreeV : the vector of valid polynomial degrees (in case given degrees are <=0)
%========================================================================
%     <PolynomialDetrend.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
poldegreeV = poldegreeV(poldegreeV>=0 & poldegreeV<n/2);
if isempty(poldegreeV) 
    yM=[];
else
    npoldegree = length(poldegreeV);
    yM = NaN*ones(n,npoldegree);
    for ipoldegree=1:npoldegree
        poldegree=poldegreeV(ipoldegree);
        if poldegree==0
            yM(:,ipoldegree) = xV-mean(xV);
        else
            parV = polyfit([1:n]',xV,poldegree);
            yM(:,ipoldegree) = xV - polyval(parV,[1:n]');
        end
    end
end
