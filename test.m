function varargout = test(varargin)
% TEST MATLAB code for test.fig
%      TEST, by itself, creates a new TEST or raises the existing
%      singleton*.
%
%      H = TEST returns the handle to a new TEST or the handle to
%      the existing singleton*.
%
%      TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST.M with the given input arguments.
%
%      TEST('Property','Value',...) creates a new TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test

% Last Modified by GUIDE v2.5 22-Jul-2021 18:33:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
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


% --- Executes just before test is made visible.
function test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test (see VARARGIN)

% Choose default command line output for test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

%% 初始化变量，每次计算前
function init_para()
    global cfg
    cfg.index = 0;
    cfg.datain = [];
    cfg.dis1 = [];%zeros(cfg.nin, cfg.dislen);
    cfg.dis2 = [];%zeros(cfg.nin, cfg.dislen);
    cfg.pos1 = [];
    cfg.pos2 = [];
    cfg.pos3 = [];
    cfg.fa_v = [];
    cfg.SIGQUAL1 = [];
    cfg.SIGQUAL2 = [];
    cfg.init_dis = [0.069 0.069 0.060 100 100 100;
                    100 100 100 0.077 0.069 0.075];%ones(cfg.nout, cfg.nin)*100;
    if strcmp(cfg.signal, 'zc')==1
        cfg.left_bd = ones(cfg.nout, cfg.nin)*cfg.init_left_bd;
        cfg.right_bd = ones(cfg.nout, cfg.nin)*cfg.init_right_bd;
    end
end

%% Play
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global  dev
global  cfg

dev = daq.createSession('ni');
dev.DurationInSeconds = 120;%cfg.duration;
dev.IsContinuous = 1;

fprintf('\ncfg.nout\n');
for i=1:cfg.nout
    addAnalogOutputChannel(dev,cfg.dev,cfg.output{i},'Voltage');
end

fprintf('\ncfg.nin\n');
for i=1:cfg.nin
    ch= addAnalogInputChannel(dev,cfg.dev,cfg.input{i},'Voltage');
    ch.Range=[-3,3];
end

dev.Rate = cfg.fs;
queueOutputData(dev,cfg.dataout);
dev.NotifyWhenDataAvailableExceeds = cfg.notifysample;
dev.NotifyWhenScansQueuedBelow = cfg.outlength/2;

% fprintf('\ninputlistener\n');
cfg.inputlistener = addlistener(dev,'DataAvailable',@processData);
% fprintf('\noutputlistener\n');
cfg.outputlistener = addlistener(dev,'DataRequired',@queueMoreData);

% fprintf('\nstartBackground\n');
startBackground(dev);

% fprintf('\nstart test\n');

cfg.testSnd = str2num(get(handles.edit1, 'string'));
cfg.testRcv = str2num(get(handles.edit2, 'string'));


fprintf("\n-----【开始读入数据】-----\n");
    
    %save_var(fileName)
    
    init_para();
    cfg.handles = handles;
end

%% 处理数据
function processData(src,event)
    global  cfg
%     cfg.drawPos = 0;
    
    %% read data
    cfg.datain = [cfg.datain; event.Data];
    
    cfg.index = cfg.index + 1;
    fprintf("【正在读入数据...】 Dataseg index: %d\n",cfg.index);
    
    datalen = size(event.Data,1);
    
    cfg.data_len = size(cfg.datain,1);
    if(mod(cfg.data_len,cfg.fs)==0)
        fprintf('Dataseg index: %d, New seg length: %d, Total data length: %d \n',cfg.index,datalen,cfg.data_len)
    end

    %% online 边读数据边计算
        cur_index = cfg.index;
        fprintf("【正在实时计算...】 Dataseg index: %d\n",cur_index);
        % 计算距离
        test_cal_dis(cur_index)
        
        
        

        
end

function test_cal_dis(cur_index)

%         fprintf("【cal_dis...】 Dataseg index: %d\n",cur_index);
    global cfg
    
    % 截取dataseg
    dataseg = cfg.datain((cur_index-1)*cfg.seglen+1:cur_index*cfg.seglen, :);

    
    i = cfg.testRcv;                 %for each mic
    out = 0;
    if cfg.testSnd == 1
        
    cir1=zeros(cfg.nin,cfg.zclen,cfg.zcrep);  %we have 3 frames 960*3 points for 3 mics
    dis1 = zeros(1, cfg.nin);
    m1 = zeros(1, cfg.nin);
    peak1 = zeros(1, cfg.nin);
    
        data=reshape(dataseg(:,i),cfg.zclen,cfg.zcrep );  %make the data to be 1920*10
        data_fft=fft(data,[],1);                 %FFT

        temp_fft1=zeros(size(data));

        for j=1:1%size(temp_fft,2)                 %correlation on frequency domain with ZC
            temp_fft1((cfg.zclen/2-(cfg.zc_l-1)/2)+1:2:(cfg.zclen/2+(cfg.zc_l-1)/2-1),j)=data_fft(cfg.leftpoint+1:2:cfg.rightpoint-1,j).*cfg.zc_fft1(2:2:end-1)';
        end

    %     figure(1)
    %     plot(abs(temp_fft1))

        cir1(i,:,:)=ifft(fftshift(temp_fft1,1),[],1);  %ifft and get the CIR
        cir1(i,:,:) = conj(cir1(i,:,:));
    %     size(cir(i,:,:)) % 1 480 16

        %% 处理左声道
        [tm1, p1] = max(abs(cir1(i,cfg.left_bd(1, i):cfg.right_bd(1, i),1)));
%         tmp = cfg.left_bd(1, i)
        peak1(i) = cfg.left_bd(1, i) + p1 - 1;
%         peak1(i) = p1 - 1;
        m1(i) = cir1(i,peak1(i),1);

        % 峰值窗口左右边界
%         cfg.left_bd(1, i) = max([peak1(i) - cfg.windows/2, 1]);
%         cfg.right_bd(1, i) = min([peak1(i) + cfg.windows/2, cfg.zclen/2]);

        % 用采样点粗粒度计算距离
        dis1(i) = peak1(i)*cfg.soundspeed/cfg.fs;
        
%         % 整数倍波长
%         dis1(i) = fix(dis1(i)/cfg.wavelength)*cfg.wavelength;
%         
%         real_part1 = real(m1(i));
%         imag_part1 = imag(m1(i));
% 
%         phase1 = atan(imag_part1/real_part1);
%         dis1(i) = dis1(i) + phase1/(2*pi)*cfg.wavelength;
        
        out = dis1(i);
        
        
    cfg.dis1 = [cfg.dis1; dis1];
        
    plot(cfg.handles.axes1,[1:1:cfg.zclen/2],abs(cir1(i,1:end/2,1)),cfg.color(i),...
                [peak1(i), peak1(i)],[0, abs(m1(i))], strcat('--*',cfg.color(i)));
    drawnow();
    
    
    elseif cfg.testSnd == 2
        
    cir2=zeros(cfg.nin,cfg.zclen,cfg.zcrep);  %we have 3 frames 960*3 points for 3 mics
    dis2 = zeros(1, cfg.nin);
    m2 = zeros(1, cfg.nin);
    peak2 = zeros(1, cfg.nin);
    
        data=reshape(dataseg(:,i),cfg.zclen,cfg.zcrep );  %make the data to be 1920*10
        data_fft=fft(data,[],1);                 %FFT

        temp_fft2=zeros(size(data));

        for j=1:1%size(temp_fft,2)                 %correlation on frequency domain with ZC
            temp_fft2((cfg.zclen/2-(cfg.zc_l-1)/2):2:(cfg.zclen/2+(cfg.zc_l-1)/2),j)=data_fft(cfg.leftpoint:2:cfg.rightpoint,j).*cfg.zc_fft2(1:2:end)';
        end

        cir2(i,:,:)=ifft(fftshift(temp_fft2,1),[],1);  %ifft and get the CIR
        cir2(i,:,:) = conj(cir2(i,:,:));

    %     size(cir(i,:,:)) % 1 480 16


        %% 处理右声道
        [tm2, p2] = max(abs(cir2(i,cfg.left_bd(2, i):cfg.right_bd(2, i),1)));

        peak2(i) = cfg.left_bd(2, i) + p2 - 1;

        m2(i) = cir2(i,peak2(i),1);

        % 峰值窗口左右边界
%         cfg.left_bd(2, i) = max([peak2(i) - cfg.windows/2, 1]);
%         cfg.right_bd(2, i) = min([peak2(i) + cfg.windows/2, cfg.zclen]);


        dis2(i) = peak2(i)*cfg.soundspeed/cfg.fs;
        
        
%         dis2(i) = fix(dis2(i)/cfg.wavelength)*cfg.wavelength;
%         
%         real_part2 = real(m2(i));
%         imag_part2 = imag(m2(i));
% 
%         phase2 = atan(imag_part2/real_part2);
% 
%         dis2(i) = dis2(i) + phase2/(2*pi)*cfg.wavelength;
        out = dis2(i);
        
    cfg.dis2 = [cfg.dis2; dis2];
    
        
    plot(cfg.handles.axes1,[1:1:cfg.zclen/2],abs(cir2(i,1:end/2,1)),cfg.color(i),...
                [peak2(i), peak2(i)],[0, abs(m2(i))], strcat('--*',cfg.color(i)));
    drawnow();
            
    end
    
        fprintf("【距离】: %.4f\n",vpa(out));
    
end

%% Stop
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    fprintf("-----【结束读入数据】-----\n");
global  cfg
daq.reset;
delete (cfg.inputlistener);
delete(cfg.outputlistener);

end

%% 输出队列
function queueMoreData(src,event)
global  dev
global  cfg
%fprintf('adddata\n');
queueOutputData(dev,cfg.dataout);
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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
