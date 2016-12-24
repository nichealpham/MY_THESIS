function [mapeM,nmseM,nrmseM,ccM,flagtxt] = ARpreite(xV,fraction,mV,TV)
% [mapeM,nmseM,nrmseM,ccM,flagtxt] = arpreite(xV,fraction,mV,TV)
% ARPREITE computes statistical errors of prediction at lead times given in 
% 'TV' with each of a number of AR models of orders given in 'mV' on a time 
% series 'xV'. The iterative prediction scheme is utilized.
% The test set for prediction is given by 'fraction', as the fraction of the  
% whole time series. 
% The different prediction error statistics given to the output have size 
% nm x nT, where nT is the length of 'TV' and 'nm' is the length of  
% 'mV'. 
% INPUT
% - xV      : The time series to be modelled, a column vector
% - fraction: A number in [0.1,0.9] that determines the length of the test
%             set as 'fraction x n' where 'n' is the length of 'xV'.
% - mV      : The vector of different orders of the AR-model
% - T       : The time step ahead for fitting the AR-model (if omitted,
%             default is T=1)
% OUTPUT
% - mapeM   : The Mean Absolute Percentage Error for predicted and real values.
%             A matrix of size nm x nT. 
% - nmseM   : The normalized mean square error for predicted and real values.
%             A matrix of size nm x nT. 
% - nrmseM  : The normalized root mean square error for predicted and real values
%             A matrix of size nm x nT. 
% - ccM     : The correlation coefficient between predicted and real values
%             A matrix of size nm x nT. 
% - flagtxt : A string of error message in case the AR matlab functions are
%             not supported by user's matlab product (missing toolbox).

if nargin == 3
    TV = 1;
end
mV=mV(:);
TV=TV(:);
nm = length(mV);
Tmax = max(TV);
nT = length(TV);
mapeM = NaN*ones(nm,nT); 
nmseM = NaN*ones(nm,nT); 
nrmseM = NaN*ones(nm,nT); 
ccM = NaN*ones(nm,nT); 
flagtxt = [];

n = length(xV);
n1 = round((1-fraction)*n);
n2 = n-n1;
x1V = xV(1:n1);

for im=1:nm
    m = mV(im);
    if n1<2*m+Tmax
        break;
    end
    if exist('armcov')==2
        parV = armcov(x1V,m);
        bV = -parV(end:-1:2); % bV(1)->x(t-m+1),bV(2)->x(t-m+2),...,bV(m)->x(t)
    elseif exist('ar')==2
        armod = ar(x1V,m); 
        bV = -armod.a(end:-1:2); % bV(1)->x(t-m+1),bV(2)->x(t-m+2),...,bV(m)->x(t)
    else
        flagtxt = 'You need to add toolbox ''ident'' or ''signal'' to be able to run measures of AR prediction.';
        return;
    end
    bV = bV(:);
    x2M = NaN*ones(n2-Tmax+1,m);
    for i=1:m
        x2M(:,i) = xV(n1-m+i:n-m-Tmax+i);
    end
    xpreM = NaN*ones(n2-Tmax+1,Tmax);  
    for j=1:Tmax
        xpreM(:,j) = x2M*bV;
        x2M(:,1:m-1)=x2M(:,2:m);
        x2M(:,m) = xpreM(:,j);
    end
    for iT=1:nT
        T = TV(iT);
        tarV = xV(n1+T:n-Tmax+T);
        ntar = length(tarV);
        mtar = mean(tarV);
        vartar = var(tarV);
        mapeM(im,iT) = mean(abs((tarV-xpreM(:,T))./tarV));
        nmseM(im,iT) = mean((tarV-xpreM(:,T)).^2) / vartar;
        nrmseM(im,iT) = sqrt(nmseM(im,iT));
        mxpre = mean(xpreM(:,T));
        ccM(im,iT) = sum((xpreM(:,T)-mxpre).*(tarV-mtar)) / sqrt((ntar-1)*vartar*(sum(xpreM(:,T).^2)-ntar*mxpre^2));
    end
end

