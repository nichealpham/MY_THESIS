function varargout = guifrequencymeasures(varargin)
%========================================================================
%     <guifrequencymeasures.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guifrequencymeasures_OpeningFcn, ...
                   'gui_OutputFcn',  @guifrequencymeasures_OutputFcn, ...
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


% --- Executes just before guifrequencymeasures is made visible.
function guifrequencymeasures_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
measureC = getappdata(0,'parlist');
handles.measures = measureC;
handles.firstfunmea = 14; % Declares the first index of frequency-based measures 
handles.lastfunmea = 19; % Declares the last index of frequency-based measures 
firstfunmea = handles.firstfunmea; 
lastfunmea = handles.lastfunmea;
measureC = measureC(firstfunmea:lastfunmea,:);

nmeafun = lastfunmea-firstfunmea+1;
curposV = [1 20];
checkwidth = 2.5;
checkheight = 1;
spaceheight = 0.5;
spacewidth = 1;
allheight = 2.5;
namewidth = 40; 
partextwidth = 20;
parvaluewidth = 10;
labeltextheight = 1;
labeltextwidth = 15;
countpar = 0;
for i=1:nmeafun
    yposnow = curposV(2)-(i-1)*(allheight+spaceheight);
    eval([sprintf('set(handles.checkbox%d,''Value'',%s)',i,measureC{i,1})])
    eval([sprintf('set(handles.checkbox%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        i,curposV(1),yposnow+allheight/4,checkwidth,checkheight)])
    namecode = sprintf('%s (%s)',measureC{i,2},measureC{i,3});
    eval([sprintf('set(handles.text%d,''String'',''%s'')',i+countpar,namecode)])
    eval([sprintf('set(handles.text%d,''HorizontalAlignment'',''left'')',i+countpar)])
    xposnow = curposV(1)+checkwidth+spacewidth;
    eval([sprintf('set(handles.text%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        i+countpar,xposnow,yposnow,namewidth,allheight)])
    npar = measureC{i,4};
    xposnow = xposnow+namewidth+spacewidth;
    for j=1:npar
        countpar = countpar + 1;
        eval([sprintf('set(handles.text%d,''String'',''%s'')',i+countpar,measureC{i,4+(j-1)*2+1})])
        eval([sprintf('set(handles.text%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
            i+countpar,xposnow,yposnow,partextwidth,allheight)])
        xposnow = xposnow+partextwidth+spacewidth;
        eval([sprintf('set(handles.edit%d,''String'',''%s'')',countpar,measureC{i,4+j*2})])
        eval([sprintf('set(handles.edit%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
            countpar,xposnow,yposnow,parvaluewidth,allheight)])
        xposnow = xposnow+parvaluewidth+spacewidth;
        if measureC{i,1}=='0'
            eval([sprintf('set(handles.edit%d,''Enable'',''off'')',countpar)])
        end
    end
end    
eval([sprintf('set(handles.text%d,''String'',''Measures'',''FontSize'',10,''Position'',[%2.2f %2.2f %2.2f %2.2f]);',...
    i+countpar+1,curposV(1)+0.5*(checkwidth+spacewidth+namewidth),curposV(2)+allheight+2*spaceheight,labeltextwidth,labeltextheight)])
maxnpar = max(cell2mat(measureC(:,4)));
eval([sprintf('set(handles.text%d,''String'',''Parameters'',''FontSize'',10,''Position'',[%2.2f %2.2f %2.2f %2.2f]);',...
    i+countpar+2,curposV(1)+(checkwidth+spacewidth+namewidth)+0.5*maxnpar*(partextwidth+spacewidth),curposV(2)+allheight+2*spaceheight,labeltextwidth,labeltextheight)])
% Enable the frequency bands B,C,D,E to begin with (until A is checked). 
countpar = 2;
for i=2:5
    eval([sprintf('checked = get(handles.checkbox%d,''Value'');',i-1)])
    if checked == 0
        % Disable the current measure since the previous is not checked 
        eval([sprintf('set(handles.checkbox%d,''Enable'',''Off'')',i)])
        eval([sprintf('set(handles.text%d,''Enable'',''Off'')',i+countpar)])
        npar = measureC{i,4};
        for j=1:npar
            countpar = countpar + 1;
            eval([sprintf('set(handles.text%d,''Enable'',''Off'')',i+countpar)])
            eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',countpar)])
        end
    else
        % The previous measure is selected. Enable edit boxes of the previous
        % measure and enable the current measure
        npar = measureC{i-1,4};
        for j=1:npar
            eval([sprintf('set(handles.edit%d,''Enable'',''On'')',countpar-npar+j)])
        end
        eval([sprintf('set(handles.checkbox%d,''Enable'',''On'')',i)])
        eval([sprintf('set(handles.text%d,''Enable'',''On'')',i+countpar)])
        npar = measureC{i,4};
        for j=1:npar
            countpar = countpar + 1;
            eval([sprintf('set(handles.text%d,''Enable'',''On'')',i+countpar)])
            eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',countpar)])
        end
    end
end
% for the last band enable edit boxes if it is checked 
i=6;
eval([sprintf('checked = get(handles.checkbox%d,''Value'');',i-1)])
if checked == 1
    npar = measureC{i-1,4};
    for j=1:npar
        eval([sprintf('set(handles.edit%d,''Enable'',''On'')',countpar-npar+j)])
    end
end    
guidata(hObject,handles);


function varargout = guifrequencymeasures_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%%%%%%% Energy in bands: checkboxes 1,2,3,4,5 %%%%%%%%
% --- Executes on button press Energy in band No 1.
function checkbox1_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea; 
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow-handles.firstfunmea+1)])
npar = 0;
if measureC{inow,1}=='1'
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
    % Now enable for frequency band B to be filled
    i = 2;
    countpar = 2;
    eval([sprintf('set(handles.checkbox%d,''Enable'',''On'')',i)])
    eval([sprintf('set(handles.text%d,''Enable'',''On'')',i+countpar)])
    npar = measureC{handles.firstfunmea+i-1,4};
    for j=1:npar
        countpar = countpar + 1;
        eval([sprintf('set(handles.text%d,''Enable'',''On'')',i+countpar)])
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',countpar)])
    end
else
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
    % Now disable for frequency bands B,C,D,E to be filled
    countpar = 2;
    for i=2:5
        eval([sprintf('set(handles.checkbox%d,''Value'',0)',i)])
        eval([sprintf('set(handles.checkbox%d,''Enable'',''Off'')',i)])
        eval([sprintf('set(handles.text%d,''Enable'',''Off'')',i+countpar)])
        npar = measureC{handles.firstfunmea+i-1,4};
        for j=1:npar
            countpar = countpar + 1;
            eval([sprintf('set(handles.text%d,''Enable'',''Off'')',i+countpar)])
            eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',countpar)])
        end
    end
end
handles.measures = measureC;
guidata(hObject,handles);
    
% Energy in band No 1: 2 parameters, here parameter 1
function edit1_Callback(hObject, eventdata, handles)
textind = 4+1; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,5},'" is allowed'',measureC{inow,2});'])
elseif parV<0 | parV>0.5
    eval(['errordlg(''Only values in [0.0,0.5] for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Energy in band No 1: 2 parameters, here parameter 2
function edit2_Callback(hObject, eventdata, handles)
textind = 4+3; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea;
lefteditnum = (inow-handles.firstfunmea)*2+1;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
eval(sprintf('editleftstr = get(handles.edit%d,''String'');',lefteditnum))
parleftV = parstr2num(editleftstr);  
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,5},'" is allowed'',measureC{inow,2});'])
elseif parV<0 | parV>0.5
    eval(['errordlg(''Only values in [0.0,0.5] for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif parV<=parleftV
    eval(['errordlg(''The value for parameter "',measureC{inow,textind},...
        '" should be larger than the value for parameter "',...
        measureC{inow,textind-2},'".'',measureC{inow,2});'])    
end

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Energy in band No 2.
function checkbox2_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea + 1;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow-handles.firstfunmea+1)])
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)));
if measureC{inow,1}=='1'
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
    % Now enable for frequency band C to be filled
    i = 3;
    countpar = 4;
    eval([sprintf('set(handles.checkbox%d,''Enable'',''On'')',i)])
    eval([sprintf('set(handles.text%d,''Enable'',''On'')',i+countpar)])
    npar = measureC{handles.firstfunmea+i-1,4};
    for j=1:npar
        countpar = countpar + 1;
        eval([sprintf('set(handles.text%d,''Enable'',''On'')',i+countpar)])
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',countpar)])
    end
else
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''off'')',j+npar)])
    end
    % Now disable for frequency bands C,D,E to be filled
    countpar = 4;
    for i=3:5
        eval([sprintf('set(handles.checkbox%d,''Value'',0)',i)])
        eval([sprintf('set(handles.checkbox%d,''Enable'',''Off'')',i)])
        eval([sprintf('set(handles.text%d,''Enable'',''Off'')',i+countpar)])
        npar = measureC{handles.firstfunmea+i-1,4};
        for j=1:npar
            countpar = countpar + 1;
            eval([sprintf('set(handles.text%d,''Enable'',''Off'')',i+countpar)])
            eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',countpar)])
        end
    end
end
handles.measures = measureC;
guidata(hObject,handles);

% Energy in band No 2: 2 parameters, here parameter 1
function edit3_Callback(hObject, eventdata, handles)
textind = 4+1; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+1;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,5},'" is allowed'',measureC{inow,2});'])
elseif parV<0 | parV>0.5
    eval(['errordlg(''Only values in [0.0,0.5] for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Energy in band No 2: 2 parameters, here parameter 2
function edit4_Callback(hObject, eventdata, handles)
textind = 4+3; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+1;
lefteditnum = (inow-handles.firstfunmea)*2+1;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
eval(sprintf('editleftstr = get(handles.edit%d,''String'');',lefteditnum))
parleftV = parstr2num(editleftstr);  
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,5},'" is allowed'',measureC{inow,2});'])
elseif parV<0 | parV>0.5
    eval(['errordlg(''Only values in [0.0,0.5] for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif parV<=parleftV
    eval(['errordlg(''The value for parameter "',measureC{inow,textind},...
        '" should be larger than the value for parameter "',...
        measureC{inow,textind-2},'".'',measureC{inow,2});'])    
end

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Energy in band No 3.
function checkbox3_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea + 2;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow-handles.firstfunmea+1)])
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)));
if measureC{inow,1}=='1'
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
    % Now enable for frequency band D to be filled
    i = 4;
    countpar = 6;
    eval([sprintf('set(handles.checkbox%d,''Enable'',''On'')',i)])
    eval([sprintf('set(handles.text%d,''Enable'',''On'')',i+countpar)])
    npar = measureC{handles.firstfunmea+i-1,4};
    for j=1:npar
        countpar = countpar + 1;
        eval([sprintf('set(handles.text%d,''Enable'',''On'')',i+countpar)])
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',countpar)])
    end
else
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''off'')',j+npar)])
    end
    % Now disable for frequency bands D,E to be filled
    countpar = 6;
    for i=4:5
        eval([sprintf('set(handles.checkbox%d,''Value'',0)',i)])
        eval([sprintf('set(handles.checkbox%d,''Enable'',''Off'')',i)])
        eval([sprintf('set(handles.text%d,''Enable'',''Off'')',i+countpar)])
        npar = measureC{handles.firstfunmea+i-1,4};
        for j=1:npar
            countpar = countpar + 1;
            eval([sprintf('set(handles.text%d,''Enable'',''Off'')',i+countpar)])
            eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',countpar)])
        end
    end
end
handles.measures = measureC;
guidata(hObject,handles);

% Energy in band No 3: 2 parameters, here parameter 1
function edit5_Callback(hObject, eventdata, handles)
textind = 4+1; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+2;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,5},'" is allowed'',measureC{inow,2});'])
elseif parV<0 | parV>0.5
    eval(['errordlg(''Only values in [0.0,0.5] for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit5_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Energy in band No 3: 2 parameters, here parameter 2
function edit6_Callback(hObject, eventdata, handles)
textind = 4+3; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+2;
lefteditnum = (inow-handles.firstfunmea)*2+1;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
eval(sprintf('editleftstr = get(handles.edit%d,''String'');',lefteditnum))
parleftV = parstr2num(editleftstr);  
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,5},'" is allowed'',measureC{inow,2});'])
elseif parV<0 | parV>0.5
    eval(['errordlg(''Only values in [0.0,0.5] for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif parV<=parleftV
    eval(['errordlg(''The value for parameter "',measureC{inow,textind},...
        '" should be larger than the value for parameter "',...
        measureC{inow,textind-2},'".'',measureC{inow,2});'])    
end

function edit6_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Energy in band No 4.
function checkbox4_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea + 3;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow-handles.firstfunmea+1)])
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)));
if measureC{inow,1}=='1'
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
    % Now enable for frequency band D to be filled
    i = 5;
    countpar = 8;
    eval([sprintf('set(handles.checkbox%d,''Enable'',''On'')',i)])
    eval([sprintf('set(handles.text%d,''Enable'',''On'')',i+countpar)])
    npar = measureC{handles.firstfunmea+i-1,4};
    for j=1:npar
        countpar = countpar + 1;
        eval([sprintf('set(handles.text%d,''Enable'',''On'')',i+countpar)])
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',countpar)])
    end
else
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''off'')',j+npar)])
    end
    % Now disable for frequency bands E to be filled
    countpar = 8;
    for i=5:5
        eval([sprintf('set(handles.checkbox%d,''Value'',0)',i)])
        eval([sprintf('set(handles.checkbox%d,''Enable'',''Off'')',i)])
        eval([sprintf('set(handles.text%d,''Enable'',''Off'')',i+countpar)])
        npar = measureC{handles.firstfunmea+i-1,4};
        for j=1:npar
            countpar = countpar + 1;
            eval([sprintf('set(handles.text%d,''Enable'',''Off'')',i+countpar)])
            eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',countpar)])
        end
    end
end
handles.measures = measureC;
guidata(hObject,handles);

% Energy in band No 4: 2 parameters, here parameter 1
function edit7_Callback(hObject, eventdata, handles)
textind = 4+1; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+3;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,5},'" is allowed'',measureC{inow,2});'])
elseif parV<0 | parV>0.5
    eval(['errordlg(''Only values in [0.0,0.5] for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit7_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Energy in band No 4: 2 parameters, here parameter 2
function edit8_Callback(hObject, eventdata, handles)
textind = 4+3; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+3;
lefteditnum = (inow-handles.firstfunmea)*2+1;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
eval(sprintf('editleftstr = get(handles.edit%d,''String'');',lefteditnum))
parleftV = parstr2num(editleftstr);  
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,5},'" is allowed'',measureC{inow,2});'])
elseif parV<0 | parV>0.5
    eval(['errordlg(''Only values in [0.0,0.5] for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif parV<=parleftV
    eval(['errordlg(''The value for parameter "',measureC{inow,textind},...
        '" should be larger than the value for parameter "',...
        measureC{inow,textind-2},'".'',measureC{inow,2});'])    
end

function edit8_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Energy in band No 5
function checkbox5_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea + 4;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow-handles.firstfunmea+1)])
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)));
if measureC{inow,1}=='1'
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);
    
% Energy in band No 5: 2 parameters, here parameter 1
function edit9_Callback(hObject, eventdata, handles)
textind = 4+1; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+4;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,5},'" is allowed'',measureC{inow,2});'])
elseif parV<0 | parV>0.5
    eval(['errordlg(''Only values in [0.0,0.5] for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit9_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Energy in band No 5: 2 parameters, here parameter 2
function edit10_Callback(hObject, eventdata, handles)
textind = 4+3; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+4;
lefteditnum = (inow-handles.firstfunmea)*2+1;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
eval(sprintf('editleftstr = get(handles.edit%d,''String'');',lefteditnum))
parleftV = parstr2num(editleftstr);  
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,5},'" is allowed'',measureC{inow,2});'])
elseif parV<0 | parV>0.5
    eval(['errordlg(''Only values in [0.0,0.5] for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif parV<=parleftV
    eval(['errordlg(''The value for parameter "',measureC{inow,textind},...
        '" should be larger than the value for parameter "',...
        measureC{inow,textind-2},'".'',measureC{inow,2});'])    
end

function edit10_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Median Frequency.
function checkbox6_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea + 5;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow-handles.firstfunmea+1)])
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)));
if measureC{inow,1}=='1'
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);

% Median Frequency parameters, 2 parameters, parameter 1 here
function edit11_Callback(hObject, eventdata, handles)
textind = 4+1; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+5;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,5},'" is allowed'',measureC{inow,2});'])
elseif parV<0 | parV>0.5
    eval(['errordlg(''Only values in [0.0,0.5] for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end


function edit11_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Median Frequency parameters, 2 parameters, parameter 2 here
function edit12_Callback(hObject, eventdata, handles)
textind = 4+3; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+5;
lefteditnum = (inow-handles.firstfunmea)*2+1;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
eval(sprintf('editleftstr = get(handles.edit%d,''String'');',lefteditnum))
parleftV = parstr2num(editleftstr);  
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,5},'" is allowed'',measureC{inow,2});'])
elseif parV<0 | parV>0.5
    eval(['errordlg(''Only values in [0.0,0.5] for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif parV<=parleftV
    eval(['errordlg(''The value for parameter "',measureC{inow,textind},...
        '" should be larger than the value for parameter "',...
        measureC{inow,textind-2},'".'',measureC{inow,2});'])    
end

function edit12_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in OK button.
function pushbutton1_Callback(hObject, eventdata, handles)
measureC = handles.measures;
firstfunmea = handles.firstfunmea; 
lastfunmea = handles.lastfunmea;
nmeafun = lastfunmea-firstfunmea+1;
countpar = 0;
for i=firstfunmea:firstfunmea+nmeafun-1
    eval([sprintf('tmp=get(handles.checkbox%d,''Value'');',i-firstfunmea+1)])
    measureC{i,1}=num2str(tmp);
    npar = measureC{i,4};
    if measureC{i,1}=='1'
        for j=1:npar
            eval([sprintf('measureC{i,4+j*2}=get(handles.edit%d,''String'');',countpar+j)])
        end
    end
    countpar = countpar + npar;
end
setappdata(0,'parlist',measureC);
delete(guifrequencymeasures)

% --- Executes on button press in Cancel button.
function pushbutton2_Callback(hObject, eventdata, handles)
delete(guifrequencymeasures)

% --- Executes on button press in Help button.
function pushbutton3_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir'); 
eval(['web(''',dirnow,'\helpfiles\FrequencyMeasures.htm'')'])

