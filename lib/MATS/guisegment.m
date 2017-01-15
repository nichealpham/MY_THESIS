function varargout = guisegment(varargin)
%========================================================================
%     <guisegment.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guisegment_OpeningFcn, ...
                   'gui_OutputFcn',  @guisegment_OutputFcn, ...
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


% --- Executes just before guisegment is made visible.
function guisegment_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
dat = getappdata(0,'datlist');
handles.current_data = dat;
listdatS = sprintf('%s (%d)',dat{1,1},dat{1,3});
for i=2:size(dat(:,1),1)
    listdatS = str2mat(listdatS,sprintf('%s (%d)',dat{i,1},dat{i,3}));
end
set(handles.listbox1,'String',listdatS,'Value',1)
set(handles.edit1,'String','0')
set(handles.edit2,'String','0')
set(handles.popupmenu1,'Value',1)
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = guisegment_OutputFcn(hObject, eventdata, handles) 
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

function edit1_Callback(hObject, eventdata, handles)
set(handles.edit2,'String',get(handles.edit1,'String'))

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in OK button.
function pushbutton1_Callback(hObject, eventdata, handles)
n = str2num(get(handles.edit1,'String'));
s = str2num(get(handles.edit2,'String'));
if n>0 & s>0
    list_entries = get(handles.listbox1,'String');
    index_selected = get(handles.listbox1,'Value');
    k2=length(index_selected); 
    segdat = [];
    first = get(handles.popupmenu1,'Value');
    if first==1
        firstchar = 'B';
    else
        firstchar = 'E';
    end
    dat = handles.current_data;
    count = size(dat(:,1),1);
    for i=1:k2 
        segdat{i,1}=dat{index_selected(i),1};
        segdat{i,2}=dat{index_selected(i),2};
        if length(segdat{i,2})>n
            xM = DivideSeg(segdat{i,2},n,s,first);
            for j=1:size(xM,2)
                newname = sprintf('%sn%ds%d%sS%d',segdat{i,1},n,s,firstchar,j);
                if isempty(strmatch(newname,segdat(:,1),'exact'))
                    count = count+1;
                    dat{count,1}=newname;
                    dat{count,2}=xM(:,j);
                    dat{count,3}=size(xM(:,j),1);
                end
            end
        end
    end
    setappdata(0,'datlist',dat);
end
% Update the active list of time series
delete(guisegment)

% --- Executes on button press in Cancel button.
function pushbutton2_Callback(hObject, eventdata, handles)
delete(guisegment)

% --- Executes on button press in Help button.
function pushbutton3_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\SegmentTimeSeries.htm'')'])

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
