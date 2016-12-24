function varargout = guinonlinearcorrelationmeasures(varargin)
%========================================================================
%     <guinonlinearcorrelationmeasures.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guinonlinearcorrelationmeasures_OpeningFcn, ...
                   'gui_OutputFcn',  @guinonlinearcorrelationmeasures_OutputFcn, ...
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


% --- Executes just before guinonlinearcorrelationmeasures is made visible.
function guinonlinearcorrelationmeasures_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
measureC = getappdata(0,'parlist');
handles.measures = measureC;
handles.firstfunmea = 28; % Declares the first index of measures 
handles.lastfunmea = 35; % Declares the last index of measures 
% Fill the measures and parameters in the specified fields of the panel.
firstfunmea = handles.firstfunmea; 
lastfunmea = handles.lastfunmea;
measureC = measureC(firstfunmea:lastfunmea,:);
nfunmea = lastfunmea-firstfunmea+1;
curposV = [1 27];
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

for i=1:nfunmea
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
guidata(hObject,handles);


 
function varargout = guinonlinearcorrelationmeasures_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%%%%%%% Bicorrelation: checkboxes 1,2 %%%%%%%%
% --- Executes on button press in bicorrelation.
function checkbox1_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea; 
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow-handles.firstfunmea+1)])
npar = 0;
if measureC{inow,1}=='1'
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);

% Pearson autocorrelation parameters
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
elseif any(sign(parV)==-1) | any(sign(parV)==0)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end
eval(sprintf('set(handles.edit%d,''String'',editstr);',inow-handles.firstfunmea+2));

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in cumulative bicorrelation.
function checkbox2_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea+1; 
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow-handles.firstfunmea+1)])
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)));
if measureC{inow,1}=='1'
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);


% Pearson cumulative autocorrelation parameters
function edit2_Callback(hObject, eventdata, handles)
textind = 4+1; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+1;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1) | any(sign(parV)==0)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%%%%%%%%%% Mutual Information Equidistant bins, checkboxes = 1,2,3
% --- Executes on button press in Mutual Information Equidistant bins.
function checkbox3_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea+2; 
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow-handles.firstfunmea+1)])
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)));
if measureC{inow,1}=='1'
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);

% Mutual Information Equidistant bins, par1->bins.
function edit3_Callback(hObject, eventdata, handles)
textind = 4+1; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+2;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end
eval(sprintf('set(handles.edit%d,''String'',editstr);',inow-handles.firstfunmea+3));
eval(sprintf('set(handles.edit%d,''String'',editstr);',inow-handles.firstfunmea+5));

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% Mutual Information Equidistant bins, par2 -> delays
function edit4_Callback(hObject, eventdata, handles)
textind = 4+3; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+2;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end
eval(sprintf('set(handles.edit%d,''String'',editstr);',inow-handles.firstfunmea+4));
eval(sprintf('set(handles.edit%d,''String'',editstr);',inow-handles.firstfunmea+6));

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in cumulative Mutual Information Equidistant bins.
function checkbox4_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea+3; 
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow-handles.firstfunmea+1)])
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)));
if measureC{inow,1}=='1'
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);

% Cumulative Mutual Information Equidistant bins, par1->bins.
function edit5_Callback(hObject, eventdata, handles)
textind = 4+1; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+3;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit5_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% Cumulative Mutual Information Equidistant bins, par2 -> delays
function edit6_Callback(hObject, eventdata, handles)
textind = 4+3; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+3;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit6_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in First Minimum Mutual Information Equidistant bins.
function checkbox5_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea+4; 
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow-handles.firstfunmea+1)])
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)));
if measureC{inow,1}=='1'
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);

%  First Minimum  Mutual Information Equidistant bins, par1->bins.
function edit7_Callback(hObject, eventdata, handles)
textind = 4+1; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+4;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit7_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%  First Minimum  Mutual Information Equidistant bins, par2 -> delays
function edit8_Callback(hObject, eventdata, handles)
textind = 4+3; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+4;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit8_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%%%%%%%%%% Mutual Information Equiprobable bins, checkboxes = 1,2,3
% --- Executes on button press in Mutual Information Equiprobable bins.
function checkbox6_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea+5; 
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow-handles.firstfunmea+1)])
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)));
if measureC{inow,1}=='1'
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);

% Mutual Information Equiprobable bins, par1->bins.
function edit9_Callback(hObject, eventdata, handles)
textind = 4+1; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+5;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end
eval(sprintf('set(handles.edit%d,''String'',editstr);',inow-handles.firstfunmea+6));
eval(sprintf('set(handles.edit%d,''String'',editstr);',inow-handles.firstfunmea+8));

function edit9_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% Mutual Information Equiprobable bins, par2 -> delays
function edit10_Callback(hObject, eventdata, handles)
textind = 4+3; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+5;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end
eval(sprintf('set(handles.edit%d,''String'',editstr);',inow-handles.firstfunmea+7));
eval(sprintf('set(handles.edit%d,''String'',editstr);',inow-handles.firstfunmea+9));

function edit10_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in cumulative Mutual Information Equiprobable bins.
function checkbox7_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea+6; 
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow-handles.firstfunmea+1)])
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)));
if measureC{inow,1}=='1'
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);

% Cumulative Mutual Information Equiprobable bins, par1->bins.
function edit11_Callback(hObject, eventdata, handles)
textind = 4+1; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+6;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit11_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% Cumulative Mutual Information Equiprobable bins, par2 -> delays
function edit12_Callback(hObject, eventdata, handles)
textind = 4+3; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+6;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit12_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in First Minimum Mutual Information Equiprobable bins.
function checkbox8_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea+7; 
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow-handles.firstfunmea+1)])
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)));
if measureC{inow,1}=='1'
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for j=1:measureC{inow,4}
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);

%  First Minimum  Mutual Information Equiprobable bins, par1->bins.
function edit13_Callback(hObject, eventdata, handles)
textind = 4+1; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+7;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit13_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%  First Minimum  Mutual Information Equiprobable bins, par2 -> delays
function edit14_Callback(hObject, eventdata, handles)
textind = 4+3; % 4-> check,measurename and code, #parameters
inow = handles.firstfunmea+7;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit14_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes on button press in OK button.
function pushbutton1_Callback(hObject, eventdata, handles)
measureC = handles.measures;
firstfunmea =handles.firstfunmea;
lastfunmea =handles.lastfunmea;
nfunmea = lastfunmea-firstfunmea+1;
countpar = 0;
for i=firstfunmea:firstfunmea+nfunmea-1
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
delete(guinonlinearcorrelationmeasures)

% --- Executes on button press in cancel button.
function pushbutton2_Callback(hObject, eventdata, handles)
delete(guinonlinearcorrelationmeasures)

% --- Executes on button press in Help button.
function pushbutton3_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\NonlinearCorrelationMeasures.htm'')'])
