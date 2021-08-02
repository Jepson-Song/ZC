   function varargout = pulse(varargin)
% PULSE MATLAB code for pulse.fig
%      PULSE, by itself, creates a new PULSE or raises the existing
%      singleton*.
%
%      H = PULSE returns the handle to a new PULSE or the handle to
%      the existing singleton*.
%
%      PULSE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PULSE.M with the given input arguments.
%
%      PULSE('Property','Value',...) creates a new PULSE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pulse_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pulse_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pulse


% Last Modified by GUIDE v2.5 02-Aug-2021 11:17:15
    
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pulse_OpeningFcn, ...
                   'gui_OutputFcn',  @pulse_OutputFcn, ...
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

% --- Executes just before pulse is made visible.
function pulse_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pulse (see VARARGIN)

% Choose default command line output for pulse
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pulse wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global  cfg

cfg = initcfg();
cfg.figure1=handles.axes1;
cfg.figure2=handles.axes2;
cfg.figure3=handles.axes3;
cfg.figure4=handles.axes4;
cfg.figure5=handles.axes5;
cfg.figure6=handles.axes6;
cfg.figure7=handles.axes7;
cfg.figure8=handles.axes8;

cfg.figure = [handles.axes1,handles.axes2;handles.axes3,handles.axes4];

cfg.handles = handles;


    set(handles.edit1, 'string', "20210801_185446");

%     cfg.choseCorrect = 0;
    set(handles.radiobutton1,'value',~cfg.choseCorrect);
	set(handles.radiobutton2,'value',cfg.choseCorrect);
	set(handles.radiobutton3,'value',0);
    set(handles.radiobutton4,'value',cfg.drawCir);
    set(handles.radiobutton5,'value',cfg.drawDis);
    set(handles.radiobutton6,'value',cfg.drawPos);
    set(handles.radiobutton9,'value',cfg.ifRealTime);
    
    set(handles.edit3,'string',num2str(cfg.temp));
    set(handles.edit4,'string',num2str(cfg.rate));
   
end

%% Play
% --- Outputs from this function are returned to the command line.
function varargout = pulse_OutputFcn(hObject, eventdata, handles) 
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
%     cfg.datain = [];
    cfg.dis1 = [];%zeros(cfg.nin, cfg.dislen);
    cfg.dis2 = [];%zeros(cfg.nin, cfg.dislen);
    cfg.pos1 = [];
    cfg.pos2 = [];
    cfg.pos3 = [];
    cfg.dir = [];
    cfg.SIGQUAL1 = [];
    cfg.SIGQUAL2 = [];
    cfg.init_dis = [0.069 0.069 0.060 100 100 100;
                    100 100 100 0.077 0.069 0.075];%ones(cfg.nout, cfg.nin)*100;
    if strcmp(cfg.signal, 'zc')==1
        cfg.left_bd = ones(cfg.nout, cfg.nin)*cfg.init_left_bd;
        cfg.right_bd = ones(cfg.nout, cfg.nin)*cfg.init_right_bd;
    end
    cfg.timeTree = 0;
end

function toobar()
    
    global cfg
            axtoolbar(cfg.figure2,{'zoomin','zoomout','pan','datacursor','restoreview'});
            axtoolbar(cfg.figure4,{'zoomin','zoomout','pan','datacursor','restoreview'});
            axtoolbar(cfg.figure5,{'zoomin','zoomout','pan','datacursor','restoreview'});
            axtoolbar(cfg.figure6,{'zoomin','zoomout','pan','datacursor','restoreview'});
            axtoolbar(cfg.figure7,{'zoomin','zoomout','pan','datacursor','restoreview'});
            axtoolbar(cfg.figure8,{'zoomin','zoomout','pan','datacursor','restoreview'});
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
dev.DurationInSeconds = cfg.duration;
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



    cfg.temp = str2num(get(handles.edit3, 'string'));
    cfg.soundspeed = (331.3+0.606*cfg.temp);
    cfg.wavelength = cfg.soundspeed/cfg.freq;  %temperature and wavelength
    fprintf("\n【温度设置为%d摄氏度】\n",cfg.temp);
    
    cfg.rate = str2num(get(cfg.handles.edit4, 'string'));
    cfg.zcrep = cfg.fs/cfg.zclen/cfg.rate;
    cfg.seglen = cfg.zclen*cfg.zcrep;
    fprintf("\n【刷新率设置为%d】\n",cfg.rate);


fprintf("\n-----【开始读入数据】-----\n");
    
    %save_var(fileName)
    
    init_para();
    cfg.datain = [];
    
end


%% 处理数据
function processData(src,event)
    tim = tic;
    global  cfg
%     cfg.drawPos = 0;
    
    %% read data
    cfg.datain = [cfg.datain; event.Data];
    
    cfg.index = cfg.index + 1;
    fprintf("【正在读入数据...】 Dataseg index: %d\n",cfg.index);
    
    datalen = size(event.Data,1);
    
    

    %% online 边读数据边计算
    if cfg.ifRealTime
        cur_index = cfg.index;
        fprintf("【正在实时计算...】 Dataseg index: %d\n",cur_index);
        % 计算距离
        if strcmp(cfg.signal, 'fmcw')==1
            fmcw_cal_dis(cur_index);
        elseif strcmp(cfg.signal, 'zc')==1
%             cal_dis(cur_index);
            cal_dis_2O6I(cur_index);
        end
        draw_dis(cur_index);
        
%         str = '';
%         for o = 1:1:cfg.nout
%             for i = 1:1:cfg.nin
%                 str = [str, sprintf('%.4f ', cfg.init_dis(o, i))];
%             end
%             str = [str, '\n'];
%         end
%         set(cfg.handles.edit2, 'string', str);
% %         set(cfg.handles.edit2, 'string', "20210518_193646");

        % 计算坐标 
        cal_pos(cur_index);
        draw_pos(cur_index);
        cfg.cur_index = cur_index;
    end
    
    t = double(toc(tim));
    cfg.data_len = size(cfg.datain,1);
    if(mod(cfg.data_len,cfg.fs)==0)
        fprintf('Dataseg index: %d, New seg length: %d, Total data length: %d 一共用时：%.4f\n',cfg.index,datalen,cfg.data_len,vpa(t))
    end
        
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

    %% 保存数据
    fprintf("\n-----【开始保存数据】-----\n");
    time = datetime();
    prefix = sprintf('%04d%02d%02d_%02d%02d%02d',time.Year,time.Month,time.Day,time.Hour,time.Minute,floor(time.Second));
%     cfg.prefix = prefix;
    fileName =  [prefix, '.txt'];
    % 新建文件
    fprintf("【创建文件保存数据】 "+fileName+"\n");
    set(handles.edit1, 'string', prefix);
    
    address = [cfg.dataAddress,fileName];
    cfg.address = address;
    
    datain = cfg.datain;
    save(address, 'datain', '-ascii')
%     whos datain
    fprintf("-----【完成保存数据】-----\n");
    
    
    set(handles.radiobutton3,'value',1);
    cfg.lastDataNum = prefix;
    

end


%% Calculate distance
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global  cfg

    %save_var(fileName
    cfg.temp = str2num(get(handles.edit3, 'string'));
    cfg.soundspeed = (331.3+0.606*cfg.temp);
    cfg.wavelength = cfg.soundspeed/cfg.freq;  %temperature and wavelength
    fprintf("\n【温度设置为%d摄氏度】\n",cfg.temp);
    
    cfg.rate = str2num(get(cfg.handles.edit4, 'string'));
    cfg.zcrep = cfg.fs/cfg.zclen/cfg.rate;
    cfg.seglen = cfg.zclen*cfg.zcrep;
    fprintf("\n【刷新率设置为%d】\n",cfg.rate);
    
%     set(handles.edit2, 'string', num2str(cfg.temp));
    
    
    prefix = get(handles.edit1, 'string');
    
    if strcmp(prefix,cfg.lastDataNum)~=1
        set(handles.radiobutton3,'value',0);
        init_para();
        cfg.datain = [];
    else
        init_para();
    end
    cfg.lastDataNum = prefix;
        
    
    %% 从文件中读取数据
    if get(handles.radiobutton3,'value') == 0
    fprintf("\n-----【开始读取数据】-----\n");
    fileName = [prefix, '.txt'];
    fprintf("【从文件读取数据】 "+fileName+"\n");
    address = [cfg.dataAddress,fileName];
    cfg.datain = load(address);
    fprintf("-----【完成读取数据】-----\n");
    set(handles.radiobutton3,'value',1);
    end
    cfg.data_len = size(cfg.datain,1);
    
    
    %% 计算距离
    fprintf("\n-----【开始计算距离】-----\n");
    fprintf('Total Data length: %d\n',cfg.data_len)
    cfg.index = floor(cfg.data_len/cfg.seglen);
    
    for cur_index = 1:1:cfg.index
        if cfg.pause
            toobar();
            fprintf("【暂停中...】 Next dataseg index: %d \n",cur_index);
            while cfg.pause
                pause(0.1)
            end
        end
        
        % 计算距离
        tic
%         cal_dis(cur_index);
        
        cal_dis_2O6I(cur_index);
        
        draw_dis(cur_index);
        
        t = toc;
        fprintf("【处理完数据帧】 Dataseg index: %d  用时：%.4f\n",cur_index, vpa(t));

    end
    toobar();
    fprintf("-----【结束计算距离】-----\n");

    %% 保存距离
    fprintf("\n-----【开始保存距离】-----\n");
    prefix = get(handles.edit1, 'string');
    fileName = [prefix, '_dis.txt'];
    % 新建文件
    fprintf("【创建文件保存距离】 "+fileName+"\n");
    
    address = [cfg.dataAddress,fileName];
    dis = [cfg.dis1,cfg.dis2];
    save(address, 'dis', '-ascii')
    fprintf("-----【完成保存距离】-----\n");
    
    
  
end


%% Draw after calculate distance
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    %save_var(fileName)
    
    init_para();
    
    global cfg
    %% 从文件中读取结果
    fprintf("\n-----【开始读取结果】-----\n");
    prefix = get(handles.edit1, 'string');
    % 读取距离
    fileName = [prefix, '_dis.txt'];
    fprintf("【从文件读取距离】 "+fileName+"\n");
    address = [cfg.dataAddress,fileName];
    dis = load(address);
    %size(dis)
    %size(dis, 1)
    cfg.index = size(dis, 1);
    cfg.dis1 = dis(:, 1:cfg.nin);
    cfg.dis2 = dis(:, cfg.nin+1:cfg.nin*2);

    fprintf("-----【完成读取结果】-----\n");
    
    %% 读取结果后画图
    fprintf("\n-----【开始画图】-----\n");
    for cur_index=1:1:cfg.index
        if cfg.pause
            toobar();
            fprintf("【暂停中...】 Next dataseg index: %d \n",cur_index);
            while cfg.pause
                pause(0.1)
            end
        end
        tic
%         draw(cur_index);
        draw_dis(cur_index);
        t = toc;
        fprintf("【正在画图...】 Dataseg index: %d  用时：%.4f\n",cur_index, vpa(t));
    end
    toobar();
    fprintf("-----【结束画图】-----\n");

end


%% Calculate position
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global  cfg
    
    %save_var(fileName)
    
    init_para();
    
    %% 从文件中读取距离
    fprintf("\n-----【开始读取距离】-----\n");
    prefix = get(handles.edit1, 'string');
    % 读取距离
%     fileName = [prefix, '_dis_cor.txt'];
    if cfg.choseCorrect == 0
        fileName = [prefix, '_dis.txt'];
    else
        fileName = [prefix, '_dis_cor.txt'];
    end
    fprintf("【从文件读取距离】 "+fileName+"\n");
    address = [cfg.dataAddress,fileName];
    dis = load(address);
%     whos dis
    cfg.index = size(dis, 1);
    cfg.dis1 = dis(:, 1:cfg.nin);
    cfg.dis2 = dis(:, cfg.nin+1:cfg.nin*2);
    fprintf("-----【完成读取距离】-----\n");
    
    %% 离线计算位置
    fprintf("\n-----【开始离线计算】-----\n");

    cfg.pos1 = [];
    cfg.pos2 = [];
    % 把data划分成dataseg
    for cur_index = 1:1:cfg.index
        %fprintf("【正在离线计算...】 Dataseg index: %d\n",cur_index);
        if cfg.pause
            toobar();
            fprintf("【暂停中...】 Next dataseg index: %d \n",cur_index);
            while cfg.pause
                pause(0.1)
            end
        end

        % 计算坐标
        tic
        cal_pos(cur_index);
        cfg.cur_index = cur_index;
        
        draw_pos(cur_index);
        
        t = toc;
        fprintf("【处理完数据帧】 Dataseg index: %d  用时：%.4f\n",cur_index, vpa(t));
    end
    toobar();
    fprintf("-----【结束离线计算】-----\n");
    
    
    %% 保存结果
    fprintf("\n-----【开始保存修正后结果】-----\n");
    prefix = get(handles.edit1, 'string');

    % 保存修正后的位置
    if cfg.choseCorrect == 0
        fileName = [prefix, '_pos.txt'];
    else
        fileName = [prefix, '_pos_cor.txt'];
    end
    fprintf("【创建文件保存修正后位置】 "+fileName+"\n");
    address = [cfg.dataAddress,fileName];
    pos_cor = [cfg.pos1,cfg.pos2,cfg.pos3];
    save(address, 'pos_cor', '-ascii')
    % 保存修正后的法向量
%     fileName = [prefix, '_dir_cor.txt'];
    if cfg.choseCorrect == 0
        fileName = [prefix, '_dir.txt'];
    else
        fileName = [prefix, '_dir_cor.txt'];
    end
    fprintf("【创建文件保存修正后法向量】 "+fileName+"\n");
    address = [cfg.dataAddress,fileName];
    dir_cor = cfg.dir;
    save(address, 'dir_cor', '-ascii')
    fprintf("-----【完成保存修正后结果】-----\n");

    
    %% 计算完成后画图
    if cfg.ifDrawAfterCal
        fprintf("\n-----【开始离线画图】-----\n");
        for cur_index=1:1:cfg.index
            tic
            draw(cur_index);
            t = toc;
            fprintf("【正在画图...】 Dataseg index: %d  用时：%.4f\n",cur_index, vpa(t));
        end
        fprintf("-----【结束离线画图】-----\n");
    end
    
end

%% Draw position
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    global cfg
    
    %save_var(fileName)
    
    %clear
    %load(address)
    
    init_para();
    
    %% 从文件中读取修正后的结果
    prefix = get(handles.edit1, 'string');
    if cfg.choseCorrect == 0
        fprintf("\n-----【开始读取原始结果】-----\n");
        fileName = [prefix, '_pos.txt'];
        fprintf("【从文件读取原始位置】 "+fileName+"\n");
    else
        fprintf("\n-----【开始读取修正后的结果】-----\n");
        fileName = [prefix, '_pos_cor.txt'];
        fprintf("【从文件读取修正后的位置】 "+fileName+"\n");
    end
    address = [cfg.dataAddress,fileName];
    pos = load(address);
    
    cfg.index = size(pos, 1);
    
    cfg.pos1 = pos(:, 1:3);
    cfg.pos2 = pos(:, 4:6);  
    cfg.pos3 = pos(:, 7:9);  
    % 读取法向量
    if cfg.choseCorrect == 0
        fileName = [prefix, '_dir.txt'];
        fprintf("【从文件读取原始法向量】 "+fileName+"\n");
    else
        fileName = [prefix, '_dir_cor.txt'];
        fprintf("【从文件读取修正后的法向量】 "+fileName+"\n");
    end
    address = [cfg.dataAddress,fileName];
    cfg.dir = load(address);
    
    if cfg.choseCorrect == 0
        fprintf("-----【完成读取原始结果】-----\n");
    else
        fprintf("-----【完成读取修正后的结果】-----\n");
    end
    
    %% 读取结果后画图
    fprintf("\n-----【开始画图】-----\n");
    for cur_index=1:1:cfg.index
        if cfg.pause
            toobar();
            fprintf("【暂停中...】 Next dataseg index: %d \n",cur_index);
            while cfg.pause
                pause(0.1)
            end
        end
        tic
        draw_pos(cur_index);
        t = toc;
        fprintf("【正在画图...】 Dataseg index: %d  用时：%.4f\n",cur_index, vpa(t));
    end
    toobar();
    fprintf("-----【结束画图】-----\n");

end

%% 输出队列
function queueMoreData(src,event)
global  dev
global  cfg
%fprintf('adddata\n');
queueOutputData(dev,cfg.dataout);
end


%% 校准
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    global cfg
    cfg.O = (cfg.pos1(cfg.cur_index, :)+cfg.pos2(cfg.cur_index, :))/2 - cfg.ear2neck;
    
end

%% Correct distance
% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global  cfg
    
    %save_var(fileName)
    
    init_para();
    
    %% 从文件中读取距离
    fprintf("\n-----【开始读取距离】-----\n");
    prefix = get(handles.edit1, 'string');
    % 读取距离
    fileName = [prefix, '_dis.txt'];
    fprintf("【从文件读取距离】 "+fileName+"\n");
    address = [cfg.dataAddress,fileName];
    dis = load(address);
    whos dis
    cfg.index = size(dis, 1);
    cfg.dis1 = dis(:, 1:cfg.nin);
    cfg.dis2 = dis(:, cfg.nin+1:cfg.nin*2);
    fprintf("-----【完成读取距离】-----\n");
    
    
    %% 修正距离
    fprintf("\n-----【开始修正距离】-----\n");
    
    dis = [cfg.dis1,cfg.dis2];
    for cur_index = 1+1:1:cfg.index-1
        fprintf("【正在进行单个凸点修正...】 Dataseg index: %d\n",cur_index);
        for i=1:1:cfg.nin*2
            if dis(cur_index, i)>dis(cur_index-1, i) && dis(cur_index, i)>dis(cur_index+1, i)...
                || dis(cur_index, i)<dis(cur_index-1, i) && dis(cur_index, i)<dis(cur_index+1, i)
                dis(cur_index, i) = (dis(cur_index-1, i)+dis(cur_index+1, i))/2;
            end
        end
    end
    threhold = cfg.wavelength;
    for cur_index = 1+1:1:cfg.index
        fprintf("【正在进行距离大幅度变化修正...】 Dataseg index: %d\n",cur_index);
        for i=1:1:cfg.nin*2
            if dis(cur_index, i)-dis(cur_index-1, i) > threhold
                dis(cur_index, i) = dis(cur_index, i) - cfg.wavelength;
            elseif dis(cur_index, i)-dis(cur_index-1, i) < -threhold
                dis(cur_index, i) = dis(cur_index, i) + cfg.wavelength;
            end
        end
    end
    cfg.dis1 = dis(:, 1:cfg.nin);
    cfg.dis2 = dis(:, cfg.nin+1:cfg.nin*2);
%     % 均值滤波
%     cfg.dis1(i,:) = smooth(cfg.dis1(i,:),5,'lowess');
%     cfg.dis2(i,:) = smooth(cfg.dis2(i,:),5,'lowess');
    fprintf("-----【结束修正距离】-----\n");
    
    %% xi修正后画图
    fprintf("\n-----【开始画图】-----\n");
    for cur_index=1:1:cfg.index
        if cfg.pause
            toobar();
            fprintf("【暂停中...】 Next dataseg index: %d \n",cur_index);
            while cfg.pause
                pause(0.1)
            end
        end
        tic
%         draw(cur_index);
        draw_dis(cur_index);
        t = toc;
        fprintf("【正在画图...】 Dataseg index: %d  用时：%.4f\n",cur_index, vpa(t));
    end
    toobar();
    fprintf("-----【结束画图】-----\n");
    
    
    %% 保存结果
    prefix = get(handles.edit1, 'string');
    % 保存修正后的距离
    fileName = [prefix, '_dis_cor.txt'];
    fprintf("【创建文件保存修正后距离】 "+fileName+"\n");
    address = [cfg.dataAddress,fileName];
    dis_cor = [cfg.dis1,cfg.dis2];
    save(address, 'dis_cor', '-ascii')
    fprintf("-----【完成保存修正后距离】-----\n");


end

%% Draw correct distance
% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    init_para();
    
    global cfg
    %% 从文件中读取结果
    fprintf("\n-----【开始读取结果】-----\n");
    prefix = get(handles.edit1, 'string');
    % 读取距离
    fileName = [prefix, '_dis_cor.txt'];
    fprintf("【从文件读取距离】 "+fileName+"\n");
    address = [cfg.dataAddress,fileName];
    dis = load(address);
    cfg.index = size(dis, 1);
    cfg.dis1 = dis(:, 1:cfg.nin);
    cfg.dis2 = dis(:, cfg.nin+1:cfg.nin*2);
    fprintf("-----【完成读取结果】-----\n");
    
    %% 读取结果后画图
    fprintf("\n-----【开始画图】-----\n");
    for cur_index=1:1:cfg.index
        if cfg.pause
            toobar();
            fprintf("【暂停中...】 Next dataseg index: %d \n",cur_index);
            while cfg.pause
                pause(0.1)
            end
        end
        tic
        draw_dis(cur_index);
        t = toc;
        fprintf("【正在画图...】 Dataseg index: %d  用时：%.4f\n",cur_index, vpa(t));
    end
    toobar();
    fprintf("-----【结束画图】-----\n");
end

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global cfg
    
    cfg.pause = ~cfg.pause;
    if cfg.pause
        set(handles.pushbutton10,'String','Continue')
    else
        set(handles.pushbutton10,'String','Pause')
    end

end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global  cfg
    
    %save_var(fileName)
    
    init_para();
    
    %% 从文件中读取距离
    fprintf("\n-----【开始读取位置】-----\n");
    prefix = get(handles.edit1, 'string');
    % 读取距离
    if cfg.choseCorrect == 0
        fileName = [prefix, '_pos.txt'];
    else
        fileName = [prefix, '_pos_cor.txt'];
    end
    fprintf("【从文件读取位置】 "+fileName+"\n");
    address = [cfg.dataAddress,fileName];
    pos = load(address);
%     whos dis
    cfg.index = size(pos, 1);
    cfg.pos1 = pos(:, 1:3);
    cfg.pos2 = pos(:, 4:6);
    cfg.pos3 = pos(:, 7:9);
    fprintf("-----【完成读取距离】-----\n");
    
    %% 离线计算位置
    fprintf("\n-----【开始离线计算】-----\n");

%     cfg.pos1 = [];
%     cfg.pos2 = [];
    % 把data划分成dataseg
    for cur_index = 1:1:cfg.index
        %fprintf("【正在离线计算...】 Dataseg index: %d\n",cur_index);
        if cfg.pause
            toobar();
            fprintf("【暂停中...】 Next dataseg index: %d \n",cur_index);
            while cfg.pause
                pause(0.1)
            end
        end

        % 计算坐标
        tic
        cal_dir(cur_index);
        cfg.cur_index = cur_index;
        
        draw_dir(cur_index);
        
        t = toc;
        fprintf("【处理完数据帧】 Dataseg index: %d  用时：%.4f\n",cur_index, vpa(t));
    end
    toobar();
    fprintf("-----【结束离线计算】-----\n");
    
    
    %% 保存结果
    fprintf("\n-----【开始保存方向】-----\n");
    prefix = get(handles.edit1, 'string');

    % 保存修正后的法向量
%     fileName = [prefix, '_dir_cor.txt'];
    if cfg.choseCorrect == 0
        fileName = [prefix, '_dir.txt'];
    else
        fileName = [prefix, '_dir_cor.txt'];
    end
    fprintf("【创建文件保存方向】 "+fileName+"\n");
    address = [cfg.dataAddress,fileName];
    dir = cfg.dir;
    save(address, 'dir', '-ascii')
    fprintf("-----【完成保存方向】-----\n");

    
end

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end







% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end




% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1

    set(handles.radiobutton1,'value',1);
	
	set(handles.radiobutton2,'value',0);
    
    global cfg
    
    cfg.choseCorrect = 0;
    
end


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2

    set(handles.radiobutton1,'value',0);
	
	set(handles.radiobutton2,'value',1);
    
    
    global cfg
    
    cfg.choseCorrect = 1;


end


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
end

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4

    global cfg
    
    cfg.drawCir = ~cfg.drawCir;
	set(handles.radiobutton4,'value',cfg.drawCir);

end

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5

    global cfg
    
    cfg.drawDis = ~cfg.drawDis;
	set(handles.radiobutton5,'value',cfg.drawDis);
end

% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6

    global cfg
    
    cfg.drawPos = ~cfg.drawPos;
	set(handles.radiobutton6,'value',cfg.drawPos);

end


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9

    global cfg
    
    cfg.ifRealTime = ~cfg.ifRealTime;
	set(handles.radiobutton9,'value',cfg.ifRealTime);
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

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
end
% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

end
% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

