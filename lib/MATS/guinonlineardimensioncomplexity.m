function varargout = guinonlineardimensioncomplexity(varargin)
%========================================================================
%     <guinonlineardimensioncomplexity.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guinonlineardimensioncomplexity_OpeningFcn, ...
                   'gui_OutputFcn',  @guinonlineardimensioncomplexity_OutputFcn, ...
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


% --- Executes just before guinonlineardimensioncomplexity is made visible.
function guinonlineardimensioncomplexity_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
measureC = getappdata(0,'parlist');
handles.measures = measureC;
handles.firstfunmea = 41; % Declares the first index of measures 
handles.lastfunmea = 48; % Declares the last index of measures 
% Fill the measures and parameters in the specified fields of the panel.
firstfunmea = handles.firstfunmea; 
lastfunmea = handles.lastfunmea;
measureC = measureC(firstfunmea:lastfunmea,:);
nfunmea = lastfunmea-firstfunmea+1;
curposV = [2 35];
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
% yposnow = curposV(2);
ypospanel = 17.5;
for i=1:nfunmea
    if mod(i,4)==1
        yposnow = ypospanel;
    else
        yposnow = yposnow-(allheight+4*spaceheight);
    end
    eval([sprintf('set(handles.checkbox%d,''Value'',%s)',i,measureC{i,1})])
    eval([sprintf('set(handles.checkbox%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        i,curposV(1),yposnow+allheight/4,checkwidth,checkheight)])
    namecode = sprintf('%s (%s)',measureC{i,2},measureC{i,3});
    xposnow = curposV(1)+checkwidth+spacewidth;
    eval([sprintf('set(handles.text%d,''String'',''%s'')',i+countpar,namecode)])
    eval([sprintf('set(handles.text%d,''HorizontalAlignment'',''left'')',i+countpar)])
    eval([sprintf('set(handles.text%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        i+countpar,xposnow,yposnow,namewidth,allheight)])
    npar = measureC{i,4};
    xposnow = xposnow+namewidth+spacewidth;
    xposline = xposnow;
    for j=1:npar
        if j==5
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
set(handles.checkbox5,'Visible','Off')
set(handles.text22,'Visible','Off')
set(handles.text23,'Visible','Off')
set(handles.text24,'Visible','Off')
set(handles.text25,'Visible','Off')
set(handles.text26,'Visible','Off')
set(handles.text27,'Visible','Off')
set(handles.edit18,'Visible','Off')
set(handles.edit19,'Visible','Off')
set(handles.edit20,'Visible','Off')
set(handles.edit21,'Visible','Off')
set(handles.edit22,'Visible','Off')
guidata(hObject,handles);


function varargout = guinonlineardimensioncomplexity_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%%%%%%% False Nearest Neighbors : checkbox 1 %%%%%%%%
function checkbox1_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea; 
check= inow-handles.firstfunmea+1; % The line of this function
measureC = handles.measures;
measureC{inow,1} = num2str(get(hObject,'Value'));
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

% False Nearest Neighbors, delay parameter
function edit1_Callback(hObject, eventdata, handles)
textind = 4+1; 
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
set(handles.edit5,'String',editstr);
set(handles.edit11,'String',editstr);
set(handles.edit15,'String',editstr);
set(handles.edit19,'String',editstr);
set(handles.edit24,'String',editstr);

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% False Nearest Neighbors, embedding dimension
function edit2_Callback(hObject, eventdata, handles)
textind = 4+3; 
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
set(handles.edit6,'String',editstr);
set(handles.edit12,'String',editstr);
set(handles.edit16,'String',editstr);
set(handles.edit20,'String',editstr);
set(handles.edit25,'String',editstr);


function edit2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% False Nearest Neighbors, Theiler window
function edit3_Callback(hObject, eventdata, handles)
textind = 4+5; 
inow = handles.firstfunmea;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,textind},'" is allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end
set(handles.edit7,'String',editstr);
set(handles.edit13,'String',editstr);
set(handles.edit17,'String',editstr);
set(handles.edit20,'String',editstr);
set(handles.edit26,'String',editstr);


function edit3_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% False Nearest Neighbors, escape factor
function edit4_Callback(hObject, eventdata, handles)
textind = 4+7; 
inow = handles.firstfunmea;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,textind},'" is allowed'',measureC{inow,2});'])
elseif parV<=2
    eval(['errordlg(''Only numbers larger than 2 for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end


function edit4_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



%%%%%%% Correlation Dimension : checkbox 2 %%%%%%%%
function checkbox2_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea+1; 
check= inow-handles.firstfunmea+1; % The line of this function
measureC = handles.measures;
measureC{inow,1} = num2str(get(hObject,'Value'));
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

% Correlation Dimension, delay parameter
function edit5_Callback(hObject, eventdata, handles)
textind = 4+1; 
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
set(handles.edit11,'String',editstr);
set(handles.edit15,'String',editstr);
set(handles.edit19,'String',editstr);
set(handles.edit24,'String',editstr);

function edit5_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% Correlation Dimension, embedding dimension
function edit6_Callback(hObject, eventdata, handles)
textind = 4+3; 
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
set(handles.edit12,'String',editstr);
set(handles.edit16,'String',editstr);
set(handles.edit20,'String',editstr);
set(handles.edit25,'String',editstr);


function edit6_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Correlation Dimension, Theiler window
function edit7_Callback(hObject, eventdata, handles)
textind = 4+5; 
inow = handles.firstfunmea+1;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1)
    eval(['errordlg(''Only positive values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,textind},'" is allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end
set(handles.edit13,'String',editstr);
set(handles.edit17,'String',editstr);
set(handles.edit20,'String',editstr);
set(handles.edit26,'String',editstr);


function edit7_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Correlation Dimension, upper/lower ratio of scaling window
function edit8_Callback(hObject, eventdata, handles)
textind = 4+7; 
inow = handles.firstfunmea+1;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif parV<2 | round(parV)~=parV
    eval(['errordlg(''Only integer numbers larger than or equal to 2 for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end


function edit8_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Correlation Dimension, number of radii, resolution (o)
function edit9_Callback(hObject, eventdata, handles)
textind = 4+9; 
inow = handles.firstfunmea+1;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,textind},'" is allowed'',measureC{inow,2});'])
elseif parV<10 | round(parV)~=parV
    eval(['errordlg(''Only integer numbers larger than or equal to 10 for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end


function edit9_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%% Correlation Sum for given radius : checkbox 3 %%%%%%%%
function checkbox3_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea+2; 
check= inow-handles.firstfunmea+1; % The line of this function
measureC = handles.measures;
measureC{inow,1} = num2str(get(hObject,'Value'));
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

% Correlation Sum for given radius, radius 
function edit10_Callback(hObject, eventdata, handles)
textind = 4+1; 
inow = handles.firstfunmea+2;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif min(parV)<=0 | max(parV)>1
    eval(['errordlg(''Only values between 0.0 and 1.0 for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end
set(handles.edit14,'String',editstr);
set(handles.edit18,'String',editstr);
set(handles.edit23,'String',editstr);

function edit10_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Correlation Sum for given radius, delay parameter
function edit11_Callback(hObject, eventdata, handles)
textind = 4+3; 
inow = handles.firstfunmea+2;
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
set(handles.edit15,'String',editstr);
set(handles.edit19,'String',editstr);
set(handles.edit24,'String',editstr);

function edit11_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% Correlation Sum for given radius, embedding dimension
function edit12_Callback(hObject, eventdata, handles)
textind = 4+5; 
inow = handles.firstfunmea+2;
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
set(handles.edit16,'String',editstr);
set(handles.edit20,'String',editstr);
set(handles.edit25,'String',editstr);

function edit12_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Correlation Sum for given radius, Theiler window
function edit13_Callback(hObject, eventdata, handles)
textind = 4+7; 
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
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,textind},'" is allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end
set(handles.edit17,'String',editstr);
set(handles.edit21,'String',editstr);
set(handles.edit26,'String',editstr);

function edit13_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%%%%%%% Radius for given Correlation Sum : checkbox 4 %%%%%%%%
function checkbox4_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea+3; 
check= inow-handles.firstfunmea+1; % The line of this function
measureC = handles.measures;
measureC{inow,1} = num2str(get(hObject,'Value'));
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

% Radius for given Correlation Sum, Correlation Sum 
function edit14_Callback(hObject, eventdata, handles)
textind = 4+1; 
inow = handles.firstfunmea+3;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif min(parV)<=0 | max(parV)>1
    eval(['errordlg(''Only values between 0.0 and 1.0 for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit14_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Radius for given Correlation Sum, delay parameter
function edit15_Callback(hObject, eventdata, handles)
textind = 4+3; 
inow = handles.firstfunmea+3;
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
set(handles.edit19,'String',editstr);
set(handles.edit24,'String',editstr);

function edit15_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% Radius for given Correlation Sum, embedding dimension
function edit16_Callback(hObject, eventdata, handles)
textind = 4+5; 
inow = handles.firstfunmea+3;
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
set(handles.edit20,'String',editstr);
set(handles.edit25,'String',editstr);

function edit16_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Radius for given Correlation Sum, Theiler window
function edit17_Callback(hObject, eventdata, handles)
textind = 4+7; 
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
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,textind},'" is allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end
set(handles.edit21,'String',editstr);
set(handles.edit26,'String',editstr);

function edit17_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%% Kolmogorov-Sinai Entropy : checkbox 5 %%%%%%%%
function checkbox5_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea+4; 
check= inow-handles.firstfunmea+1; % The line of this function
measureC = handles.measures;
measureC{inow,1} = num2str(get(hObject,'Value'));
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

% Kolmogorov-Sinai Entropy, delay parameter
function edit18_Callback(hObject, eventdata, handles)
textind = 4+1; 
inow = handles.firstfunmea+4;
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
set(handles.edit23,'String',editstr);

function edit18_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% Kolmogorov-Sinai Entropy, embedding dimension
function edit19_Callback(hObject, eventdata, handles)
textind = 4+3; 
inow = handles.firstfunmea+4;
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


function edit19_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Kolmogorov-Sinai Entropy, Theiler window
function edit20_Callback(hObject, eventdata, handles)
textind = 4+5; 
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
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,textind},'" is allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end


function edit20_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Kolmogorov-Sinai Entropy, upper/lower ratio of scaling window
function edit21_Callback(hObject, eventdata, handles)
textind = 4+7; 
inow = handles.firstfunmea+4;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif parV<2 | round(parV)~=parV
    eval(['errordlg(''Only integer numbers larger than or equal to 2 for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end


function edit21_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Kolmogorov-Sinai Entropy, number of radii, resolution (o)
function edit22_Callback(hObject, eventdata, handles)
textind = 4+9; 
inow = handles.firstfunmea+4;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,textind},'" is allowed'',measureC{inow,2});'])
elseif parV<10 | round(parV)~=parV
    eval(['errordlg(''Only integer numbers larger than or equal to 10 for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end


function edit22_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%% Aprroximate Entropy : checkbox 6 %%%%%%%%
function checkbox6_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea+5; 
check= inow-handles.firstfunmea+1; % The line of this function
measureC = handles.measures;
measureC{inow,1} = num2str(get(hObject,'Value'));
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

% Aprroximate Entropy, radius 
function edit23_Callback(hObject, eventdata, handles)
textind = 4+1; 
inow = handles.firstfunmea+5;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif min(parV)<=0 | max(parV)>1
    eval(['errordlg(''Only values between 0.0 and 1.0 for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit23_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Aprroximate Entropy, delay parameter
function edit24_Callback(hObject, eventdata, handles)
textind = 4+3; 
inow = handles.firstfunmea+5;
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

function edit24_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% Aprroximate Entropy, embedding dimension
function edit25_Callback(hObject, eventdata, handles)
textind = 4+5; 
inow = handles.firstfunmea+5;
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

function edit25_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Aprroximate Entropy, Theiler window
function edit26_Callback(hObject, eventdata, handles)
textind = 4+7; 
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
elseif length(parV)>1
    eval(['errordlg(''Only one value for parameter "',measureC{inow,textind},'" is allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit26_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%% Algorithmic Complexity, equidistant bins : checkbox 7 %%%%%%%%
function checkbox7_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea+6; 
check= inow-handles.firstfunmea+1; % The line of this function
measureC = handles.measures;
measureC{inow,1} = num2str(get(hObject,'Value'));
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

% Algorithmic Complexity, number of bins 
function edit27_Callback(hObject, eventdata, handles)
textind = 4+1; 
inow = handles.firstfunmea+6;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1)
    eval(['errordlg(''Only non-negative values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end
set(handles.edit28,'String',editstr);

function edit27_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%% Algorithmic Complexity, equipropable bins : checkbox 8 %%%%%%%%
function checkbox8_Callback(hObject, eventdata, handles)
inow = handles.firstfunmea+7; 
check= inow-handles.firstfunmea+1; % The line of this function
measureC = handles.measures;
measureC{inow,1} = num2str(get(hObject,'Value'));
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

% Algorithmic Complexity, equipropable bins, number of bins 
function edit28_Callback(hObject, eventdata, handles)
textind = 4+1; 
inow = handles.firstfunmea+7;
editstr = get(hObject,'String');
parV = parstr2num(editstr);
measureC = handles.measures;
if isempty(parV)
    eval(['errordlg(''No data for parameter "',measureC{inow,textind},'" are given'',measureC{inow,2});'])
elseif isnan(parV)
    eval(['errordlg(''The format of values for parameter "',measureC{inow,textind},'" is not valid'',measureC{inow,2});'])
elseif any(sign(parV)==-1)
    eval(['errordlg(''Only non-negative values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end

function edit28_CreateFcn(hObject, eventdata, handles)
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
delete(guinonlineardimensioncomplexity)

% --- Executes on button press in cancel button.
function pushbutton2_Callback(hObject, eventdata, handles)
delete(guinonlineardimensioncomplexity)

% --- Executes on button press in Help button.
function pushbutton3_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\NonlinearDimensionComplexityMeasures.htm'')'])


