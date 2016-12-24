function [kautV,cumkautV,deckaut,zerokaut] = Kendallautocorrelation(xV,tauV,flag)
% [kautV,cumkautV,deckaut,zerokaut] = Kendallautocorrelation(xV,tauV,flag)
% KENDALLAUTOCORRELATION computed the Kendall autocorrelation on the time
% series 'xV' for given delays in 'tauV'.
% According to a given flag, it can also compute the cumulative Kendall
% autocorrelation for each given lag, the decorrelation time (the delay
% for which the Kendall autocorrelation is 1/e) and the time the
% Kendall autocorrelation falls to zero.
% INPUT
% - xV       : a vector for the time series
% - tauV     : a vector of the delays to be evaluated for
% - flag    : if 0-> compute only Kendall autocorrelation,
%           : if 1-> compute the Kendall autocorrelation, the cumulative
%             Kendall autocorrelation, the decorrelation time and the time
%             of zero Kendall autocorrelation.
%             if 2-> compute (also) the cumulative Kendall autocorrelation.
%             if 3-> compute (also) the decorrelation time.
%             if 4-> compute (also) the time of zero Kendall autocorrelation.
% OUTPUT
% - kautV    : the vector of the Kendall autocorrelations for the given delays
% - cumkautV : the vector of the cumulative Kendall autocorrelations for the
%              given delays
% - deckaut  : the decorrelation time from Kendall autocorrelation.
% - zerokaut : the time the Kendall autocorrelation falls to zero.
%========================================================================
%     <Kendallautocorrelation.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
kautV=NaN;
cumkautV=NaN;
deckaut=NaN;
zerokaut=NaN;

switch flag
    case 0
        % Compute only the Kendall autocorrelation for the given lags
        kautV=kendallcor(xV,tauV);
    case 1
        % Compute the Kendall autocorrelation for the given lags, the
        % cumulative Kendall autocorrelation, and find, if possible,
        % the decorrelation time and the zero Kendall autocorrelation time
        kacV=kendallcor(xV,[1:taumax]');
        kautV = kacV(tauV); % store only the delays given in 'tauV'
        % Compute the cumulative Kendall autocorrelation for the given delays
        cumkautV = NaN*ones(ntau,1);
        for i=1:ntau
            cumkautV(i) = sum(abs(kacV(1:tauV(i))));
        end
        % Find, if possible, the decorrelation time
        dectauV = find(kacV <= 1/exp(1));
        if ~isempty(dectauV)
            deckaut = dectauV(1);
        end
        % Find, if possible, the zero Kendall autocorrelation time
        zerotauV = find(kacV <= 0);
        if ~isempty(zerotauV)
            zerokaut = zerotauV(1);
        end
    case 2
        % Compute the cumulative Kendall autocorrelation for the given lags
        kacV=kendallcor(xV,[1:taumax]');
        % Compute the cumulative Kendall autocorrelation for the given delays
        cumkautV = NaN*ones(ntau,1);
        for i=1:ntau
            cumkautV(i) = sum(abs(kacV(1:tauV(i))));
        end
    case 3
        % Find, if possible, the decorrelation time
        kacV=kendallcor(xV,[1:taumax]');
        % Find, if possible, the decorrelation time
        dectauV = find(kacV <= 1/exp(1));
        if ~isempty(dectauV)
            deckaut = dectauV(1);
        end
    case 4
        % Find, if possible, the zero Kendall autocorrelation time
        kacV=kendallcor(xV,[1:taumax]');
        % Find, if possible, the zero Kendall autocorrelation time
        zerotauV = find(kacV <= 0);
        if ~isempty(zerotauV)
            zerokaut = zerotauV(1);
        end
end


