function varargout = guiviewtimeseries2D3D(varargin)
%========================================================================
%     <guiviewtimeseries2D3D.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guiviewtimeseries2D3D_OpeningFcn, ...
                   'gui_OutputFcn',  @guiviewtimeseries2D3D_OutputFcn, ...
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


% --- Executes just before guiviewtimeseries2D3D is made visible.
function guiviewtimeseries2D3D_OpeningFcn(hObject, eventdata, handles, varargin)
% Fill in listbox1 with time series names
dat = getappdata(0,'datlist');
handles.current_data = dat;
listdatS = sprintf('%s (%d)',dat{1,1},dat{1,3});
for i=2:size(dat(:,1),1)
    listdatS = str2mat(listdatS,sprintf('%s (%d)',dat{i,1},dat{i,3}));
end
set(handles.listbox1,'String',listdatS,'Value',1)
set(handles.listbox1,'Max',1) % Only one time series can be chosen
set(handles.popupmenu1,'Value',1) % The draw type 
set(handles.slider1,'Min',1) % The delay time
set(handles.slider1,'Max',101) % The delay time
set(handles.slider1,'SliderStep',[0.01 0.1]) % The delay time
set(handles.slider1,'Value',1) % The delay time
set(handles.text4,'String','1') % The delay time

% Choose default command line output for guifreeplot
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = guiviewtimeseries2D3D_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on selection change in time series listbox.
function listbox1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton "2D scatter diagram".
function pushbutton1_Callback(hObject, eventdata, handles)
datalist_entries = get(handles.listbox1,'String');
dataindex_selected = get(handles.listbox1,'Value');
dat = handles.current_data;
plotdat = dat(dataindex_selected,:);
lag = round(get(handles.slider1,'Value'));
drawtype = get(handles.popupmenu1,'Value');
handles.PlotFigure = figure('NumberTitle','Off','Name','2D scatter diagram',...
    'PaperOrientation','Landscape');
if drawtype==1
    plot(plotdat{1,2}(1:end-lag),plotdat{1,2}(lag+1:end),'-b','linewidth',1)
elseif drawtype==2
    plot(plotdat{1,2}(1:end-lag),plotdat{1,2}(lag+1:end),'.b','Markersize',8)
else
    plot(plotdat{1,2}(1:end-lag),plotdat{1,2}(lag+1:end),'.-b','Markersize',8,'linewidth',1)
end
xlabel(sprintf('x(t-%d)',lag))
ylabel('x(t)')
title(sprintf('%s (%d)',plotdat{1,1},plotdat{1,3}))
guidata(hObject, handles);

% --- Executes on button press in pushbutton "3D scatter diagram".
function pushbutton2_Callback(hObject, eventdata, handles)
datalist_entries = get(handles.listbox1,'String');
dataindex_selected = get(handles.listbox1,'Value');
dat = handles.current_data;
plotdat = dat(dataindex_selected,:);
lag = round(get(handles.slider1,'Value'));
drawtype = get(handles.popupmenu1,'Value');
handles.PlotFigure = figure('NumberTitle','Off','Name','3D scatter diagram',...
    'PaperOrientation','Landscape');
if drawtype==1
    plot3(plotdat{1,2}(1:end-2*lag),plotdat{1,2}(lag+1:end-lag),plotdat{1,2}(2*lag+1:end),'-b','linewidth',1)
elseif drawtype==2
    plot3(plotdat{1,2}(1:end-2*lag),plotdat{1,2}(lag+1:end-lag),plotdat{1,2}(2*lag+1:end),'.b','Markersize',8)
else
    plot3(plotdat{1,2}(1:end-2*lag),plotdat{1,2}(lag+1:end-lag),plotdat{1,2}(2*lag+1:end),'.-b','Markersize',8,'linewidth',1)
end
set(gca,'Box','On')
xlabel(sprintf('x(t-%d)',2*lag))
ylabel(sprintf('x(t-%d)',lag))
zlabel('x(t)')
title(sprintf('%s (%d)',plotdat{1,1},plotdat{1,3}))
guidata(hObject, handles);


% --- Executes on button press in pushbutton "Exit".
function pushbutton3_Callback(hObject, eventdata, handles)
delete(guiviewtimeseries2D3D)

% --- Executes on button press in pushbutton "Help".
function pushbutton4_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\ViewTimeSeries2D3D.htm'')'])

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
NewVal = get(hObject, 'Value');
% Set the value of the lag in edit1 to the new value set by slider
set(handles.text4,'String',round(NewVal))


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



