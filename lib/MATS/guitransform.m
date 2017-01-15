function varargout = guitransform(varargin)
%========================================================================
%     <guitransform.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
    'gui_OpeningFcn', @guitransform_OpeningFcn, ...
    'gui_OutputFcn',  @guitransform_OutputFcn, ...
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


% --- Executes just before guitransform is made visible.
function guitransform_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
dat = getappdata(0,'datlist');
handles.current_data = dat;
listdatS = sprintf('%s (%d)',dat{1,1},dat{1,3});
for i=2:size(dat(:,1),1)
    listdatS = str2mat(listdatS,sprintf('%s (%d)',dat{i,1},dat{i,3}));
end
set(handles.listbox1,'String',listdatS,'Value',1)
set(handles.text4,'Enable','Off') % Do not allow see parameter info
set(handles.text5,'Enable','Off') % Do not allow see parameter info
set(handles.text6,'Enable','Off') % Do not allow see parameter info
set(handles.edit1,'Enable','Off') % Do not allow see parameter info
set(handles.edit2,'Enable','Off') % Do not allow see parameter info
set(handles.edit3,'Enable','Off') % Do not allow see parameter info
set(handles.edit1,'String','1') % The polynomial degree
set(handles.edit2,'String','1') % The lag for difference
set(handles.edit3,'String','0') % The lambda of Box-Cox
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = guitransform_OutputFcn(hObject, eventdata, handles)
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

% --- Executes on button press in OK button.
function pushbutton1_Callback(hObject, eventdata, handles)
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
k2=length(index_selected);
transdat = [];
transformvalV = zeros(8,1);
% Values from 8 checkboxes: 1->Gaussian,2->Uniform,3->Linear,4->Normalized
% 5->Logarithmic, 6->Detrend, 7->Lag Difference, 8-> Box Cox transform
for i=1:8
    eval(['transformvalV(i) = get(handles.checkbox',int2str(i),',''Value'');'])
end
dat = handles.current_data;
count = size(dat(:,1),1);
transindV = [];
% Find first all time series in the list already transformed.
for j=1:count
    if ~isempty(find(dat{j,1}(end)==['G';'U';'L';'N';'O'])) 
        transindV = [transindV; j];
    else
        tmpV = find(dat{j,1}=='D' | dat{j,1}=='T' | dat{j,1}=='X');
        if ~isempty(tmpV) & isnumeric(str2num(dat{j,1}(tmpV(end)+1:end)))
            transindV = [transindV; j];
        end
    end
end
if transformvalV(1)==1
    % Gaussian transform the selected time series that are not already
    % transformed.
    for i=1:k2
        transdat{i,1}=dat{index_selected(i),1};
        transdat{i,2}=dat{index_selected(i),2};
        newname = sprintf('%sG',transdat{i,1});
        % Check whether the name of the original data and Gaussian
        % transformed data is included in the list of already Gaussian
        % transformed. If not then Guassian transform and add it.
        if isempty(strmatch(newname,dat(transindV,1),'exact')) & isempty(strmatch(newname(1:end-1),dat(transindV,1),'exact'))
            yV = GaussianTransform(transdat{i,2});
            count = count+1;
            dat{count,1}=newname;
            dat{count,2}=yV;
            dat{count,3}=size(yV,1);
        end
    end
end
if transformvalV(2)==1
    % Uniform transform the selected time series that are not already
    % transformed.
    for i=1:k2
        transdat{i,1}=dat{index_selected(i),1};
        transdat{i,2}=dat{index_selected(i),2};
        newname = sprintf('%sU',transdat{i,1});
        % Check whether the name of the original data and Uniform
        % transformed data is included in the list of already Uniform
        % transformed. If not then Guassian transform and add it.
        if isempty(strmatch(newname,dat(transindV,1),'exact')) & isempty(strmatch(newname(1:end-1),dat(transindV,1),'exact'))
            yV = UniformTransform(transdat{i,2});
            count = count+1;
            dat{count,1}=newname;
            dat{count,2}=yV;
            dat{count,3}=size(yV,1);
        end
    end
end
if transformvalV(3)==1
    % Linear transform the selected time series that are not already
    % transformed.
    for i=1:k2
        transdat{i,1}=dat{index_selected(i),1};
        transdat{i,2}=dat{index_selected(i),2};
        newname = sprintf('%sL',transdat{i,1});
        % Check whether the name of the original data and Linear
        % transformed data is included in the list of already Linear
        % transformed. If not then Guassian transform and add it.
        if isempty(strmatch(newname,dat(transindV,1),'exact')) & isempty(strmatch(newname(1:end-1),dat(transindV,1),'exact'))
            yV = LinearTransform(transdat{i,2});
            count = count+1;
            dat{count,1}=newname;
            dat{count,2}=yV;
            dat{count,3}=size(yV,1);
        end
    end
end
if transformvalV(4)==1
    % Normalized transform the selected time series that are not already
    % transformed.
    for i=1:k2
        transdat{i,1}=dat{index_selected(i),1};
        transdat{i,2}=dat{index_selected(i),2};
        newname = sprintf('%sN',transdat{i,1});
        % Check whether the name of the original data and Normalized
        % transformed data is included in the list of already Normalized
        % transformed. If not then Guassian transform and add it.
        if isempty(strmatch(newname,dat(transindV,1),'exact')) & isempty(strmatch(newname(1:end-1),dat(transindV,1),'exact'))
            yV = NormalizedTransform(transdat{i,2});
            count = count+1;
            dat{count,1}=newname;
            dat{count,2}=yV;
            dat{count,3}=size(yV,1);
        end
    end
end
if transformvalV(5)==1
    % Logarithmic transform of the selected time series that are not already
    % transformed (using the natural logarithm)
    for i=1:k2
        transdat{i,1}=dat{index_selected(i),1};
        transdat{i,2}=dat{index_selected(i),2};
        newname = sprintf('%sO',transdat{i,1});
        % Check whether the name of the original data and logarithmically
        % transformed data is included in the list of already
        % logarithmically transformed. If not then transform and add it.
        if isempty(strmatch(newname,dat(transindV,1),'exact')) & isempty(strmatch(newname(1:end-1),dat(transindV,1),'exact'))
            yV = LogDifferenceTransform(transdat{i,2});
            count = count+1;
            dat{count,1}=newname;
            dat{count,2}=yV;
            dat{count,3}=size(yV,1);
        end
    end
end
if transformvalV(6)==1
    % Polynomial detrending of the selected time series that are not already
    % transformed
    tmp = str2num(get(handles.edit1,'String'));
    if isnumeric(tmp)
        poldegreeV = round(tmp);
        for i=1:k2
            transdat{i,1}=dat{index_selected(i),1};
            transdat{i,2}=dat{index_selected(i),2};
            [yM,poldegreeV] = PolynomialDetrend(transdat{i,2},poldegreeV);
            if ~isempty(yM)
                for ipoldegree=1:length(poldegreeV)
                    newname = sprintf('%sD%d',transdat{i,1},poldegreeV(ipoldegree));
                    % Check whether such a name exist in the data list. 
                    % If yes, then do not add it.
                    if isempty(strmatch(newname,dat(transindV,1),'exact'))
                        count = count+1;
                        dat{count,1}=newname;
                        dat{count,2}=yM(:,ipoldegree);
                        dat{count,3}=size(yM,1);
                    end
                end
            end
        end
    end
end
if transformvalV(7)==1
    % Lag differencing of the selected time series that are not already
    % transformed
    tmp = str2num(get(handles.edit2,'String'));
    if isnumeric(tmp)
        lagV = round(tmp);
        for i=1:k2
            transdat{i,1}=dat{index_selected(i),1};
            transdat{i,2}=dat{index_selected(i),2};
            [yM,lagV] = LagDifference(transdat{i,2},lagV);
            if ~isempty(yM)
                for ilag=1:length(lagV)
                    newname = sprintf('%sT%d',transdat{i,1},lagV(ilag));
                    % Check whether such a name exist in the data list. 
                    % If yes, then do not add it.
                    if isempty(strmatch(newname,dat(transindV,1),'exact'))
                        count = count+1;
                        dat{count,1}=newname;
                        dat{count,2}=yM(1:size(yM,1)-lagV(ilag),ilag);
                        dat{count,3}=size(yM,1)-lagV(ilag);
                    end
                end
            end
        end
    end
end
if transformvalV(8)==1
    % Lag differencing of the selected time series that are not already
    % transformed
    tmp = str2num(get(handles.edit3,'String'));
    if isnumeric(tmp)
        lambdaV = tmp;
        for i=1:k2
            transdat{i,1}=dat{index_selected(i),1};
            transdat{i,2}=dat{index_selected(i),2};
            yM = BoxCoxTransform(transdat{i,2},lambdaV);
            if ~isempty(yM)
                for ilambda=1:length(lambdaV)
                    newname = sprintf('%sX%d',transdat{i,1},round(100*lambdaV(ilambda)));
                    % Check whether such a name exist in the data list. 
                    % If yes, then do not add it.
                    if isempty(strmatch(newname,dat(transindV,1),'exact'))
                        count = count+1;
                        dat{count,1}=newname;
                        dat{count,2}=yM(:,ilambda);
                        dat{count,3}=size(yM,1);
                    end
                end
            end
        end
    end
end
% Update the active list of time series
setappdata(0,'datlist',dat);
delete(guitransform)

% --- Executes on button press in Cancel button.
function pushbutton2_Callback(hObject, eventdata, handles)
delete(guitransform)

% --- Executes on button press in Help button.
function pushbutton3_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\TransformTimeSeries.htm'')'])

% --- Executes on button press in Gaussian checkbox.
function checkbox1_Callback(hObject, eventdata, handles)

% --- Executes on button press in Uniform checkbox.
function checkbox2_Callback(hObject, eventdata, handles)

% --- Executes on button press in Linear [0,1] checkbox.
function checkbox3_Callback(hObject, eventdata, handles)

% --- Executes on button press in Standardized checkbox.
function checkbox4_Callback(hObject, eventdata, handles)

% --- Executes on button press in Logarithmic transform.
function checkbox5_Callback(hObject, eventdata, handles)

% --- Executes on button press in Detrend.
function checkbox6_Callback(hObject, eventdata, handles)
if get(handles.checkbox6,'Value')==1
    set(handles.text4,'Enable','On') % Allow see parameter info
    set(handles.edit1,'Enable','On') % Allow see parameter info
else
    set(handles.text4,'Enable','Off') % Disallow see parameter info
    set(handles.edit1,'Enable','Off') % Disallow see parameter info
end

% --- Executes on button press in Lag Difference.
function checkbox7_Callback(hObject, eventdata, handles)
if get(handles.checkbox7,'Value')==1
    set(handles.text5,'Enable','On') % Allow see parameter info
    set(handles.edit2,'Enable','On') % Allow see parameter info
else
    set(handles.text5,'Enable','Off') % Disallow see parameter info
    set(handles.edit2,'Enable','Off') % Disallow see parameter info
end

% --- Executes on button press in Box Cox transform.
function checkbox8_Callback(hObject, eventdata, handles)
if get(handles.checkbox8,'Value')==1
    set(handles.text6,'Enable','On') % Allow see parameter info
    set(handles.edit3,'Enable','On') % Allow see parameter info
else
    set(handles.text6,'Enable','Off') % Disallow see parameter info
    set(handles.edit3,'Enable','Off') % Disallow see parameter info
end

function edit2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



