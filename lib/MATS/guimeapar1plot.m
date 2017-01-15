function varargout = guimeapar1plot(varargin)
%========================================================================
%     <guimeapar1plot.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guimeapar1plot_OpeningFcn, ...
                   'gui_OutputFcn',  @guimeapar1plot_OutputFcn, ...
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


% --- Executes just before guimeapar1plot is made visible.
function guimeapar1plot_OpeningFcn(hObject, eventdata, handles, varargin)
% Fill in listbox1 with time series names
parsymbols = 'tmphfkqbsraw';
datnameM = getappdata(0,'datnameM');
set(handles.listbox1,'Max',size(datnameM,1))
set(handles.listbox1,'String',datnameM,'Value',1)
% Fill in listbox2 with measure names
set(handles.popupmenu1,'Value',1) % At start use delay (t) from the popupmenu
set(handles.popupmenu2,'Value',1) % At start use lines from the popupmenu
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
        if ~isempty(indV) & ~isempty(str2num(meadatC{i,1}(10+indV(end)+1))) ...
                & isempty(intersect(i,parsymbindV))
            parsymbindV = [parsymbindV;i];
        end
    end
end

% --- Outputs from this function are returned to the command line.
function varargout = guimeapar1plot_OutputFcn(hObject, eventdata, handles) 
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
if isempty(dataindex_selected)
    messageS = sprintf('At least one time series should be selected for displaying the graph measures vs parameter.');
    set(handles.edit1,'String',messageS);
elseif isempty(measureindex_selected)
    messageS = sprintf('At least two measures of same parameter type should be selected for displaying the graph measures vs parameter.');
    set(handles.edit1,'String',messageS);
else
    rows=length(measureindex_selected); 
    partypeval = get(handles.popupmenu1,'Value');
    partypeS = get(handles.popupmenu1,'String');
    partypeS = char(partypeS{partypeval});
    cols=length(dataindex_selected);
    datnameM = handles.current_dataname;
    meadatC = handles.current_meadat;
    meadatC = meadatC(measureindex_selected,:);
    parsymbindV = parinlist(meadatC,partypeS(end-1));

    messageS = ''; % To be ready to show a new message
    if length(parsymbindV)>=2
        % Add the natural order to keep track of the changes of the length
        % of the vector of parameter values.
        foundall = 0;
        while length(parsymbindV)>=2 & ~foundall
            indV = find(meadatC{parsymbindV(1),1}==partypeS(end-1));
            meanameleft = meadatC{parsymbindV(1),1}(1:indV(end)-1);
            meanameleftlength = length(meanameleft);
            j = meanameleftlength + 2;
            foundpar = 0;
            while j<=length(meadatC{parsymbindV(1),1}) & ~foundpar
                if ~isempty(str2num(meadatC{parsymbindV(1),1}(j)))
                    j=j+1;
                else
                    foundpar=1;
                end
            end
            if j<=length(meadatC{parsymbindV(1),1})
                meanameright = meadatC{parsymbindV(1),1}(j:end);
            else
                meanameright = [];
            end
            % 1-> the index in the measure list, 2-> parameter value
            parM = [parsymbindV(1) str2num(meadatC{parsymbindV(1),1}(meanameleftlength+2:j-1))];
            measurelabel = sprintf('%s %s',meanameleft,meanameright);
            trackindV = 1;
            for i=2:size(parsymbindV,1)
                if length(meadatC{parsymbindV(i),1})>=meanameleftlength & ...
                        strmatch(meanameleft,meadatC{parsymbindV(i),1}(1:meanameleftlength),'exact') 
                    j=meanameleftlength+2;
                    foundpari = 0;
                    while j<=length(meadatC{parsymbindV(i),1}) & ~foundpari
                        if ~isempty(str2num(meadatC{parsymbindV(i),1}(j)))
                            j=j+1;
                        else
                            foundpari=1;
                        end
                    end
                    candnum = meadatC{parsymbindV(i),1}(meanameleftlength+2:j-1);
                    if (isempty(meanameright) & j>length(meadatC{i,1})) | (~isempty(meanameright) & ...
                            ~isempty(meadatC{parsymbindV(i),1}(j:end)) & ...
                            strmatch(meanameright,meadatC{parsymbindV(i),1}(j:end),'exact')) 
                        parM = [parM; [parsymbindV(i)  str2num(candnum)]];
                        trackindV=[trackindV;i];
                    end 
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
        messageS = sprintf('At least two measures of same parameter type should be selected for displaying the graph measures vs parameter %s.',partypeS);
        set(handles.edit1,'String',messageS);
    else
        datnamelist = [];
        npar = size(parM,1);
        % The sort below should not be needed...
        % parM = sortrows(parM);
        plottableM = NaN*ones(npar,cols);
        datnamelist=datnameM(dataindex_selected,:);
        for j=1:cols
            for i=1:npar
                plottableM(i,j)= meadatC{parM(i,1),2}(dataindex_selected(j));
            end
        end
        drawtype = get(handles.popupmenu2,'Value');
        if drawtype==1
            symbV = str2mat('-k','-c','-r','--k','--c','--r','-.k','-.c','-.r',':k',':c',':r');
        elseif drawtype==2
            symbV = str2mat('ok','oc','or','xk','xc','xr','+k','+c','+r','*k','*c','*r');
        else
            symbV = str2mat('o-k','o-c','o-r','x--k','x--c','x--r','+-.k','+-.c','+-.r','*:k','*:c','*:r');
        end
        nsymb = size(symbV,1);

        handles.PlotFigure = figure('NumberTitle','Off','Name','Measure vs Parameter',...
            'PaperOrientation','Landscape');
        eval(['plot(parM(:,2),plottableM(:,1),''',symbV(1,:),''',''Markersize'',8,''linewidth'',2);'])
        hold on
        for j=2:cols
            k = mod(j-1,nsymb)+1;
            eval(['plot(parM(:,2),plottableM(:,j),''',symbV(k,:),''',''Markersize'',8,''linewidth'',2);'])
        end
        if cols<=5
            datnamelist2 = replacesymbol(datnamelist,'_','');
            eval(['leg = legend([datnamelist2],''location'',''Best'');'])
        else
            for j=1:cols
                k = mod(j-1,nsymb)+1;
                messageS = sprintf('%s ''%s'': %s \n',messageS,symbV(k,:),char(datnamelist{j}));
            end
            set(handles.edit1,'String',messageS);
        end
        xlabel([partypeS])
        measurelabel2 = replacesymbol(measurelabel,'_','');
        ylabel([measurelabel2])
        title(sprintf('%s vs %s',measurelabel2,partypeS))
        if cols<=5
            messageS = sprintf('Graph measures vs parameter for different time series: \n The selected measures should differ only with respect to the value of the parameter, otherwise they are ignored. \n When up to 5 time series are selected, they are listed in a legend. \n Otherwise they are listed in this text box (matlab color and symbol syntax for the measures).');
            set(handles.edit1,'String',messageS);
        end
    end % if No of surrogates == 1
end % if No of time series == 1
guidata(hObject, handles);

% --- Executes on button press in Exit button.
function pushbutton2_Callback(hObject, eventdata, handles)
% if isfield(handles,'PlotFigure') & ishandle(handles.PlotFigure),
%     close(handles.PlotFigure);
% end
delete(guimeapar1plot)

% --- Executes on button press in Help button.
function pushbutton3_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\ViewMeasurePar1.htm'')'])

function edit1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
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


