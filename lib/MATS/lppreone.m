function [xpre,neiindV] = lppreone(xV,TreeRoot,winnowV,m,tau,nnei,q,mindist,tarintree)
% xpre = lppreone(xV,TreeRoot,winnowV,m,tau,nnei,q,mindist,tarintree)
% Help function called in localARpreite.m
%========================================================================
%     <lppreone.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
f = 1.2;  % factor to increase the distance if not enough neighbors are found 
tarV = winnowV((m-1)*tau+1:-tau:1)';
distnow = mindist;
if tarintree
    [neiM,neidisV,neiindV]=kdrangequery(TreeRoot,tarV,distnow);
    while length(neiindV)<nnei+1
        distnow = f*distnow;
        [neiM,neidisV,neiindV]=kdrangequery(TreeRoot,tarV,distnow);
    end
    [oneidisV,oneiindV]=sort(neidisV);
    neiindV = neiindV(oneiindV(2:nnei+1));
    neidisV = neidisV(oneiindV(2:nnei+1));
    neiM = neiM(oneiindV(2:nnei+1),:);
    yV = xV(neiindV+(m-1)*tau+1);
    if q==0 | nnei==1
        xpre = mean(yV);
    else
        mneiV = mean(neiM);
        my = mean(yV);
        zM = neiM - ones(nnei,1)*mneiV;
        [Ux, Sx, Vx] = svd(zM, 0);
        tmpM = Vx(:,1:q) * inv(Sx(1:q,1:q)) * Ux(:,1:q)';
        lsbV = tmpM * (yV - my);
        xpre = my + (tarV-mneiV) * lsbV;
    end
elseif nnei==1
    [neiindV,neidisV,TreeRoot]=kdtreeidx([],tarV,TreeRoot);
    xpre = xV(neiindV+(m-1)*tau+1);
else
    [neiM,neidisV,neiindV]=kdrangequery(TreeRoot,tarV,distnow);
    while length(neiindV)<nnei
        distnow = f*distnow;
        [neiM,neidisV,neiindV]=kdrangequery(TreeRoot,tarV,distnow);
    end
    [oneidisV,oneiindV]=sort(neidisV);
    neiindV = neiindV(oneiindV(1:nnei));
    neidisV = neidisV(oneiindV(1:nnei));
    neiM = neiM(oneiindV(1:nnei),:);
    yV = xV(neiindV+(m-1)*tau+1);
    if q==0 
        xpre = mean(yV);
    else
        mneiV = mean(neiM);
        my = mean(yV);
        zM = neiM - ones(nnei,1)*mneiV;
        [Ux, Sx, Vx] = svd(zM, 0);
        tmpM = Vx(:,1:q) * inv(Sx(1:q,1:q)) * Ux(:,1:q)';
        lsbV = tmpM * (yV - my);
        xpre = my + (tarV-mneiV) * lsbV;
    end
end