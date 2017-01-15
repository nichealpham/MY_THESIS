function varargout = guilinearmodelmeasures(varargin)
%========================================================================
%     <guilinearmodelmeasures.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guilinearmodelmeasures_OpeningFcn, ...
                   'gui_OutputFcn',  @guilinearmodelmeasures_OutputFcn, ...
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


% --- Executes just before guilinearmodelmeasures is made visible.
function guilinearmodelmeasures_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
measureC = getappdata(0,'parlist');
handles.measures = measureC;
handles.firstfunmea = 20; % Declares the first index of measures 
handles.lastfunmea = 23; % Declares the last index of measures 
% Fill the measures and parameters in the specified fields of the panel.
firstfunmea = handles.firstfunmea; 
lastfunmea = handles.lastfunmea;
measureC = measureC(firstfunmea:lastfunmea,:);
nfunmea = lastfunmea-firstfunmea+1;
curposV = [1 36];
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
panelnameC ={'Fit error','Prediction error','Fit error','Prediction error'};
countpar = 0;
nerr = 4;
errheight = 1.1;
errwidth = 15;
errxpos = 1;
errypos = 3.6;
panelwidth = 18;
panelheight = 6.1;
panelydisplace = allheight+spaceheight;
yposnow = curposV(2);
for i=1:nfunmea
    yposnow = yposnow-(allheight+8*spaceheight);
    eval([sprintf('set(handles.checkbox%d,''Value'',%s)',(i-1)*(nerr+1)+1,measureC{i,1})])
    eval([sprintf('set(handles.checkbox%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        (i-1)*(nerr+1)+1,curposV(1),yposnow+allheight/4,checkwidth,checkheight)])
    namecode = sprintf('%s (%s)',measureC{i,2},measureC{i,3});
    xposnow = curposV(1)+checkwidth+spacewidth;
    eval([sprintf('set(handles.text%d,''String'',''%s'')',i+countpar,namecode)])
    eval([sprintf('set(handles.text%d,''HorizontalAlignment'',''left'')',i+countpar)])
    eval([sprintf('set(handles.text%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        i+countpar,xposnow,yposnow,namewidth,allheight)])
    % Fill the panel with the stat errors
    xposnow = xposnow+namewidth+spacewidth;
    eval([sprintf('set(handles.uipanel%d,''Title'',''%s'',''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        i,char(panelnameC{i}),xposnow,yposnow-panelydisplace,panelwidth,panelheight)])
    for ierr=1:nerr
        eval([sprintf('set(handles.checkbox%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        (i-1)*(nerr+1)+1+ierr,errxpos,errypos-(ierr-1)*errheight,errwidth,errheight)])
        eval([sprintf('set(handles.checkbox%d,''String'',''%s'',''Value'',%s)',...
        (i-1)*(nerr+1)+1+ierr,measureC{i,4+(ierr-1)*2+1},measureC{i,4+ierr*2})])
        if measureC{i,1}=='0'
            eval([sprintf('set(handles.checkbox%d,''Enable'',''off'')',(i-1)*(nerr+1)+1+ierr)])
        end
    end
    npar = measureC{i,4};
    xposnow = xposnow+panelwidth+spacewidth;
    xposline = xposnow;
    for j=nerr+1:npar
        if j-nerr==4
            yposnow = yposnow-(allheight+spaceheight);
            xposnow = xposline;
        end
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
    i+countpar+1,curposV(1)+0.5*(checkwidth+spacewidth+namewidth),curposV(2)-4*spaceheight,labeltextwidth,labeltextheight)])
maxnpar = max(cell2mat(measureC(:,4)));
maxnpar = min(maxnpar,3);
eval([sprintf('set(handles.text%d,''String'',''Parameters'',''FontSize'',10,''Position'',[%2.2f %2.2f %2.2f %2.2f]);',...
    i+countpar+2,curposV(1)+(checkwidth+spacewidth+namewidth)+0.5*maxnpar*(partextwidth+spacewidth),curposV(2)-4*spaceheight,labeltextwidth,labeltextheight)])
guidata(hObject,handles);

function varargout = guilinearmodelmeasures_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%%%%%%% Linear Autoregressive (AR) Fit : checkbox 1 %%%%%%%%
function checkbox1_Callback(hObject, eventdata, handles)
nerr = 4;
inow = handles.firstfunmea; 
check= inow-handles.firstfunmea+1; % The line of this function
measureC = handles.measures;
measureC{inow,1} = num2str(get(hObject,'Value'));
npar = 0;
if measureC{inow,1}=='1'
    for ierr=1:nerr
        eval([sprintf('set(handles.checkbox%d,''Enable'',''on'')',(check-1)*(nerr+1)+1+ierr)])
    end
    for j=1:measureC{inow,4}-nerr
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for ierr=1:nerr
        eval([sprintf('set(handles.checkbox%d,''Enable'',''Off'')',(check-1)*(nerr+1)+1+ierr)])
    end
    for j=1:measureC{inow,4}-nerr
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);


%%%%%%% Linear Autoregressive (AR) Fit, MAPE checkbox  %%%%%%%%
function checkbox2_Callback(hObject, eventdata, handles)
ierr=1;
inow = handles.firstfunmea; 
measureC = handles.measures;
measureC{inow,4+ierr*2} = num2str(get(hObject,'Value'));

%%%%%%% Linear Autoregressive (AR) Fit, NMSE checkbox  %%%%%%%%
function checkbox3_Callback(hObject, eventdata, handles)
ierr=2;
inow = handles.firstfunmea; 
measureC = handles.measures;
measureC{inow,4+ierr*2} = num2str(get(hObject,'Value'));

%%%%%%% Linear Autoregressive (AR) Fit, NRMSE checkbox  %%%%%%%%
function checkbox4_Callback(hObject, eventdata, handles)
ierr=3;
inow = handles.firstfunmea; 
measureC = handles.measures;
measureC{inow,4+ierr*2} = num2str(get(hObject,'Value'));

%%%%%%% Linear Autoregressive (AR) Fit, CC checkbox  %%%%%%%%
function checkbox5_Callback(hObject, eventdata, handles)
ierr=4;
inow = handles.firstfunmea; 
measureC = handles.measures;
measureC{inow,4+ierr*2} = num2str(get(hObject,'Value'));

% Linear Autoregressive (AR) Fit, model order
function edit1_Callback(hObject, eventdata, handles)
textind = 4+8+1; % 8-> for the 4 errors
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


function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% Linear Autoregressive (AR) Fit, prediction time h
function edit2_Callback(hObject, eventdata, handles)
textind = 4+8+3; % 8-> for the 4 errors
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


function edit2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%%%% Linear Autoregressive (AR) prediction, checkbox
function checkbox6_Callback(hObject, eventdata, handles)
nerr = 4;
inow = handles.firstfunmea+1; 
check=inow-handles.firstfunmea+1; % The line of this function
measureC = handles.measures;
measureC{inow,1} = num2str(get(hObject,'Value'));
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)))-(check-1)*nerr;
if measureC{inow,1}=='1'
    for ierr=1:nerr
        eval([sprintf('set(handles.checkbox%d,''Enable'',''on'')',(check-1)*(nerr+1)+1+ierr)])
    end
    for j=1:measureC{inow,4}-nerr
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for ierr=1:nerr
        eval([sprintf('set(handles.checkbox%d,''Enable'',''Off'')',(check-1)*(nerr+1)+1+ierr)])
    end
    for j=1:measureC{inow,4}-nerr
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);


%%%%%%% Linear Autoregressive (AR) Prediction, MAPE checkbox  %%%%%%%%
function checkbox7_Callback(hObject, eventdata, handles)
ierr=1;
inow = handles.firstfunmea+1; 
measureC = handles.measures;
measureC{inow,4+ierr*2} = num2str(get(hObject,'Value'));

%%%%%%% Linear Autoregressive (AR) Prediction NMSE checkbox  %%%%%%%%
function checkbox8_Callback(hObject, eventdata, handles)
ierr=2;
inow = handles.firstfunmea+1; 
measureC = handles.measures;
measureC{inow,4+ierr*2} = num2str(get(hObject,'Value'));

%%%%%%% Linear Autoregressive (AR) Prediction NRMSE checkbox  %%%%%%%%
function checkbox9_Callback(hObject, eventdata, handles)
ierr=3;
inow = handles.firstfunmea+1; 
measureC = handles.measures;
measureC{inow,4+ierr*2} = num2str(get(hObject,'Value'));

%%%%%%% Linear Autoregressive (AR) Prediction CC checkbox  %%%%%%%%
function checkbox10_Callback(hObject, eventdata, handles)
ierr=4;
inow = handles.firstfunmea+1; 
measureC = handles.measures;
measureC{inow,4+ierr*2} = num2str(get(hObject,'Value'));

% Linear Autoregressive (AR) Prediction, fraction for test set
function edit3_Callback(hObject, eventdata, handles)
textind = 4+8+1; % 8-> for the 4 errors
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
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,textind},'" is allowed'',measureC{inow,2});'])
elseif parV<0.1 | parV>0.9
    eval(['errordlg(''Only values in interval [0.1,0.9] for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end


function edit3_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% Linear Autoregressive (AR) Prediction, model order
function edit4_Callback(hObject, eventdata, handles)
textind = 4+8+3; % 8-> for the 4 errors
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


function edit4_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% Linear Autoregressive (AR) Prediction, prediction time parameter
function edit5_Callback(hObject, eventdata, handles)
textind = 4+8+5; % 8-> for the 4 errors
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


function edit5_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%% Linear Autoregressive Moving average (ARMA) Fit : checkbox 11 %%%%%%%%
function checkbox11_Callback(hObject, eventdata, handles)
nerr = 4;
inow = handles.firstfunmea+2; 
check= inow-handles.firstfunmea+1; % The line of this function
measureC = handles.measures;
measureC{inow,1} = num2str(get(hObject,'Value'));
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)))-(check-1)*nerr;
if measureC{inow,1}=='1'
    for ierr=1:nerr
        eval([sprintf('set(handles.checkbox%d,''Enable'',''on'')',(check-1)*(nerr+1)+1+ierr)])
    end
    for j=1:measureC{inow,4}-nerr
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for ierr=1:nerr
        eval([sprintf('set(handles.checkbox%d,''Enable'',''Off'')',(check-1)*(nerr+1)+1+ierr)])
    end
    for j=1:measureC{inow,4}-nerr
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);

%%%%%%% Linear Autoregressive Moving average (ARMA) Fit, MAPE checkbox  %%%%%%%%
function checkbox12_Callback(hObject, eventdata, handles)
ierr=1;
inow = handles.firstfunmea; 
measureC = handles.measures;
measureC{inow,4+ierr*2} = num2str(get(hObject,'Value'));

%%%%%%% Linear Autoregressive Moving average (ARMA) Fit, NMSE checkbox  %%%%%%%%
function checkbox13_Callback(hObject, eventdata, handles)
ierr=2;
inow = handles.firstfunmea; 
measureC = handles.measures;
measureC{inow,4+ierr*2} = num2str(get(hObject,'Value'));

%%%%%%% Linear Autoregressive Moving average (ARMA) Fit, NRMSE checkbox  %%%%%%%%
function checkbox14_Callback(hObject, eventdata, handles)
ierr=3;
inow = handles.firstfunmea; 
measureC = handles.measures;
measureC{inow,4+ierr*2} = num2str(get(hObject,'Value'));

%%%%%%% Linear Autoregressive Moving average (ARMA) Fit, CC checkbox  %%%%%%%%
function checkbox15_Callback(hObject, eventdata, handles)
ierr=4;
inow = handles.firstfunmea; 
measureC = handles.measures;
measureC{inow,4+ierr*2} = num2str(get(hObject,'Value'));

% Linear Autoregressive Moving average (ARMA) Fit, AR order
function edit6_Callback(hObject, eventdata, handles)
textind = 4+8+1; % 8-> for the 4 errors
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

function edit6_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Linear Autoregressive Moving average (ARMA) Fit, MA order
function edit7_Callback(hObject, eventdata, handles)
textind = 4+8+3; % 8-> for the 4 errors
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

function edit7_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Linear Autoregressive Moving average (ARMA) Fit, prediction time h
function edit8_Callback(hObject, eventdata, handles)
textind = 4+8+5; % 8-> for the 4 errors
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

function edit8_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%%%% Linear Autoregressive Moving average (ARMA) prediction, checkbox 
function checkbox16_Callback(hObject, eventdata, handles)
nerr = 4;
inow = handles.firstfunmea+3; 
check=inow-handles.firstfunmea+1; % The line of this function
measureC = handles.measures;
measureC{inow,1} = num2str(get(hObject,'Value'));
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)))-(check-1)*nerr;
if measureC{inow,1}=='1'
    for ierr=1:nerr
        eval([sprintf('set(handles.checkbox%d,''Enable'',''on'')',(check-1)*(nerr+1)+1+ierr)])
    end
    for j=1:measureC{inow,4}-nerr
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for ierr=1:nerr
        eval([sprintf('set(handles.checkbox%d,''Enable'',''Off'')',(check-1)*(nerr+1)+1+ierr)])
    end
    for j=1:measureC{inow,4}-nerr
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);


%%%%%%% Linear Autoregressive Moving average (ARMA) Prediction, MAPE checkbox  %%%%%%%%
function checkbox17_Callback(hObject, eventdata, handles)
ierr=1;
inow = handles.firstfunmea+1; 
measureC = handles.measures;
measureC{inow,4+ierr*2} = num2str(get(hObject,'Value'));

%%%%%%% Linear Autoregressive Moving average (ARMA) Prediction NMSE checkbox  %%%%%%%%
function checkbox18_Callback(hObject, eventdata, handles)
ierr=2;
inow = handles.firstfunmea+1; 
measureC = handles.measures;
measureC{inow,4+ierr*2} = num2str(get(hObject,'Value'));

%%%%%%% Linear Autoregressive Moving average (ARMA) Prediction NRMSE checkbox  %%%%%%%%
function checkbox19_Callback(hObject, eventdata, handles)
ierr=3;
inow = handles.firstfunmea+1; 
measureC = handles.measures;
measureC{inow,4+ierr*2} = num2str(get(hObject,'Value'));

%%%%%%% Linear Autoregressive Moving average (ARMA) Prediction CC checkbox  %%%%%%%%
function checkbox20_Callback(hObject, eventdata, handles)
ierr=4;
inow = handles.firstfunmea+1; 
measureC = handles.measures;
measureC{inow,4+ierr*2} = num2str(get(hObject,'Value'));

% Linear Autoregressive Moving average (ARMA) Prediction, fraction for test set
function edit9_Callback(hObject, eventdata, handles)
textind = 4+8+1; % 8-> for the 4 errors
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
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,textind},'" is allowed'',measureC{inow,2});'])
elseif parV<0.1 | parV>0.9
    eval(['errordlg(''Only values in interval [0.1,0.9] for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end


function edit9_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% Linear Autoregressive Moving average (ARMA) Prediction, AR order
function edit10_Callback(hObject, eventdata, handles)
textind = 4+8+3; % 8-> for the 4 errors
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


function edit10_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Linear Autoregressive Moving average (ARMA) Prediction, MA order
function edit11_Callback(hObject, eventdata, handles)
textind = 4+8+5; % 8-> for the 4 errors
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


function edit11_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% Linear Autoregressive Moving average (ARMA) Prediction, prediction time parameter
function edit12_Callback(hObject, eventdata, handles)
textind = 4+8+7; % 8-> for the 4 errors
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


function edit12_CreateFcn(hObject, eventdata, handles)
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
nerr = 4;
for i=firstfunmea:firstfunmea+nfunmea-1
    eval([sprintf('tmp=get(handles.checkbox%d,''Value'');',(i-firstfunmea+1-1)*(nerr+1)+1)])
    measureC{i,1}=num2str(tmp);
    npar = measureC{i,4};
    if measureC{i,1}=='1'
        for ierr=1:nerr              
            eval([sprintf('tmp=get(handles.checkbox%d,''Value'');',(i-firstfunmea+1-1)*(nerr+1)+1+ierr)])
            measureC{i,4+ierr*2}=num2str(tmp);
        end
        % If none of the error measures are selected, select them all
        if isempty(find(cell2mat(measureC(i,4+[1:nerr]*2))=='1'))
            for ierr=1:nerr              
                measureC{i,4+ierr*2}='1';
            end
        end    
        for j=1:npar-nerr
            eval([sprintf('measureC{i,4+2*nerr+j*2}=get(handles.edit%d,''String'');',countpar-(i-firstfunmea+1-1)*nerr+j)])
        end
    end
    countpar = countpar + npar;
end
setappdata(0,'parlist',measureC);
delete(guilinearmodelmeasures)


% --- Executes on button press in cancel button.
function pushbutton2_Callback(hObject, eventdata, handles)
delete(guilinearmodelmeasures)

% --- Executes on button press in Help button.
function pushbutton3_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\LinearModelMeasures.htm'')'])


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


