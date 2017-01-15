function mutV=mutinfHisDis(yV,tauV,b,imax)
% mutV=mutinfHisDis(yV,tauV,b)
% mutinfHisDis computes the mutual information on the time series 'yV' 
% for given delays in 'tauV'. The estimation of mutual information is 
% based on 'b' partitions of equal distance at each dimension. 
% The last input parameter is the index of the maximum of the time series
% that will be assigned the largest bin index (a technical detail).
%========================================================================
%     <mutinfHisDis.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
n = length(yV);
ntau = length(tauV);
mutV = NaN*ones(ntau,1);
h1V = zeros(b,1);  % for p(x(t+tau))
h2V = zeros(b,1);  % for p(x(t))
h12M = zeros(b,b);  % for p(x(t+tau),x(t))
arrayV = floor(yV*b)+1; % Array of b: 1,...,b
arrayV(imax) = b; % Set the maximum in the last partition
for itau=1:ntau
    tau = tauV(itau);
    ntotal = n-tau;
    mutS = 0;
    for i=1:b
        for j=1:b
            h12M(i,j) = length(find(arrayV(tau+1:n)==i & arrayV(1:n-tau)==j));
        end
    end
    for i=1:b
        h1V(i) = sum(h12M(i,:));
        h2V(i) = sum(h12M(:,i));
    end
    for i=1:b
        for j=1:b
            if h12M(i,j) > 0
                mutS=mutS+(h12M(i,j)/ntotal)*log(h12M(i,j)*ntotal/(h1V(i)*h2V(j)));
            end
        end
    end
    mutV(itau) = mutS;
end
