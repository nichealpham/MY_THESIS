%========================================================================
%     <imgfreeplotbutton.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
clear all
ndata = 5;
nmea = 3;
randn('state',0);
meaM = randn(ndata,nmea);
buttonsize = [150 120];

h = figure(1);
clf
axes('position',[0.12 0.16 0.80 0.65])
h1 = plot(meaM(:,1),'o-','Markersize',10,'linewidth',3);
hold on
plot(meaM(:,2),'x--k','Markersize',10,'linewidth',3)
plot(meaM(:,3),'+-.r','Markersize',10,'linewidth',3)
set(gca,'XTickLabelMode','Manual');
set(gca,'XTickLabel',num2str([1:ndata]'));
set(gca,'XTickMode','Manual');
set(gca,'XTick',[1:ndata]');
set(gca,'YTickLabelMode','Manual');
set(gca,'YTickLabel','');
set(gca,'YTickMode','Manual');
set(gca,'YTick',[]);
leg = legend('measure 1','measure 2','measure 3','location','NorthEastOutside');
set(leg,'EdgeColor',[1 1 1])
set(leg,'FontSize',24)
legpos = get(leg,'Position');
ax = axis;
dyax = 0.1*(ax(4)-ax(3));
text(5.2,ax(3)+4*dyax,'1: time series 1','fontsize',24)
text(5.2,ax(3)+3*dyax,'2: time series 2','fontsize',24)
text(5.2,ax(3)+2*dyax,'3: time series 3','fontsize',24)
text(5.2,ax(3)+dyax,'4: time series 4','fontsize',24)
text(5.2,ax(3),'5: time series 5','fontsize',24)
xlabel('time series index','fontsize',50)
ylabel('measure','fontsize',50)
title('free plot','fontsize',80)
% print -r300 -djpeg90 buttonfreeplot.jpg
print -r300 -dbmp buttonfreeplot.bmp
