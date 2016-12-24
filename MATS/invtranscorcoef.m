function [rhos,cV] = invtranscorcoef(rhox,aV)
% [rhos,cV] = invtranscorcoef(rhox,aV)
% INVTRANSCORCOEF computes the inverse transformed autocorrelation 
% coefficient rhos = Cov(s1,s2)/Var(s) of the presumed normal process 
% S for given (a) a polynomial transform formed by the vector of its
% coefficients 'aV', and (b) the autocorrelation coefficient for the 
% process of interest X, rhox = Cov(x1,x2)/Var(x).
% The coefficients of the polynomial 
%    rhox = c_0 + c_1 * rhos + c_2 * rhos^2 + ... + c_m * rhos^m 
% are given in the vector 'cV' and the solution for rhos in 'rhos'.
% INPUTS:
% - rhox    : The autocorrelation coefficient for the transformed process X.
%             It can be a vector, i.e. the autocorrelation function, or a 
%             scalar, i.e. the correlation coefficient for a single 'tau': 
%             x1=x(t),x2=x2(t-tau).  
% - aV      : The vector for the coefficients of the polynomial transform 
%             from S to X (a0, a1, ...).
% OUTPUTS:
% - rhos    : The correlation coefficient or autocorrelation for the 
%             standard normal process S, computed by solving the system of 
%             equation(s)  rhox = phi(rhos,aV)  with respect to rhos. 
%             Note that multiple solutions may exist and these are all 
%             given to the output. The maximum number of solutions is the  
%             order 'm' of the polynomial, so 'rhos' is a matrix with as  
%             many rows as 'rhox' and as many columns as 'm'. If the roots 
%             are less than 'm' the entries are filled with NaN.
% - cV      : The coefficients of the polynomial transform for the
%             correlation coefficients.
%========================================================================
%     <invtranscorcoef.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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

aV = aV(2:length(aV));
m = length(aV);
nt = length(rhox);
%%%% Some repeated standard computations are assigned to vectors
factV = zeros(m+1,1); % The factorial for 0,1,...,m
pow2V = zeros(m+1,1); % The powers of 2 for 0,1,...,m
for i=1:m+1
    factV(i) = factorial(i-1);
    pow2V(i) = 2^(i-1);
end
%%% The sum of the scalar moments  
tsum1 = 0;
tsum2 = 0;
for i=1:m
    tsum1 = tsum1 + aV(i)^2*momnormal(1,i)^2;
    tsum2 = tsum2 + aV(i)^2*(momnormal(1,2*i)-momnormal(1,i)^2);
    for j=i+1:m
        tsum1 = tsum1 + 2*aV(i)*aV(j)*momnormal(1,i)*momnormal(1,j);
        tsum2 = tsum2 + 2*aV(i)*aV(j)*(momnormal(1,i+j)-momnormal(1,i)*momnormal(1,j));
    end
end;

%%%% The coefficients of rhos computed from the triple sum
coefV = zeros(m+1,1); % Coefficients for powers of 0,1,...,m
%% First loop, the power for rhos, divided in two, even and odd powers
for k=0:2:m
    kk=k/2;
    if k==0, istart=2; else istart=k; end
    %% Second and third loop for the running indices of the double sum
    for i=istart:2:m
        ii=i/2;
        coefV(k+1)=coefV(k+1)+aV(i)^2*(factV(i+1)^2*pow2V(k+1))/(pow2V(i+1)*factV(ii-kk+1)^2*factV(k+1));
        for j=i+2:2:m
            jj=j/2; 
            coefV(k+1)=coefV(k+1)+2*aV(i)*aV(j)*(factV(i+1)*factV(j+1)*pow2V(k+1))/(pow2V((i+j)/2+1)*factV(ii-kk+1)*factV(jj-kk+1)*factV(k+1));   
        end  
    end
end
for k=1:2:m
    kk=(k-1)/2;
    %% Second and third loop for the running indices of the double sum
    for i=k:2:m
        ii=(i-1)/2;
        coefV(k+1)=coefV(k+1)+aV(i)^2*(factV(i+1)^2*pow2V(k+1))/(pow2V(i+1)*factV(ii-kk+1)^2*factV(k+1));
        for j=i+2:2:m
            jj=(j-1)/2; 
            coefV(k+1)=coefV(k+1)+2*aV(i)*aV(j)*(factV(i+1)*factV(j+1)*pow2V(k+1))/(pow2V((i+j)/2+1)*factV(ii-kk+1)*factV(jj-kk+1)*factV(k+1));   
        end  
    end
end

rhos = NaN*ones(nt,m);  
%% First loop, the delay tau
for t=1:nt
    % Sum up the first contsant term to the rest ...  
    cV = zeros(m+1,1);
    cV(1) = (coefV(1)-tsum1) / tsum2;
    cV(2:m+1) = coefV(2:m+1) / tsum2;
    c0 = cV(1) - rhox(t);
    parV = [cV(m+1:-1:2);c0];
    rhos(t,:) = roots(parV)';
end


function mom = momnormal(sigma,r)
% mom = momnormal(sigma,r)
% MOMNORMAL computes the moments of the normal distribution for given
% power r and standard deviation sigma.   

if mod(r,2)==1
    mom = 0;
else
    mom = sigma^r * factorial(r) / (2^(r/2)*factorial(r/2));
end

