function varargout = guisurrogate(varargin)
% GUISURROGATE M-file for guisurrogate.fig
%      GUISURROGATE, by itself, creates a new GUISURROGATE or raises the existing
%      singleton*.
%
%      H = GUISURROGATE returns the handle to a new GUISURROGATE or the handle to
%      the existing singleton*.
%
%      GUISURROGATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUISURROGATE.M with the given input arguments.
%
%      GUISURROGATE('Property','Value',...) creates a new GUISURROGATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guisurrogate_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guisurrogate_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guisurrogate

% Last Modified by GUIDE v2.5 18-Jan-2008 12:38:51
%========================================================================
%     <guisurrogate.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guisurrogate_OpeningFcn, ...
                   'gui_OutputFcn',  @guisurrogate_OutputFcn, ...
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

% --- Executes just before guisurrogate is made visible.
function guisurrogate_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
dat = getappdata(0,'datlist');
handles.current_data = dat;
listdatS = sprintf('%s (%d)',dat{1,1},dat{1,3});
for i=2:size(dat(:,1),1)
    listdatS = str2mat(listdatS,sprintf('%s (%d)',dat{i,1},dat{i,3}));
end
set(handles.listbox1,'String',listdatS,'Value',1)
set(handles.edit1,'String','40');
set(handles.edit2,'String','5');
set(handles.edit3,'String','20');
set(handles.edit4,'String','20');
set(handles.edit2,'Enable','Off');
set(handles.edit3,'Enable','Off');
set(handles.edit4,'Enable','Off');
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = guisurrogate_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in OK button.
function pushbutton1_Callback(hObject, eventdata, handles)
surnameC = {'RP','FT','AAFT','IAAFT','STAP','AMRB'};
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
k2=length(index_selected);
nsur = str2num(get(handles.edit1,'String'));
surdat = [];
surrogateV = zeros(6,1); % For the checkbox of each surrogate type
% Values from 6 checkboxes: 1->RP,2->FT,3->AAFT,4->IAAFT,5->STAP,6->AMRB
for i=1:6
    eval(['surrogateV(i) = get(handles.checkbox',int2str(i),',''Value'');'])
end
dat = handles.current_data;
% Find those surrogate types that are selected
runindV = find(surrogateV == 1);
if isempty(runindV)
    messageS = sprintf('Run: No surrogate type is selected. Select at least one surrogate type.\n');
    set(handles.edit5,'String',messageS);
else
    nrunind = length(runindV); % The number of selected surrogate types from the list
    dat = getappdata(0,'datlist');
    if isempty(dat)
        messageS = sprintf('Run: The data list is empty. Go to the main menu and load data first.\n');
        set(handles.edit5,'String',messageS);
    else
        count = size(dat(:,1),1);
        % Run first loop over all surrogate types then for each surrogate 
        % type, run into a second loop over all time series
        messageS = '';
        for irun=1:nrunind
            runind = runindV(irun);
            messageS = sprintf('%s %s : \n',messageS,surnameC{runind});
            set(handles.edit5,'String',messageS);
            switch runind
                case 1
                % Random Permutation (RP) surrogate of the selected time series.
                for i=1:k2 
                    surdat{i,1}=dat{index_selected(i),1};
                    surdat{i,2}=dat{index_selected(i),2};
                    newname = sprintf('%s%s',surdat{i,1},surnameC{runind});
                    messageS = sprintf('%s  %s: ',messageS,surdat{i,1});
                    set(handles.edit5,'String',messageS);
                    pause(0.00000000000001)
                    % Check whether this name is in the list and in that case remove  
                    % these RP surrogates from the active data list.
                    existV = strmatch(newname,dat(:,1));
                    if ~isempty(existV)
                        dat(existV,:)=[];
                        count = count-length(existV);
                        messageS = sprintf('%s Surrogate of this type already exist and they are deleted.',messageS);
                        set(handles.edit5,'String',messageS);
                    end
                    xV = surdat{i,2};
                    n = length(xV);
                    messageS = sprintf('%s Generating surrogates 1 ...',messageS);
                    set(handles.edit5,'String',messageS);
                    for isur=1:nsur
                        yV = xV(randperm(n));
                        count = count+1;
                        dat{count,1}=sprintf('%s%d',newname,isur);
                        dat{count,2}=yV;
                        dat{count,3}=size(yV,1);
                    end
                    messageS = sprintf('%s %d \n',messageS,nsur);
                    set(handles.edit5,'String',messageS);
                    pause(0.00000000000001)
                end
                case 2 
                % Fourier transform (FT) surrogate of the selected time series.
                for i=1:k2 
                    surdat{i,1}=dat{index_selected(i),1};
                    surdat{i,2}=dat{index_selected(i),2};
                    newname = sprintf('%s%s',surdat{i,1},surnameC{runind});
                    messageS = sprintf('%s  %s: ',messageS,surdat{i,1});
                    set(handles.edit5,'String',messageS);
                    pause(0.00000000000001)
                    % Check whether this name is in the list and in that case remove  
                    % these FT surrogates from the active data list.
                    existV = strmatch(newname,dat(:,1));
                    if ~isempty(existV)
                        dat(existV,:)=[];
                        count = count-length(existV);
                        messageS = sprintf('%s Surrogate of this type already exist and they are deleted.',messageS);
                        set(handles.edit5,'String',messageS);
                    end
                    messageS = sprintf('%s Generating surrogates 1 ...',messageS);
                    set(handles.edit5,'String',messageS);
                    xV = surdat{i,2};
                    n = length(xV);
                    zM = FourierTransform(xV,nsur);
                    for isur=1:nsur
                        count = count+1;
                        dat{count,1}=sprintf('%s%d',newname,isur);
                        dat{count,2}=zM(:,isur);
                        dat{count,3}=n;
                    end
                    messageS = sprintf('%s %d \n',messageS,nsur);
                    set(handles.edit5,'String',messageS);
                    pause(0.00000000000001)
                end
                case 3
                % Amplitude Adjusted Fourier transform (AAFT) surrogate of the selected time series.
                for i=1:k2 
                    surdat{i,1}=dat{index_selected(i),1};
                    surdat{i,2}=dat{index_selected(i),2};
                    newname = sprintf('%s%s',surdat{i,1},surnameC{runind});
                    messageS = sprintf('%s  %s: ',messageS,surdat{i,1});
                    set(handles.edit5,'String',messageS);
                    % Check whether this name is in the list and in that case remove  
                    % these AAFT surrogates from the active data list.
                    existV = strmatch(newname,dat(:,1));
                    if ~isempty(existV)
                        dat(existV,:)=[];
                        count = count-length(existV);
                        messageS = sprintf('%s Surrogate of this type already exist and they are deleted.',messageS);
                        set(handles.edit5,'String',messageS);
                    end
                    messageS = sprintf('%s Generating surrogates 1 ...',messageS);
                    set(handles.edit5,'String',messageS);
                    xV = surdat{i,2};
                    n = length(xV);
                    zM = AAFTsur(xV,nsur);
                    for isur=1:nsur
                        count = count+1;
                        dat{count,1}=sprintf('%s%d',newname,isur);
                        dat{count,2}=zM(:,isur);
                        dat{count,3}=n;
                    end
                    messageS = sprintf('%s %d \n',messageS,nsur);
                    set(handles.edit5,'String',messageS);
                    pause(0.00000000000001)
                end
                case 4
                % Iterated Amplitude Adjusted Fourier transform (IAAFT) surrogate of
                % the selected time series. 
                for i=1:k2 
                    surdat{i,1}=dat{index_selected(i),1};
                    surdat{i,2}=dat{index_selected(i),2};
                    newname = sprintf('%s%s',surdat{i,1},surnameC{runind});
                    messageS = sprintf('%s  %s: ',messageS,surdat{i,1});
                    set(handles.edit5,'String',messageS);
                    % Check whether this name is in the list and in that case remove  
                    % these IAAFT surrogates from the active data list.
                    existV = strmatch(newname,dat(:,1));
                    if ~isempty(existV)
                        dat(existV,:)=[];
                        count = count-length(existV);
                        messageS = sprintf('%s Surrogate of this type already exist and they are deleted.',messageS);
                        set(handles.edit5,'String',messageS);
                    end
                    messageS = sprintf('%s Generating surrogates 1 ...',messageS);
                    set(handles.edit5,'String',messageS);
                    xV = surdat{i,2};
                    n = length(xV);
                    zM = IAAFTsur(xV,nsur);
                    for isur=1:nsur
                        count = count+1;
                        dat{count,1}=sprintf('%s%d',newname,isur);
                        dat{count,2}=zM(:,isur);
                        dat{count,3}=n;
                    end
                    messageS = sprintf('%s %d \n',messageS,nsur);
                    set(handles.edit5,'String',messageS);
                    pause(0.00000000000001)
                end
                case 5
                % Statically Transformed Autoregressive Process (STAP) surrogate of
                % the selected time series. 
                pol = str2num(get(handles.edit2,'String'));
                arm = str2num(get(handles.edit3,'String'));
                for i=1:k2 
                    surdat{i,1}=dat{index_selected(i),1};
                    surdat{i,2}=dat{index_selected(i),2};
                    newname = sprintf('%s%s',surdat{i,1},surnameC{runind});
                    messageS = sprintf('%s  %s: ',messageS,surdat{i,1});
                    set(handles.edit5,'String',messageS);
                    % Check whether this name is in the list and in that case remove  
                    % these STAP surrogates from the active data list.
                    existV = strmatch(newname,dat(:,1));
                    if ~isempty(existV)
                        dat(existV,:)=[];
                        count = count-length(existV);
                        messageS = sprintf('%s Surrogate of this type already exist and they are deleted.',messageS);
                        set(handles.edit5,'String',messageS);
                    end
                    messageS = sprintf('%s Generating surrogates 1 ...',messageS);
                    set(handles.edit5,'String',messageS);
                    xV = surdat{i,2};
                    n = length(xV);
                    [zM,errormsg] = STAPsur(xV, pol, arm, nsur);
                    if isempty(errormsg)
                        for isur=1:nsur
                            count = count+1;
                            dat{count,1}=sprintf('%s%d',newname,isur);
                            dat{count,2}=zM(:,isur);
                            dat{count,3}=n;
                        end
                        messageS = sprintf('%s %d \n',messageS,nsur);
                        set(handles.edit5,'String',messageS);
                    else
                        messageS = sprintf('%s %s \n Surrogates are not generated for this time series. \n',messageS,errormsg);
                        set(handles.edit5,'String',messageS);
                    end
                end
                case 6
                % ARMB : Autoregressive Model Residual Bootstrap time series for
                % the selected time series. 
                arm = str2num(get(handles.edit4,'String'));
                for i=1:k2 
                    surdat{i,1}=dat{index_selected(i),1};
                    surdat{i,2}=dat{index_selected(i),2};
                    newname = sprintf('%s%s',surdat{i,1},surnameC{runind});
                    messageS = sprintf('%s  %s: ',messageS,surdat{i,1});
                    set(handles.edit5,'String',messageS);
                    % Check whether this name is in the list and in that case remove  
                    % these AMRB surrogates from the active data list.
                    existV = strmatch(newname,dat(:,1));
                    if ~isempty(existV)
                        dat(existV,:)=[];
                        count = count-length(existV);
                        messageS = sprintf('%s Surrogate of this type already exist and they are deleted.',messageS);
                        set(handles.edit5,'String',messageS);
                    end
                    messageS = sprintf('%s Generating surrogates 1 ...',messageS);
                    set(handles.edit5,'String',messageS);
                    xV = surdat{i,2};
                    n = length(xV);
                    [zM,flagtxt] = AMRBootstrap(xV,arm,nsur);
                    if isempty(flagtxt)
                        for isur=1:nsur
                            count = count+1;
                            dat{count,1}=sprintf('%s%d',newname,isur);
                            dat{count,2}=zM(:,isur);
                            dat{count,3}=n;
                        end
                        messageS = sprintf('%s %d \n',messageS,nsur);
                        set(handles.edit5,'String',messageS);
                    else
                        messageS = flagtxt;
                        set(handles.edit5,'String',messageS);
                        pause(3)
                    end
                end
            end % switch
            messageS = sprintf('%s \n ',messageS);
            set(handles.edit5,'String',messageS);
            pause(0.00000000000001)
        end % for surrogate types (runind)
    end % if empty datalist
end % if empty surrogate type list
% Update the active list of time series
setappdata(0,'datlist',dat);
uiwait(guisurrogate,1);
delete(guisurrogate)

% --- Executes on button press in Cancel button.
function pushbutton2_Callback(hObject, eventdata, handles)
delete(guisurrogate)

% --- Executes on button press in Help button.
function pushbutton3_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\ResampledTimeSeries.htm'')'])

% --- Executes on button press in RP checkbox.
function checkbox1_Callback(hObject, eventdata, handles)

% --- Executes on button press in FT checkbox.
function checkbox2_Callback(hObject, eventdata, handles)

% --- Executes on button press in AAFT checkbox.
function checkbox3_Callback(hObject, eventdata, handles)

% --- Executes on button press in IAAFT checkbox.
function checkbox4_Callback(hObject, eventdata, handles)

% --- Executes on button press in STAP checkbox.
function checkbox5_Callback(hObject, eventdata, handles)
checkstap = get(handles.checkbox5,'Value');
if checkstap==1
    set(handles.edit2,'Enable','on')
    set(handles.edit3,'Enable','on')
else
    set(handles.edit2,'Enable','off')
    set(handles.edit3,'Enable','off')
end
guidata(hObject,handles);

% --- Executes on button press in AMRB checkbox.
function checkbox6_Callback(hObject, eventdata, handles)
checkamrb = get(handles.checkbox6,'Value');
if checkamrb==1
    set(handles.edit4,'Enable','on')
else
    set(handles.edit4,'Enable','off')
end
guidata(hObject,handles);

% Enter number of surrogates
function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Enter STAP polynomial degree
function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Enter STAP AR order
function edit3_Callback(hObject, eventdata, handles)

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Enter AMRB AR order
function edit4_Callback(hObject, eventdata, handles)

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit5_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


