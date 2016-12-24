function [bicV,cumbicV] = Bicorrelation(xV,tauV,flag)
% [bicV,cumbicV] = Bicorrelation(xV,tauV,flag)
% BICORRELATION computes the bicorrelation on the time series 'xV' for 
% given delays in 'tauV'. In addition, it computes the cumulative 
% bicorrelation for each given lag.
% Bicorrelation is the extension of the autocorrelation to the third order 
% moments, where the two delays are chosen here to be the one twice the
% other, i.e. x(t)*x(t-tau)*x(t-2*tau). 
% According to a given flag, it can also compute the cumulative
% bicorrelation for each given lag.
% INPUT
% - xV      : a vector for the time series
% - tauV    : a vector of the delays to be evaluated for
% - flag    : if 0-> compute only mutual information,
%           : if 1-> compute the mutual information, the first minimum of
%             if 2-> compute only the cumulative bicorrelation.
% OUTPUT
% - bicV    : the vector of the bicorrelations for the given delays
% - cumbicV : the vector of the cumulative bicorrelations for the
%             given delays 
%========================================================================
%     <Bicorrelation.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
tauV(tauV==0)=[];
tauV = sort(tauV);
ntau = length(tauV);
taumax = tauV(end);
n = length(xV);

if n<tauV(end)+1
    return;
end
yV = (xV - mean(xV)) / std(xV);
switch flag
    case 0
        % Compute only the bicorrelation for the given lags
        bicV = NaN*ones(ntau,1);
        for itau=1:ntau
            tau = tauV(itau);
            bicV(itau)= sum(yV(1+2*tau:n).*yV(1+tau:n-tau).*yV(1:n-2*tau))/(n-2*tau);
        end
        cumbicV = [];
    case 1
        % Compute the bicorrelation for all lags up to the largest given
        % lag and the cumulative bicorrelation for the given lags.
        biV = NaN*ones(taumax,1);
        for tau=1:taumax
            biV(tau)= sum(yV(1+2*tau:n).*yV(1+tau:n-tau).*yV(1:n-2*tau))/(n-2*tau);
        end
        bicV = biV(tauV); % store only the delays given in 'tauV' 
        % Compute the cumulative bicorrelation for the given delays
        cumbicV = NaN*ones(ntau,1);
        for i=1:ntau
            cumbicV(i) = sum(abs(biV(1:tauV(i))));
        end
    case 2
        % Compute the cumulative bicorrelation for the given lags.
        biV = NaN*ones(taumax,1);
        for tau=1:taumax
            biV(tau)= sum(yV(1+2*tau:n).*yV(1+tau:n-tau).*yV(1:n-2*tau))/(n-2*tau);
        end
        bicV = []; % 
        % Compute the cumulative bicorrelation for the given delays
        cumbicV = NaN*ones(ntau,1);
        for i=1:ntau
            cumbicV(i) = sum(abs(biV(1:tauV(i))));
        end
end