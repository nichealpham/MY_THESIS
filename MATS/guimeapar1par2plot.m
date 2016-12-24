function varargout = guimeapar1par2plot(varargin)
%========================================================================
%     <guimeapar1par2plot.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @guimeapar1par2plot_OpeningFcn, ...
    'gui_OutputFcn',  @guimeapar1par2plot_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before guimeapar1par2plot is made visible.
function guimeapar1par2plot_OpeningFcn(hObject, eventdata, handles, varargin)
% Fill in listbox1 with time series names
parsymbols = 'tmphfkqbsraw';
datnameM = getappdata(0,'datnameM');
set(handles.listbox1,'Max',size(datnameM,1))
set(handles.listbox1,'String',datnameM,'Value',1)
% Fill in listbox2 with measure names
set(handles.popupmenu1,'Value',1) % At start use delay (t) from the popupmenu
meadatC = getappdata(0,'mealist');
parsymbindV = parinlist(meadatC,parsymbols);
meadatC = meadatC(parsymbindV,:);
if isempty(parsymbindV)
    set(handles.listbox2,'String','Empty list, no parameter dependent measures','Value',1)
else
    set(handles.listbox2,'Max',length(parsymbindV))
    set(handles.listbox2,'String',meadatC(:,1),'Value',1)
end
messageS = sprintf('Graph measures vs parameter for different time series: \n The selected measures should differ only with respect to the value of the parameter, otherwise they are ignored. \n When up to 5 time series are selected, they are listed in a legend. \n Otherwise they are listed in this text box (matlab color and symbol syntax for the measures).');
set(handles.edit1,'String',messageS);
handles.current_dataname = datnameM;
handles.current_meadat = meadatC;
handles.output = hObject;
guidata(hObject, handles);


function parsymbindV = parinlist(meadatC,parsymbols)
% Finds the indices of the measures in the list that match any of the given
% parameters symbols.
nmeadat = size(meadatC,1);
parsymbindV = [];
for j=1:length(parsymbols)
    for i=1:nmeadat
        indV = strfind(meadatC{i,1}(11:end),parsymbols(j));
        % If there is a parameter symbol in the measure name and the
        % character in the next position is numeric then keep this index.
        if ~isempty(indV) && ~isempty(str2num(meadatC{i,1}(10+indV(end)+1)))
            if isempty(find(parsymbindV==i,1))
                parsymbindV = [parsymbindV;i];
            end
        end
    end
end

% --- Outputs from this function are returned to the command line.
function varargout = guimeapar1par2plot_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in View Selected Plot button.
function pushbutton1_Callback(hObject, eventdata, handles)
datalist_entries = get(handles.listbox1,'String');
dataindex_selected = get(handles.listbox1,'Value');
measurelist_entries = get(handles.listbox2,'String');
measureindex_selected = get(handles.listbox2,'Value');

parM = [];
if isempty(dataindex_selected) | length(dataindex_selected)>1
    messageS = sprintf('Only one time series should be selected for displaying the graph measures vs two parameters.');
    set(handles.edit1,'String',messageS);
    return;
end
if isempty(measureindex_selected)
    messageS = sprintf('At least two measures of same parameter type should be selected for displaying the graph measures vs two parameters.');
    set(handles.edit1,'String',messageS);
    return;
end
partypeval1 = get(handles.popupmenu1,'Value');
partype1S = get(handles.popupmenu1,'String');
partype1S = char(partype1S{partypeval1});
partypeval2 = get(handles.popupmenu2,'Value');
partype2S = get(handles.popupmenu2,'String');
partype2S = char(partype2S{partypeval2});
if partypeval1==partypeval2
    messageS = sprintf('The two parameter types should be different for displaying the graph measures vs two parameters.');
    set(handles.edit1,'String',messageS);
    return;
end
rows=length(measureindex_selected);
meadatC = handles.current_meadat;
meadatC = meadatC(measureindex_selected,:);
parsymbind1V = parinlist(meadatC,partype1S(end-1));
parsymbind2V = parinlist(meadatC,partype2S(end-1));
parsymbindV = intersect(parsymbind1V,parsymbind2V);

messageS = ''; % To be ready to show a new message
if length(parsymbindV)>=2
    % Add the natural order to keep track of the changes of the length
    % of the vector of parameter values.
    foundall = 0;
    while length(parsymbindV)>=2 & ~foundall
        ind1V = find(meadatC{parsymbindV(1),1}==partype1S(end-1));
        ind2V = find(meadatC{parsymbindV(1),1}==partype2S(end-1));
        meanameleft1 = meadatC{parsymbindV(1),1}(1:ind1V(end)-1);
        meanameleft1length = length(meanameleft1);
        meanameleft2 = meadatC{parsymbindV(1),1}(1:ind2V(end)-1);
        meanameleft2length = length(meanameleft2);
        if meanameleft1length<meanameleft2length
            meanamesmall = meanameleft1;
            meanamebig = meanameleft2;
            reverseorder = 0; % To track the order of appearance of the two
            % parameters in the measure name.
        else
            meanamesmall = meanameleft2;
            meanamebig = meanameleft1;
            reverseorder = 1; % To track the order of appearance of the two
            % parameters in the measure name.
        end
        nmeanamesmall = length(meanamesmall);
        nmeanamebig = length(meanamebig);
        j = nmeanamesmall + 2;
        foundpar = 0;
        while j<=length(meadatC{parsymbindV(1),1}) & ~foundpar
            if ~isempty(str2num(meadatC{parsymbindV(1),1}(j)))
                j=j+1;
            else
                foundpar=1;
            end
        end
        % At this point, j is at position one over the last digit of the
        % parameter at the left
        % parM: 1-> the index in the measure list, 2-> left parameter value
        parM = [parsymbindV(1) str2num(meadatC{parsymbindV(1),1}(nmeanamesmall+2:j-1))];
        if j<=nmeanamebig
            meanamenext = meanamebig(j:end);
            nmeanamenext = length(meanamenext);
        else
            meanamenext = [];
            nmeanamenext = 0;
        end
        j = nmeanamebig+2;
        foundpar = 0;
        while j<=length(meadatC{parsymbindV(1),1}) & ~foundpar
            if ~isempty(str2num(meadatC{parsymbindV(1),1}(j)))
                j=j+1;
            else
                foundpar=1;
            end
        end
        % parM: 3-> right parameter value
        parM = [parM str2num(meadatC{parsymbindV(1),1}(nmeanamebig+2:j-1))];
        if j<=length(meadatC{parsymbindV(1),1})
            meanameright = meadatC{parsymbindV(1),1}(j:end);
        else
            meanameright = [];
        end
        measurelabel = sprintf('%s %s %s',meanamesmall,meanamenext,meanameright);
        trackindV = 1;
        % For each of the other measure names check to find the same format
        for i=2:size(parsymbindV,1)
            if length(meadatC{parsymbindV(i),1})>=nmeanamesmall & ...
                    strmatch(meanamesmall,meadatC{parsymbindV(i),1}(1:nmeanamesmall),'exact')
                j=nmeanamesmall+2;
                foundpari = 0;
                while j<=length(meadatC{parsymbindV(i),1}) & ~foundpari
                    if ~isempty(str2num(meadatC{parsymbindV(i),1}(j)))
                        j=j+1;
                    else
                        foundpari=1;
                    end
                end % It should exit while only by violating the second condition
                % The first parameter value is found.
                candnum1 = meadatC{parsymbindV(i),1}(nmeanamesmall+2:j-1);
                if isempty(meanamenext) | (~isempty(meanamenext) & ...
                        ~isempty(findstr(meanamenext,meadatC{parsymbindV(i),1}(j:end))))
                    jstart = j+nmeanamenext+1; % if no string between the two parameters then length is 0
                    foundpar = 0;
                    j = jstart;
                    while j<=length(meadatC{parsymbindV(i),1}) & ~foundpar
                        if ~isempty(str2num(meadatC{parsymbindV(i),1}(j)))
                            j=j+1;
                        else
                            foundpar=1;
                        end
                    end
                    candnum2 =  meadatC{parsymbindV(i),1}(jstart:j-1);
                    if (isempty(meanameright) & j>length(meadatC{i,1})) | (~isempty(meanameright) & ...
                            ~isempty(meadatC{parsymbindV(i),1}(j:end)) & ...
                            strmatch(meanameright,meadatC{parsymbindV(i),1}(j:end),'exact'))
                        parM = [parM; [parsymbindV(i)  str2num(candnum1) str2num(candnum2)]];
                        trackindV=[trackindV;i];
                    end
                end % If conditions
            end % If conditions
        end % for rest measures
        if size(parM,1)>=2
            foundall=1;
        else
            parsymbindV(trackindV)=[];
        end
    end % while
end % if
if size(parM,1)<2
    messageS = sprintf('At least two different values for each parameter should exist for displaying the graph measures vs parameter "%s" and "%s".',partype1S,partype2S);
    set(handles.edit1,'String',messageS);
else
    datnameM = handles.current_dataname;
    datnamelist=datnameM(dataindex_selected,:);
    npar = size(parM,1);
    % The sort below should not be needed...
    % parM = sortrows(parM);
    for i=1:npar
        parM(i,4) = meadatC{parM(i,1),2}(dataindex_selected);
    end
    parM = parM(:,2:4);
    par1V = sort(unique(parM(:,1)));
    par2V = sort(unique(parM(:,2)));
    if length(par1V)<2 | length(par2V)<2
        messageS = sprintf('At least two different values for each parameter should exist for displaying the graph measures vs parameter "%s" and "%s".',partype1S,partype2S);
        set(handles.edit1,'String',messageS);
    else
        % Check that all combinations of values of par1V and par2V exist
        % (all cells in the grid), otherwise omit the whole row or column 
        % from the grid
        zM = NaN*ones(length(par1V),length(par2V));
        for i=1:length(par1V)
            for j=1:length(par2V)
                ij = find(parM(:,1)==par1V(i) & parM(:,2)==par2V(j));
%                 fprintf('par1V(%d)=%d par2V(%d)=%d length(ij)=%d \n',i,par1V(i),j,par2V(j),length(ij));
                if ~isempty(ij)
                    zM(i,j) = parM(ij,3);
                end
            end
        end
        handles.PlotFigure = figure('NumberTitle','Off','Name','Measure vs two Parameters',...
            'PaperOrientation','Landscape');
        surf(par2V,par1V,zM)
        if reverseorder
            xlabel([partype1S])
            ylabel([partype2S])
        else
            xlabel([partype2S])
            ylabel([partype1S])
        end
        measurelabel2 = replacesymbol(measurelabel,'_','');
        zlabel([measurelabel2])
        datnamelist2 = replacesymbol(datnamelist,'_','');
        title(sprintf('%s',char(datnamelist2)))
    end
end % if No of surrogates == 1
guidata(hObject, handles);

% --- Executes on button press in Exit button.
function pushbutton2_Callback(hObject, eventdata, handles)
% if isfield(handles,'PlotFigure') & ishandle(handles.PlotFigure),
%     close(handles.PlotFigure);
% end
delete(guimeapar1par2plot)

% --- Executes on button press in Help button.
function pushbutton3_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\ViewMeasurePar1Par2.htm'')'])

function edit1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
datnameM = handles.current_dataname;
meadatC = getappdata(0,'mealist');
partypeval = get(handles.popupmenu1,'Value');
partypeS = get(handles.popupmenu1,'String');
partypeS = char(partypeS{partypeval});
set(handles.text2,'String',sprintf('Select measures of parameter type \n "%s"',partypeS));
parsymbindV = parinlist(meadatC,partypeS(end-1));
if isempty(parsymbindV)
    set(handles.listbox2,'String','Empty list, no measures of the selected parameter','Value',1)
else
    set(handles.listbox2,'Max',length(parsymbindV))
    set(handles.listbox2,'String',meadatC(parsymbindV,1),'Value',1)
end
handles.current_meadat = meadatC(parsymbindV,:);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
datnameM = handles.current_dataname;
meadatC = handles.current_meadat;
% meadatC = getappdata(0,'mealist');
partypeval1 = get(handles.popupmenu1,'Value');
partype1S = get(handles.popupmenu1,'String');
partype1S = char(partype1S{partypeval1});
partypeval2 = get(handles.popupmenu2,'Value');
partype2S = get(handles.popupmenu2,'String');
partype2S = char(partype2S{partypeval2});
set(handles.text2,'String',sprintf('Select measures of parameter type \n "%s" and \n "%s"',partype1S,partype2S));
parsymbindV = parinlist(meadatC,partype2S(end-1));
if isempty(parsymbindV)
    set(handles.listbox2,'String','Empty list, no measures of the selected parameter','Value',1)
else
    set(handles.listbox2,'Max',length(parsymbindV))
    set(handles.listbox2,'String',meadatC(parsymbindV,1),'Value',1)
end
handles.current_meadat = meadatC(parsymbindV,:);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


