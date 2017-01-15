function varargout = guilinearcorrelationmeasures(varargin)
%========================================================================
%     <guilinearcorrelationmeasures.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guilinearcorrelationmeasures_OpeningFcn, ...
                   'gui_OutputFcn',  @guilinearcorrelationmeasures_OutputFcn, ...
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


% --- Executes just before guilinearcorrelationmeasures is made visible.
function guilinearcorrelationmeasures_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
measureC = getappdata(0,'parlist');
handles.measures = measureC;
handles.firstfunmea = 1; % Declares the first index of measures 
handles.lastfunmea = 13; % Declares the last index of measures 
fillmeasureparameters(handles);
% Update handles structure
guidata(hObject,handles);

% --- An internal function that fills in the measures and parameters in the
% specified fields of the panel.
function fillmeasureparameters(handles)
% fillmeasureparameters(measureC,handles)
% No output, just fills the fields with the appropriate names and values
% for the measures and their parameters.
measureC = handles.measures;
firstfunmea = handles.firstfunmea; 
lastfunmea = handles.lastfunmea;
measureC = measureC(firstfunmea:lastfunmea,:);
nfunmea = lastfunmea-firstfunmea+1;
curposV = [1 40.5];
checkwidth = 2.5;
checkheight = 1;
spaceheight = 0.5;
spacewidth = 1;
allheight = 2.5;
namewidth = 40; 
partextwidth = 20;
parvaluewidth = 10;
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
 
function varargout = guilinearcorrelationmeasures_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%%%%%%% Pearson: checkboxes 1,2,3,4 %%%%%%%%
% --- Executes on button press in Pearson autocorrelation.
function checkbox1_Callback(hObject, eventdata, handles)
inow = 1;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow)])
npar = 0;
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
    
% Pearson autocorrelation parameters
function edit1_Callback(hObject, eventdata, handles)
inow = 1;
eval(sprintf('edit%dstr = get(handles.edit%d,''String'');',inow,inow))
eval(sprintf('parV = parstr2num(edit%dstr);',inow));
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,5},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,5},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1) | any(sign(parV)==0)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
end
eval(sprintf('set(handles.edit%d,''String'',edit%dstr);',inow+1,inow));
eval(sprintf('set(handles.edit%d,''String'',edit%dstr);',inow+2,inow));
eval(sprintf('set(handles.edit%d,''String'',edit%dstr);',inow+3,inow));

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Pearson cumulative autocorrelation.
function checkbox2_Callback(hObject, eventdata, handles)
inow = 2;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow)])
npar = sum(cell2mat(measureC(1:inow-1,4)));
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

% Pearson cumulative autocorrelation parameters
function edit2_Callback(hObject, eventdata, handles)
inow = 2;
eval(sprintf('edit%dstr = get(handles.edit%d,''String'');',inow,inow))
eval(sprintf('parV = parstr2num(edit%dstr);',inow));
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,5},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,5},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1) | any(sign(parV)==0)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
end

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Pearson decorrelation time.
function checkbox3_Callback(hObject, eventdata, handles)
inow = 3;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow)])
npar = sum(cell2mat(measureC(1:inow-1,4)));
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

% Parameters of Pearson decorrelation time.
function edit3_Callback(hObject, eventdata, handles)
inow = 3;
eval(sprintf('edit%dstr = get(handles.edit%d,''String'');',inow,inow))
eval(sprintf('parV = parstr2num(edit%dstr);',inow));
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,5},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,5},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1) | any(sign(parV)==0)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
end

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Pearson zero autocorrelation lag.
function checkbox4_Callback(hObject, eventdata, handles)
inow = 4;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow)])
npar = sum(cell2mat(measureC(1:inow-1,4)));
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

% Parameters of Pearson zero autocorrelation lag
function edit4_Callback(hObject, eventdata, handles)
edit4str = get(handles.edit4,'String');
parV = parstr2num(edit4str);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{4,5},'" are given'',measureC{4,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{4,5},'" is not valid'',measureC{4,2});'])
elseif any(sign(parV)==-1) | any(sign(parV)==0)
    eval(['errordlg(''Only positive values for parameter "',measureC{4,5},'" are allowed'',measureC{4,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
end

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%%%%%%% Kendall: checkboxes 5,6,7,8 %%%%%%%%
% --- Executes on button press in Kendall autocorrelation.
function checkbox5_Callback(hObject, eventdata, handles)
inow = 5;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow)])
npar = sum(cell2mat(measureC(1:inow-1,4)));
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
    
% Kendall autocorrelation parameters
function edit5_Callback(hObject, eventdata, handles)
inow = 5;
eval(sprintf('edit%dstr = get(handles.edit%d,''String'');',inow,inow))
eval(sprintf('parV = parstr2num(edit%dstr);',inow));
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,5},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,5},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1) | any(sign(parV)==0)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
end
eval(sprintf('set(handles.edit%d,''String'',edit%dstr);',inow+1,inow));
eval(sprintf('set(handles.edit%d,''String'',edit%dstr);',inow+2,inow));
eval(sprintf('set(handles.edit%d,''String'',edit%dstr);',inow+3,inow));

function edit5_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Kendall cumulative autocorrelation.
function checkbox6_Callback(hObject, eventdata, handles)
inow = 6;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow)])
npar = sum(cell2mat(measureC(1:inow-1,4)));
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

% Kendall cumulative autocorrelation parameters
function edit6_Callback(hObject, eventdata, handles)
inow = 6;
eval(sprintf('edit%dstr = get(handles.edit%d,''String'');',inow,inow))
eval(sprintf('parV = parstr2num(edit%dstr);',inow));
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,5},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,5},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1) | any(sign(parV)==0)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
end

function edit6_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Kendall decorrelation time.
function checkbox7_Callback(hObject, eventdata, handles)
inow = 7;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow)])
npar = sum(cell2mat(measureC(1:inow-1,4)));
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

% Parameters of Kendall decorrelation time.
function edit7_Callback(hObject, eventdata, handles)
inow = 7;
eval(sprintf('edit%dstr = get(handles.edit%d,''String'');',inow,inow))
eval(sprintf('parV = parstr2num(edit%dstr);',inow));
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,5},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,5},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1) | any(sign(parV)==0)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
end

function edit7_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in Kendall zero autocorrelation lag.
function checkbox8_Callback(hObject, eventdata, handles)
inow = 8;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow)])
npar = sum(cell2mat(measureC(1:inow-1,4)));
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

% Parameters of Kendall zero autocorrelation lag
function edit8_Callback(hObject, eventdata, handles)
inow = 8;
eval(sprintf('edit%dstr = get(handles.edit%d,''String'');',inow,inow))
eval(sprintf('parV = parstr2num(edit%dstr);',inow));
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,5},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,5},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1) | any(sign(parV)==0)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
end

function edit8_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%% Spearman: checkboxes 9,10,11,12 %%%%%%%%
% --- Executes on button press in Spearman autocorrelation.
function checkbox9_Callback(hObject, eventdata, handles)
inow = 9;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow)])
npar = sum(cell2mat(measureC(1:inow-1,4)));
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
    
% Spearman autocorrelation parameters
function edit9_Callback(hObject, eventdata, handles)
inow = 9;
eval(sprintf('edit%dstr = get(handles.edit%d,''String'');',inow,inow))
eval(sprintf('parV = parstr2num(edit%dstr);',inow));
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,5},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,5},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1) | any(sign(parV)==0)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
end
eval(sprintf('set(handles.edit%d,''String'',edit%dstr);',inow+1,inow));
eval(sprintf('set(handles.edit%d,''String'',edit%dstr);',inow+2,inow));
eval(sprintf('set(handles.edit%d,''String'',edit%dstr);',inow+3,inow));

function edit9_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Spearman cumulative autocorrelation.
function checkbox10_Callback(hObject, eventdata, handles)
inow = 10;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow)])
npar = sum(cell2mat(measureC(1:inow-1,4)));
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

% Spearman cumulative autocorrelation parameters
function edit10_Callback(hObject, eventdata, handles)
inow = 10;
eval(sprintf('edit%dstr = get(handles.edit%d,''String'');',inow,inow))
eval(sprintf('parV = parstr2num(edit%dstr);',inow));
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,5},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,5},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1) | any(sign(parV)==0)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
end

function edit10_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Spearman decorrelation time.
function checkbox11_Callback(hObject, eventdata, handles)
inow = 11;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow)])
npar = sum(cell2mat(measureC(1:inow-1,4)));
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

% Parameters of Spearman decorrelation time.
function edit11_Callback(hObject, eventdata, handles)
inow = 11;
eval(sprintf('edit%dstr = get(handles.edit%d,''String'');',inow,inow))
eval(sprintf('parV = parstr2num(edit%dstr);',inow));
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,5},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,5},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1) | any(sign(parV)==0)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
end

function edit11_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Spearman zero autocorrelation lag.
function checkbox12_Callback(hObject, eventdata, handles)
inow = 12;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow)])
npar = sum(cell2mat(measureC(1:inow-1,4)));
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

% Parameters of Spearman zero autocorrelation lag
function edit12_Callback(hObject, eventdata, handles)
inow = 12;
eval(sprintf('edit%dstr = get(handles.edit%d,''String'');',inow,inow))
eval(sprintf('parV = parstr2num(edit%dstr);',inow));
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,5},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,5},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1) | any(sign(parV)==0)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
end

function edit12_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Partial autocorrelation checkbox
function checkbox13_Callback(hObject, eventdata, handles)
inow = 13;
measureC = handles.measures;
eval([sprintf('measureC{inow,1} = num2str(get(handles.checkbox%d,''Value''));',inow)])
npar = sum(cell2mat(measureC(1:inow-1,4)));
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

% Partial autocorrelation parameters
function edit13_Callback(hObject, eventdata, handles)
inow = 13;
eval(sprintf('edit%dstr = get(handles.edit%d,''String'');',inow,inow))
eval(sprintf('parV = parstr2num(edit%dstr);',inow));
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,5},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,5},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1) | any(sign(parV)==0)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,5},'" are allowed'',measureC{inow,2});'])
end

function edit13_CreateFcn(hObject, eventdata, handles)
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
    eval([sprintf('tmpS=get(handles.checkbox%d,''Value'');',i-firstfunmea+1)])
    measureC{i,1}=num2str(tmpS);
    npar = measureC{i,4};
    if measureC{i,1}=='1'
        for j=1:npar
            eval([sprintf('measureC{i,4+j*2}=get(handles.edit%d,''String'');',countpar+j)])
        end
    end
    countpar = countpar + npar;
end
setappdata(0,'parlist',measureC);
delete(guilinearcorrelationmeasures)

% --- Executes on button press in cancel button.
function pushbutton2_Callback(hObject, eventdata, handles)
delete(guilinearcorrelationmeasures)

% --- Executes on button press in Help button.
function pushbutton3_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\LinearCorrelationMeasures.htm'')'])

