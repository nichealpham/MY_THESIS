function varargout = guiselectmeasures(varargin)
% GUISELECTMEASURES M-file for guiselectmeasures.fig
%      GUISELECTMEASURES, by itself, creates a new GUISELECTMEASURES or raises the existing
%      singleton*.
%
%      H = GUISELECTMEASURES returns the handle to a new GUISELECTMEASURES or the handle to
%      the existing singleton*.
%
%      GUISELECTMEASURES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUISELECTMEASURES.M with the given input arguments.
%
%      GUISELECTMEASURES('Property','Value',...) creates a new GUISELECTMEASURES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiselectmeasures_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiselectmeasures_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help guiselectmeasures

% Last Modified by GUIDE v2.5 20-Jan-2010 14:44:03
%========================================================================
%     <guiselectmeasures.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
    'gui_OpeningFcn', @guiselectmeasures_OpeningFcn, ...
    'gui_OutputFcn',  @guiselectmeasures_OutputFcn, ...
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


% --- Executes just before guiselectmeasures is made visible.
function guiselectmeasures_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
fullpath = 'defaultmeasures.txt';
measureC = getappdata(0,'parlist');
if isempty(measureC)
   measureC=readmeasureparameters(fullpath);
end
setappdata(0,'parlist',measureC);


% --- An internal function that reads a file with the measures and
% parameters in specified fields of the panel.
function measureC=readmeasureparameters(fullpath)
% measureC=readmeasureparameters(fullpath)
% READMEASUREPARAMETERS reads in the measures and their parameters from a
% file in a prespecified format.
eval(['fid=fopen(''',fullpath,''',''r'');'])
counter = 0;
tline = fgetl(fid);
while tline~=-1
    itabV = find(tline==';');
    if isempty(itabV) | length(itabV)<3 | mod(length(itabV),2)~=1
        error('Measure and Parameter file does not have proper format.');
    end
    counter = counter+1;
    measureC{counter,1}=tline(1:itabV(1)-1);
    measureC{counter,2}=tline(itabV(1)+1:itabV(2)-1);
    measureC{counter,3}=tline(itabV(2)+1:itabV(3)-1);
    npar = (length(itabV)-3)/2;
    measureC{counter,4}=npar;
    for i=1:npar
        measureC{counter,4+(i-1)*2+1}=tline(itabV(3+(i-1)*2)+1:itabV(3+(i-1)*2+1)-1);
        measureC{counter,4+i*2}=tline(itabV(3+(i-1)*2+1)+1:itabV(3+i*2)-1);
    end
    tline = fgetl(fid);
end
fclose(fid);

% --- Outputs from this function are returned to the command line.
function varargout = guiselectmeasures_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

%%%%% BUTTONS %%%%%
% --- Executes on button press in linear correlation measures.
function pushbutton1_Callback(hObject, eventdata, handles)
guilinearcorrelationmeasures;

% --- Executes on button press in Frequency Measures.
function pushbutton2_Callback(hObject, eventdata, handles)
guifrequencymeasures;

% --- Executes on button press in Linear Model Measurs button.
function pushbutton3_Callback(hObject, eventdata, handles)
guilinearmodelmeasures;

% --- Executes on button press in nonlinear correlation measures pushbutton.
function pushbutton4_Callback(hObject, eventdata, handles)
guinonlinearcorrelationmeasures;

% --- Executes on button press in Nonlinear Dimension and Complexity pushbutton.
function pushbutton5_Callback(hObject, eventdata, handles)
guinonlineardimensioncomplexity;

% --- Executes on button press in nonlinear model button.
function pushbutton6_Callback(hObject, eventdata, handles)
guinonlinearmodelmeasures;

% --- Executes on button press in Moment and Long Range pushbutton.
function pushbutton7_Callback(hObject, eventdata, handles)
guimomentslongrange;

% --- Executes on button press in Feature Statistics pushbutton.
function pushbutton8_Callback(hObject, eventdata, handles)
guifeaturestatistics;

% --- Executes on button press in Load Measure Parameters pushbutton.
function pushbutton9_Callback(hObject, eventdata, handles)
[filename,pathname] = uigetfile('*.*','Select the Measure and Parameter File');
if filename==0
    return;
end
fullpath = sprintf('%s%s',pathname,filename);
eval(['fid=fopen(''',fullpath,''',''r'');'])
counter = 0;
tline = fgetl(fid);
if tline(1)~='0' & tline(1)~='1' 
    messageS = sprintf('Measure and Parameter file %s does not have proper format.\n',fullpath);
    set(handles.edit1,'String',messageS);
    fclose(fid);
    return;
end 
while tline~=-1
    itabV = find(tline==';');
    if isempty(itabV) | length(itabV)<3 | mod(length(itabV),2)~=1
        messageS = sprintf('Measure and Parameter file %s does not have proper format.\n',fullpath);
        set(handles.edit1,'String',messageS);
    end
    counter = counter+1;
    measureC{counter,1}=tline(1:itabV(1)-1);
    measureC{counter,2}=tline(itabV(1)+1:itabV(2)-1);
    measureC{counter,3}=tline(itabV(2)+1:itabV(3)-1);
    npar = (length(itabV)-3)/2;
    measureC{counter,4}=npar;
    for i=1:npar
        measureC{counter,4+(i-1)*2+1}=tline(itabV(3+(i-1)*2)+1:itabV(3+(i-1)*2+1)-1);
        measureC{counter,4+i*2}=tline(itabV(3+(i-1)*2+1)+1:itabV(3+i*2)-1);
    end
    tline = fgetl(fid);
end
fclose(fid);
messageS = sprintf('Measure and Parameter file %s is loaded successfully.\n',fullpath);
set(handles.edit1,'String',messageS);
setappdata(0,'parlist',measureC);

% --- Executes on button press in Save Measure Parameters pushbutton.
function pushbutton10_Callback(hObject, eventdata, handles)
measureC = getappdata(0,'parlist');
% Allowed save format for measure table: ascii, xls and mat  
[filename, pathname, filterindex] = uiputfile({'*.*', 'simple ascii (*.*)'},'Save as');
if filename==0
    return;
end
fullpath = sprintf('%s%s',pathname,filename);
switch filterindex
    case 0
        % do nothing (the user selected Cancel in the dialogue window)
    case 1
        eval(['fid=fopen(''',fullpath,''',''w'');'])
        counter = 0;
        for i=1:size(measureC,1)
            counter = counter+1;
            fprintf(fid','%s;',measureC{counter,1});
            fprintf(fid','%s;',measureC{counter,2});
            fprintf(fid','%s;',measureC{counter,3});
            npar = measureC{counter,4};
            for i=1:npar
                fprintf(fid','%s;',measureC{counter,4+(i-1)*2+1});
                fprintf(fid','%s;',measureC{counter,4+i*2});
            end
            fprintf(fid,'\n');
        end
        fclose(fid);
        messageS = sprintf('Measure and Parameter file %s is saved successfully.\n',fullpath);
        set(handles.edit1,'String',messageS);
    otherwise
        error('Could not save the Measure and Parameter file.')
end


% --- Executes on button press in Run button.
function pushbutton11_Callback(hObject, eventdata, handles)
measureC = getappdata(0,'parlist');
tmpindV = str2num(cell2mat(measureC(:,1)));
runindV = find(tmpindV == 1);
count = 0;
if isempty(runindV)
    messageS = sprintf('Run: No measures selected. Select measures (from this window). \n');
    set(handles.edit1,'String',messageS);
else
    nrunind = length(runindV); % The number of selected measures from the list
    dat = getappdata(0,'datlist');
    if isempty(dat)
        messageS = sprintf('Run: The data list is empty. Go to the main menu and load data first. \n');
        set(handles.edit1,'String',messageS);
    else
        ndata = size(dat(:,1),1);
        % Run first loop over all time series, second loop over all measure
        % functions.
        messageS = '';
        editposV = get(handles.edit1,'Position');
        linechar = ceil(editposV(3)); % The width of the edit box in char units
        for i=1:nrunind
            runind = runindV(i);
            if length(messageS)>100*linechar
                messageS = messageS(end-10*linechar:end);
            end
            messageS = sprintf('%s %s :',messageS,measureC{runind,2});
            set(handles.edit1,'String',messageS);
            for j=1:ndata
                if mod(j,20)==1
                    messageS = sprintf('%s %d',messageS,j);
                else
                    messageS = sprintf('%s.',messageS);
                end
                set(handles.edit1,'String',messageS);
                pause(0.0000000000000000000000000000001)
                xV = dat{j,2};
                switch runind
                    case 1
                        % Pearson autocorrelation, #par = 1
                        % Possible check
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['par1V = ',testS,';'])
                        if measureC{2,1}=='0' & measureC{3,1}=='0' & measureC{4,1}=='0'
                            [pautV,tmp1,tmp2,tmp3] = ...
                                Pearsonautocorrelation(xV,par1V,0);
                        else
                            [pautV,cumpautV,decpaut,zeropaut] = ...
                                Pearsonautocorrelation(xV,par1V,1);
                            % The extra outputs have to be stored separately
                            % for each time series in case they are used from
                            % other calls for measures
                            cumpautVC{j}=cumpautV;
                            decpautC{j}=decpaut;
                            zeropautC{j}=zeropaut;
                        end
                        if j==1
                            count1=count;
                            for ipar=1:length(pautV)
                                count=count+1;
                                meadatC{count,1} = sprintf('%st%d',measureC{runind,3},par1V(ipar));
                                meadatC{count,2}(j)=pautV(ipar);
                            end
                        else
                            count = count1;
                            for ipar=1:length(pautV)
                                count=count+1;
                                meadatC{count,2}(j)=pautV(ipar);
                            end
                        end
                    case 2
                        % Cumulative Pearson autocorrelation, #par = 1
                        if measureC{1,1}=='0' | ~strcmp(measureC{1,6},measureC{runind,6})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            [tmp1,cumpautV,tmp2,tmp3] = Pearsonautocorrelation(xV,par1V,2);
                            cumpautVC{j}=cumpautV;
                        end
                        if j==1
                            count2 = count;
                            for ipar=1:length(cumpautVC{j})
                                count=count+1;
                                meadatC{count,1} = sprintf('%st%d',measureC{runind,3},par1V(ipar));
                                meadatC{count,2}(j)=cumpautVC{j}(ipar);
                            end
                        else
                            count = count2;
                            for ipar=1:length(cumpautVC{j})
                                count=count+1;
                                meadatC{count,2}(j)=cumpautVC{j}(ipar);
                            end
                        end
                    case 3
                        % Pearson Decorrelation time, #par = 1
                        if measureC{1,1}=='0' | ~strcmp(measureC{1,6},measureC{runind,6})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            taumax = max(par1V);
                            [tmp1,tmp2,decpaut,tmp3]= Pearsonautocorrelation(xV,taumax,3);
                            decpautC{j}=decpaut;
                        else
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            taumax = max(par1V);
                        end
                        if j==1
                            count3=count;
                            count=count+1;
                            meadatC{count,1} = sprintf('%stmax%d',measureC{runind,3},taumax);
                            meadatC{count,2}(j)=decpautC{j};
                        else
                            count = count3;
                            count=count+1;
                            meadatC{count,2}(j)=decpautC{j};
                        end
                    case 4
                        % Zero Pearson autocorrelation time, #par = 1
                        if measureC{1,1}=='0' | ~strcmp(measureC{1,6},measureC{runind,6})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            taumax = max(par1V);
                            [tmp1,tmp2,tmp3,zeropaut] = Pearsonautocorrelation(xV,taumax,4);
                            zeropautC{j}=zeropaut;
                        else
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            taumax = max(par1V);
                        end
                        if j==1
                            count4=count;
                            count=count+1;
                            meadatC{count,1} = sprintf('%stmax%d',measureC{runind,3},taumax);
                            meadatC{count,2}(j)=zeropautC{j};
                        else
                            count = count4;
                            count=count+1;
                            meadatC{count,2}(j)=zeropautC{j};
                        end
                    case 5
                        % Kendall autocorrelation, #par = 1
                        % Possible check
                        % if measureC{runind,4}~=1, error('Error in #par'); end
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['par1V = ',testS,';'])
                        if measureC{6,1}=='0' & measureC{7,1}=='0' & measureC{8,1}=='0'
                            [kautV,tmp1,tmp2,tmp3] = ...
                                Kendallautocorrelation(xV,par1V,0);
                        else
                            [kautV,cumkautV,deckaut,zerokaut] = ...
                                Kendallautocorrelation(xV,par1V,1);
                            % The extra outputs have to be stored separately
                            % for each time series in case they are used from
                            % other calls for measures
                            cumkautVC{j}=cumkautV;
                            deckautC{j}=deckaut;
                            zerokautC{j}=zerokaut;
                        end
                        if j==1
                            count5=count;
                            for ipar=1:length(kautV)
                                count=count+1;
                                meadatC{count,1} = sprintf('%st%d',measureC{runind,3},par1V(ipar));
                                meadatC{count,2}(j)=kautV(ipar);
                            end
                        else
                            count = count5;
                            for ipar=1:length(kautV)
                                count=count+1;
                                meadatC{count,2}(j)=kautV(ipar);
                            end
                        end
                    case 6
                        % Cumulative Kendall autocorrelation, #par = 1
                        if measureC{5,1}=='0' | ~strcmp(measureC{5,6},measureC{runind,6})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            [tmp1,cumkautV,tmp2,tmp3] = Kendallautocorrelation(xV,par1V,2);
                            cumkautVC{j}=cumkautV;
                        end
                        if j==1
                            count6 = count;
                            for ipar=1:length(cumkautVC{j})
                                count=count+1;
                                meadatC{count,1} = sprintf('%st%d',measureC{runind,3},par1V(ipar));
                                meadatC{count,2}(j)=cumkautVC{j}(ipar);
                            end
                        else
                            count = count6;
                            for ipar=1:length(cumkautV)
                                count=count+1;
                                meadatC{count,2}(j)=cumkautVC{j}(ipar);
                            end
                        end
                    case 7
                        % Kendall Decorrelation time, #par = 1
                        if measureC{5,1}=='0' | ~strcmp(measureC{5,6},measureC{runind,6})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            taumax = max(par1V);
                            [tmp1,tmp2,deckaut,tmp3]= Kendallautocorrelation(xV,taumax,3);
                            deckautC{j}=deckaut;
                        else
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            taumax = max(par1V);
                        end
                        if j==1
                            count7=count;
                            count=count+1;
                            meadatC{count,1} = sprintf('%stmax%d',measureC{runind,3},taumax);
                            meadatC{count,2}(j)=deckautC{j};
                        else
                            count = count7;
                            count=count+1;
                            meadatC{count,2}(j)=deckautC{j};
                        end
                    case 8
                        % Zero Kendall autocorrelation time, #par = 1
                        if measureC{5,1}=='0' | ~strcmp(measureC{5,6},measureC{runind,6})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            taumax = max(par1V);
                            [tmp1,tmp2,tmp3,zerokaut] = Kendallautocorrelation(xV,taumax,4);
                            zerokautC{j}=zerokaut;
                        else
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            taumax = max(par1V);
                        end
                        if j==1
                            count8=count;
                            count=count+1;
                            meadatC{count,1} = sprintf('%stmax%d',measureC{runind,3},taumax);
                            meadatC{count,2}(j)=zerokautC{j};
                        else
                            count = count8;
                            count=count+1;
                            meadatC{count,2}(j)=zerokautC{j};
                        end
                    case 9
                        % Spearman autocorrelation, #par = 1
                        % Possible check
                        % if measureC{runind,4}~=1, error('Error in #par'); end
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['par1V = ',testS,';'])
                        if measureC{10,1}=='0' & measureC{11,1}=='0' & measureC{12,1}=='0'
                            [sautV,tmp1,tmp2,tmp3] = ...
                                Spearmanautocorrelation(xV,par1V,0);
                        else
                            [sautV,cumsautV,decsaut,zerosaut] = ...
                                Spearmanautocorrelation(xV,par1V,1);
                            % The extra outputs have to be stored separately
                            % for each time series in case they are used from
                            % other calls for measures
                            cumsautVC{j}=cumsautV;
                            decsautC{j}=decsaut;
                            zerosautC{j}=zerosaut;
                        end
                        if j==1
                            count9=count;
                            for ipar=1:length(sautV)
                                count=count+1;
                                meadatC{count,1} = sprintf('%st%d',measureC{runind,3},par1V(ipar));
                                meadatC{count,2}(j)=sautV(ipar);
                            end
                        else
                            count = count9;
                            for ipar=1:length(sautV)
                                count=count+1;
                                meadatC{count,2}(j)=sautV(ipar);
                            end
                        end
                    case 10
                        % Cumulative Spearman autocorrelation, #par = 1
                        if measureC{9,1}=='0' | ~strcmp(measureC{9,6},measureC{runind,6})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            [tmp1,cumsautV,tmp2,tmp3] = Spearmanautocorrelation(xV,par1V,2);
                            cumsautVC{j}=cumsautV;
                        end
                        if j==1
                            count10 = count;
                            for ipar=1:length(cumsautVC{j})
                                count=count+1;
                                meadatC{count,1} = sprintf('%st%d',measureC{runind,3},par1V(ipar));
                                meadatC{count,2}(j)=cumsautVC{j}(ipar);
                            end
                        else
                            count = count10;
                            for ipar=1:length(cumsautVC{j})
                                count=count+1;
                                meadatC{count,2}(j)=cumsautVC{j}(ipar);
                            end
                        end
                    case 11
                        % Spearman Decorrelation time, #par = 1
                        if measureC{9,1}=='0' | ~strcmp(measureC{9,6},measureC{runind,6})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            taumax = max(par1V);
                            [tmp1,tmp2,decsaut,tmp3]= Spearmanautocorrelation(xV,taumax,3);
                            decsautC{j}=decsaut;
                        else
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            taumax = max(par1V);
                        end
                        if j==1
                            count11=count;
                            count=count+1;
                            meadatC{count,1} = sprintf('%stmax%d',measureC{runind,3},taumax);
                            meadatC{count,2}(j)=decsautC{j};
                        else
                            count = count11;
                            count=count+1;
                            meadatC{count,2}(j)=decsautC{j};
                        end
                    case 12
                        % Zero Spearman autocorrelation time, #par = 1
                        if measureC{9,1}=='0' | ~strcmp(measureC{9,6},measureC{runind,6})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            taumax = max(par1V);
                            [tmp1,tmp2,tmp3,zerosaut] = Spearmanautocorrelation(xV,taumax,4);
                            zerosautC{j}=zerosaut;
                        else
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            taumax = max(par1V);
                        end
                        if j==1
                            count12=count;
                            count=count+1;
                            meadatC{count,1} = sprintf('%stmax%d',measureC{runind,3},taumax);
                            meadatC{count,2}(j)=zerosautC{j};
                        else
                            count = count12;
                            count=count+1;
                            meadatC{count,2}(j)=zerosautC{j};
                        end
                    case 13
                        % Partial autocorrelation, #par = 1
                        % Possible check
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['par1V = ',testS,';'])
                        pautV = PartialAutocorrelation(xV,par1V);
                        if j==1
                            count13=count;
                            for ipar=1:length(pautV)
                                count=count+1;
                                meadatC{count,1} = sprintf('%st%d',measureC{runind,3},par1V(ipar));
                                meadatC{count,2}(j)=pautV(ipar);
                            end
                        else
                            count = count13;
                            for ipar=1:length(pautV)
                                count=count+1;
                                meadatC{count,2}(j)=pautV(ipar);
                            end
                        end
                    case 14
                        % Energy in bands, #par = 2
                        % The parameters must have been checked for
                        % validity (single numeric values) when entered
                        Eband1=[]; % To control entering the loop for filling measure list
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['par1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,8});
                        eval(['par2V = ',testS,';'])
                        if par2V > par1V
                            [Eband1,freqV,psV,errormsg] = EnergyBand(xV,[par1V par2V]);
                            freqVC{j}=freqV;
                            psVC{j}=psV;
                        end
                        if ~isempty(Eband1)
                            if j==1
                                count14=count;
                                count=count+1;
                                meadatC{count,1} = sprintf('%sl%du%d',measureC{runind,3},round(par1V*1000),round(par2V*1000));
                                meadatC{count,2}(j)=Eband1;
                            else
                                count = count14;
                                count=count+1;
                                meadatC{count,2}(j)=Eband1;
                            end
                        end
                    case 15
                        % Energy in bands, #par = 2
                        % The parameters must have been checked for
                        % validity (single numeric values) when entered
                        Eband2=[]; % To control entering the loop for filling measure list
                        if measureC{14,1}=='0' | isempty(Eband1)
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            if par2V > par1V
                                [Eband2,freqV,psV,errormsg] = EnergyBand(xV,[par1V par2V]);
                            end
                        elseif (strcmp(measureC{14,6},measureC{runind,6}) & strcmp(measureC{14,8},measureC{runind,8}))
                            errormsg = sprintf('The frequency band [%1.4f,%1.4f] is given twice.',par1V,par2V);
                            Eband2 = Eband1;
                        else
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            if par2V > par1V
                                [Eband2,errormsg] = EnergyBand2(freqVC{j},psVC{j},[par1V par2V]);
                            end
                        end
                        if ~isempty(Eband2)
                            if j==1
                                count15=count;
                                count=count+1;
                                meadatC{count,1} = sprintf('%sl%du%d',measureC{runind,3},round(par1V*1000),round(par2V*1000));
                                meadatC{count,2}(j)=Eband2;
                            else
                                count = count15;
                                count=count+1;
                                meadatC{count,2}(j)=Eband2;
                            end
                        end
                    case 16
                        % Energy in bands, #par = 2
                        % The parameters must have been checked for
                        % validity (single numeric values) when entered
                        Eband3=[]; % To control entering the loop for filling measure list
                        if measureC{14,1}=='0' | isempty(Eband1)
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            if par2V > par1V
                                [Eband3,freqV,psV,errormsg] = EnergyBand(xV,[par1V par2V]);
                            end
                        elseif (strcmp(measureC{14,6},measureC{runind,6}) & strcmp(measureC{14,8},measureC{runind,8}))
                            errormsg = sprintf('The frequency band [%1.4f,%1.4f] is given twice.',par1V,par2V);
                            Eband3 = Eband1;
                        elseif (measureC{15,1}=='1' & strcmp(measureC{15,6},measureC{runind,6}) & strcmp(measureC{15,8},measureC{runind,8}))
                            errormsg = sprintf('The frequency band [%1.4f,%1.4f] is given twice.',par1V,par2V);
                            Eband3 = Eband2;
                        else
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            if par2V > par1V
                                [Eband3,errormsg] = EnergyBand2(freqVC{j},psVC{j},[par1V par2V]);
                            end
                        end
                        if ~isempty(Eband3)
                            if j==1
                                count16=count;
                                count=count+1;
                                meadatC{count,1} = sprintf('%sl%du%d',measureC{runind,3},round(par1V*1000),round(par2V*1000));
                                meadatC{count,2}(j)=Eband3;
                            else
                                count = count16;
                                count=count+1;
                                meadatC{count,2}(j)=Eband3;
                            end
                        end
                    case 17
                        % Energy in bands, #par = 2
                        % The parameters must have been checked for
                        % validity (single numeric values) when entered
                        Eband4=[]; % To control entering the loop for filling measure list
                        if measureC{14,1}=='0'
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            if par2V > par1V
                                [Eband4,freqV,psV,errormsg] = EnergyBand(xV,[par1V par2V]);
                            end
                        elseif (strcmp(measureC{14,6},measureC{runind,6}) & strcmp(measureC{14,8},measureC{runind,8}))
                            errormsg = sprintf('The frequency band [%1.4f,%1.4f] is given twice.',par1V,par2V);
                            Eband4 = Eband1;
                        elseif (measureC{15,1}=='1' & strcmp(measureC{15,6},measureC{runind,6}) & strcmp(measureC{15,8},measureC{runind,8}))
                            errormsg = sprintf('The frequency band [%1.4f,%1.4f] is given twice.',par1V,par2V);
                            Eband4 = Eband2;
                        elseif (measureC{16,1}=='1' & strcmp(measureC{16,6},measureC{runind,6}) & strcmp(measureC{16,8},measureC{runind,8}))
                            errormsg = sprintf('The frequency band [%1.4f,%1.4f] is given twice.',par1V,par2V);
                            Eband4 = Eband3;
                        else
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            if par2V > par1V
                                [Eband4,errormsg] = EnergyBand2(freqVC{j},psVC{j},[par1V par2V]);
                            end
                        end
                        if ~isempty(Eband4)
                            if j==1
                                count17=count;
                                count=count+1;
                                meadatC{count,1} = sprintf('%sl%du%d',measureC{runind,3},round(par1V*1000),round(par2V*1000));
                                meadatC{count,2}(j)=Eband4;
                            else
                                count = count17;
                                count=count+1;
                                meadatC{count,2}(j)=Eband4;
                            end
                        end
                    case 18
                        % Energy in bands, #par = 2
                        % The parameters must have been checked for
                        % validity (single numeric values) when entered
                        Eband5=[]; % To control entering the loop for filling measure list
                        if measureC{14,1}=='0'
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            if par2V > par1V
                                [Eband5,freqV,psV,errormsg] = EnergyBand(xV,[par1V par2V]);
                            end
                        elseif (strcmp(measureC{14,6},measureC{runind,6}) & strcmp(measureC{14,8},measureC{runind,8}))
                            errormsg = sprintf('The frequency band [%1.4f,%1.4f] is given twice.',par1V,par2V);
                            Eband5 = Eband1;
                        elseif (measureC{15,1}=='1' & strcmp(measureC{15,6},measureC{runind,6}) & strcmp(measureC{15,8},measureC{runind,8}))
                            errormsg = sprintf('The frequency band [%1.4f,%1.4f] is given twice.',par1V,par2V);
                            Eband5 = Eband2;
                        elseif (measureC{16,1}=='1' & strcmp(measureC{16,6},measureC{runind,6}) & strcmp(measureC{16,8},measureC{runind,8}))
                            errormsg = sprintf('The frequency band [%1.4f,%1.4f] is given twice.',par1V,par2V);
                            Eband5 = Eband3;
                        elseif (measureC{17,1}=='1' & strcmp(measureC{17,6},measureC{runind,6}) & strcmp(measureC{17,8},measureC{runind,8}))
                            errormsg = sprintf('The frequency band [%1.4f,%1.4f] is given twice.',par1V,par2V);
                            Eband5 = Eband4;
                        else
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            if par2V > par1V
                                [Eband5,errormsg] = EnergyBand2(freqVC{j},psVC{j},[par1V par2V]);
                            end
                        end
                        if ~isempty(Eband5)
                            if j==1
                                count18=count;
                                count=count+1;
                                meadatC{count,1} = sprintf('%sl%du%d',measureC{runind,3},round(par1V*1000),round(par2V*1000));
                                meadatC{count,2}(j)=Eband5;
                            else
                                count = count18;
                                count=count+1;
                                meadatC{count,2}(j)=Eband5;
                            end
                        end
                    case 19
                        % Energy in bands, #par = 2
                        % The parameters must have been checked for
                        % validity (single numeric values) when entered
                        MedFreq=[]; % To control entering the loop for filling measure list
                        if measureC{14,1}=='0'
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            if par2V > par1V
                                [MedFreq,errormsg] = MedianFrequency(xV,par1V,par2V);
                            end
                        else
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            if par2V > par1V
                                [MedFreq,errormsg] = MedianFrequency2(freqVC{j},psVC{j},par1V,par2V);
                            end
                        end
                        if ~isempty(MedFreq)
                            if j==1
                                count19=count;
                                count=count+1;
                                meadatC{count,1} = sprintf('%sl%du%d',measureC{runind,3},round(par1V*1000),round(par2V*1000));
                                meadatC{count,2}(j)=MedFreq;
                            else
                                count = count19;
                                count=count+1;
                                meadatC{count,2}(j)=MedFreq;
                            end
                        end
                    case 20
                        % Linear autoregressive fit, #par = 2,
                        % 1->mV, 2->TV
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['err1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,8});
                        eval(['err2V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,10});
                        eval(['err3V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,12});
                        eval(['err4V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,14});
                        eval(['par1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,16});
                        eval(['par2V = ',testS,';'])
                        [mapeM,nmseM,nrmseM,ccM,flagtxt] = ARfitite(xV,par1V,par2V);
                        if isempty(flagtxt)
                            errtxtC = {'mape','nmse','nrmse','cc'};
                            errtxtcapC = {'MAPE','NMSE','NRMSE','CC'};
                            if j==1
                                count20=count;
                                for ierr=1:4
                                    eval(['errV = err',int2str(ierr),'V;']);
                                    if errV==1
                                        %register
                                        eval(['[npar1,npar2]=size(',char(errtxtC{ierr}),'M);'])
                                        for ipar1=1:npar1
                                            for ipar2=1:npar2
                                                count=count+1;
                                                meadatC{count,1} = sprintf('%s%sm%dh%d',measureC{runind,3},...
                                                    char(errtxtcapC{ierr}),par1V(ipar1),par2V(ipar2));
                                                eval(['meadatC{count,2}(j)=',char(errtxtC{ierr}),'M(ipar1,ipar2);'])
                                            end % par2
                                        end % par1
                                    end % if checked
                                end % for ierr
                            else
                                count = count20;
                                for ierr=1:4
                                    eval(['errV = err',int2str(ierr),'V;']);
                                    if errV==1
                                        %register
                                        eval(['[npar1,npar2]=size(',char(errtxtC{ierr}),'M);'])
                                        for ipar1=1:npar1
                                            for ipar2=1:npar2
                                                count=count+1;
                                                eval(['meadatC{count,2}(j)=',char(errtxtC{ierr}),'M(ipar1,ipar2);'])
                                            end % par2
                                        end % par1
                                    end % if checked
                                end % for ierr
                            end % if j==1
                        else
                            messageS = sprintf('%s \n %s',messageS,flagtxt);
                            set(handles.edit1,'String',messageS);
                        end % if flagtxt
                    case 21
                        % AR prediction, #par = 3,
                        % 0->fraction, 1->mV, 2->TV
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['err1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,8});
                        eval(['err2V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,10});
                        eval(['err3V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,12});
                        eval(['err4V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,14});
                        eval(['par0V = ',testS,';']) % 0-> fraction
                        testS = sprintf('[%s]',measureC{runind,16});
                        eval(['par1V = ',testS,';']) 
                        testS = sprintf('[%s]',measureC{runind,18});
                        eval(['par2V = ',testS,';'])
                        [mapeM,nmseM,nrmseM,ccM,flagtxt] = ARpreite(xV,par0V,par1V,par2V);
                        if isempty(flagtxt)
                            errtxtC = {'mape','nmse','nrmse','cc'};
                            errtxtcapC = {'MAPE','NMSE','NRMSE','CC'};
                            if j==1
                                count21=count;
                                for ierr=1:4
                                    eval(['errV = err',int2str(ierr),'V;']);
                                    if errV==1
                                        %register
                                        eval(['[npar1,npar2]=size(',char(errtxtC{ierr}),'M);'])
                                        for ipar1=1:npar1
                                            for ipar2=1:npar2
                                                count=count+1;
                                                meadatC{count,1} = sprintf('%s%sf%dm%dh%d',...
                                                    measureC{runind,3},char(errtxtcapC{ierr}),...
                                                    100*par0V,par1V(ipar1),par2V(ipar2));
                                                eval(['meadatC{count,2}(j)=',char(errtxtC{ierr}),...
                                                    'M(ipar1,ipar2);'])
                                            end % par2
                                        end % par1
                                    end % if checked
                                end % for ierr
                            else
                                count = count21;
                                for ierr=1:4
                                    eval(['errV = err',int2str(ierr),'V;']);
                                    if errV==1
                                        %register
                                        eval(['[npar1,npar2]=size(',char(errtxtC{ierr}),'M);'])
                                        for ipar1=1:npar1
                                            for ipar2=1:npar2
                                                count=count+1;
                                                eval(['meadatC{count,2}(j)=',char(errtxtC{ierr}),...
                                                    'M(ipar1,ipar2);'])
                                            end % par2
                                        end % par1
                                    end % if checked
                                end % for ierr
                            end % if j==1
                        else
                            messageS = sprintf('%s \n %s',messageS,flagtxt);
                            set(handles.edit1,'String',messageS);
                        end % if flagtxt                            
                    case 22
                        % Linear autoregressive moving average fit, #par = 3,
                        % 1->mV, 2->p(moving average order), 2->TV
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['err1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,8});
                        eval(['err2V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,10});
                        eval(['err3V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,12});
                        eval(['err4V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,14});
                        eval(['par1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,16});
                        eval(['par2V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,18});
                        eval(['par3V = ',testS,';'])
                        [mapeT,nmseT,nrmseT,ccT,flagtxt] = ARMAfitite(xV,par1V,par2V,par3V);
                        if isempty(flagtxt)
                            errtxtC = {'mape','nmse','nrmse','cc'};
                            errtxtcapC = {'MAPE','NMSE','NRMSE','CC'};
                            if j==1
                                count22=count;
                                for ierr=1:4
                                    eval(['errV = err',int2str(ierr),'V;']);
                                    if errV==1
                                        %register
                                        eval(['[npar1,npar2,npar3]=size(',char(errtxtC{ierr}),'T);'])
                                        for ipar1=1:npar1
                                            for ipar2=1:npar2
                                                for ipar3=1:npar3
                                                    count=count+1;
                                                    meadatC{count,1} = sprintf('%s%sm%dp%dh%d',measureC{runind,3},...
                                                    char(errtxtcapC{ierr}),par1V(ipar1),par2V(ipar2),par3V(ipar3));
                                                    eval(['meadatC{count,2}(j)=',char(errtxtC{ierr}),'T(ipar1,ipar2,ipar3);'])
                                                end % par3
                                            end % par2
                                        end % par1
                                    end % if checked
                                end % for ierr
                            else
                                count = count22;
                                for ierr=1:4
                                    eval(['errV = err',int2str(ierr),'V;']);
                                    if errV==1
                                        %register
                                        eval(['[npar1,npar2,npar3]=size(',char(errtxtC{ierr}),'T);'])
                                        for ipar1=1:npar1
                                            for ipar2=1:npar2
                                                for ipar3=1:npar3
                                                    count=count+1;
                                                    eval(['meadatC{count,2}(j)=',char(errtxtC{ierr}),'T(ipar1,ipar2,ipar3);'])
                                                end % par3
                                            end % par2
                                        end % par1
                                    end % if checked
                                end % for ierr
                            end % if j==1
                        else
                            messageS = sprintf('%s \n %s',messageS,flagtxt);
                            set(handles.edit1,'String',messageS);
                        end % if flagtxt
                    case 23
                        % Linear autoregressive moving average prediction, #par = 3,
                        % 0->fraction, 1->mV, 2->p(moving average order), 2->TV
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['err1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,8});
                        eval(['err2V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,10});
                        eval(['err3V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,12});
                        eval(['err4V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,14});
                        eval(['par0V = ',testS,';']) % 0-> fraction
                        testS = sprintf('[%s]',measureC{runind,16});
                        eval(['par1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,18});
                        eval(['par2V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,20});
                        eval(['par3V = ',testS,';'])
                        [mapeT,nmseT,nrmseT,ccT,flagtxt] = ARMApreite(xV,par0V,par1V,par2V,par3V);
                        if isempty(flagtxt)
                            errtxtC = {'mape','nmse','nrmse','cc'};
                            errtxtcapC = {'MAPE','NMSE','NRMSE','CC'};
                            if j==1
                                count23=count;
                                for ierr=1:4
                                    eval(['errV = err',int2str(ierr),'V;']);
                                    if errV==1
                                        %register
                                        eval(['[npar1,npar2,npar3]=size(',char(errtxtC{ierr}),'T);'])
                                        for ipar1=1:npar1
                                            for ipar2=1:npar2
                                                for ipar3=1:npar3
                                                    count=count+1;
                                                    meadatC{count,1} = sprintf('%s%sf%dm%dp%dh%d',measureC{runind,3},...
                                                    char(errtxtcapC{ierr}),100*par0V,...
                                                    par1V(ipar1),par2V(ipar2),par3V(ipar3));
                                                    eval(['meadatC{count,2}(j)=',char(errtxtC{ierr}),'T(ipar1,ipar2,ipar3);'])
                                                end % par3
                                            end % par2
                                        end % par1
                                    end % if checked
                                end % for ierr
                            else
                                count = count23;
                                for ierr=1:4
                                    eval(['errV = err',int2str(ierr),'V;']);
                                    if errV==1
                                        %register
                                        eval(['[npar1,npar2,npar3]=size(',char(errtxtC{ierr}),'T);'])
                                        for ipar1=1:npar1
                                            for ipar2=1:npar2
                                                for ipar3=1:npar3
                                                    count=count+1;
                                                    eval(['meadatC{count,2}(j)=',char(errtxtC{ierr}),'T(ipar1,ipar2,ipar3);'])
                                                end % par3
                                            end % par2
                                        end % par1
                                    end % if checked
                                end % for ierr
                            end % if j==1
                        else
                            messageS = sprintf('%s \n %s',messageS,flagtxt);
                            set(handles.edit1,'String',messageS);
                        end % if flagtxt
                    case 24
                        % Local average of linear Direct fit MAPE, #par = 5,
                        % 1->tauV, 2->mV, 3->nneiV, 4->TV, 5->q
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['err1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,8});
                        eval(['err2V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,10});
                        eval(['err3V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,12});
                        eval(['err4V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,14});
                        eval(['par1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,16});
                        eval(['par2V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,18});
                        eval(['par3V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,20});
                        eval(['par4V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,22});
                        eval(['par5V = ',testS,';'])
                        [mapeT,nmseT,nrmseT,ccT] = LocalARfitdir(xV,par1V,par2V,par3V,par5V,par4V);
                        errtxtC = {'mape','nmse','nrmse','cc'};
                        errtxtcapC = {'MAPE','NMSE','NRMSE','CC'};
                        if j==1
                            count24=count;
                            for ierr=1:4
                                eval(['errV = err',int2str(ierr),'V;']);
                                if errV==1
                                    %register
                                    eval(['[npar1,npar2,npar3,npar4]=size(',char(errtxtC{ierr}),'T);'])
                                    for ipar1=1:npar1
                                        for ipar2=1:npar2
                                            for ipar3=1:npar3
                                                for ipar4=1:npar4
                                                    count=count+1;
                                                    meadatC{count,1} = sprintf('%s%st%dm%dk%dq%dh%d',...
                                                        measureC{runind,3},char(errtxtcapC{ierr}),...
                                                        par1V(ipar1),par2V(ipar2),par3V(ipar3),...
                                                        par5V,par4V(ipar4));
                                                    eval(['meadatC{count,2}(j)=',char(errtxtC{ierr}),...
                                                        'T(ipar1,ipar2,ipar3,ipar4);'])
                                                end % par4
                                            end % par3
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for ierr
                        else
                            count = count24;
                            for ierr=1:4
                                eval(['errV = err',int2str(ierr),'V;']);
                                if errV==1
                                    %register
                                    eval(['[npar1,npar2,npar3,npar4]=size(',char(errtxtC{ierr}),'T);'])
                                    for ipar1=1:npar1
                                        for ipar2=1:npar2
                                            for ipar3=1:npar3
                                                for ipar4=1:npar4
                                                    count=count+1;
                                                    eval(['meadatC{count,2}(j)=',char(errtxtC{ierr}),...
                                                        'T(ipar1,ipar2,ipar3,ipar4);'])
                                                end % par4
                                            end % par3
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for ierr
                        end % if j==1
                    case 25
                        % Local average of linear Iterative fit MAPE, #par = 5,
                        % 1->tauV, 2->mV, 3->nneiV, 4->TV, 5->q
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['err1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,8});
                        eval(['err2V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,10});
                        eval(['err3V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,12});
                        eval(['err4V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,14});
                        eval(['par1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,16});
                        eval(['par2V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,18});
                        eval(['par3V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,20});
                        eval(['par4V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,22});
                        eval(['par5V = ',testS,';'])
                        [mapeT,nmseT,nrmseT,ccT] = LocalARfitite(xV,par1V,par2V,par3V,par5V,par4V);
                        errtxtC = {'mape','nmse','nrmse','cc'};
                        errtxtcapC = {'MAPE','NMSE','NRMSE','CC'};
                        if j==1
                            count25=count;
                            for ierr=1:4
                                eval(['errV = err',int2str(ierr),'V;']);
                                if errV==1
                                    %register
                                    eval(['[npar1,npar2,npar3,npar4]=size(',char(errtxtC{ierr}),'T);'])
                                    for ipar1=1:npar1
                                        for ipar2=1:npar2
                                            for ipar3=1:npar3
                                                for ipar4=1:npar4
                                                    count=count+1;
                                                    meadatC{count,1} = sprintf('%s%st%dm%dk%dq%dh%d',...
                                                        measureC{runind,3},char(errtxtcapC{ierr}),...
                                                        par1V(ipar1),par2V(ipar2),par3V(ipar3),...
                                                        par5V,par4V(ipar4));
                                                    eval(['meadatC{count,2}(j)=',char(errtxtC{ierr}),...
                                                        'T(ipar1,ipar2,ipar3,ipar4);'])
                                                end % par4
                                            end % par3
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for ierr
                        else
                            count = count25;
                            for ierr=1:4
                                eval(['errV = err',int2str(ierr),'V;']);
                                if errV==1
                                    %register
                                    eval(['[npar1,npar2,npar3,npar4]=size(',char(errtxtC{ierr}),'T);'])
                                    for ipar1=1:npar1
                                        for ipar2=1:npar2
                                            for ipar3=1:npar3
                                                for ipar4=1:npar4
                                                    count=count+1;
                                                    eval(['meadatC{count,2}(j)=',char(errtxtC{ierr}),...
                                                        'T(ipar1,ipar2,ipar3,ipar4);'])
                                                end % par4
                                            end % par3
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for ierr
                        end % if j==1
                    case 26
                        % Local average of linear Direct Predict MAPE, #par = 6,
                        % 0->fraction, 1->tauV, 2->mV, 3->nneiV, 4->TV, 5->q
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['err1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,8});
                        eval(['err2V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,10});
                        eval(['err3V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,12});
                        eval(['err4V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,14});
                        eval(['par0V = ',testS,';']) % 0-> fraction
                        testS = sprintf('[%s]',measureC{runind,16});
                        eval(['par1V = ',testS,';']) 
                        testS = sprintf('[%s]',measureC{runind,18});
                        eval(['par2V = ',testS,';']) 
                        testS = sprintf('[%s]',measureC{runind,20});
                        eval(['par3V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,22});
                        eval(['par4V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,24});
                        eval(['par5V = ',testS,';'])
                        [mapeT,nmseT,nrmseT,ccT] = LocalARpredir(xV,par0V,par1V,par2V,par3V,par5V,par4V);
                        errtxtC = {'mape','nmse','nrmse','cc'};
                        errtxtcapC = {'MAPE','NMSE','NRMSE','CC'};
                        if j==1
                            count26=count;
                            for ierr=1:4
                                eval(['errV = err',int2str(ierr),'V;']);
                                if errV==1
                                    %register
                                    eval(['[npar1,npar2,npar3,npar4]=size(',char(errtxtC{ierr}),'T);'])
                                    for ipar1=1:npar1
                                        for ipar2=1:npar2
                                            for ipar3=1:npar3
                                                for ipar4=1:npar4
                                                    count=count+1;
                                                    meadatC{count,1} = sprintf('%s%sf%dt%dm%dk%dq%dh%d',...
                                                        measureC{runind,3},char(errtxtcapC{ierr}),...
                                                        100*par0V,par1V(ipar1),par2V(ipar2),par3V(ipar3),...
                                                        par5V,par4V(ipar4));
                                                    eval(['meadatC{count,2}(j)=',char(errtxtC{ierr}),...
                                                        'T(ipar1,ipar2,ipar3,ipar4);'])
                                                end % par4
                                            end % par3
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for ierr
                        else
                            count = count26;
                            for ierr=1:4
                                eval(['errV = err',int2str(ierr),'V;']);
                                if errV==1
                                    %register
                                    eval(['[npar1,npar2,npar3,npar4]=size(',char(errtxtC{ierr}),'T);'])
                                    for ipar1=1:npar1
                                        for ipar2=1:npar2
                                            for ipar3=1:npar3
                                                for ipar4=1:npar4
                                                    count=count+1;
                                                    eval(['meadatC{count,2}(j)=',char(errtxtC{ierr}),...
                                                        'T(ipar1,ipar2,ipar3,ipar4);'])
                                                end % par4
                                            end % par3
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for ierr
                        end % if j==1
                    case 27
                        % Local average of linear Iterative Predict MAPE, #par = 6,
                        % 0->fraction, 1->tauV, 2->mV, 3->nneiV, 4->TV, 5->q
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['err1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,8});
                        eval(['err2V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,10});
                        eval(['err3V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,12});
                        eval(['err4V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,14});
                        eval(['par0V = ',testS,';']) % 0-> fraction
                        testS = sprintf('[%s]',measureC{runind,16});
                        eval(['par1V = ',testS,';']) 
                        testS = sprintf('[%s]',measureC{runind,18});
                        eval(['par2V = ',testS,';']) 
                        testS = sprintf('[%s]',measureC{runind,20});
                        eval(['par3V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,22});
                        eval(['par4V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,24});
                        eval(['par5V = ',testS,';'])
                        [mapeT,nmseT,nrmseT,ccT] = LocalARpreite(xV,par0V,par1V,par2V,par3V,par5V,par4V);
                        errtxtC = {'mape','nmse','nrmse','cc'};
                        errtxtcapC = {'MAPE','NMSE','NRMSE','CC'};
                        if j==1
                            count27=count;
                            for ierr=1:4
                                eval(['errV = err',int2str(ierr),'V;']);
                                if errV==1
                                    %register
                                    eval(['[npar1,npar2,npar3,npar4]=size(',char(errtxtC{ierr}),'T);'])
                                    for ipar1=1:npar1
                                        for ipar2=1:npar2
                                            for ipar3=1:npar3
                                                for ipar4=1:npar4
                                                    count=count+1;
                                                    meadatC{count,1} = sprintf('%s%sf%dt%dm%dk%dq%dh%d',...
                                                        measureC{runind,3},char(errtxtcapC{ierr}),...
                                                        100*par0V,par1V(ipar1),par2V(ipar2),par3V(ipar3),...
                                                        par5V,par4V(ipar4));
                                                    eval(['meadatC{count,2}(j)=',char(errtxtC{ierr}),...
                                                        'T(ipar1,ipar2,ipar3,ipar4);'])
                                                end % par4
                                            end % par3
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for ierr
                        else
                            count = count27;
                            for ierr=1:4
                                eval(['errV = err',int2str(ierr),'V;']);
                                if errV==1
                                    %register
                                    eval(['[npar1,npar2,npar3,npar4]=size(',char(errtxtC{ierr}),'T);'])
                                    for ipar1=1:npar1
                                        for ipar2=1:npar2
                                            for ipar3=1:npar3
                                                for ipar4=1:npar4
                                                    count=count+1;
                                                    eval(['meadatC{count,2}(j)=',char(errtxtC{ierr}),...
                                                        'T(ipar1,ipar2,ipar3,ipar4);'])
                                                end % par4
                                            end % par3
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for ierr
                        end % if j==1
                    case 28
                        % Bicorrelation, #par = 1
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['par1V = ',testS,';'])
                        if measureC{29,1}=='0'
                            [bicV,tmp] = Bicorrelation(xV,par1V,0);
                        else
                            [bicV,cumbicV] = Bicorrelation(xV,par1V,1);
                            cumbicVC{j}=cumbicV;
                        end
                        if j==1
                            count28=count;
                            for ipar=1:length(bicV)
                                count=count+1;
                                meadatC{count,1} = sprintf('%st%d',measureC{runind,3},par1V(ipar));
                                meadatC{count,2}(j)=bicV(ipar);
                            end
                        else
                            count = count28;
                            for ipar=1:length(bicV)
                                count=count+1;
                                meadatC{count,2}(j)=bicV(ipar);
                            end
                        end
                    case 29
                        % Cumulative Bicorrelation, #par = 1
                        if measureC{28,1}=='0' | ~strcmp(measureC{28,6},measureC{runind,6})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            [tmp,cumbicV] = Bicorrelation(xV,par1V,2);
                            cumbicVC{j}=cumbicV;
                        end
                        if j==1
                            count29 = count;
                            for ipar=1:length(cumbicVC{j})
                                count=count+1;
                                meadatC{count,1} = sprintf('%st%d',measureC{runind,3},par1V(ipar));
                                meadatC{count,2}(j)=cumbicVC{j}(ipar);
                            end
                        else
                            count = count29;
                            for ipar=1:length(cumbicV)
                                count=count+1;
                                meadatC{count,2}(j)=cumbicVC{j}(ipar);
                            end
                        end
                    case 30
                        % Mutual Information Equidistant bins, #par = 2, 
                        % 1->b, 2-> tau
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['par1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,8});
                        eval(['par2V = ',testS,';'])
                        if measureC{31,1}=='0' & measureC{32,1}=='0'
                            [mutM,tmp,tmp] = ...
                                MutualInformationHisDis(xV,par2V,par1V,0);
                        else
                            [mutM,cummutM,minmuttauV] = ...
                                MutualInformationHisDis(xV,par2V,par1V,1);
                            cummutMC{j}=cummutM;
                            minmuttauVC{j}=minmuttauV;
                        end
                        if j==1
                            count30=count;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    count=count+1;
                                    meadatC{count,1} = sprintf('%sb%dt%d',measureC{runind,3},par1V(ipar1),par2V(ipar2));
                                    meadatC{count,2}(j)=mutM(ipar2,ipar1);
                                end
                            end
                        else
                            count = count30;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    count=count+1;
                                    meadatC{count,2}(j)=mutM(ipar2,ipar1);
                                end
                            end
                        end
                    case 31
                        % Cumulative Mutual Information Equidistant bins, #par = 2, 
                        % 1->b, 2-> tau
                        if measureC{30,1}=='0' | ~strcmp(measureC{30,6},measureC{runind,6}) | ~strcmp(measureC{30,8},measureC{runind,8})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            [tmp,cummutM,tmp] = MutualInformationHisDis(xV,par2V,par1V,2);
                            cummutMC{j}=cummutM;
                        end
                        if j==1
                            count31 = count;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    count=count+1;
                                    meadatC{count,1} = sprintf('%sb%dt%d',measureC{runind,3},par1V(ipar1),par2V(ipar2));
                                    meadatC{count,2}(j)=cummutMC{j}(ipar2,ipar1);
                                end
                            end
                        else
                            count = count31;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    count=count+1;
                                    meadatC{count,2}(j)=cummutMC{j}(ipar2,ipar1);
                                end
                            end
                        end
                    case 32
                        % First Minimum Mutual Information Equidistant bins, #par = 2, 
                        % 1->b, 2-> tau
                        if measureC{30,1}=='0' | ~strcmp(measureC{30,6},measureC{runind,6}) | ~strcmp(measureC{30,8},measureC{runind,8})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            taumax = max(par2V);
                            [tmp,tmp,minmuttauV] =  MutualInformationHisDis(xV,par2V,par1V,3);
                            minmuttauVC{j}=minmuttauV;
                        else
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            taumax = max(par2V);
                        end
                        if j==1
                            count32 = count;
                            for ipar1=1:length(par1V)
                                count=count+1;
                                meadatC{count,1} = sprintf('%sb%dt%d',measureC{runind,3},par1V(ipar1),taumax);
                                meadatC{count,2}(j)=minmuttauVC{j}(ipar1);
                            end
                        else
                            count = count32;
                            for ipar1=1:length(par1V)
                                count=count+1;
                                meadatC{count,2}(j)=minmuttauVC{j}(ipar1);
                            end
                        end
                    case 33
                        % Mutual Information Equiprobable bins, #par = 2, 
                        % 1->b, 2-> tau
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['par1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,8});
                        eval(['par2V = ',testS,';'])
                        if measureC{34,1}=='0' & measureC{35,1}=='0'
                            [mutM,tmp,tmp] = ...
                                MutualInformationHisPro(xV,par2V,par1V,0);
                        else
                            [mutM,cummutM,minmuttauV] = ...
                                MutualInformationHisPro(xV,par2V,par1V,1);
                            cummutMC{j}=cummutM;
                            minmuttauVC{j}=minmuttauV;
                        end
                        if j==1
                            count33=count;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    count=count+1;
                                    meadatC{count,1} = sprintf('%sb%dt%d',measureC{runind,3},par1V(ipar1),par2V(ipar2));
                                    meadatC{count,2}(j)=mutM(ipar2,ipar1);
                                end
                            end
                        else
                            count = count33;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    count=count+1;
                                    meadatC{count,2}(j)=mutM(ipar2,ipar1);
                                end
                            end
                        end
                    case 34
                        % Cumulative Mutual Information Equiprobable bins, #par = 2, 
                        % 1->b, 2-> tau
                        if measureC{33,1}=='0' | ~strcmp(measureC{33,6},measureC{runind,6}) | ~strcmp(measureC{33,8},measureC{runind,8})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            [tmp,cummutM,tmp] = MutualInformationHisPro(xV,par2V,par1V,2);
                            cummutMC{j}=cummutM;
                        end
                        if j==1
                            count34 = count;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    count=count+1;
                                    meadatC{count,1} = sprintf('%sb%dt%d',measureC{runind,3},par1V(ipar1),par2V(ipar2));
                                    meadatC{count,2}(j)=cummutMC{j}(ipar2,ipar1);
                                end
                            end
                        else
                            count = count34;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    count=count+1;
                                    meadatC{count,2}(j)=cummutMC{j}(ipar2,ipar1);
                                end
                            end
                        end
                    case 35
                        % First Minimum Mutual Information Equiprobable bins, #par = 2, 
                        % 1->b, 2-> tau
                        if measureC{33,1}=='0' | ~strcmp(measureC{33,6},measureC{runind,6}) | ~strcmp(measureC{33,8},measureC{runind,8})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            taumax = max(par2V);
                            [tmp,tmp,minmuttauV] = MutualInformationHisPro(xV,par2V,par1V,3);
                            minmuttauVC{j}=minmuttauV;
                        else
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            taumax = max(par2V);
                        end
                        if j==1
                            count35 = count;
                            for ipar1=1:length(par1V)
                                count=count+1;
                                meadatC{count,1} = sprintf('%sb%dt%d',measureC{runind,3},par1V(ipar1),taumax);
                                meadatC{count,2}(j)=minmuttauVC{j}(ipar1);
                            end
                        else
                            count = count35;
                            for ipar1=1:length(par1V)
                                count=count+1;
                                meadatC{count,2}(j)=minmuttauVC{j}(ipar1);
                            end
                        end
                    case 36
                        % Local Maxima, Feature Statistics, #par = 2, 
                        % 1->filterorder (a), 2->nsam (w)
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['par1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,8});
                        eval(['par2V = ',testS,';'])
                        nstat = 4;
                        testS = sprintf('[%s]',measureC{runind,10});
                        eval(['stat1V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,12});
                        eval(['stat2V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,14});
                        eval(['stat3V = ',testS,';'])
                        testS = sprintf('[%s]',measureC{runind,16});
                        eval(['stat4V = ',testS,';'])
                        [ymaxC,yminC,tminmaxC,tminminC,dminmaxC] = ExtremeFeatureStatistics(xV,par1V,par2V);
                        for istat=1:4
                            ymintsC{istat,j}=yminC{istat};
                            tminmaxtsC{istat,j}=tminmaxC{istat};
                            tminmintsC{istat,j}=tminminC{istat};
                            dminmaxtsC{istat,j}=dminmaxC{istat};
                        end
                        stattxtC = {'MEAN','MEDIAN','SD','IQR'};
                        if j==1
                            count36=count;
                            for istat=1:4
                                eval(['statV = stat',int2str(istat),'V;']);
                                if statV==1
                                    %register
                                    for ipar1=1:length(par1V)
                                        for ipar2=1:length(par2V)
                                            count=count+1;
                                            meadatC{count,1} = sprintf('%s%sa%dw%d',measureC{runind,3},...
                                                char(stattxtC{istat}),par1V(ipar1),par2V(ipar2));
                                            meadatC{count,2}(j)=ymaxC{istat}(ipar1,ipar2);
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for istat
                        else                            
                            count=count36;
                            for istat=1:4
                                eval(['statV = stat',int2str(istat),'V;']);
                                if statV==1
                                    %register
                                    for ipar1=1:length(par1V)
                                        for ipar2=1:length(par2V)
                                            count=count+1;
                                            meadatC{count,2}(j)=ymaxC{istat}(ipar1,ipar2);
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for istat
                        end % if j==1
                    case 37
                        % Local Minima, Feature Statistics, #par = 2, 
                        % 1->filterorder (a), 2->nsam (w)
                        if measureC{36,1}=='0' | ~strcmp(measureC{36,6},measureC{runind,6}) | ~strcmp(measureC{36,8},measureC{runind,8})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            nstat = 4;
                            testS = sprintf('[%s]',measureC{runind,10});
                            eval(['stat1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,12});
                            eval(['stat2V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,14});
                            eval(['stat3V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,16});
                            eval(['stat4V = ',testS,';'])
                            [ymaxC,yminC,tminmaxC,tminminC,dminmaxC] = ExtremeFeatureStatistics(xV,par1V,par2V);
                            for istat=1:4
                                ymintsC{istat,j}=yminC{istat};
                            end
                        end
                        stattxtC = {'MEAN','MEDIAN','SD','IQR'};
                        if j==1
                            count37=count;
                            for istat=1:4
                                eval(['statV = stat',int2str(istat),'V;']);
                                if statV==1
                                    %register
                                    for ipar1=1:length(par1V)
                                        for ipar2=1:length(par2V)
                                            count=count+1;
                                            meadatC{count,1} = sprintf('%s%sa%dw%d',measureC{runind,3},...
                                                char(stattxtC{istat}),par1V(ipar1),par2V(ipar2));
                                            meadatC{count,2}(j)=ymintsC{istat,j}(ipar1,ipar2);
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for istat
                        else                            
                            count=count37;
                            for istat=1:4
                                eval(['statV = stat',int2str(istat),'V;']);
                                if statV==1
                                    %register
                                    for ipar1=1:length(par1V)
                                        for ipar2=1:length(par2V)
                                            count=count+1;
                                            meadatC{count,2}(j)=ymintsC{istat,j}(ipar1,ipar2);
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for istat
                        end % if j==1
                    case 38
                        % Time from Min to Max, Feature Statistics, #par = 2, 
                        % 1->filterorder (a), 2->nsam (w)
                        if measureC{36,1}=='0' | ~strcmp(measureC{36,6},measureC{runind,6}) | ~strcmp(measureC{36,8},measureC{runind,8})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            nstat = 4;
                            testS = sprintf('[%s]',measureC{runind,10});
                            eval(['stat1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,12});
                            eval(['stat2V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,14});
                            eval(['stat3V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,16});
                            eval(['stat4V = ',testS,';'])
                            [ymaxC,yminC,tminmaxC,tminminC,dminmaxC] = ExtremeFeatureStatistics(xV,par1V,par2V);
                            for istat=1:4
                                tminmaxtsC{istat,j}=tminmaxC{istat};
                            end
                        end
                        stattxtC = {'MEAN','MEDIAN','SD','IQR'};
                        if j==1
                            count38=count;
                            for istat=1:4
                                eval(['statV = stat',int2str(istat),'V;']);
                                if statV==1
                                    %register
                                    for ipar1=1:length(par1V)
                                        for ipar2=1:length(par2V)
                                            count=count+1;
                                            meadatC{count,1} = sprintf('%s%sa%dw%d',measureC{runind,3},...
                                                char(stattxtC{istat}),par1V(ipar1),par2V(ipar2));
                                            meadatC{count,2}(j)=tminmaxtsC{istat,j}(ipar1,ipar2);
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for istat
                        else                            
                            count=count38;
                            for istat=1:4
                                eval(['statV = stat',int2str(istat),'V;']);
                                if statV==1
                                    %register
                                    for ipar1=1:length(par1V)
                                        for ipar2=1:length(par2V)
                                            count=count+1;
                                            meadatC{count,2}(j)=tminmaxtsC{istat,j}(ipar1,ipar2);
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for istat
                        end % if j==1
                    case 39
                        % Time from Min to Min, Feature Statistics, #par = 2, 
                        % 1->filterorder (a), 2->nsam (w)
                        if measureC{36,1}=='0' | ~strcmp(measureC{36,6},measureC{runind,6}) | ~strcmp(measureC{36,8},measureC{runind,8})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            nstat = 4;
                            testS = sprintf('[%s]',measureC{runind,10});
                            eval(['stat1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,12});
                            eval(['stat2V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,14});
                            eval(['stat3V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,16});
                            eval(['stat4V = ',testS,';'])
                            [ymaxC,yminC,tminmaxC,tminminC,dminmaxC] = ExtremeFeatureStatistics(xV,par1V,par2V);
                            for istat=1:4
                                tminmintsC{istat,j}=tminminC{istat};
                            end
                        end
                        stattxtC = {'MEAN','MEDIAN','SD','IQR'};
                        if j==1
                            count39=count;
                            for istat=1:4
                                eval(['statV = stat',int2str(istat),'V;']);
                                if statV==1
                                    %register
                                    for ipar1=1:length(par1V)
                                        for ipar2=1:length(par2V)
                                            count=count+1;
                                            meadatC{count,1} = sprintf('%s%sa%dw%d',measureC{runind,3},...
                                                char(stattxtC{istat}),par1V(ipar1),par2V(ipar2));
                                            meadatC{count,2}(j)=tminmintsC{istat,j}(ipar1,ipar2);
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for istat
                        else                            
                            count=count39;
                            for istat=1:4
                                eval(['statV = stat',int2str(istat),'V;']);
                                if statV==1
                                    %register
                                    for ipar1=1:length(par1V)
                                        for ipar2=1:length(par2V)
                                            count=count+1;
                                            meadatC{count,2}(j)=tminmintsC{istat,j}(ipar1,ipar2);
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for istat
                        end % if j==1
                    case 40
                        % Difference of Min from Max, Feature Statistics, #par = 2, 
                        % 1->filterorder (a), 2->nsam (w)
                        if measureC{36,1}=='0' | ~strcmp(measureC{36,6},measureC{runind,6}) | ~strcmp(measureC{36,8},measureC{runind,8})
                            testS = sprintf('[%s]',measureC{runind,6});
                            eval(['par1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,8});
                            eval(['par2V = ',testS,';'])
                            nstat = 4;
                            testS = sprintf('[%s]',measureC{runind,10});
                            eval(['stat1V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,12});
                            eval(['stat2V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,14});
                            eval(['stat3V = ',testS,';'])
                            testS = sprintf('[%s]',measureC{runind,16});
                            eval(['stat4V = ',testS,';'])
                            [ymaxC,yminC,tminmaxC,tminminC,dminmaxC] = ExtremeFeatureStatistics(xV,par1V,par2V);
                            for istat=1:4
                                dminmaxtsC{istat,j}=dminmaxC{istat};
                            end
                        end
                        stattxtC = {'MEAN','MEDIAN','SD','IQR'};
                        if j==1
                            count40=count;
                            for istat=1:4
                                eval(['statV = stat',int2str(istat),'V;']);
                                if statV==1
                                    %register
                                    for ipar1=1:length(par1V)
                                        for ipar2=1:length(par2V)
                                            count=count+1;
                                            meadatC{count,1} = sprintf('%s%sa%dw%d',measureC{runind,3},...
                                                char(stattxtC{istat}),par1V(ipar1),par2V(ipar2));
                                            meadatC{count,2}(j)=dminmaxtsC{istat,j}(ipar1,ipar2);
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for istat
                        else                            
                            count=count40;
                            for istat=1:4
                                eval(['statV = stat',int2str(istat),'V;']);
                                if statV==1
                                    %register
                                    for ipar1=1:length(par1V)
                                        for ipar2=1:length(par2V)
                                            count=count+1;
                                            meadatC{count,2}(j)=dminmaxtsC{istat,j}(ipar1,ipar2);
                                        end % par2
                                    end % par1
                                end % if checked
                            end % for istat
                        end % if j==1
                    case 41
                        % False Nearest Neighbors, #par = 4, 
                        % 1->delay (t); 2->embedding dimension (m);
                        % 3->Theiler window (g); 4->escape factor (e)
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['par1V = ',testS,';']) % delay
                        testS = sprintf('[%s]',measureC{runind,8});
                        eval(['par2V = ',testS,';']) % embedding dimension
                        testS = sprintf('[%s]',measureC{runind,10});
                        eval(['par3V = ',testS,';']) % theiler window
                        testS = sprintf('[%s]',measureC{runind,12});
                        eval(['par4V = ',testS,';']) % escape factor
                        fnnM = FalseNearestNeighbors(xV,par1V,par2V,par4V,par3V);
                        if j==1
                            count41=count;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    count=count+1;
                                    meadatC{count,1} = sprintf('%st%dm%dg%de%d',measureC{runind,3},...
                                        par1V(ipar1),par2V(ipar2),par3V,par4V);
                                    meadatC{count,2}(j)=fnnM(ipar1,ipar2);
                                end % par2
                            end % par1
                        else                            
                            count=count41;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    count=count+1;
                                    meadatC{count,2}(j)=fnnM(ipar1,ipar2);
                                end % par2
                            end % par1
                        end % if j==1
                    case 42
                        % Correlation Dimension, #par = 5, 
                        % 1->delay (t); 2->embedding dimension (m);
                        % 3->Theiler window (g); 4->upper/lower ratio of
                        % scaling window (e); 5->number of radii, resolution (o)
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['par1V = ',testS,';']) % delay
                        testS = sprintf('[%s]',measureC{runind,8});
                        eval(['par2V = ',testS,';']) % embedding dimension
                        testS = sprintf('[%s]',measureC{runind,10});
                        eval(['par3V = ',testS,';']) % theiler window
                        testS = sprintf('[%s]',measureC{runind,12});
                        eval(['par4V = ',testS,';']) % upper/lower ratio 
                        testS = sprintf('[%s]',measureC{runind,14});
                        eval(['par5V = ',testS,';']) % number of radii, resolution
                        nuT = CorrelationDimension(xV,par1V,par2V,par3V,par4V,par5V);
                        if j==1
                            count42=count;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    for ipar4=1:length(par4V)
                                        count=count+1;
                                        meadatC{count,1} = sprintf('%st%dm%dg%ds%do%d',measureC{runind,3},...
                                        par1V(ipar1),par2V(ipar2),par3V,par4V(ipar4),par5V);
                                        meadatC{count,2}(j)=nuT(ipar1,ipar2,ipar4);
                                    end % par4
                                end % par2
                            end % par1
                        else                            
                            count=count42;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    for ipar4=1:length(par4V)
                                        count=count+1;
                                        meadatC{count,2}(j)=nuT(ipar1,ipar2,ipar4);
                                    end % par4
                                end % par2
                            end % par1
                        end % if j==1
                    case 43
                        % Correlation Sum for given radius, #par =4, 
                        % 1-> radius (r), 2->delay (t); 
                        % 3->embedding dimension (m); 4->Theiler window (g)
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['par1V = ',testS,';']) % radius
                        testS = sprintf('[%s]',measureC{runind,8});
                        eval(['par2V = ',testS,';']) % delay
                        testS = sprintf('[%s]',measureC{runind,10});
                        eval(['par3V = ',testS,';']) % embedding dimension
                        testS = sprintf('[%s]',measureC{runind,12});
                        eval(['par4V = ',testS,';']) % theiler window 
                        corsumT = CorrelationSum(xV,par1V,par2V,par3V,par4V);
                        if j==1
                            count43=count;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    for ipar3=1:length(par3V)
                                        count=count+1;
                                        meadatC{count,1} = sprintf('%sr%dt%dm%dg%d',measureC{runind,3},...
                                        round(100*par1V(ipar1)),par2V(ipar2),par3V(ipar3),par4V);
                                        meadatC{count,2}(j)=corsumT(ipar1,ipar2,ipar3);
                                    end % par3
                                end % par2
                            end % par1
                        else                            
                            count=count43;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    for ipar3=1:length(par3V)
                                        count=count+1;
                                        meadatC{count,2}(j)=corsumT(ipar1,ipar2,ipar3);
                                    end % par3
                                end % par2
                            end % par1
                        end % if j==1
                    case 44
                        % Radius for given Correlation Sum, #par =4, 
                        % 1-> correlation sum (c), 2->delay (t); 
                        % 3->embedding dimension (m); 4->Theiler window (g)
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['par1V = ',testS,';']) % correlation sum
                        testS = sprintf('[%s]',measureC{runind,8});
                        eval(['par2V = ',testS,';']) % delay
                        testS = sprintf('[%s]',measureC{runind,10});
                        eval(['par3V = ',testS,';']) % embedding dimension
                        testS = sprintf('[%s]',measureC{runind,12});
                        eval(['par4V = ',testS,';']) % theiler window 
                        radiusT = RadiusCorrelationSum(xV,par1V,par2V,par3V,par4V);
                        if j==1
                            count44=count;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    for ipar3=1:length(par3V)
                                        count=count+1;
                                        meadatC{count,1} = sprintf('%sc%dt%dm%dg%d',measureC{runind,3},...
                                        round(100*par1V(ipar1)),par2V(ipar2),par3V(ipar3),par4V);
                                        meadatC{count,2}(j)=radiusT(ipar1,ipar2,ipar3);
                                    end % par3
                                end % par2
                            end % par1
                        else                            
                            count=count44;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    for ipar3=1:length(par3V)
                                        count=count+1;
                                        meadatC{count,2}(j)=radiusT(ipar1,ipar2,ipar3);
                                    end % par3
                                end % par2
                            end % par1
                        end % if j==1
                    case 45
                        % Kolmogorov-Sinai Entropy is not implemented yet
                    case 46
                        % Aprroximate Entropy, #par =4, 
                        % 1-> radius (r), 2->delay (t); 
                        % 3->embedding dimension (m); 4->Theiler window (g)
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['par1V = ',testS,';']) % radius
                        testS = sprintf('[%s]',measureC{runind,8});
                        eval(['par2V = ',testS,';']) % delay
                        testS = sprintf('[%s]',measureC{runind,10});
                        eval(['par3V = ',testS,';']) % embedding dimension
                        testS = sprintf('[%s]',measureC{runind,12});
                        eval(['par4V = ',testS,';']) % theiler window 
                        apenT = ApproximateEntropy(xV,par1V,par2V,par3V,par4V);
                        if j==1
                            count46=count;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    for ipar3=1:length(par3V)
                                        count=count+1;
                                        meadatC{count,1} = sprintf('%sr%dt%dm%dg%d',measureC{runind,3},...
                                        round(100*par1V(ipar1)),par2V(ipar2),par3V(ipar3),par4V);
                                        meadatC{count,2}(j)=apenT(ipar1,ipar2,ipar3);
                                    end % par3
                                end % par2
                            end % par1
                        else                            
                            count=count46;
                            for ipar1=1:length(par1V)
                                for ipar2=1:length(par2V)
                                    for ipar3=1:length(par3V)
                                        count=count+1;
                                        meadatC{count,2}(j)=apenT(ipar1,ipar2,ipar3);
                                    end % par3
                                end % par2
                            end % par1
                        end % if j==1
                    case 47
                        % Algorithmic Complexity, equidistant bins, #par=1, 
                        % 1-> number of bins (b)
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['par1V = ',testS,';'])
                        acV=AlgorithmicComplexityHisDis(xV,par1V);
                        if j==1
                            count47=count;
                            for ipar1=1:length(par1V)
                                count=count+1;
                                meadatC{count,1} = sprintf('%sb%d',measureC{runind,3},...
                                    par1V(ipar1));
                                meadatC{count,2}(j)=acV(ipar1);
                            end % par1
                        else                            
                            count=count47;
                            for ipar1=1:length(par1V)
                                count=count+1;
                                meadatC{count,1} = sprintf('%sb%d',measureC{runind,3},...
                                    par1V(ipar1));
                                meadatC{count,2}(j)=acV(ipar1);
                            end % par1
                        end % if j==1
                    case 48
                        % Algorithmic Complexity, equiprobable bins, #par=1, 
                        % 1-> number of bins (b)
                        testS = sprintf('[%s]',measureC{runind,6});
                        eval(['par1V = ',testS,';'])
                        acV=AlgorithmicComplexityHisPro(xV,par1V);
                        if j==1
                            count48=count;
                            for ipar1=1:length(par1V)
                                count=count+1;
                                meadatC{count,1} = sprintf('%sb%d',measureC{runind,3},...
                                    par1V(ipar1));
                                meadatC{count,2}(j)=acV(ipar1);
                            end % par1
                        else                            
                            count=count48;
                            for ipar1=1:length(par1V)
                                count=count+1;
                                meadatC{count,1} = sprintf('%sb%d',measureC{runind,3},...
                                    par1V(ipar1));
                                meadatC{count,2}(j)=acV(ipar1);
                            end % par1
                        end % if j==1
                    case 49
                        % Time Series mean
                        if j==1
                            count49=count;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=mean(xV);
                        else                            
                            count=count49;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=mean(xV);
                        end % if j==1
                    case 50
                        % Time Series median
                        if j==1
                            count50=count;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=median(xV);
                        else                            
                            count=count50;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=median(xV);
                        end % if j==1
                    case 51
                        % Time Series variance
                        if j==1
                            count51=count;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=var(xV);
                        else                            
                            count=count51;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=var(xV);
                        end % if j==1
                    case 52
                        % Time Series standard deviation
                        if j==1
                            count52=count;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=std(xV);
                        else                            
                            count=count52;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=std(xV);
                        end % if j==1
                    case 53
                        % Time Series interquartile range
                        if j==1
                            count53=count;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=iqr(xV);
                        else                            
                            count=count53;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=iqr(xV);
                        end % if j==1
                    case 54
                        % Time Series skewness
                        if j==1
                            count54=count;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=skewness(xV);
                        else                            
                            count=count54;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=skewness(xV);
                        end % if j==1
                    case 55
                        % Time Series kurtosis
                        if j==1
                            count55=count;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=kurtosis(xV);
                        else                            
                            count=count55;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=kurtosis(xV);
                        end % if j==1
                    case 56
                        % Hjorth Mobility
                        [mobility,complexity] = HjorthParameters(xV);
                        complexityC{j} = complexity;
                        if j==1
                            count56=count;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=mobility;
                        else                            
                            count=count56;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=mobility;
                        end % if j==1
                    case 57
                        % Hjorth Complexity
                        if measureC{56,1}=='0'
                            [mobility,complexity] = HjorthParameters(xV);
                            complexityC{j} = complexity;
                        end
                        if j==1
                            count57=count;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=complexityC{j};
                        else                            
                            count=count57;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=complexityC{j};
                        end % if j==1
                    case 58
                        % Hurst Exponent
                        Hurst=HurstExponent(xV);
                        if j==1
                            count58=count;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=Hurst;
                        else                            
                            count=count58;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=Hurst;
                        end % if j==1
                    case 59
                        % detrended fluctuation analysis
                        dfa=DetrendedFluctuation(xV);
                        if j==1
                            count59=count;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=dfa;
                        else                            
                            count=count59;
                            count=count+1;
                            meadatC{count,1} = sprintf('%s',measureC{runind,3});
                            meadatC{count,2}(j)=dfa;
                        end % if j==1
                    otherwise
                        error('No cases more than 56.')
                end % switch
            end % for data
            messageS = sprintf('%s \n ',messageS);
            set(handles.edit1,'String',messageS);
        end % for measures
    end % if empty datalist
end % if empty measurelist
% Generate a string array with the names of the active data sets
if exist('meadatC')==1
    setappdata(0,'mealist',meadatC);
    setappdata(0,'datnameM',dat(:,1));
    uiwait(guiselectmeasures,1);
    delete(guiselectmeasures)
else
    flagtxt = 'No measures have been computed, please select measures.';
    messageS = sprintf('%s \n %s',messageS,flagtxt);
    set(handles.edit1,'String',messageS);
end

% --- Executes on button press in Cancel button.
function pushbutton12_Callback(hObject, eventdata, handles)
delete(guiselectmeasures)

% --- Executes on button press in Help button.
function pushbutton13_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\SelectRunMeasures.htm'')'])


function edit1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Reset Default Parameters button.
function pushbutton17_Callback(hObject, eventdata, handles)
fullpath = 'defaultmeasures.txt';
measureC=readmeasureparameters(fullpath);
setappdata(0,'parlist',measureC);
messageS = sprintf('The parameters are set to their default values.\n');
set(handles.edit1,'String',messageS);

