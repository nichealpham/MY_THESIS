function dfa=DetrendedFluctuation(xV)
% dfa=DetrendedFluctuation(xV)
% SETRENDEDFLUCTUATION computes the detrended fluctuation analysis for a
% given time series 'xV'.
% INPUTS:
% - xV        : The given scalar time series (vector of size n x 1).
% OUTPUTS
% - dfa       : The value of the detrended fluctuation analysis.
%========================================================================
%     <DetrendedFluctuation.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
pord=1;
d=[];
n=length(xV);
y=cumsum(xV-mean(xV));
p1=polyfit([1:n]',y,pord);
er=y-polyval(p1,[1:n]');
d(1)=sqrt(er'*er/n);
i=1;
y2=y;
len=[];
len(1)=n;
while size(y2,1)>=16
    i=i+1;
    rnr=floor(n/(2^(i-1)));
    rnc=floor(n/rnr);
    y2=reshape(y(1:rnr*rnc),rnr,rnc);
    pro=NaN*ones(rnr*rnc,1);
    for j=1:rnc
        p1=polyfit([1:rnr]',y2(:,j),pord);
        pro(rnr*(j-1)+1:rnr*j)=polyval(p1,[1:rnr]');
    end
    er=y(1:rnr*rnc)-pro;
    d(i)=sqrt(er'*er/(rnr*rnc));
    len(i)=rnr;
end
dlog=log2(d(end:-1:1));
blog=log2(len(end:-1:1));
p=polyfit(blog,dlog,1);
dfa=p(1);
