function acV=AlgorithmicComplexityHisDis(xV,bV)
% acV = AlgorithmicComplexityHisDis(xV,bV)
% ALGORITHMICCOMPLEXITYHISDIS computes the algorithmic complexity on the
% time series 'xV'. The estimation of the algorithmic complexity is based
% on 'b' partitions of equal distance of 'xV'. 
% A number of different 'b' can be given in the input vector 'bV'.
% INPUT
% - xV      : a vector for the time series
% - bV      : a vector of the number of equidistant partitions. 
% OUTPUT
% - acV     : the vector of the algorithmic complexity values for the given
%             delays. 
%========================================================================
%     <AlgorithmicComplexityHisDis.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
n = length(xV);
if nargin==1
    bV = round(sqrt(n/5));
end
bV(bV==0) = round(sqrt(n/5));

nb = length(bV);
xmin=min(xV);
xrange=range(xV);
acV = NaN*ones(nb,1);
for ib=1:nb
    parxM = [];
    cel=[];
    b = bV(ib);
    if n<2*b
        break;
    end
    if b==1
        continue;
    end
    dV=[1:b]*xrange/b;
    dV=[0-xrange*10^(-6) dV+xrange*10^(-6)];
    dV=xmin+dV;
    for i=1:b
        parxM(i,:)=i*(xV>=dV(i) & xV<=dV(i+1));
    end
    symb=sum(parxM);
    symbc=char(symb+64);
    oo=max(symb);
    cel{1}=symbc(1);
    i=2;
    while i~=n+1
        pro=symbc(i);
        while sum(ismember(cel,pro))~=0 & i~=n
            i=i+1;
            prot=symbc(i);
            pro=[pro prot];
        end
        cel=union(cel,pro);
        if i~=n+1
           i=i+1;
        end
    end
    dic=length(cel);
    acV(ib)=(dic*log10(n))/(log10(b)*n);
end
