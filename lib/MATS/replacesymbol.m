function txtout = replacesymbol(txtin,symbolfind,symbolreplace)
% txtout = replacesymbol(txtin,symbolinfind,symbolreplace)
% REPLACESYMBOL replaces all occurences of a given symbol 'symbolfind' with 
% another symbol 'symbolreplace' (can also be blank '') in a given cell array 
% of strings or matrix of strings 'txtin'.
% INPUT 
% - txtin       : the input cell array of strings or matrix of strings.
% - symbolfind  : the symbol to be found
% - symbolreplace : the symbol to replace symbolfind.
% OUTPUT
% - txtout      : same as txtin but with symbolfind replaced by
%                 symbolreplace.
%========================================================================
%     <replacesymbol.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
if iscell(txtin)
    [n,m]=size(txtin);
    for i=1:n
        for j=1:m
            if n>1 & m>1
                txtout{i,j}=strrep(txtin{i,j},symbolfind,symbolreplace);
            elseif n==1
                txtout{j}=strrep(txtin{j},symbolfind,symbolreplace);
            elseif m==1
                txtout{i}=strrep(txtin{i},symbolfind,symbolreplace);
            else
                txtout=strrep(txtin,symbolfind,symbolreplace);
            end
        end
    end
elseif ischar(txtin)
    [n,m]=size(txtin);
    txtout=str2mat(strrep(txtin(1,:),symbolfind,symbolreplace));
    if n>1
        for i=2:n
            txtout=str2mat(txtout,strrep(txtin(i,:),symbolfind,symbolreplace));
        end
    end
end
