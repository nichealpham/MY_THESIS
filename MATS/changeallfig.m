function changeallfig(dirtxt)
% It calls the function 'replacefcnhandles2.m' on each file of extension
% .fig in the given directory 'dirtxt'. The function 'replacefcnhandles2.m'
% updates the GUI in order to be run by older matlab versions.
% INPUT 
% - dirtxt : the full path of the directory containing the GUI files, e.g.
%            'c:\MyFiles\matlab\MATS\';
%========================================================================
%     <changeallfig.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
suffixtxt = '.fig';

eval(['cd ',dirtxt])
AllS = ls;
n = size(AllS,1);
for i=1:n
    if findstr(AllS(i,:),suffixtxt)>0
        replacefcnhandles2(AllS(i,:));
    end
end

