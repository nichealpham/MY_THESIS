function [mapeM,nmseM,nrmseM,ccM,flagtxt] = ARfitite(xV,mV,TV)
% [mapeM,nmseM,nrmseM,ccM,flagtxt] = arfitite(xV,mV,TV)
% ARFITITE computes statistical errors of fit at lead times given in 'TV' 
% with each of a number of AR models of orders given in 'mV' on a time 
% series 'xV'. The iterative prediction scheme is utilized.
% The different fit error statistics given to the output have size 
% nm x nT, wherre nT is the length of 'TV' and 'nm' is the length of  
% 'mV'. 
% INPUT
% - xV      : The time series to be modelled, a column vector
% - mV      : The vector of different orders of the AR-model
% - T       : The time step ahead for fitting the AR-model (if omitted,
%             default is T=1)
% OUTPUT
% - mapeM   : The Mean Absolute Percentage Error for fitted and real values.
%             A matrix of size nm x nT. 
% - nmseM   : The normalized mean square error for fitted and real values.
%             A matrix of size nm x nT. 
% - nrmseM  : The normalized root mean square error for fitted and real values
%             A matrix of size nm x nT. 
% - ccM     : The correlation coefficient between fitted and real values
%             A matrix of size nm x nT. 
% - flagtxt : A string of error message in case the AR matlab functions are
%             not supported by user's matlab product (missing toolbox).
%========================================================================
%     <ARfitite.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
if nargin == 2
    TV = 1;
end
mV=mV(:);
TV=TV(:);
n = length(xV);           % Choose length of time series
nm = length(mV);
Tmax = max(TV);
nT = length(TV);
mapeM = NaN*ones(nm,nT); 
nmseM = NaN*ones(nm,nT); 
nrmseM = NaN*ones(nm,nT); 
ccM = NaN*ones(nm,nT); 
flagtxt = [];

for im=1:nm
    m = mV(im);
    if n<2*m+Tmax
        break;
    end
    if exist('armcov')==2
        parV = armcov(xV,m);
        bV = -parV(end:-1:2); % bV(1)->x(t-m+1),bV(2)->x(t-m+2),...,bV(m)->x(t)
    elseif exist('ar')==2
        armod = ar(xV,m); 
        bV = -armod.a(end:-1:2); % bV(1)->x(t-m+1),bV(2)->x(t-m+2),...,bV(m)->x(t)
    else
        flagtxt = 'You need to add toolbox ''ident'' or ''signal'' to be able to run measures of AR fitting.';
        return;
    end
    bV = bV(:);
    xM = NaN*ones(n-m-Tmax+1,m);
    for i=1:m
        xM(:,i) = xV(i:n-m-Tmax+i);
    end
    xpreM = NaN*ones(n-m-Tmax+1,Tmax);
    for j=1:Tmax
        xpreM(:,j) = xM*bV;
        xM(:,1:m-1)=xM(:,2:m);
        xM(:,m) = xpreM(:,j);
    end
    for iT=1:nT
        T = TV(iT);
        tarV = xV(m+T:n-Tmax+T);
        ntar = length(tarV);
        mtar = mean(tarV);
        vartar = var(tarV);
        mapeM(im,iT) = mean(abs((tarV-xpreM(:,T))./tarV));
        nmseM(im,iT) = mean((tarV-xpreM(:,T)).^2) / vartar;
        nrmseM(im,iT) = sqrt(nmseM(im,iT));
        mxpre = mean(xpreM(:,T));
        ccM(im,iT) = sum((xpreM(:,T)-mxpre).*(tarV-mtar)) / sqrt((ntar-1)*vartar*(sum(xpreM(:,T).^2)-ntar*mxpre^2));
    end
end

