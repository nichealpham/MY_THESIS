function varargout = MATS(varargin)
% MATS M-file for MATS.fig
%      MATS, by itself, creates a new MATS or raises the existing
%      singleton*.
%
%      H = MATS returns the handle to a new MATS or the handle to
%      the existing singleton*.
%
%      MATS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATS.M with the given input arguments.
%
%      MATS('Property','Value',...) creates a new MATS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MATS_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MATS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help MATS

% Last Modified by GUIDE v2.5 25-Sep-2009 14:59:47
%========================================================================
%     <MATS.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @MATS_OpeningFcn, ...
                   'gui_OutputFcn',  @MATS_OutputFcn, ...
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


% --- Executes just before MATS is made visible.
function MATS_OpeningFcn(hObject, eventdata, handles, varargin)
% Add the current path where the guis are in the matlabpath
currentpath = pwd;
eval(['addpath ',currentpath])
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
setappdata(0,'programDir',currentpath);
setappdata(0,'datlist',[]);
setappdata(0,'parlist',[]);
setappdata(0,'mealist',[]);
setappdata(0,'datnameM',[]);
set(handles.popupmenu1,'Value',1) % At start set to view time series 1D


% --- Outputs from this function are returned to the command line.
function varargout = MATS_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in Load time series button.
function pushbutton1_Callback(hObject, eventdata, handles)
guiread
messageS = sprintf('Upon completion of operation "Load time series" the activated time series list will be updated.');
set(handles.text3,'String',messageS);
uiwait;
dat = getappdata(0,'datlist');
% List the activated time series 
if ~isempty(dat)
    listdatS = sprintf('%s (%d)',dat{1,1},dat{1,3});
    for i=2:size(dat(:,1),1)
        listdatS = str2mat(listdatS,sprintf('%s (%d)',dat{i,1},dat{i,3}));
    end
    set(handles.listbox1,'String',listdatS,'Value',1)
    datsizetxt = sprintf('Total: %d',size(dat(:,1),1));
    set(handles.text5,'String',datsizetxt);
end
set(handles.text3,'String',' ');

% --- Executes on button press in Segment time series button.
function pushbutton2_Callback(hObject, eventdata, handles)
% Enter guisegment only if active list of time series is not empty 
if ~isempty(getappdata(0,'datlist'))
    guisegment
    uiwait;
    dat = getappdata(0,'datlist');
    listdatS = sprintf('%s (%d)',dat{1,1},dat{1,3});
    for i=2:size(dat(:,1),1)
        listdatS = str2mat(listdatS,sprintf('%s (%d)',dat{i,1},dat{i,3}));
    end
    set(handles.listbox1,'String',listdatS,'Value',1)
    datsizetxt = sprintf('Total: %d',size(dat(:,1),1));
    set(handles.text5,'String',datsizetxt);
else
    messageS = sprintf('To use the operation "Segment time series" you must have first loaded time series.');
    set(handles.text3,'String',messageS);
end

% --- Executes on button press in Transform time series button.
function pushbutton3_Callback(hObject, eventdata, handles)
% Enter guitransform only if active list of time series is not empty 
if ~isempty(getappdata(0,'datlist'))
    guitransform
    uiwait;
    dat = getappdata(0,'datlist');
    listdatS = sprintf('%s (%d)',dat{1,1},dat{1,3});
    for i=2:size(dat(:,1),1)
        listdatS = str2mat(listdatS,sprintf('%s (%d)',dat{i,1},dat{i,3}));
    end
    set(handles.listbox1,'String',listdatS,'Value',1)
    datsizetxt = sprintf('Total: %d',size(dat(:,1),1));
    set(handles.text5,'String',datsizetxt);
else
    messageS = sprintf('To use the operation "Transform time series" you must have first loaded time series.');
    set(handles.text3,'String',messageS);
end

% --- Executes on button press in Surrogate time series button.
function pushbutton4_Callback(hObject, eventdata, handles)
% Enter guisurrogate only if active list of time series is not empty 
if ~isempty(getappdata(0,'datlist'))
    guisurrogate
    uiwait;
    dat = getappdata(0,'datlist');
    listdatS = sprintf('%s (%d)',dat{1,1},dat{1,3});
    for i=2:size(dat(:,1),1)
        listdatS = str2mat(listdatS,sprintf('%s (%d)',dat{i,1},dat{i,3}));
    end
    set(handles.listbox1,'String',listdatS,'Value',1)
    datsizetxt = sprintf('Total: %d',size(dat(:,1),1));
    set(handles.text5,'String',datsizetxt);
else
    messageS = sprintf('To use the operation "Resampled time series" you must have first loaded time series.');
    set(handles.text3,'String',messageS);
end


% --- Executes on button press in Save time series button.
function pushbutton5_Callback(hObject, eventdata, handles)
if ~isempty(getappdata(0,'datlist'))
    guisavedata
    uiwait;
    dat = getappdata(0,'datlist');
    listdatS = sprintf('%s (%d)',dat{1,1},dat{1,3});
    for i=2:size(dat(:,1),1)
        listdatS = str2mat(listdatS,sprintf('%s (%d)',dat{i,1},dat{i,3}));
    end
    set(handles.listbox1,'String',listdatS,'Value',1)
else
    messageS = sprintf('To use the operation "Save time series" you must have first loaded time series.');
    set(handles.text3,'String',messageS);
end

% --- Executes on selection change in View Time Series popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
if ~isempty(getappdata(0,'datlist'))
    viewcase = get(hObject,'Value');
    if viewcase==1
        guiviewtimeseries1D
    elseif viewcase==2
        guiviewtimeseries2D3D
    else
        guiviewtimeserieshist
    end
    uiwait;
else
    messageS = sprintf('To use the operation "View time series" you must have first loaded time series.');
    set(handles.text3,'String',messageS);
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Select / Run Measures button.
function pushbutton6_Callback(hObject, eventdata, handles)
if ~isempty(getappdata(0,'datlist'))
    guiselectmeasures
    uiwait;
    meadatC = getappdata(0,'mealist');
    if ~isempty(meadatC)
        listdatS = meadatC{1,1};
        for i=2:size(meadatC(:,1),1)
            listdatS = str2mat(listdatS,meadatC{i,1});
        end
        set(handles.listbox2,'String',listdatS,'Value',1)
        measizetxt = sprintf('Total: %d',size(meadatC(:,1),1));
        set(handles.text6,'String',measizetxt);
    end
else
    messageS = sprintf('To use the operation "Select / run measures" you must have first loaded time series.');
    set(handles.text3,'String',messageS);
    % measizetxt = sprintf('Total: 0');
    set(handles.text6,'String',' ');
end

% --- Executes on button press in Save Measures pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
datnameM = getappdata(0,'datnameM');
meadatC = getappdata(0,'mealist');
rows=size(meadatC,1); 
cols=size(datnameM,1); 
if rows>0
    viewtable = [];
    viewtable{1,1}='';
    for j=1:cols
        viewtable{1,j+1}=char(datnameM(j,:));
    end
    for i=1:rows
        viewtable{i+1,1}=meadatC{i,1};
        for j=1:cols
            viewtable{i+1,j+1}= meadatC{i,2}(j);
        end
    end
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
                messageS = sprintf('Cannot open file %s%s for writing the full measure table \n',pathname,filename);
                set(handles.text3,'String',messageS);
            else
                messageS = sprintf('The full measure table is saved successfully in ascii text file %s%s \n',pathname,filename);
                set(handles.text3,'String',messageS);
            end     
        case 2
            dattxt = sprintf('%s%s',pathname,filename);
            eval(['success = xlswrite(''',dattxt,''',viewtable);'])
            if success
                messageS = sprintf('The full measure table is saved successfully in excel file %s%s \n',pathname,filename);
                set(handles.text3,'String',messageS);
            else
                messageS = sprintf('%s File %s could not be saved.\n',messageS,dattxt);
                set(handles.text3,'String',messageS);
            end
        case 3
            eval(sprintf('save %s%s viewtable ',pathname,filename))
            messageS = sprintf('The full measure table is saved successfully in the matlab data file %s%s \n',pathname,filename);
            set(handles.text3,'String',messageS);
        otherwise
            error('Select a valid format.')
    end
else
    messageS = sprintf('The measure table is empty, nothing to save.\n');
    set(handles.text3,'String',messageS);
end

% --- Executes on button press in View Measures.
function pushbutton8_Callback(hObject, eventdata, handles)
if ~isempty(getappdata(0,'mealist'))
    guiviewmeasures
    uiwait;
else
    messageS = sprintf('The measure table is empty, nothing to view.');
    set(handles.text3,'String',messageS);
end

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Delete (data).
function pushbutton9_Callback(hObject, eventdata, handles)
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
k2=length(index_selected); 
dat = getappdata(0,'datlist');
if ~isempty(dat)
    dat(index_selected,:)=[];
end
% Update the active list of time series
setappdata(0,'datlist',dat);
if ~isempty(dat)
    listdatS = sprintf('%s (%d)',dat{1,1},dat{1,3});
    for i=2:size(dat(:,1),1)
        listdatS = str2mat(listdatS,sprintf('%s (%d)',dat{i,1},dat{i,3}));
    end
    set(handles.listbox1,'String',listdatS,'Value',1)
    datsizetxt = sprintf('Total: %d',size(dat(:,1),1));
    set(handles.text5,'String',datsizetxt);
else
    set(handles.listbox1,'String','Empty','Value',1)
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

% --- Executes on button press in Sort by name.
function pushbutton10_Callback(hObject, eventdata, handles)
dat = getappdata(0,'datlist');
if ~isempty(dat)
    [odat,idatV]=sort(dat(:,1));
    dat = dat(idatV,:);
    listdatS = sprintf('%s (%d)',dat{1,1},dat{1,3});
    for i=2:size(dat(:,1),1)
        listdatS = str2mat(listdatS,sprintf('%s (%d)',dat{i,1},dat{i,3}));
    end
    set(handles.listbox1,'String',listdatS,'Value',1)
else
    set(handles.listbox1,'String','Empty','Value',1)
end
% Update the active list of time series
setappdata(0,'datlist',dat);

% --- Executes on button press in Sort by Size.
function pushbutton11_Callback(hObject, eventdata, handles)
dat = getappdata(0,'datlist');
if ~isempty(dat)
    for i=1:size(dat(:,3))
        datsizeV(i) = dat{i,3};
    end
    [odat,idatV]=sort(datsizeV);
    dat = dat(idatV,:);
    listdatS = sprintf('%s (%d)',dat{1,1},dat{1,3});
    for i=2:size(dat(:,1),1)
        listdatS = str2mat(listdatS,sprintf('%s (%d)',dat{i,1},dat{i,3}));
    end
    set(handles.listbox1,'String',listdatS,'Value',1)
else
    set(handles.listbox1,'String','Empty','Value',1)
end
% Update the active list of time series
setappdata(0,'datlist',dat);


% --- Executes on button press in Table of selected time series.
function pushbutton19_Callback(hObject, eventdata, handles)
index_selected = get(handles.listbox1,'Value');
dat = getappdata(0,'datlist');
if ~isempty(dat)
    assignin('base','Table_of_Selected_Time_Series',dat(index_selected,:))
    openvar('Table_of_Selected_Time_Series');
%     uiwait(MATS,1);
%     datnew = getappdata(0,'Table_of_Selected_Time_Series');
%     if length(datnew(:,1))==length(dat(index_selected,1))
%         dat(index_selected,:)=datnew;
%     end
end
% setappdata(0,'datlist',dat);

% --- Executes on button press in Time Series Name Notation button.
function pushbutton12_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\timeseriesnames.htm'')'])


% --- Executes on button press in Measure Parameter Name Notation button.
function pushbutton13_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\parameternames.htm'')'])



% --- Executes on button press in Exit pushbutton.
function pushbutton40_Callback(hObject, eventdata, handles)
delete(MATS)

% --- Executes on button press in Help pushbutton.
function pushbutton41_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\index.htm'')'])




