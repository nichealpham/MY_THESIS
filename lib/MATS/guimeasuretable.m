function varargout = guimeasuretable(varargin)
% GUIMEASURETABLE M-file for guimeasuretable.fig
%      GUIMEASURETABLE, by itself, creates a new GUIMEASURETABLE or raises the existing
%      singleton*.
%
%      H = GUIMEASURETABLE returns the handle to a new GUIMEASURETABLE or the handle to
%      the existing singleton*.
%
%      GUIMEASURETABLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIMEASURETABLE.M with the given input arguments.
%
%      GUIMEASURETABLE('Property','Value',...) creates a new GUIMEASURETABLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guimeasuretable_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guimeasuretable_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help guimeasuretable

% Last Modified by GUIDE v2.5 16-Jan-2008 16:01:27
%========================================================================
%     <guimeasuretable.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guimeasuretable_OpeningFcn, ...
                   'gui_OutputFcn',  @guimeasuretable_OutputFcn, ...
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


% --- Executes just before guimeasuretable is made visible.
function guimeasuretable_OpeningFcn(hObject, eventdata, handles, varargin)
% Fill in listbox1 with time series names
datnameM = getappdata(0,'datnameM');
set(handles.listbox1,'Max',size(datnameM,1))
set(handles.listbox1,'String',datnameM,'Value',1)
% Fill in listbox2 with measure names
meadatC = getappdata(0,'mealist');
set(handles.listbox2,'Max',size(meadatC(:,1),1))
listdatS = meadatC{1,1};
for i=2:size(meadatC(:,1),1)
    listdatS = str2mat(listdatS,meadatC{i,1});
end
set(handles.listbox2,'String',listdatS,'Value',1)
set(handles.pushbutton4,'Enable','Off')

handles.current_dataname = datnameM;
handles.current_meadat = meadatC;

% Choose default command line output for guimeasuretable
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = guimeasuretable_OutputFcn(hObject, eventdata, handles) 
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

% --- Executes on button press in View Tables button.
function pushbutton1_Callback(hObject, eventdata, handles)
datalist_entries = get(handles.listbox1,'String');
dataindex_selected = get(handles.listbox1,'Value');
measurelist_entries = get(handles.listbox2,'String');
measureindex_selected = get(handles.listbox2,'Value');
rows=length(measureindex_selected); 
cols=length(dataindex_selected); 

messageS = sprintf('Please wait until the selected measure table is displayed in a separate Array Editor window \n');
set(handles.edit1,'String',messageS);

datnameM = handles.current_dataname;
meadatC = handles.current_meadat;
viewtable = [];
viewtable{1,1}='';
for j=1:cols
    viewtable{1,j+1}=char(datnameM(dataindex_selected(j),:));
end
for i=1:rows
    viewtable{i+1,1}=meadatC{measureindex_selected(i),1};
    for j=1:cols
        viewtable{i+1,j+1}= meadatC{measureindex_selected(i),2}(dataindex_selected(j));
    end
end
assignin('base','Table_of_Measures',viewtable)
uiwait(guiviewmeasures,1);
uiwait(guimeasuretable,1);
openvar('Table_of_Measures');
set(handles.listbox1,'Value',dataindex_selected);
set(handles.listbox2,'Value',measureindex_selected);
set(handles.pushbutton4,'Enable','On')
handles.viewtable = viewtable;
guidata(hObject, handles);

% --- Executes on button press in Cancel button.
function pushbutton2_Callback(hObject, eventdata, handles)
delete(guimeasuretable)

% --- Executes on button press in Help button.
function pushbutton3_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\ViewMeasureTable.htm'')'])

% --- Executes on button press in Save Selected Table button.
function pushbutton4_Callback(hObject, eventdata, handles)
viewtable = handles.viewtable;
% Allowed save format for measure table: ascii, xls and mat  
[filename, pathname, filterindex] = uiputfile({'*.*', 'simple ascii (*.*)'; ...
 '*.xls','Excel (*.xls)';'*.mat','MAT-files (*.mat)'},'Save as');
switch filterindex
    case 0
        % do nothing (the user selected Cancel in the dialogue window)
    case 1
        % The first row contains strings of the data file name, the first 
        % column sttrings of the measure names and the rest are numeric values.
        fid = asciimeasuretable(pathname,filename,viewtable);
        if fid==-1
            messageS = sprintf('Cannot open file %s%s for writing the selected measure table \n',pathname,filename);
            set(handles.edit1,'String',messageS);
        else
            messageS = sprintf('The selected measure table is save successfully in file %s%s \n',pathname,filename);
            set(handles.edit1,'String',messageS);
        end     
    case 2
        disp('sadsaa');
    case 3
        eval(sprintf('save %s%s viewtable ',pathname,filename))
    otherwise
        error('Selected a valid format.')
end


function edit1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


