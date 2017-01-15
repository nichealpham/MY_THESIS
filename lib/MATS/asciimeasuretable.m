function fid = asciimeasuretable(pathname,filename,viewtable)
% fid = asciimeasuretable(pathname,filename,viewtable)
%========================================================================
%     <asciimeasuretable.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
eval(['fid = fopen(''',pathname,filename,''',''w'');'])
rows = size(viewtable,1)-1;
cols = size(viewtable,2)-1;
for j=1:cols
    fprintf(fid,'\t %s ',char(viewtable{1,j+1}));
end
fprintf(fid,'\n');
for i=1:rows
    fprintf(fid,'%s ',char(viewtable{i+1,1}));
    for j=1:cols
        fprintf(fid,'\t %f ',viewtable{i+1,j+1});
    end
    fprintf(fid,'\n');
end
fclose(fid);
