function [mapeT,nmseT,nrmseT,ccT] = LocalARfitdir(xV,tauV,mV,nneiV,q,TV)
% [mapeT,nmseT,nrmseT,ccT] = LocalARfitdir(xV,tauV,mV,nneiV,q,TV)
% LOCALARFITDIR makes in-sample direct predictions with a local model on a
% given time series 'xV'. A number of input parameters determine the local 
% model that are allowed to vary (components of the input vectors). 
% The state space reconstruction is done with the method of delays and the 
% parameters are the embedding dimension 'm' (component of 'mV') and the 
% delay time 'tau' (component of 'tauV'). The first target point is for 
% the time index 1+(m-1)*tau and the last is for the time n-Tmax, where 'n'
% is the length of the time series and Tmax is the largest prediction time
% in 'TV'.
% The local prediction model is one of the following:
% Ordinary Least Squares, OLS (standard local linear model): if the 
% trunctaion parameter q is such as q >= m
% Principal Component Regression, PCR, project the parameter space of the 
% model to only q of the m principal axes: if 0<q<m
% Local Average Mapping, LAM: if q=0.
% The local region is determined by the number of neighbours 'nnei' 
% (component of 'nneiV') formed from the training set. The k-d-tree data 
% structure is utilized to speed up computation time in the search of 
% neighboring points. 
% The distance is computed using the Euclidean (L2) norm.
% INPUTS:
% - xV       : The vector of the scalar time series
% - tauV     : A vector of delay times
% - mV       : A vetcor of embedding dimensions.
% - nneiV    : A vector of the number of neighboring points to support the
%              local model. 
% - q        : The truncation parameter for a normalization of the local
%              linear model (to project the parameter space of the model, 
%              using Principal Component Regression, PCR, locally).
%             if q>=m -> Ordinary Least Squares, OLS (standard local linear
%                        model,no projection)
%             if 0<q<m -> PCR(q)
%             if q=0 -> local average model
% - TV       : A vector of the prediction times.
% OUTPUT: 
% - mapeT   : The Mean Absolute Percentage Error for fitted and real values.
%             A matrix of dimension 4 and size
%             (ntau+1)x(nm+1)x(nnnei+1)x(nT+1) where ntau=length(tauV),
%             nm=length(mV), nnnei=length(nneiV) and nT = length(TV). 
% - nmseT   : The normalized mean square error of the fit for fitted and
%             real values. 
% - nrmseT  : The normalized root mean square error of the fit for fitted
%             and real values 
% - ccT     : The correlation coefficient between fitted and real values
% 
% Credit should be given to Guy Shechter who created the k-d-tree routines.
%========================================================================
%     <LocalARfitdir.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
r = 1000;  % to deviate the range of the data and get the minimum distance
if nargin == 5
    TV = 1;
end
tauV=tauV(:);
mV=mV(:);
nneiV=nneiV(:);
TV=TV(:);
ntau = length(tauV);
nm = length(mV);
nnnei = length(nneiV);
Tmax = max(TV);
nT = length(TV);
n = length(xV); 

mapeT = NaN*ones(ntau,nm,nnnei,nT); 
nmseT = NaN*ones(ntau,nm,nnnei,nT); 
nrmseT = NaN*ones(ntau,nm,nnnei,nT); 
ccT = NaN*ones(ntau,nm,nnnei,nT); 

for itau=1:ntau
    tau = tauV(itau);
    for im=1:nm
        m = mV(im);
        if n<2*((m-1)*tau-Tmax)
            break;
        end
        for innei=1:nnnei
            nnei = nneiV(innei);
            % The solution for the model parameters with respect to the
            % smallest rank of the predictor matrix of size nnei x m.
            qnow = min([q m]); 
            if (m>=nnei & qnow>=nnei)
                continue;
            end
            nvec = n-(m-1)*tau-Tmax;
            xM = NaN*ones(nvec,m);
            for i=1:m
                xM(:,m-i+1) = xV(1+(i-1)*tau:nvec+(i-1)*tau);
            end
            [tmp,tmp,TreeRoot]=kdtreeidx(xM,[]); % k-d-tree data structure of the training set
            % For each target point, find neighbors, apply the linear models and keep track 
            % of the predicted values for each model and each prediction time.
            preM = NaN*ones(nvec,Tmax);
            mindist = (max(xV)-min(xV))/r;
            for i=1:nvec
                inow = i+(m-1)*tau;
                winnowV = xV(inow-(m-1)*tau:inow);
                xpreV = lppreonedirT(xV,TreeRoot,winnowV,m,tau,nnei,qnow,Tmax,mindist,1);
                preM(i,:) = xpreV';
            end
            kdtreeidx([],[],TreeRoot); % Free the pointer to k-d-tree
            preM = [[1:nvec]+(m-1)*tau;preM']'; %Add the target point index before the iterative predictions
            for iT=1:nT
                T = TV(iT);
                tarV = xV(preM(:,1)+T);
                prenowV = preM(:,T+1);
                ntar = length(tarV);
                mtar = mean(tarV);
                vartar = var(tarV);
                mapeT(itau,im,innei,iT) = mean(abs((tarV-prenowV)./prenowV));
                nmseT(itau,im,innei,iT) = mean((tarV-prenowV).^2) / vartar;
                nrmseT(itau,im,innei,iT) = sqrt(nmseT(itau,im,innei,iT));
                mxpre = mean(prenowV);
                ccT(itau,im,innei,iT) = sum((prenowV-mxpre).*(tarV-mtar)) / sqrt((ntar-1)*vartar*(sum(prenowV.^2)-ntar*mxpre^2));
            end
        end
    end
end
