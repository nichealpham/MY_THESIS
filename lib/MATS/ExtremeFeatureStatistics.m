function [ymaxC,yminC,tminmaxC,tminminC,dminmaxC] = ExtremeFeatureStatistics(xV,filterorderV,nsamV)
% [ymaxC,yminC,tminmaxC,tminminC,dminmaxC] = ExtremeFeatureStatistics(xV,filterorderV,nsamV)
% EXTREMEFEATURESTATISTICS finds the local extreme values for a given time 
% series 'xV' computed for a window of 2*'nsam'+1 samples, for different 
% 'nsam' values given in 'nsamV'. The time series can be first filtered by 
% a forward-backward moving average filter of order 'filterorder' (the
% number of points in the moving average smoothing), for different 
% 'filterorder' values given in 'filterorderV'.
% From the series of local extremes, 5 series are generated: the local
% maxima and minima, the time between local minima (period) and the time
% from local minimum to local maximum, and the difference of local maxima
% and minima. For each of the 5 series the statistics of mean, median,
% standard deviation (std) and interquartile range (iqr) are computed.
% INPUTS:
% - xV          : The given scalar time series (vector of size n x 1).
% - filterorderV: A vector with components the order of the filter (if 0 or
%                 1 no filter is applied). 
% - nsamV       : A vector with components the number of samples to form
%                 the sliding data window, on which the local extremes are
%                 detected (default is 1). 
% OUTPUTS
% - ymaxC       : A cell array of 4 components for the 4 statistics of 
%                 local maxima (mean, median, std and iqr) where each 
%                 component is a matrix of size nfilterorder x nsam, where 
%                 'nfilterorder' and 'nnsam' are the lengths of the input 
%                 vectors for the number of filterorders and window sizes, 
%                 respectively. 
% - yminC       : The same as above but for the local minima.
% - tminmaxC    : The same as above but for the time from local minimum to
%                 the next local maximum.
% - tminminC    : The same as above but for the time from local minimum to
%                 the next local minimum. 
% - dminmaxC    : The same as above but for the difference of the local
%                 minimum from the next local maximum.
%========================================================================
%     <ExtremeFeatureStatistics.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
nfilterorder = length(filterorderV);
nnsam = length(nsamV);
n = length(xV);
for i=1:4
    ymaxC{i} = NaN*ones(nfilterorder,nnsam);
    yminC{i} = NaN*ones(nfilterorder,nnsam);
    tminmaxC{i} = NaN*ones(nfilterorder,nnsam);
    tminminC{i} = NaN*ones(nfilterorder,nnsam);
    dminmaxC{i} = NaN*ones(nfilterorder,nnsam);
end
for ifilter=1:nfilterorder
    filterorder = filterorderV(ifilter);
    % Filter the time series with 'filterorder'-point averaging FIR filter
    if n<2*filterorder
        break;
    end
    if filterorder > 1
        b = ones(1,filterorder)/filterorder;
        yV = filtfilt(b,1,xV);
        % To avoid multiple extremes due to discretization (round off) 
        % error, add infinitesimal small noise to the data.
        yV = AddNoise(yV,10^(-10)*std(yV));
    else
        yV = xV;
    end
    for insam = 1:nnsam
        % Find first local extreme
        nsam = nsamV(insam);
        if n<2*nsam
            break;
        end
        i=nsam+1;
        extfound = 'n'; % Local extreme found
        extfound = 0;
        locextM = [];
        while i<=n-nsam & ~extfound
            winyV = yV([i-nsam:i-1 i+1:i+nsam]);
            minwin = min(winyV);
            maxwin = max(winyV);
            checkextV = find(yV(i) >= winyV);
            if length(checkextV)==length(winyV) 
                locextM = [i yV(i) 1];
                extfound = 1;
            elseif length(checkextV) == 0
                locextM = [i yV(i) -1];
                extfound = 1;
            end
            i= i+1;
        end
        istart = i;
        for i=istart:n-nsam
            winyV = yV([i-nsam:i-1 i+1:i+nsam]);
            checkextV = find(yV(i) >= winyV);
            if length(checkextV)==length(winyV) & locextM(end,3)==-1
                locextM = [locextM; [i yV(i) 1]];
            elseif length(checkextV)==length(winyV) & locextM(end,2)<yV(i)
                locextM(end,:) = [i yV(i) 1];
            elseif length(checkextV) == 0 & locextM(end,3)==1
                locextM = [locextM; [i yV(i) -1]];
            elseif length(checkextV)==0 & locextM(end,2)>yV(i)
                locextM(end,:) = [i yV(i) -1];               
            end
        end
        % Check if the succession min,max is not followed. If both are maxima then 
        % remove the smaller one. If both are minima then remove the largest one.
        % This might be rare but it might happen!
        if size(locextM,1)>1
            iV = 1;
            while length(iV) > 0
                iV = find(locextM(1:end-1,3)+locextM(2:end,3) ~= 0);
                if length(iV)>0
                    dellocextM = []; % rows to be subtracted
                    for i=1:length(iV)
                        [tmp,imax] = max(locextM(iV(i):iV(i)+1,2));
                        if locextM(iV(i),3) == 1
                            iin = iV(i)+imax-1; 
                            iout = iV(i)+2-imax;
                        else
                            iin = iV(i)+2-imax; 
                            iout = iV(i)+imax-1;
                        end
                        dellocextM = [dellocextM;locextM(iout,:)];
                    end
                    locextM = setdiff(locextM,dellocextM,'rows');
                end
            end
            if locextM(1,3)==1
                ymaxV = locextM(1:2:end,2);
                yminV = locextM(2:2:end,2);
                ymaxV = ymaxV(1:length(yminV));
                tminmaxV = locextM(3:2:end,1)-locextM(2:2:end-1,1);
                tminminV = locextM(4:2:end,1)-locextM(2:2:end-2,1);
            else
                ymaxV = locextM(2:2:end,2);
                yminV = locextM(1:2:end,2);
                yminV = yminV(1:length(ymaxV));
                tminmaxV = locextM(2:2:end,1)-locextM(1:2:end-1,1);
                tminminV = locextM(3:2:end,1)-locextM(1:2:end-2,1);
            end
            dextV =ymaxV-yminV;
            ymaxC{1}(ifilter,insam)=mean(ymaxV);
            yminC{1}(ifilter,insam)=mean(yminV);
            tminmaxC{1}(ifilter,insam)=mean(tminmaxV);
            tminminC{1}(ifilter,insam)=mean(tminminV);
            dminmaxC{1}(ifilter,insam)=mean(dextV);
            ymaxC{2}(ifilter,insam)=median(ymaxV);
            yminC{2}(ifilter,insam)=median(yminV);
            tminmaxC{2}(ifilter,insam)=median(tminmaxV);
            tminminC{2}(ifilter,insam)=median(tminminV);
            dminmaxC{2}(ifilter,insam)=median(dextV);
            ymaxC{3}(ifilter,insam)=std(ymaxV);
            yminC{3}(ifilter,insam)=std(yminV);
            tminmaxC{3}(ifilter,insam)=std(tminmaxV);
            tminminC{3}(ifilter,insam)=std(tminminV);
            dminmaxC{3}(ifilter,insam)=std(dextV);
            ymaxC{4}(ifilter,insam)=iqr(ymaxV);
            yminC{4}(ifilter,insam)=iqr(yminV);
            tminmaxC{4}(ifilter,insam)=iqr(tminmaxV);
            tminminC{4}(ifilter,insam)=iqr(tminminV);
            dminmaxC{4}(ifilter,insam)=iqr(dextV);
        end
    end
end
        