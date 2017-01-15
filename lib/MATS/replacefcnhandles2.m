function replacefcnhandles2(name)
%========================================================================
%     <replacefcnhandles2.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
try
    hFig = load('-mat', name);
catch
    disp('Error Reading input file! Check File name.');
    return
end
hFig = repStru(hFig);
save(name,'-struct','hFig');
end

function Stru = repStru(Stru)
for it = 1: numel(Stru)
    names = fieldnames(Stru(it));
    for nm_len = 1:length(names)
        %Stru(it).(names{nm_len})
        if(isa(Stru(it).(names{nm_len}),'struct'))
            Stru(it).(names{nm_len})=repStru(Stru(it).(names{nm_len}));
        else
            if isa(Stru(it).(names{nm_len}), 'function_handle')

                fstring = func2str(Stru(it).(names{nm_len}));
                fstring = strrep(fstring, '@(hObject,eventdata)', '');
                fstring = strrep(fstring, 'hObject', 'gcbo');
                fstring = strrep(fstring, 'eventdata', '[]');
                Stru(it).(names{nm_len}) = fstring;
                disp(fstring);
            end

        end
    end
end
end
