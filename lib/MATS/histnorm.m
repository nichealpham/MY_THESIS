function [xnorV,NnorV] = histnorm(xV,xxV)
% [NxV,xxV,yvalV] = histnorm(xV,bins)
% HISTNORM gives the x values and count values for the normal curve that
% fits the histogram of the data in 'xV' given by 'xxV' for the selected
% bins.
% INPUT
% - xV      : vector of data
% - xxV     : array of the centers of bins of xV
% OUTPUT
% - xnorV   : array of x values spread in the range of xV
% - NnorV   : array of the values for normal distribution regarding xnorV
%========================================================================
%     <histnorm.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
nresol = 1000;

n = length(xV);
mx = mean(xV);
sdx = std(xV);

xnorV = linspace(mx-4*sdx,mx+4*sdx,nresol);
fnorV = normpdf(xnorV,mx,sdx);
yyV = normpdf(xxV,mx,sdx);
NyV = n*yyV/sum(yyV);
maxNy=max(NyV);
NnorV = fnorV * (maxNy / fnorV(round(nresol/2))); 
