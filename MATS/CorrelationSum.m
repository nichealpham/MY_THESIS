function corsumT = CorrelationSum(xV,rV,tauV,mV,theiler)
% corsumT = CorrelationSum(xV,rV,tauV,mV,theiler)
% CORRELATIONSUM computes the correlation on a given time series 'xV' for a  
% number of radius in 'rV' and state space reconstructions with delays in
% 'tauV' and embedding dimensions in 'mV'. The parameter 'theiler' excludes
% temporally close points (smaller than 'theiler') from the inter-distance 
% computations.
% INPUT 
% - xV      : Vector of the scalar time series
% - rV      : A vector of the radius (assuming first that 'xV' is
%             standardized in [0,1]).
% - tauV    : A vector of the delay times.
% - mV      : A vector of the embedding dimension.
% - theiler : the Theiler window to exclude time correlated points in the
%             search for neighboring points. Default=0.
% OUTPUT: 
% - corsumT : A matrix of size 'nr' x 'ntau' x 'nm', where 'nr' is the 
%             number of given radius, 'ntau' is the number of given delays 
%             and 'nm' is the number of given embedding dimensions. The
%             components of the matrix are the correlation sum values.
%========================================================================
%     <CorrelationSum.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
if isempty(theiler), theiler=0; end
% Rescale to [0,1]
xmin = min(xV);
xmax = max(xV);
xV = (xV - xmin) / (xmax-xmin);
nr = length(rV);
ntau = length(tauV);
nm = length(mV);
corsumT = NaN*ones(nr,ntau,nm);
for ir=1:nr
    r = rV(ir);
    for itau = 1:ntau
        tau = tauV(itau);
        for im=1:nm
            m = mV(im);
            nvec = n-m*tau; % to be able to add the component x(nvec+tau) for m+1 
            if nvec-theiler < 2
                break;
            end
            xM = NaN*ones(nvec,m);
            for i=1:m
                xM(:,m-i+1) = xV(1+(i-1)*tau:nvec+(i-1)*tau);
            end
            % k-d-tree data structure of the training set for the given m
            [tmp,tmp,TreeRoot]=kdtreeidx(xM,[]); 
            % For each target point, find the points at a distance smaller than 
            % the radius, and same their cardinality.
            countV = NaN*ones(nvec,1);
            for i=1:nvec
                tarV = xM(i,:);
                [neiM,neidisV,neiindV]=kdrangequery(TreeRoot,tarV,r*sqrt(m));          
                countV(i)=length(find(abs(i-neiindV(2:end))>theiler));
            end
            kdtree([],[],TreeRoot);
            corsumT(ir,itau,im) = sum(countV)/(2*sum(nvec-theiler-...
                [1:theiler])+(nvec-2*theiler)*(nvec-2*theiler-1));
        end
    end
end