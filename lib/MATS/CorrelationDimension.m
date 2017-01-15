function nuT = CorrelationDimension(xV,tauV,mV,theiler,sV,resol)
% nuT = CorrelationDimension(xV,tauV,mV,theiler,sV,resol)
% CORRELATIONDIMENSION computes the correlation dimension for a given time
% series 'xV', for a range of delays in 'tauV', a range of embedding 
% dimensions in 'mV' and for a range of upper/lower ratio of scaling window
% in % 'sV' (s=r2/r1 where r2-r1 is the length of the scaling window).
% The parameter 'theiler' excludes temporally close points (smaller than 
% 'theiler') from the inter-distance computations. The parameter 'resol'
% determines the number of radii for which the correlation sum is
% computed. 
% First, the correlation sum C(r) and the local slopes log(C(r))/log(r) are 
% computed for a range of distances r given by 'resol'. Then the correlation 
% dimension 'nu' is estimated by searching for the local slope in radii
% intervals [r1,r2] (determined by 's') with the smallest standard 
% deviation (best scaling). The mean local slope in this interval is the  
% estimate of 'nu'. 
% INPUTS:
% - xV      : Vector of the scalar time series ('xV' is then standardized
%             in [0,1]). 
% - tauV    : A vector of the delay times.
% - mV      : A vector of the embedding dimension.
% - theiler : the Theiler window to exclude time correlated points in the
%             search for neighboring points. Default=0.
% - sV      : A vector of values of upper/lower ratio of scaling window
%             (e=r2/r1 where r2-r1 is the length of the scaling window).
% - resol   : The number of radius for which the correlation sum is computed.
%             Note that this parameters is supposed to be larger than 10.
% OUTPUT: 
% - nuT     : A matrix of size 'ntau' x 'nm' x 'ne', where 'ntau' is the 
%             number of given delays, 'nm' is the number of given embedding 
%             dimensions and 'ne' is the number of scaling ratio of radii. 
%             The components of the matrix are the correlation dimension
%             values. 
%========================================================================
%     <CorrelationDimension.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
smoothorder = 2; % Order of the smooth derivative for the correlation sum
logdmin=-3; % the lowest log10(distance)
% Rescale to [0,1]
xmin = min(xV);
xmax = max(xV);
xV = (xV - xmin) / (xmax-xmin);
n = length(xV);
if isempty(theiler), theiler=0; end
nm = length(mV);
mV = sort(mV);
mmax = mV(end);
mmin = mV(1);
ntau = length(tauV);
ns = length(sV);
% Any computed distance d will be placed in a bin of 'rV'
rV = logspace(logdmin,0,resol);
rV = [-Inf rV]';
nuT = NaN*ones(ntau,nm,ns);
% To be used in allocating the components of temporal correlated distances
% in the distance matrix below (it is given here to avoid repetitions).

if resol-1-2*smoothorder < 1
    return;
end
if theiler>0
    isumV = cumsum([0:n-theiler-1]);
end
for itau = 1:ntau
    tau = tauV(itau);
    densityM = zeros(resol,mmax-mmin+1);
    nvec = n-mmax*tau; 
    if nvec-theiler < 2
        break;
    end
    xM = NaN*ones(nvec,mmax);
    for i=1:mmax
        xM(:,i) = xV(1+(i-1)*tau:nvec+(i-1)*tau);
    end
    % If theiler window define the components of the vector of all
    % distances that have to be removed.
    if theiler>0
        targV = [0:nvec-theiler-1]*nvec-isumV(1:end-mmax*tau);
        ntarg = length(targV);
        omitV = NaN*ones((nvec-theiler)*theiler,1);
        for ith=1:theiler
            omitV(([1:ntarg]-1)*theiler+ith) = targV+ith;
        end
        omitV = [omitV' omitV(end)+1:(nvec*(nvec-1)/2)];
    end
    for im=1:length(mV)
        % To handle large time series use single precision.
        if nvec>10000
            distV = single(pdist(xM(:,1:im)));
        else
            distV = pdist(xM(:,1:im));
        end
        % Remove components of distance matrix that regard temporally close
        % points
        if theiler>0
            distV(omitV)=[];
        end  
        % Count the distances that lie in each bin formed by the grid of
        % distances (given by 'resol')
        countV =histc(distV,rV);
        countV(end-1)=countV(end)+countV(end-1);
        countV(end)=[];
        densityM(:,im) = countV/length(distV);
    end        
    % The log10 of distances corresponding to each bin
    log10rV = (resol-[1:resol]')*logdmin/(resol-1);
    cM = cumsum(densityM(1:end,:)); 
    cM(cM==0)=1; % To avoid log10(0)
    log10cM = log10(cM);
    log10rV = log10rV(2:end);
    log10cM = log10cM(2:end,:);
    rV = 10.^log10rV(1+smoothorder:resol-1-smoothorder);
    for im=1:nm
        m = mV(im);
        % Smooth derivative of the log10 of the correlation sum with 
        % respect to the log10 of radii.  
        % Compute the correlation dimension only if enough radii are
        % given to perform the smooth derivation
        poidimV = NaN*ones(resol-1-2*smoothorder,1);
        for i=1+smoothorder:resol-1-smoothorder
            A = [log10rV(i-smoothorder:i+smoothorder)';ones(1,2*smoothorder+1)]';
            b = log10cM(i-smoothorder:i+smoothorder,im);
            x = A \ b;
            poidimV(i-smoothorder) = x(1);
        end
        for is=1:ns
            s = sV(is);
            % Compute the correlation dimension only if enough radii
            % are given to form scaling intervals according to 'e'.
            if rV(end) / rV(1) > s
                interval = length(find(rV<=rV(1)*s));
                nusd = m+1; % large starting values for mean and SD
                numean = NaN;
                for k=1:length(rV)-interval
                    nusdi= std(poidimV(k:k+interval));
                    numeani = mean(poidimV(k:k+interval));
                    if nusdi < nusd & numeani>0.7 
                        numean = numeani;
                        nusd = nusdi;
                    end
                end
                nuT(itau,im,is) = numean;
            end
        end
    end
end
