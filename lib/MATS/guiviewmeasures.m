function varargout = guiviewmeasures(varargin)
% GUIVIEWMEASURES M-file for guiviewmeasures.fig
%      GUIVIEWMEASURES, by itself, creates a new GUIVIEWMEASURES or raises the existing
%      singleton*.
%
%      H = GUIVIEWMEASURES returns the handle to a new GUIVIEWMEASURES or the handle to
%      the existing singleton*.
%
%      GUIVIEWMEASURES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIVIEWMEASURES.M with the given input arguments.
%
%      GUIVIEWMEASURES('Property','Value',...) creates a new GUIVIEWMEASURES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiviewmeasures_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiviewmeasures_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help guiviewmeasures

% Last Modified by GUIDE v2.5 21-Jan-2008 14:01:44
%========================================================================
%     <guiviewmeasures.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guiviewmeasures_OpeningFcn, ...
                   'gui_OutputFcn',  @guiviewmeasures_OutputFcn, ...
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


% --- Executes just before guiviewmeasures is made visible.
function guiviewmeasures_OpeningFcn(hObject, eventdata, handles, varargin)
img1 = importdata('buttontable.bmp');
set(handles.pushbutton1,'CData',img1);
img2 = importdata('buttonfreeplot.bmp');
set(handles.pushbutton2,'CData',img2);
img3 = importdata('buttonsegmentplot.bmp');
set(handles.pushbutton3,'CData',img3);
img4 = importdata('buttonsurrogateplot.bmp');
set(handles.pushbutton4,'CData',img4);
img5 = importdata('buttonparameterplot.bmp');
set(handles.pushbutton5,'CData',img5);
img6 = importdata('buttonpar1par2plot.bmp');
set(handles.pushbutton6,'CData',img6);
img7 = importdata('buttonmea1mea2plot.bmp');
set(handles.pushbutton7,'CData',img7);
img8 = importdata('buttonmea1mea2mea3plot.bmp');
set(handles.pushbutton8,'CData',img8);

% Choose default command line output for guiviewmeasures
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = guiviewmeasures_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Table of Measures button.
function pushbutton1_Callback(hObject, eventdata, handles)
guimeasuretable
uiwait;

% --- Executes on button press in Free Plot button.
function pushbutton2_Callback(hObject, eventdata, handles)
guifreeplot
uiwait;


% --- Executes on button press in Segment Plot button.
function pushbutton3_Callback(hObject, eventdata, handles)
guimeasegmentplot
uiwait;


% --- Executes on button press in Surrogate Plot button.
function pushbutton4_Callback(hObject, eventdata, handles)
guimeasurrogateplot
uiwait;


% --- Executes on button press in Measure vs Par1 button.
function pushbutton5_Callback(hObject, eventdata, handles)
guimeapar1plot
uiwait;


% --- Executes on button press in Measure vs Par1 and Par2 button.
function pushbutton6_Callback(hObject, eventdata, handles)
guimeapar1par2plot
uiwait;


% --- Executes on button press in Measure1 vs Measure2 button.
function pushbutton7_Callback(hObject, eventdata, handles)
guimea1mea2plot
uiwait;


% --- Executes on button press in Measure1 vs Measure2 vs Measure3 button.
function pushbutton8_Callback(hObject, eventdata, handles)
guimea1mea2mea3plot
uiwait;


% --- Executes on button press in Exit button.
function pushbutton9_Callback(hObject, eventdata, handles)
allV = get(0,'Children');
indV = find(allV==round(allV));
delete(allV(indV))
delete(guiviewmeasures)

% --- Executes on button press in Help button.
function pushbutton10_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\ViewMeasures.htm'')'])


