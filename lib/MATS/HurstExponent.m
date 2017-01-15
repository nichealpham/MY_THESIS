function Hurst=HurstExponent(xV)
% Hurst=HurstExponent(xV)
% HURSTEXPONENT computes the Hurst exponent for a given time series 'xV'.
% INPUTS:
% - xV          : The given scalar time series (vector of size n x 1).
% OUTPUTS
% - Hurst       : The value of the Hurst exponent.
%========================================================================
%     <HurstExponent.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
n=length(xV);
d=[];
len=[];
y=xV;
y2=cumsum(y-mean(y),1);
d(1)=mean(range(y2)./std(y,1));
i=1;
len(1)=size(y,1);
while size(y,1)>=16
    i=i+1;
    rnr=floor(n/(2^(i-1)));
    rnc=floor(n/rnr);
    y=reshape(xV(1:rnr*rnc),rnr,rnc);
    n2=size(y,1);
    pop=find(std(y,1)~=0);     %
    if ~isempty(pop)
        y=y(:,pop);                %
        len(i)=n2;
        y2=cumsum(y-kron(mean(y),ones(n2,1)),1);
        d(i)=mean(range(y2)./std(y,1));
    else
        len(i) = NaN;
        d(i)=NaN;
    end
end
dlog=log2(d(end:-1:1));
blog=log2(len(end:-1:1));
pone=polyfit(blog,dlog,1);
Hurst=pone(1);
