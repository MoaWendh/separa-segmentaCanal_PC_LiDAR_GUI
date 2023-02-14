function varargout = separaSegementaCanal_PC_LiDAR__GUI(varargin)
% SEPARASEGEMENTACANAL_PC_LIDAR__GUI MATLAB code for separaSegementaCanal_PC_LiDAR__GUI.fig
%      SEPARASEGEMENTACANAL_PC_LIDAR__GUI, by itself, creates a new SEPARASEGEMENTACANAL_PC_LIDAR__GUI or raises the existing
%      singleton*.
%
%      H = SEPARASEGEMENTACANAL_PC_LIDAR__GUI returns the handle to a new SEPARASEGEMENTACANAL_PC_LIDAR__GUI or the handle to
%      the existing singleton*.
%
%      SEPARASEGEMENTACANAL_PC_LIDAR__GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEPARASEGEMENTACANAL_PC_LIDAR__GUI.M with the given input arguments.
%
%      SEPARASEGEMENTACANAL_PC_LIDAR__GUI('Property','Value',...) creates a new SEPARASEGEMENTACANAL_PC_LIDAR__GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before separaSegementaCanal_PC_LiDAR__GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to separaSegementaCanal_PC_LiDAR__GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help separaSegementaCanal_PC_LiDAR__GUI

% Last Modified by GUIDE v2.5 14-Feb-2023 17:47:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @separaSegementaCanal_PC_LiDAR__GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @separaSegementaCanal_PC_LiDAR__GUI_OutputFcn, ...
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


% --- Executes just before separaSegementaCanal_PC_LiDAR__GUI is made visible.
function separaSegementaCanal_PC_LiDAR__GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to separaSegementaCanal_PC_LiDAR__GUI (see VARARGIN)

% Abaixo foi crada uma Lookup table contendo a nomenclatura dos verdadeiros canais e seus
% respectivos ângulos:
handles.lookUpTable= { 'cn00_15_graus_neg';
                       'cn02_13_graus_neg';
                       'cn04_11_graus_neg';
                       'cn06_09_graus_neg';
                       'cn08_07_graus_neg';
                       'cn10_05_graus_neg';
                       'cn12_03_graus_neg';
                       'cn14_01_graus_neg';
                       'cn01_01_graus_pos';
                       'cn03_03_graus_pos';
                       'cn05_05_graus_pos';
                       'cn07_07_graus_pos';
                       'cn09_09_graus_pos';
                       'cn11_11_graus_pos';
                       'cn13_13_graus_pos';
                       'cn15_15_graus_pos'};

% Definiçção de alguns handles: 
handles.statusProgram= 'Aguardando comando.'
handles.pathBase= 'C:\Projetos\Matlab';

% Minhas variáveis e parâmetros:
handles.folderToSaveSep= 'canalSeparado';
handles.folderToSaveSeg= '\canalSegmentado';

handles.extPC= 'pcd';

% Choose default command line output for separaSegementaCanal_PC_LiDAR__GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes separaSegementaCanal_PC_LiDAR__GUI wait for user response (see UIRESUME)
% uiwait(handles.baseFigure);

% --- Outputs from this function are returned to the command line.
function varargout = separaSegementaCanal_PC_LiDAR__GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on button press in pushSair.
function pushSair_Callback(hObject, eventdata, handles)
% hObject    handle to pushSair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.baseFigure.HandleVisibility= 'on';
clc;
close all;


% --- Executes on button press in pbSeparaCanais.
function pbSeparaCanais_Callback(hObject, eventdata, handles)
% hObject    handle to pbSeparaCanais (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Define a(s) PC(s) cujos canais serão separados:
path= sprintf('%s%s', handles.pathBase,'\*.pcd');
[handles.filesParaSeparar, handles.path]= uigetfile(path,'MultiSelect', 'on');

if iscell(handles.filesParaSeparar) || (length(handles.filesParaSeparar)>1)
    handles.statusProgram= 'Separando canais...';
    handles.staticShowStatusSepara.String= handles.statusProgram; 
    handles.staticShowStatusSepara.ForegroundColor= [0.467, 0.675, 0.188];
    
    % Chama a função principal que irá separar os canais:
    handles= fSeparaCanais(handles);
    
    handles.staticShowStatusSepara.String= handles.statusProgram;
    handles.pathBase= handles.path;
else    
    msg= sprintf(' Seleção das PCs foi cancelada! \n Reinicialize o procedimento.');
    handles.staticShowStatusSepara.String= msg;
    handles.staticShowStatusSepara.ForegroundColor= [1, 0, 0];
    % Exibe msg de erro:
    figMsg= msgbox(msg);
    uiwait(figMsg);
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in chkEscolherCanalSequencia.
function chkEscolherCanalSequencia_Callback(hObject, eventdata, handles)
% hObject    handle to chkEscolherCanalSequencia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkEscolherCanalSequencia


function editCanalSemSequencia_Callback(hObject, eventdata, handles)
% hObject    handle to editCanalSemSequencia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCanalSemSequencia as text
%        str2double(get(hObject,'String')) returns contents of editCanalSemSequencia as a double

% Obs.: A entrada dos canais pode ser feita de três formas:
% 1ª) Na sequência separados por ":", exemplo: 1:16, 5:10, 15:16;
% 2º) Mais de um canal sem sequência separados por ",", exemplo: 3, 5, 7;
% 3ª) Individulamente, exemplo: 9;

handles.cnSepara= str2num(hObject.String);
handles.valMax= max(handles.cnSepara);
handles.valMin= min(handles.cnSepara);
if (handles.valMax>16 || handles.valMin<1)
    hObject.String= 'Erro! Val. inválido: (>1 e <16)';
    hObject.ForegroundColor= [1, 0, 0];
    f = msgbox('Valor inválido!!', 'Error','error');
else
    hObject.ForegroundColor= [0, 0.447, 0.471];   
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editCanalSemSequencia_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCanalSemSequencia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.cnSepara= str2num(hObject.String);
handles.valMax= max(handles.cnSepara);
handles.valMin= min(handles.cnSepara);

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in pbSegmentaCanal.
function pbSegmentaCanal_Callback(hObject, eventdata, handles)
% hObject    handle to pbSegmentaCanal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Define a(s) PC(s) cujos canais serão separados:
path= sprintf('%s%s', handles.pathBase,'\*.pcd');
[handles.filesParaSegmentar, handles.pathFilesParaSegmentar]= uigetfile(path,'MultiSelect', 'on');

if (handles.pathFilesParaSegmentar==0)
    msg= sprintf('Escolha da PC para segmetnação foi cancelada!!!!!');
    handles.statusProgram= msg;
    handles.staticShowStatusSegmenta.String= handles.statusProgram;
    handles.staticShowStatusSegmenta.ForegroundColor= [1, 0, 0];
    % Exibe msg de erro:
    msgbox(msg, 'Escolha cancelada','error');
else 
    handles.statusProgram= "Segmentando...";
    handles.staticShowStatusSegmenta.String= handles.statusProgram;
    handles.staticShowStatusSegmenta.ForegroundColor= [0.467, 0.675, 0.188];
    
    % Chama a função principal que irá segmentar os canais:
    handles= fSegmentaPCPorCanal(handles);
    
    % Atualiza status do programa:
    handles.staticShowStatusSegmenta.String= handles.statusProgram;  
    
    handles.pathBase= handles.pathFilesParaSegmentar;
end

% Update handles structure
guidata(hObject, handles);



function editThresholdMin_Callback(hObject, eventdata, handles)
% hObject    handle to editThresholdMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editThresholdMin as text
%        str2double(get(hObject,'String')) returns contents of editThresholdMin as a double

handles.valThresholdMinDistance= str2num(hObject.String);

% Update handles structure
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function editThresholdMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editThresholdMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.valThresholdMinDistance= str2num(hObject.String);

% Update handles structure
guidata(hObject, handles);


function editNumMimPoints_Callback(hObject, eventdata, handles)
% hObject    handle to editNumMimPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNumMimPoints as text
%        str2double(get(hObject,'String')) returns contents of editNumMimPoints as a double

handles.valMinPoints= str2num(hObject.String);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editNumMimPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNumMimPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.valMinPoints= str2num(hObject.String);

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in radioExibePointCloud.
function radioExibePointCloud_Callback(hObject, eventdata, handles)
% hObject    handle to radioExibePointCloud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioExibePointCloud

handles.habShowPC= hObject.Value;

% Update handles structure
guidata(hObject, handles);



function editThresholdMax_Callback(hObject, eventdata, handles)
% hObject    handle to editThresholdMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editThresholdMax as text
%        str2double(get(hObject,'String')) returns contents of editThresholdMax as a double

handles.valThresholdMaxDistance= str2num(hObject.String);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editThresholdMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editThresholdMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.valThresholdMaxDistance= str2num(hObject.String);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in radioHabSegFuncaoMatlab.
function radioHabSegFuncaoMatlab_Callback(hObject, eventdata, handles)
% hObject    handle to radioHabSegFuncaoMatlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioHabSegFuncaoMatlab
if hObject.Value
    handles.editNumMimPoints.Enable= 'on';
    handles.editDistanciaMinimaEntreClusters.Enable= 'on';
    handles.editNumMaxPoints.Enable= 'on';
    handles.habSegmentacaoNatMatlab= 1;
else
    handles.editNumMimPoints.Enable= 'off';
    handles.editDistanciaMinimaEntreClusters.Enable= 'off';
    handles.editNumMaxPoints.Enable= 'off';
    handles.habSegmentacaoNatMatlab= 0;
end

% Update handles structure
guidata(hObject, handles);

function editNumMaxPoints_Callback(hObject, eventdata, handles)
% hObject    handle to editNumMaxPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNumMaxPoints as text
%        str2double(get(hObject,'String')) returns contents of editNumMaxPoints as a double
handles.valMaxPoints= str2num(hObject.String);

% Update handles structure
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function editNumMaxPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNumMaxPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.F
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.valMaxPoints= str2num(hObject.String);

% Update handles structure
guidata(hObject, handles);


function editDistanciaMinimaEntreClusters_Callback(hObject, eventdata, handles)
% hObject    handle to editDistanciaMinimaEntreClusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDistanciaMinimaEntreClusters as text
%        str2double(get(hObject,'String')) returns contents of editDistanciaMinimaEntreClusters as a double


% O parâmetro "handles.valMinDistance" define a distância mínima que deve existir entre 2 ou mais cluster:
handles.valMinDistance= str2num(hObject.String);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editDistanciaMinimaEntreClusters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDistanciaMinimaEntreClusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% O parâmetro "handles.valMinDistance" define a distância mínima que deve existir entre 2 ou mais cluster:
handles.valMinDistance= str2num(hObject.String);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function radioHabSegFuncaoMatlab_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radioHabSegFuncaoMatlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.habSegmentacaoNatMatlab= 0;

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function radioExibePointCloud_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radioExibePointCloud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.habShowPC= hObject.Value;
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in rdHabSavePcSegmented.
function rdHabSavePcSegmented_Callback(hObject, eventdata, handles)
% hObject    handle to rdHabSavePcSegmented (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdHabSavePcSegmented
handles.habSavePCSeg= hObject.Value;

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function rdHabSavePcSegmented_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rdHabSavePcSegmented (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: get(hObject,'Value') returns toggle state of rdHabSavePcSegmented
handles.habSavePCSeg= hObject.Value;

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in pbVisualizarPC.
function pbVisualizarPC_Callback(hObject, eventdata, handles)
% hObject    handle to pbVisualizarPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Define a(s) PC(s) ´para exibição:
path= sprintf('%s%s', handles.pathBase,'\*.pcd');
[pcFile, pathPC]= uigetfile(path,'MultiSelect', 'on');

if iscell(pcFile) || (length(pcFile)>1)
    fullPath= fullfile(pathPC, pcFile);
    pc= pcread(fullPath);
    f= figure;
    f.WindowState= 'maximized';
    pcshow(pc.Location);
    msg= sprintf('Nuvem de pontos: %s', pcFile);
    title(msg);
    
    xlabel('X (m)');
    ylabel('Y (m)');
    zlabel('Z (m)');
    
    handles.pathBase= pathPC;
end    

% Update handles structure
guidata(hObject, handles);



