function varargout = guimeasurrogateplot(varargin)
%========================================================================
%     <AAFTsur.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guimeasurrogateplot_OpeningFcn, ...
                   'gui_OutputFcn',  @guimeasurrogateplot_OutputFcn, ...
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


% --- Executes just before guimeasurrogateplot is made visible.
function guimeasurrogateplot_OpeningFcn(hObject, eventdata, handles, varargin)
% Fill in listbox1 with time series names
datnameM = getappdata(0,'datnameM');
set(handles.popupmenu2,'Value',1) % At start use the first choice from the popupmenu
surtypeS = get(handles.popupmenu2,'String');
surtypeS = char(surtypeS{1});
surdatindV = surinlist(datnameM,surtypeS);
set(handles.text1,'String',sprintf('Select %s resampled time series',surtypeS));
if isempty(surdatindV)
    set(handles.listbox1,'String','Empty list','Value',1)
else
    set(handles.listbox1,'Max',length(surdatindV))
    set(handles.listbox1,'String',datnameM(surdatindV,:),'Value',1)
end
% Fill in listbox2 with measure names
meadatC = getappdata(0,'mealist');
set(handles.listbox2,'Max',size(meadatC(:,1),1))
listdatS = meadatC{1,1};
for i=2:size(meadatC(:,1),1)
    listdatS = str2mat(listdatS,meadatC{i,1});
end
set(handles.listbox2,'String',listdatS,'Value',1)
set(handles.popupmenu1,'Value',1) % At start use the first choice from the popupmenu

handles.current_surdatind = surdatindV;
handles.current_dataname = datnameM;
handles.current_meadat = meadatC;

messageS = sprintf('Graph measures vs resampled time series index of a specific type: \n The given resampled time series names should differ only with respect to the resampled time series index, otherwise they are ignored. \n When up to 5 measures are selected, they are listed in a legend. \n Otherwise they are listed in this text box (matlab color and symbol syntax for the measures).');
set(handles.edit1,'String',messageS);

% Choose default command line output for guimeasurrogateplot
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

function surdatindV = surinlist(datnameM,surtypeS)
% Finds the indices of the data list that match a resampling type
ndatname = size(datnameM,1);
surdatindV = [];
for i=1:ndatname
    datnamenow = char(datnameM(i,:));
    indV =  strfind(datnamenow,surtypeS);
    if ~isempty(indV)
        ind = indV(end);
        if ind+length(surtypeS)<=length(datnamenow) ...
                & ~isempty(str2num(datnamenow(ind+length(surtypeS)))) ...
                & datnamenow(ind-1)~='A' & datnamenow(ind-1)~='I' 
            surdatindV = [surdatindV; i];
        end
    end
end

% --- Outputs from this function are returned to the command line.
function varargout = guimeasurrogateplot_OutputFcn(hObject, eventdata, handles) 
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

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in View Selected Plot button.
function pushbutton1_Callback(hObject, eventdata, handles)
datalist_entries = get(handles.listbox1,'String');
dataindex_selected = get(handles.listbox1,'Value');
measurelist_entries = get(handles.listbox2,'String');
measureindex_selected = get(handles.listbox2,'Value');
cols=length(measureindex_selected); 
surtypeval = get(handles.popupmenu2,'Value');
surtypeS = get(handles.popupmenu2,'String');
surtypeS = char(surtypeS{surtypeval});

normsurr = get(handles.checkbox1,'Value'); % if activated then normalize data
disptest = get(handles.checkbox2,'Value'); % if activated then display test

if isempty(dataindex_selected)
    messageS = sprintf('At least one resampled time series should be selected for displaying the graph measures vs resampled time series index (the original time series gets index 0.');
    set(handles.edit1,'String',messageS);
else
    rows=length(dataindex_selected);
    datnameM = handles.current_dataname;
    meadatC = handles.current_meadat;
    surdatindV = handles.current_surdatind;
    datnamelist = datnameM(surdatindV(dataindex_selected),:);
    messageS = ''; % To be ready to show a new message
    foundnum = 1;
    i=1;
    while i<=rows & foundnum==1
        datnamenowS = char(datnamelist{i});
        indV =  strfind(datnamenowS,surtypeS);
        ind = indV(end);
        datnameleft = datnamenowS(1:ind-1);
        datnameleftlength = length(datnameleft);
        j=datnameleftlength+length(surtypeS)+1;
        while j<=length(datnamenowS) & foundnum==1
            if ~isempty(str2num(datnamenowS(j)))
                j=j+1;
            else
                foundnum=0;
            end
        end
        if j<=length(datnamenowS)
            datnameright = datnamenowS(j:end);
        else
            datnameright = [];
        end
        i = i+1;
    end % Here we found the datnameleft and datnameright of the time series name
    surM = [];
    for i=1:rows
        datnamenowS = char(datnamelist{i});
        if length(datnamenowS)>=datnameleftlength & strmatch(datnameleft,datnamenowS(1:datnameleftlength),'exact') 
            j=datnameleftlength+length(surtypeS)+1;
            foundnum = 1;
            while j<=length(datnamenowS) & foundnum==1
                if ~isempty(str2num(datnamenowS(j)))
                    j=j+1;
                else
                    foundnum=0;
                end
            end
            candnum = datnamenowS(datnameleftlength+length(surtypeS)+1:j-1);
            if (isempty(datnameright) & j>length(datnamenowS)) | (~isempty(datnameright) & ~isempty(datnamenowS(j:end)) & strmatch(datnameright,datnamenowS(j:end),'exact')) 
                surM = [surM; [surdatindV(dataindex_selected(i)) str2num(candnum)]];
            end
        end
    end
    % Check whether the original time series is in the data list and if 
    % there exists add it in the list of resampled time series with index 0.
    oridatname = sprintf('%s%s',datnameleft,datnameright);
    oriind = strmatch(oridatname,datnameM,'exact');
    if ~isempty(oriind)
        surM = [[oriind 0];surM];
    end
    if size(surM,1)==1
        messageS = sprintf('At least one resampled time series should be selected for displaying the graph measures vs resampled time series index.');
        set(handles.edit1,'String',messageS);
    else
        meanamelist = [];
        nsur = size(surM,1);
        plottableM = NaN*ones(nsur,cols);
        for j=1:cols
            meanamelist{j}=meadatC{measureindex_selected(j),1};
            for i=1:nsur
                plottableM(i,j)= meadatC{measureindex_selected(j),2}(surM(i,1));
            end
        end
        % For better display of the measure name, drop the underscore where it
        % appears.
        meanamelist2 = replacesymbol(meanamelist,'_',''); 
        if normsurr
            mplottableV = mean(plottableM);
            sdplottableV = std(plottableM);
            plottableM = (plottableM - kron(mplottableV,ones(nsur,1)))./kron(sdplottableV,ones(nsur,1));
        end
        drawtype = get(handles.popupmenu1,'Value');
        if disptest & ~isempty(oriind)
            % Make a seperate test and a plot displaying the test results for each
            % measure
            for icol=1:cols
                meavalV = plottableM(:,icol);
                % Parametric test - p-value
                msmeaval = mean(meavalV(2:nsur));
                sdsmeaval = std(meavalV(2:nsur));
                testpar = (meavalV(1)-msmeaval)/sdsmeaval;
                pvalpar = 2*(1-normcdf(abs(testpar)));
                % Nonparametric test - p-value
                [omeavalV,imeavalV]=sort(meavalV);
                iorigmea = find(imeavalV==1);
                omeavalV(iorigmea)=[];
                if iorigmea<nsur/2
                    pvalnpar = 2*(iorigmea-0.5)/nsur;
                else
                    pvalnpar = 2*(1 -(iorigmea-0.5)/nsur);
                    omeavalV = flipud(omeavalV);
                end
                % Plot measure values, parametric test limits and display
                % test results on the title text
                handles.PlotFigure = figure('NumberTitle','Off','Name',...
                    'Measure vs Resampled Time Series',...
                   'PaperOrientation','Landscape');
                if meavalV(1)>0
                    meacritV = [1.9600 2.5758]'*sdsmeaval+msmeaval;
                else
                    meacritV = [-1.9600 -2.5758]'*sdsmeaval+msmeaval;
                end
                plot([-1 nsur],meacritV(1)*[1 1],'r--')
                hold on
                plot([-1 nsur],meacritV(2)*[1 1],'r-.')
                if drawtype==1
                    plot([0:nsur-1]',[meavalV(1);omeavalV],'-k','Markersize',8,'linewidth',2);
                elseif drawtype==2
                    plot([0:nsur-1]',[meavalV(1);omeavalV],'.k','Markersize',8,'linewidth',2);
                else
                    plot([0:nsur-1]',[meavalV(1);omeavalV],'.-k','Markersize',8,'linewidth',2);
                end
                xlabel('resampling index (0 for the original)')
                plot(surM(1,2),meavalV(1),'ok','Markersize',12)
                if normsurr
                    ylabel(sprintf('normalized %s',meanamelist2{icol}))
                else
                    ylabel(sprintf('%s',meanamelist2{icol}))
                end
                legend('\alpha=0.05(param)','\alpha=0.01(param)','Location','Best')
                ax = axis;
                axis([-1 nsur ax(3) ax(4)])       
                if isempty(datnameright)
                    tstxt = sprintf('%s%s<index>',datnameleft,surtypeS);
                else
                    tstxt = sprintf('%s%s<index>%s',datnameleft,surtypeS,datnameright);
                end
                if ~kstest(meavalV(2:nsur))
                    testtxt = sprintf('p-value: %1.4f(param,normality accepted) %1.4f(nonparam)',...
                       pvalpar,pvalnpar); 
                else
                    testtxt = sprintf('p-value: %1.4f(param,normality rejected) %1.4f(nonparam)',...
                       pvalpar,pvalnpar); 
                end
                title(sprintf('Time series %s \n %s',...
                    tstxt,testtxt))
            end % for cols
        else
            if drawtype==1
                symbV = str2mat('-k','--k','-c','-r','--c','--r','-.k',':k','-.c','-.r',':c',':r');
            elseif drawtype==2
                symbV = str2mat('ok','xk','+k','*k','oc','or','xc','xr','+c','+r','*c','*r');
            else
                symbV = str2mat('o-k','x--k','+-.k','*:k','o-c','o-r','x--c','x--r','+-.c','+-.r','*:c','*:r');
            end
            nsymb = size(symbV,1);

            handles.PlotFigure = figure('NumberTitle','Off','Name','Measures vs Resampled Time Series',...
                'PaperOrientation','Landscape');
            eval(['plot(surM(:,2),plottableM(:,1),''',symbV(1,:),''',''Markersize'',8,''linewidth'',2);'])
            hold on
            for j=2:cols
                k = mod(j-1,nsymb)+1;
                eval(['plot(surM(:,2),plottableM(:,j),''',symbV(k,:),''',''Markersize'',8,''linewidth'',2);'])
            end
            if cols<=5
                eval(['leg = legend([meanamelist2],''location'',''Best'');'])
                % set(leg,'EdgeColor',[1 1 1])
            else
                for j=1:cols
                    k = mod(j-1,nsymb)+1;
                    messageS = sprintf('%s ''%s'': %s \n',messageS,symbV(k,:),char(meanamelist{j}));
                end
                set(handles.edit1,'String',messageS);
            end
            if ~isempty(oriind)
                xlabel('resampling index (0 for the original)')
                if drawtype==1
                    for j=1:cols
                        plot(surM(1,2),plottableM(1,j),'ok')
                    end
                else
                    for j=1:cols
                        plot(surM(1,2),plottableM(1,j),'ok','Markersize',12)
                    end
                end
            else
                xlabel('resampling index')
            end
            ylabel('measure')
            ax = axis;
            axis([ax(1)-1 ax(2)+1 ax(3) ax(4)])
            if isempty(datnameright)
                title(sprintf('Time series %s%s<index>',datnameleft,surtypeS))
            else
                title(sprintf('Time series %s%s<index>%s',datnameleft,surtypeS,datnameright))
            end
            if cols<=5
                messageS = sprintf('Graph measures vs resampling index: \n The given time series names should differ only with respect to the resampled time series index (0 for the original time series if it exists), otherwise they are ignored. \n When up to 5 measures are selected, they are listed in a legend. \n Otherwise they are listed in this text box (matlab color and symbol syntax for the measures).');
                set(handles.edit1,'String',messageS);
            end
        end % if disptest
    end % if size(surM,1)==1
end % if isempty(dataindex_selected)
guidata(hObject, handles);

% --- Executes on button press in Exit button.
function pushbutton2_Callback(hObject, eventdata, handles)
delete(guimeasurrogateplot)

% --- Executes on button press in Help button.
function pushbutton3_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\ViewMeasureResampled.htm'')'])

function edit1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
datnameM = handles.current_dataname;
surtypeval = get(handles.popupmenu2,'Value');
surtypeS = get(handles.popupmenu2,'String');
surtypeS = char(surtypeS{surtypeval});
set(handles.text1,'String',sprintf('Select %s resampling time series',surtypeS));
surdatindV = surinlist(datnameM,surtypeS);
if isempty(surdatindV)
    set(handles.listbox1,'String','Empty list','Value',1)
else
    set(handles.listbox1,'Max',length(surdatindV))
    set(handles.listbox1,'String',datnameM(surdatindV,:),'Value',1)
end
handles.current_surdatind = surdatindV;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)

