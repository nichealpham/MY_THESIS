function varargout = guimea1mea2mea3plot(varargin)
%========================================================================
%     <guimea1mea2mea3plot.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guimea1mea2mea3plot_OpeningFcn, ...
                   'gui_OutputFcn',  @guimea1mea2mea3plot_OutputFcn, ...
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


% --- Executes just before guimea1mea2mea3plot is made visible.
function guimea1mea2mea3plot_OpeningFcn(hObject, eventdata, handles, varargin)
% Fill in listbox1 with time series names
datnameM = getappdata(0,'datnameM');
set(handles.listbox1,'Max',size(datnameM,1))
set(handles.listbox1,'String',datnameM,'Value',1)
% Fill in listbox2 with measure names
meadatC = getappdata(0,'mealist');
set(handles.listbox2,'Max',2)
listdatS = meadatC{1,1};
for i=2:size(meadatC(:,1),1)
    listdatS = str2mat(listdatS,meadatC{i,1});
end
set(handles.listbox2,'String',listdatS,'Value',1)

handles.current_dataname = datnameM;
handles.current_meadat = meadatC;

messageS = sprintf('3D scatter plot of measures: \n Exactly three mesures should be selected. The measure value triple is drawn as a point in a 3D scatter plot for each time series.');
set(handles.edit1,'String',messageS);

% Choose default command line output for guimea1mea2mea3plot
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = guimea1mea2mea3plot_OutputFcn(hObject, eventdata, handles) 
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

% --- Executes on button press in View Free Plot button.
function pushbutton1_Callback(hObject, eventdata, handles)
datalist_entries = get(handles.listbox1,'String');
dataindex_selected = get(handles.listbox1,'Value');
measurelist_entries = get(handles.listbox2,'String');
measureindex_selected = get(handles.listbox2,'Value');
cols=length(measureindex_selected);
rows=length(dataindex_selected);
if cols ~= 3
    messageS = sprintf('Exactly three measures should be selected for displaying the 3D scatter plot of measures.');
    set(handles.edit1,'String',messageS);
else
    messageS = ''; % To be ready to show a new message
    datnameM = handles.current_dataname;
    meadatC = handles.current_meadat;

    meanamelist = [];
    plottableM = NaN*ones(rows,cols);
    for j=1:cols
        meanamelist{j}=meadatC{measureindex_selected(j),1};
        for i=1:rows
            plottableM(i,j)= meadatC{measureindex_selected(j),2}(dataindex_selected(i));
        end
    end
    handles.PlotFigure = figure('NumberTitle','Off','Name','3D scatter plot of measures',...
        'PaperOrientation','Landscape');
    plot3(plottableM(:,1),plottableM(:,2),plottableM(:,3),'.','Markersize',10)
    hold on
    xlabel([char(meanamelist{1})])
    ylabel([char(meanamelist{2})])
    zlabel([char(meanamelist{3})])
    set(gca,'Box','On')
end % if No of measures ==2
guidata(hObject, handles);

% --- Executes on button press in Exit button.
function pushbutton2_Callback(hObject, eventdata, handles)
% if isfield(handles,'PlotFigure') & ishandle(handles.PlotFigure),
%     close(handles.PlotFigure);
% end
delete(guimea1mea2mea3plot)

% --- Executes on button press in Help button.
function pushbutton3_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\ViewMeasure3D.htm'')'])

function edit1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

