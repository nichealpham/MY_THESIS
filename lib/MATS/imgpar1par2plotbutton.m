%========================================================================
%     <imgpar1par2plotbutton.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
buttonsize = [150 120];
ylimnrm = [0.9 1.3];

load usbpmd355LS1___t2T1.nrm
nrmM = usbpmd355LS1___t2T1;

[nrow,ncol]=size(nrmM);
kV = nrmM(1,2:ncol);
mV = nrmM(2:nrow,1);
nk = length(kV);
nm = length(mV);
for irow=2:nrow
    for icol=2:ncol
        if nrmM(irow,icol)==-1
            nrmM(irow,icol)=NaN; 
        end
    end
end  

h = figure(1);
clf
surf(kV,mV,nrmM(2:nm+1,2:nk+1))
% set(gca,'XTickLabelMode','Manual');
% set(gca,'XTickLabel',num2str([1:ndata]'));
% set(gca,'XTickMode','Manual');
% set(gca,'XTick',[1:ndata]');
% set(gca,'YTickLabelMode','Manual');
% set(gca,'YTickLabel','');
% set(gca,'YTickMode','Manual');
% set(gca,'YTick',[]);
ax = axis;
axis([nrmM(1,2) nrmM(1,nk+1) nrmM(2,1) nrmM(nm+1,1) ylimnrm])
xlabel('par 1','fontsize',50)
ylabel('par 2','fontsize',50)
zlabel('measure','fontsize',50)
title('measure vs parameters','fontsize',50);
print -r300 -dbmp buttonpar1par2plot.bmp
