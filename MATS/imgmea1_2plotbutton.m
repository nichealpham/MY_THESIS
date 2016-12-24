%========================================================================
%     <imgmea1_2plotbutton.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
ndata1 = 20;
ndata2 = 25;
nmea = 2;
randn('state',0);
buttonsize = [150 120];

mu1 = [5 0];
sigma1 = [1 0.3; 0.3 1];
set1M = mvnrnd(mu1,sigma1,ndata1);
mu2 = [1 5];
sigma2 = [1 -0.3; 0.3 1];
set2M = mvnrnd(mu2,sigma2,ndata2);

h = figure(1);
clf
% axes('position',[0.12 0.16 0.80 0.65])
plot(set1M(:,1),set1M(:,2),'.','Markersize',30);
hold on
plot(set2M(:,1),set2M(:,2),'.','Markersize',30);
%set(gca,'XTickLabelMode','Manual');
% set(gca,'XTickLabel',num2str([1:ndata]'));
%set(gca,'XTickMode','Manual');
% set(gca,'XTick',[1:ndata]');
%set(gca,'YTickLabelMode','Manual');
%set(gca,'YTickLabel','');
%set(gca,'YTickMode','Manual');
%set(gca,'YTick',[]);
% leg = legend('measure 1','measure 2','measure 3','location','NorthEastOutside');
xlabel('measure 1','fontsize',50)
ylabel('measure 2','fontsize',50)
h = title('measure scatter plot','fontsize',58)
print -r300 -dbmp buttonmea1mea2plot.bmp
