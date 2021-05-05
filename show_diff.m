function varargout = show_diff(varargin)
% SHOW_DIFF MATLAB code for show_diff.fig
%      SHOW_DIFF, by itself, creates a new SHOW_DIFF or raises the existing
%      singleton*.
%
%      H = SHOW_DIFF returns the handle to a new SHOW_DIFF or the handle to
%      the existing singleton*.
%
%      SHOW_DIFF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHOW_DIFF.M with the given input arguments.
%
%      SHOW_DIFF('Property','Value',...) creates a new SHOW_DIFF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before show_diff_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to show_diff_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help show_diff

% Last Modified by GUIDE v2.5 01-May-2021 22:11:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @show_diff_OpeningFcn, ...
                   'gui_OutputFcn',  @show_diff_OutputFcn, ...
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

end


% --- Executes just before show_diff is made visible.
function show_diff_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to show_diff (see VARARGIN)

% Choose default command line output for show_diff
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes show_diff wait for user response (see UIRESUME)
% uiwait(handles.figure1);


global cfg

cfg = initcfg();
cfg.figure1=handles.axes1;
cfg.figure2=handles.axes2;
cfg.figure3=handles.axes3;
cfg.figure4=handles.axes4;
cfg.figure5=handles.axes5;
cfg.figure6=handles.axes6;


cfg.figure = [handles.axes1,handles.axes2,handles.axes3,handles.axes4,handles.axes5,handles.axes6];
    set(handles.edit1, 'string', "");

end


% --- Outputs from this function are returned to the command line.
function varargout = show_diff_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cfg
    %% 从文件中读取结果
    fprintf("\n-----【开始读取结果】-----\n");
    prefix = get(handles.edit1, 'string');
    fileName = [prefix, '_result.txt'];
    fprintf("【从文件读取结果】 "+fileName+"\n");
    address = ['./data/',fileName];
    result = load(address);
    cfg.index = size(result, 2);
    cfg.dis1 = [zeros(cfg.nin, cfg.dislen), result(1:3,:)];
    cfg.dis2 = [zeros(cfg.nin, cfg.dislen), result(4:6,:)];
%     cfg.pos1 = result(7:9,:);
%     cfg.pos2 = result(10:12,:);
    fprintf("-----【完成读取结果】-----\n");
    
    %% 从文件中读取修正后结果
    fprintf("\n-----【开始读取修正后结果】-----\n");
    prefix = get(handles.edit1, 'string');
    fileName = [prefix, '_result_corr.txt'];
    fprintf("【从文件读取修正后结果】 "+fileName+"\n");
    address = ['./data/',fileName];
    result = load(address);
    cfg.index = size(result, 2);
    cfg.dis1_corr = [zeros(cfg.nin, cfg.dislen), result(1:3,:)];
    cfg.dis2_corr = [zeros(cfg.nin, cfg.dislen), result(4:6,:)];
%     cfg.pos1 = result(7:9,:);
%     cfg.pos2 = result(10:12,:);
    fprintf("-----【完成读取修正后结果】-----\n");
    
    for i=1:1:cfg.index
    
        fprintf("【正在画图...】 Dataseg index: %d\n",i);
            
        for j=1:1:3
            plot(cfg.figure(j),[1:1:cfg.dislen],cfg.dis1(j,i:cfg.dislen+i-1),'b' ...
                            ,[1:1:cfg.dislen],cfg.dis1_corr(j,i:cfg.dislen+i-1),'r');
        end
        for j=1:1:3
            plot(cfg.figure(j+3),[1:1:cfg.dislen],cfg.dis2(j,i:cfg.dislen+i-1),'b' ...
                            ,[1:1:cfg.dislen],cfg.dis2_corr(j,i:cfg.dislen+i-1),'r');
        end
                  
        drawnow();  
    end
    


end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end