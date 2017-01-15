function varargout = guifeaturestatistics(varargin)
%========================================================================
%     <guifeaturestatistics.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guifeaturestatistics_OpeningFcn, ...
                   'gui_OutputFcn',  @guifeaturestatistics_OutputFcn, ...
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


% --- Executes just before guifeaturestatistics is made visible.
function guifeaturestatistics_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
measureC = getappdata(0,'parlist');
handles.measures = measureC;
handles.firstfunmea = 36; % Declares the first index of measures 
handles.lastfunmea = 40; % Declares the last index of measures 
% Fill the measures and parameters in the specified fields of the panel.
firstfunmea = handles.firstfunmea; 
lastfunmea = handles.lastfunmea;
measureC = measureC(firstfunmea:lastfunmea,:);
nfunmea = lastfunmea-firstfunmea+1;
curposV = [1 40];
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
panelname ='Statistics';
countpar = 0;
nstat = 4;
statheight = 1.1;
statwidth = 23;
statxpos = 1;
statypos = 3.6;
panelwidth = 26;
panelheight = 6.1;
panelydisplace = allheight+spaceheight;
yposnow = curposV(2);
for i=1:nfunmea
    yposnow = yposnow-(allheight+8*spaceheight);
    eval([sprintf('set(handles.checkbox%d,''Value'',%s)',(i-1)*(nstat+1)+1,measureC{i,1})])
    eval([sprintf('set(handles.checkbox%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        (i-1)*(nstat+1)+1,curposV(1),yposnow+allheight/4,checkwidth,checkheight)])
    namecode = sprintf('%s (%s)',measureC{i,2},measureC{i,3});
    xposnow = curposV(1)+checkwidth+spacewidth;
    eval([sprintf('set(handles.text%d,''String'',''%s'')',i+countpar,namecode)])
    eval([sprintf('set(handles.text%d,''HorizontalAlignment'',''left'')',i+countpar)])
    eval([sprintf('set(handles.text%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        i+countpar,xposnow,yposnow,namewidth,allheight)])
    npar = measureC{i,4}-4;
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
    % Fill the panel with the statistics
    % xposnow = xposnow+partextwidth+spacewidth;
    eval([sprintf('set(handles.uipanel%d,''Title'',''%s'',''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        i,panelname,xposnow,yposnow-panelydisplace,panelwidth,panelheight)])
    for istat=1:nstat
        eval([sprintf('set(handles.checkbox%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        (i-1)*(nstat+1)+1+istat,statxpos,statypos-(istat-1)*statheight,statwidth,statheight)])
        eval([sprintf('set(handles.checkbox%d,''String'',''%s'',''Value'',%s)',...
        (i-1)*(nstat+1)+1+istat,measureC{i,4+2*npar+(istat-1)*2+1},measureC{i,4+2*npar+istat*2})])
        if measureC{i,1}=='0'
            eval([sprintf('set(handles.checkbox%d,''Enable'',''off'')',(i-1)*(nstat+1)+1+istat)])
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


function varargout = guifeaturestatistics_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%%%%%%% Local Maxima : checkbox 1 %%%%%%%%
function checkbox1_Callback(hObject, eventdata, handles)
nstat = 4;
inow = handles.firstfunmea; 
check= inow-handles.firstfunmea+1; % The line of this function
measureC = handles.measures;
measureC{inow,1} = num2str(get(hObject,'Value'));
npar = 0;
if measureC{inow,1}=='1'
    for istat=1:nstat
        eval([sprintf('set(handles.checkbox%d,''Enable'',''on'')',(check-1)*(nstat+1)+1+istat)])
    end
    for j=1:measureC{inow,4}-nstat
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for istat=1:nstat
        eval([sprintf('set(handles.checkbox%d,''Enable'',''Off'')',(check-1)*(nstat+1)+1+istat)])
    end
    for j=1:measureC{inow,4}-nstat
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);

% Local Maxima, filter order
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
elseif any(sign(parV)==-1)
    eval(['errordlg(''Only non-negative values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
elseif round(parV)~=parV
    eval(['errordlg(''Only integer values for parameter "',measureC{inow,textind},'" are allowed'',measureC{inow,2});'])
end
eval(sprintf('set(handles.edit%d,''String'',editstr);',inow-handles.firstfunmea+3));
eval(sprintf('set(handles.edit%d,''String'',editstr);',inow-handles.firstfunmea+5));
eval(sprintf('set(handles.edit%d,''String'',editstr);',inow-handles.firstfunmea+7));
eval(sprintf('set(handles.edit%d,''String'',editstr);',inow-handles.firstfunmea+9));

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% Local Maxima, offset for window length
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
eval(sprintf('set(handles.edit%d,''String'',editstr);',inow-handles.firstfunmea+4));
eval(sprintf('set(handles.edit%d,''String'',editstr);',inow-handles.firstfunmea+6));
eval(sprintf('set(handles.edit%d,''String'',editstr);',inow-handles.firstfunmea+8));
eval(sprintf('set(handles.edit%d,''String'',editstr);',inow-handles.firstfunmea+10));


function edit2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%%%%%%% Local Maxima, mean checkbox  %%%%%%%%
function checkbox2_Callback(hObject, eventdata, handles)
istat=1;
inow = handles.firstfunmea; 
measureC = handles.measures;
checkvalue = get(hObject,'Value');
measureC{inow,8+istat*2} = num2str(checkvalue);
nstat = 4;
eval(sprintf('set(handles.checkbox%d,''Value'',checkvalue);',(inow-handles.firstfunmea+1)*(nstat+1)+2));
eval(sprintf('set(handles.checkbox%d,''Value'',checkvalue);',(inow-handles.firstfunmea+2)*(nstat+1)+2));
eval(sprintf('set(handles.checkbox%d,''Value'',checkvalue);',(inow-handles.firstfunmea+3)*(nstat+1)+2));
eval(sprintf('set(handles.checkbox%d,''Value'',checkvalue);',(inow-handles.firstfunmea+4)*(nstat+1)+2));

%%%%%%% Local Maxima, median checkbox  %%%%%%%%
function checkbox3_Callback(hObject, eventdata, handles)
istat=2;
inow = handles.firstfunmea; 
measureC = handles.measures;
checkvalue = get(hObject,'Value');
measureC{inow,8+istat*2} = num2str(checkvalue);
nstat = 4;
eval(sprintf('set(handles.checkbox%d,''Value'',checkvalue);',(inow-handles.firstfunmea+1)*(nstat+1)+3));
eval(sprintf('set(handles.checkbox%d,''Value'',checkvalue);',(inow-handles.firstfunmea+2)*(nstat+1)+3));
eval(sprintf('set(handles.checkbox%d,''Value'',checkvalue);',(inow-handles.firstfunmea+3)*(nstat+1)+3));
eval(sprintf('set(handles.checkbox%d,''Value'',checkvalue);',(inow-handles.firstfunmea+4)*(nstat+1)+3));

%%%%%%% Local Maxima, standard deviation checkbox  %%%%%%%%
function checkbox4_Callback(hObject, eventdata, handles)
istat=3;
inow = handles.firstfunmea; 
measureC = handles.measures;
checkvalue = get(hObject,'Value');
measureC{inow,8+istat*2} = num2str(checkvalue);
nstat = 4;
eval(sprintf('set(handles.checkbox%d,''Value'',checkvalue);',(inow-handles.firstfunmea+1)*(nstat+1)+4));
eval(sprintf('set(handles.checkbox%d,''Value'',checkvalue);',(inow-handles.firstfunmea+2)*(nstat+1)+4));
eval(sprintf('set(handles.checkbox%d,''Value'',checkvalue);',(inow-handles.firstfunmea+3)*(nstat+1)+4));
eval(sprintf('set(handles.checkbox%d,''Value'',checkvalue);',(inow-handles.firstfunmea+4)*(nstat+1)+4));

%%%%%%% Local Maxima, interquartile checkbox  %%%%%%%%
function checkbox5_Callback(hObject, eventdata, handles)
istat=4;
inow = handles.firstfunmea; 
measureC = handles.measures;
checkvalue = get(hObject,'Value');
measureC{inow,8+istat*2} = num2str(checkvalue);
nstat = 4;
eval(sprintf('set(handles.checkbox%d,''Value'',checkvalue);',(inow-handles.firstfunmea+1)*(nstat+1)+5));
eval(sprintf('set(handles.checkbox%d,''Value'',checkvalue);',(inow-handles.firstfunmea+2)*(nstat+1)+5));
eval(sprintf('set(handles.checkbox%d,''Value'',checkvalue);',(inow-handles.firstfunmea+3)*(nstat+1)+5));
eval(sprintf('set(handles.checkbox%d,''Value'',checkvalue);',(inow-handles.firstfunmea+4)*(nstat+1)+5));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Local Minima : checkbox 6 %%%%%%%%
function checkbox6_Callback(hObject, eventdata, handles)
nstat = 4;
inow = handles.firstfunmea+1; 
check=inow-handles.firstfunmea+1; % The line of this function
measureC = handles.measures;
measureC{inow,1} = num2str(get(hObject,'Value'));
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)))-(check-1)*nstat;
if measureC{inow,1}=='1'
    for istat=1:nstat
        eval([sprintf('set(handles.checkbox%d,''Enable'',''on'')',(check-1)*(nstat+1)+1+istat)])
    end
    for j=1:measureC{inow,4}-nstat
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for istat=1:nstat
        eval([sprintf('set(handles.checkbox%d,''Enable'',''Off'')',(check-1)*(nstat+1)+1+istat)])
    end
    for j=1:measureC{inow,4}-nstat
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);


% Local Minima, filter order
function edit3_Callback(hObject, eventdata, handles)
textind = 4+1; 
inow = handles.firstfunmea+1;
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

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Local Minima, offset for window length
function edit4_Callback(hObject, eventdata, handles)
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

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%%%%%%% Local Minima, mean checkbox  %%%%%%%%
function checkbox7_Callback(hObject, eventdata, handles)
istat=1;
inow = handles.firstfunmea+1; 
measureC = handles.measures;
measureC{inow,8+istat*2} = num2str(get(hObject,'Value'));

%%%%%%% Local Minima, median checkbox  %%%%%%%%
function checkbox8_Callback(hObject, eventdata, handles)
istat=2;
inow = handles.firstfunmea+1; 
measureC = handles.measures;
measureC{inow,8+istat*2} = num2str(get(hObject,'Value'));

%%%%%%% Local Minima, standard deviation checkbox  %%%%%%%%
function checkbox9_Callback(hObject, eventdata, handles)
istat=3;
inow = handles.firstfunmea+1; 
measureC = handles.measures;
measureC{inow,8+istat*2} = num2str(get(hObject,'Value'));

%%%%%%% Local Minima, interquartile checkbox  %%%%%%%%
function checkbox10_Callback(hObject, eventdata, handles)
istat=4;
inow = handles.firstfunmea+1; 
measureC = handles.measures;
measureC{inow,8+istat*2} = num2str(get(hObject,'Value'));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Time Min to Max : checkbox 11 %%%%%%%%
function checkbox11_Callback(hObject, eventdata, handles)
nstat = 4;
inow = handles.firstfunmea+2; 
check=inow-handles.firstfunmea+1; % The line of this function
measureC = handles.measures;
measureC{inow,1} = num2str(get(hObject,'Value'));
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)))-(check-1)*nstat;
if measureC{inow,1}=='1'
    for istat=1:nstat
        eval([sprintf('set(handles.checkbox%d,''Enable'',''on'')',(check-1)*(nstat+1)+1+istat)])
    end
    for j=1:measureC{inow,4}-nstat
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for istat=1:nstat
        eval([sprintf('set(handles.checkbox%d,''Enable'',''Off'')',(check-1)*(nstat+1)+1+istat)])
    end
    for j=1:measureC{inow,4}-nstat
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);


% Time Min to Max, filter order
function edit5_Callback(hObject, eventdata, handles)
textind = 4+1; 
inow = handles.firstfunmea+2;
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

function edit5_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Time Min to Max, offset for window length
function edit6_Callback(hObject, eventdata, handles)
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

function edit6_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%%%%%%% Time Min to Max, mean checkbox  %%%%%%%%
function checkbox12_Callback(hObject, eventdata, handles)
istat=1;
inow = handles.firstfunmea+2; 
measureC = handles.measures;
measureC{inow,8+istat*2} = num2str(get(hObject,'Value'));

%%%%%%% Time Min to Max, median checkbox  %%%%%%%%
function checkbox13_Callback(hObject, eventdata, handles)
istat=2;
inow = handles.firstfunmea+2; 
measureC = handles.measures;
measureC{inow,8+istat*2} = num2str(get(hObject,'Value'));

%%%%%%% Time Min to Max, standard deviation checkbox  %%%%%%%%
function checkbox14_Callback(hObject, eventdata, handles)
istat=3;
inow = handles.firstfunmea+2; 
measureC = handles.measures;
measureC{inow,8+istat*2} = num2str(get(hObject,'Value'));

%%%%%%% Time Min to Max, interquartile checkbox  %%%%%%%%
function checkbox15_Callback(hObject, eventdata, handles)
istat=4;
inow = handles.firstfunmea+2; 
measureC = handles.measures;
measureC{inow,8+istat*2} = num2str(get(hObject,'Value'));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Time Max to Max : checkbox 16 %%%%%%%%
function checkbox16_Callback(hObject, eventdata, handles)
nstat = 4;
inow = handles.firstfunmea+3; 
check=inow-handles.firstfunmea+1; % The line of this function
measureC = handles.measures;
measureC{inow,1} = num2str(get(hObject,'Value'));
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)))-(check-1)*nstat;
if measureC{inow,1}=='1'
    for istat=1:nstat
        eval([sprintf('set(handles.checkbox%d,''Enable'',''on'')',(check-1)*(nstat+1)+1+istat)])
    end
    for j=1:measureC{inow,4}-nstat
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for istat=1:nstat
        eval([sprintf('set(handles.checkbox%d,''Enable'',''Off'')',(check-1)*(nstat+1)+1+istat)])
    end
    for j=1:measureC{inow,4}-nstat
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);


% Time Max to Max, filter order
function edit7_Callback(hObject, eventdata, handles)
textind = 4+1; 
inow = handles.firstfunmea+3;
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

function edit7_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Time Max to Max, offset for window length
function edit8_Callback(hObject, eventdata, handles)
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

function edit8_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%%%%%%% Time Max to Max, mean checkbox  %%%%%%%%
function checkbox17_Callback(hObject, eventdata, handles)
istat=1;
inow = handles.firstfunmea+3; 
measureC = handles.measures;
measureC{inow,8+istat*2} = num2str(get(hObject,'Value'));

%%%%%%% Time Max to Max, median checkbox  %%%%%%%%
function checkbox18_Callback(hObject, eventdata, handles)
istat=2;
inow = handles.firstfunmea+3; 
measureC = handles.measures;
measureC{inow,8+istat*2} = num2str(get(hObject,'Value'));

%%%%%%% Time Max to Max, standard deviation checkbox  %%%%%%%%
function checkbox19_Callback(hObject, eventdata, handles)
istat=3;
inow = handles.firstfunmea+3; 
measureC = handles.measures;
measureC{inow,8+istat*2} = num2str(get(hObject,'Value'));

%%%%%%% Time Max to Max, interquartile checkbox  %%%%%%%%
function checkbox20_Callback(hObject, eventdata, handles)
istat=4;
inow = handles.firstfunmea+3; 
measureC = handles.measures;
measureC{inow,8+istat*2} = num2str(get(hObject,'Value'));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Difference Min from Max : checkbox 21 %%%%%%%%
function checkbox21_Callback(hObject, eventdata, handles)
nstat = 4;
inow = handles.firstfunmea+4; 
check=inow-handles.firstfunmea+1; % The line of this function
measureC = handles.measures;
measureC{inow,1} = num2str(get(hObject,'Value'));
npar = sum(cell2mat(measureC(handles.firstfunmea:inow-1,4)))-(check-1)*nstat;
if measureC{inow,1}=='1'
    for istat=1:nstat
        eval([sprintf('set(handles.checkbox%d,''Enable'',''on'')',(check-1)*(nstat+1)+1+istat)])
    end
    for j=1:measureC{inow,4}-nstat
        eval([sprintf('set(handles.edit%d,''Enable'',''on'')',j+npar)])
    end
else
    for istat=1:nstat
        eval([sprintf('set(handles.checkbox%d,''Enable'',''Off'')',(check-1)*(nstat+1)+1+istat)])
    end
    for j=1:measureC{inow,4}-nstat
        eval([sprintf('set(handles.edit%d,''Enable'',''Off'')',j+npar)])
    end
end
handles.measures = measureC;
guidata(hObject,handles);


% Difference Min from Max, filter order
function edit9_Callback(hObject, eventdata, handles)
textind = 4+1; 
inow = handles.firstfunmea+4;
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

function edit9_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Difference Min from Max, offset for window length
function edit10_Callback(hObject, eventdata, handles)
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

function edit10_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%%%%%%% Difference Min from Max, mean checkbox  %%%%%%%%
function checkbox22_Callback(hObject, eventdata, handles)
istat=1;
inow = handles.firstfunmea+4; 
measureC = handles.measures;
measureC{inow,8+istat*2} = num2str(get(hObject,'Value'));

%%%%%%% Difference Min from Max, median checkbox  %%%%%%%%
function checkbox23_Callback(hObject, eventdata, handles)
istat=2;
inow = handles.firstfunmea+4; 
measureC = handles.measures;
measureC{inow,8+istat*2} = num2str(get(hObject,'Value'));

%%%%%%% Difference Min from Max, standard deviation checkbox  %%%%%%%%
function checkbox24_Callback(hObject, eventdata, handles)
istat=3;
inow = handles.firstfunmea+4; 
measureC = handles.measures;
measureC{inow,8+istat*2} = num2str(get(hObject,'Value'));

%%%%%%% Difference Min from Max, interquartile checkbox  %%%%%%%%
function checkbox25_Callback(hObject, eventdata, handles)
istat=4;
inow = handles.firstfunmea+4; 
measureC = handles.measures;
measureC{inow,8+istat*2} = num2str(get(hObject,'Value'));

% --- Executes on button press in OK button.
function pushbutton1_Callback(hObject, eventdata, handles)
measureC = handles.measures;
firstfunmea =handles.firstfunmea;
lastfunmea =handles.lastfunmea;
nfunmea = lastfunmea-firstfunmea+1;
countpar = 0;
nstat = 4;
for i=firstfunmea:firstfunmea+nfunmea-1
    eval([sprintf('tmp=get(handles.checkbox%d,''Value'');',(i-firstfunmea)*(nstat+1)+1)])
    measureC{i,1}=num2str(tmp);
    npar = measureC{i,4};
    if measureC{i,1}=='1'
        for j=1:npar-nstat
            eval([sprintf('measureC{i,4+j*2}=get(handles.edit%d,''String'');',(i-firstfunmea)*(npar-nstat)+j)])
        end
        for istat=1:nstat              
            eval([sprintf('tmp=get(handles.checkbox%d,''Value'');',(i-firstfunmea)*(nstat+1)+1+istat)])
            measureC{i,4+2*(npar-nstat)+istat*2}=num2str(tmp);
        end
        % If none of the statistics measures are selected, select them all
        if isempty(find(cell2mat(measureC(i,4+2*(npar-nstat)+[1:nstat]*2))=='1'))
            for istat=1:nstat              
                measureC{i,4+2*(npar-nstat)+istat*2}='1';
            end
        end    
    end
    countpar = countpar + npar;
end
setappdata(0,'parlist',measureC);
delete(guifeaturestatistics)

% --- Executes on button press in cancel button.
function pushbutton2_Callback(hObject, eventdata, handles)
delete(guifeaturestatistics)

% --- Executes on button press in Help button.
function pushbutton3_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\FeatureStatisticsMeasures.htm'')'])

