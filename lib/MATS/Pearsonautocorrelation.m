function [pautV,cumpautV,decpaut,zeropaut] = Pearsonautocorrelation(xV,tauV,flag)
% [pautV,cumpautV,decpaut,zeropaut] = Pearsonautocorrelation(xV,tauV,flag)
% PEARSONAUTOCORRELATION computes the Pearson autocorrelation on the time
% series 'xV' for given delays in 'tauV'. 
% According to a given flag, it can also compute the cumulative Pearson 
% autocorrelation for each given lag, the decorrelation time (the delay 
% for which the Pearson autocorrelation is 1/e) and the time the 
% Pearson autocorrelation falls to zero.
% INPUT
% - xV      : a vector for the time series
% - tauV    : a vector of the delays to be evaluated for
% - flag    : if 0-> compute only Pearson autocorrelation,
%           : if 1-> compute the Pearson autocorrelation, the cumulative
%             Pearson autocorrelation, the decorrelation time and the time
%             of zero Pearson autocorrelation. 
%             if 2-> compute (also) the cumulative Pearson autocorrelation.
%             if 3-> compute (also) the decorrelation time.
%             if 4-> compute (also) the time of zero Pearson autocorrelation. 
% OUTPUT
% - pauV    : the vector of the Pearson autocorrelations for the given delays
% - cumpauV : the vector of the cumulative Pearson autocorrelations for the
%             given delays 
% - decpaut : the decorrelation time from Pearson autocorrelation.
% - zeropaut : the time the Pearson autocorrelation falls to zero.
%========================================================================
%     <Pearsonautocorrelation.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
    flag = 1;
end
tauV = sort(tauV);
ntau = length(tauV);
taumax = tauV(end);
n = length(xV);
if n<taumax+1
    return;
end
xm = mean(xV);
yV = xV - xm;
pautV=NaN;
cumpautV=NaN;
decpaut=NaN;
zeropaut=NaN;
switch flag
    case 0
        % Compute only the Pearson autocorrelation for the given lags
        tmpV = xcorr(yV,taumax,'coeff');
        acV = tmpV(taumax+2:2*taumax+1);
        pautV = acV(tauV); % store only the delays given in 'tauV'
    case 1
        % Compute the Pearson autocorrelation for the given lags, the
        % cumulative Pearson autocorrelation, and find, if possible, 
        % the decorrelation time and the zero Pearson autocorrelation time
        tmpV = xcorr(yV,taumax,'coeff');
        acV = tmpV(taumax+2:2*taumax+1);
        pautV = acV(tauV); % store only the delays given in 'tauV'
        cumpautV = NaN*ones(ntau,1);
        for i=1:ntau
            cumpautV(i) = sum(abs(acV(1:tauV(i))));
        end
        dectauV = find(acV <= 1/exp(1));
        if ~isempty(dectauV)
            decpaut = dectauV(1);
        end
        % Find, if possible, the zero Pearson autocorrelation time 
        zeroptauV = find(acV <= 0);
        if ~isempty(zeroptauV)
            zeropaut = zeroptauV(1);
        end
    case 2
        % Compute the cumulative Pearson autocorrelation for the given lags
        tmpV = xcorr(yV,taumax,'coeff');
        acV = tmpV(taumax+2:2*taumax+1);
        cumpautV = NaN*ones(ntau,1);
        for i=1:ntau
            cumpautV(i) = sum(abs(acV(1:tauV(i))));
        end
    case 3
        % Find, if possible, the decorrelation time 
        tmpV = xcorr(yV,taumax,'coeff');
        acV = tmpV(taumax+2:2*taumax+1);
        dectauV = find(acV <= 1/exp(1));
        if ~isempty(dectauV)
            decpaut = dectauV(1);
        end
    case 4
        % Find, if possible, the zero Pearson autocorrelation time 
        tmpV = xcorr(yV,taumax,'coeff');
        acV = tmpV(taumax+2:2*taumax+1);
        zeroptauV = find(acV <= 0);
        if ~isempty(zeroptauV)
            zeropaut = zeroptauV(1);
        end
end
