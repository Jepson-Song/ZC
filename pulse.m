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


% Last Modified by GUIDE v2.5 15-Nov-2021 10:52:31
    
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


    set(handles.edit1, 'string', "20211213_214603");

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
    
    %% ??????HMM??????
%     addpath(genpath('.\HMMall'))

    %% ??????LSTM??????
    cfg.net = coder.loadDeepLearningNetwork('lstm_net.mat');
    cfg.net.Layers
   
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


%% ?????????????????????????????????
function init_para()
    global cfg
    cfg.index = 0;
%     cfg.datain = [];
    cfg.dis1 = [];%zeros(cfg.nin, cfg.dislen);
    cfg.cir1 = [];
    cfg.dis2 = [];%zeros(cfg.nin, cfg.dislen);
    cfg.dis_rcv = [];
    cfg.pos_rcv = [];
    cfg.pos1 = [];
    cfg.pos2 = [];
    cfg.pos3 = [];
    cfg.dir = [];
    cfg.mov = [];
    cfg.obs= [];
    cfg.SIGQUAL1 = [];
    cfg.SIGQUAL2 = [];
    cfg.ser_aa= [];
    cfg.ser_bb= [];
    cfg.ser_bb= [];
%     cfg.init_dis = [0.069 0.069 0.060 100 100 100;
%                     100 100 100 0.077 0.069 0.075];%ones(cfg.nout, cfg.nin)*100;
    if strcmp(cfg.signal, 'zc')==1
        cfg.left_bd = ones(cfg.nout, cfg.nin)*cfg.init_left_bd;
        cfg.right_bd = ones(cfg.nout, cfg.nin)*cfg.init_right_bd;
    end
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



    time = datetime();
    prefix = sprintf('%04d%02d%02d_%02d%02d%02d',time.Year,time.Month,time.Day,time.Hour,time.Minute,floor(time.Second));
    set(handles.edit1, 'string', prefix);
    

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
    fprintf("\n??????????????????%d????????????\n",cfg.temp);
    
    cfg.rate = str2num(get(cfg.handles.edit4, 'string'));
    cfg.zcrep = cfg.fs/cfg.zclen/cfg.rate;
    cfg.seglen = cfg.zclen*cfg.zcrep;
    fprintf("\n?????????????????????%d???\n",cfg.rate);


fprintf("\n-----????????????????????????-----\n");
    
    %save_var(fileName)
    
    init_para();
    cfg.datain = [];
    
    
    
end


%% ????????????
function processData(src,event)
    tim = tic;
    global  cfg
%     cfg.drawPos = 0;
    
    %% read data
    cfg.datain = [cfg.datain; event.Data];
    
    cfg.index = cfg.index + 1;
    fprintf("?????????????????????...??? Dataseg index: %d\n",cfg.index);
    
    datalen = size(event.Data,1);
    
    

    %% online ?????????????????????
    if cfg.ifRealTime
        cur_index = cfg.index;
        fprintf("?????????????????????...??? Dataseg index: %d\n",cur_index);
        
        % ???IMU??????
        Head = fread(cfg.ser,2,'uint8');
%         if (Head(1)~=uint8(85))
%             continue;
%         end   
        Head(2);
        switch(Head(2))
%             case 81 
%                 a = fread(s,3,'int16')/32768*16 ;
%             case 82 
%                 b = fread(s,3,'int16')/32768*2000 ;   
            case 83 
                c = fread(cfg.ser,3,'int16')/32768*180;
%                 cfg.aa = [cfg.aa;a'];
%                 cfg.bb = [cfg.bb;b'];
                cfg.cc = [cfg.cc;c'];
        end
        
        % ????????????
        if strcmp(cfg.signal, 'fmcw')==1
            fmcw_cal_dis(cur_index);
        elseif strcmp(cfg.signal, 'zc')==1
            % cal_dis_new(cur_index);
            cal_dis_2O6I(cur_index);
        end
        
        
        
        draw_dis(cur_index);

%         % ???????????? 
%         cal_pos(cur_index);
%         if cfg.drawStyle == 2 ||cfg.drawStyle == 1
%             draw_pos(cur_index);
%         end
%         
%         % ????????????
%         if cfg.drawStyle == 3
%             cal_dir(cur_index);
%             draw_dir(cur_index);
%         end
        
        cfg.cur_index = cur_index;
    end
    
    t = double(toc(tim));
    cfg.data_len = size(cfg.datain,1);
%     if(mod(cfg.data_len,cfg.fs)==0)
        fprintf('Dataseg index: %d, New seg length: %d, Total data length: %d ???????????????%.4f\n',cfg.index,datalen,cfg.data_len,vpa(t))
%     end
        
end

function save_data(data, type)

    global cfg
    
    %% ????????????
    fprintf("\n-----????????????????????????-----\n");
    
    %???????????????
    prefix = get(cfg.handles.edit1, 'string');
    dir_address = [cfg.dataAddress,prefix];
    if ~exist(dir_address,'dir')
    fprintf("????????????????????? "+prefix+"\n");
        mkdir(dir_address);
    end
    
    % ????????????
    if isempty(type)
        fileName =  [prefix, '.txt'];
    else
        fileName =  [prefix, '_', type '.txt'];
    end
    fprintf("?????????????????????????????? "+fileName+"\n");
    
    address = [dir_address,'\',fileName];
%     cfg.address = address;
%     data = mat2str(data);
    save(address, 'data', '-ascii')
%     dlmwrite(address, data)
%     whos datain
    fprintf("-----????????????????????????-----\n");

end

function data = load_data(type)
    
    global cfg
    
    prefix = get(cfg.handles.edit1, 'string');
    dir_address = [cfg.dataAddress,prefix];
    if ~exist(dir_address,'dir')
        fprintf("??????????????????\n");
        return;
    end

    fprintf("\n-----????????????????????????-----\n");
    if isempty(type)
        fileName =  [prefix, '.txt'];
    else
        fileName =  [prefix, '_', type '.txt'];
    end
    fprintf("??????????????????????????? "+fileName+"\n");
    address = [dir_address,'\',fileName];
    data = load(address);
    fprintf("-----????????????????????????-----\n");
    

end

%% Stop
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    fprintf("-----????????????????????????-----\n");
global  cfg
daq.reset;
delete (cfg.inputlistener);
delete(cfg.outputlistener);

%     time = datetime();
%     prefix = sprintf('%04d%02d%02d_%02d%02d%02d',time.Year,time.Month,time.Day,time.Hour,time.Minute,floor(time.Second));
%     set(handles.edit1, 'string', prefix);
    
    
    %% ????????????
    if get(handles.radiobutton10,'value') == 1
        save_data(cfg.datain, '');
        save_data(cfg.cc, 'ang');
        prefix = get(cfg.handles.edit1, 'string');
        cfg.lastDataNum = prefix;
        set(handles.radiobutton3,'value',1);
    end
    

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
    fprintf("\n??????????????????%d????????????\n",cfg.temp);
    
%     cfg.rate = str2num(get(cfg.handles.edit4, 'string'));
    cfg.rate = 10;
    cfg.zcrep = cfg.fs/cfg.zclen/cfg.rate;
    cfg.seglen = cfg.zclen*cfg.zcrep;
    fprintf("\n?????????????????????%d???\n",cfg.rate);

    
    prefix = get(handles.edit1, 'string');
    if strcmp(prefix,cfg.lastDataNum)~=1
        set(handles.radiobutton3,'value',0);
        cfg.datain = [];
    end
    init_para();
    cfg.lastDataNum = prefix;
        
    
    %% ????????????????????????
    if get(handles.radiobutton3,'value') == 0

        cfg.datain = load_data('');

        set(handles.radiobutton3,'value',1);
    end
    cfg.data_len = size(cfg.datain,1);
    
    
    %% ????????????
    fprintf("\n-----????????????????????????-----\n");
    fprintf('Total Data length: %d\n',cfg.data_len)
    cfg.index = floor(cfg.data_len/cfg.seglen);
%     index = cfg.index
    
    tic
    for cur_index = 1:1:cfg.index
        % ????????????
        tic

        cal_dis_new(cur_index);
        
        t = toc;
        fprintf("???????????????????????? Dataseg index: %d  ?????????%.4f\n",cur_index, vpa(t));

    end
    
    t = toc;
    fprintf("????????????????????? ???????????????%d???????????????%.4f\n",cfg.index,vpa(t));
    toobar();
    fprintf("-----????????????????????????-----\n");
    
%     pushbutton5_Callback(hObject, eventdata, handles);
%     pushbutton11_Callback(hObject, eventdata, handles);

%     %% ????????????
%     dis = [cfg.dis1,cfg.dis2];
%     save_data(dis, 'dis')

    %% ???????????? new
    dis = cfg.dis_rcv;
    save_data(dis, 'dis')
    
    
    %% ??????cir
    if cfg.ifResp == 1
        cfg.lastCIR = prefix;
        cir = cfg.cir1;
        whos cir
        
        cfg.imag_cir = imag(cir);
        cfg.real_cir = real(cir);
        
        save_data(real(cir), 'cir_real')
        save_data(imag(cir), 'cir_imag')
    end
    
%     %% pca
%     coeff = pca(cir(310:420, :));
%     figure(1)
%     plot(coeff(1,:))
  
end


%% Draw after calculate distance
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    %save_var(fileName)

    %% draw dis 
    global cfg
    init_para();   
    
       %% ????????????????????????
    if cfg.choseCorrect == 0
        dis = load_data('dis');
    else
        dis = load_data('dis_cor');
    end
    whos dis
    cfg.index = size(dis, 1);

    cfg.dis1 = dis(:, 1:2:cfg.nin*cfg.nout);
    cfg.dis2 = dis(:, 2:2:cfg.nin*cfg.nout);
    fprintf("-----????????????????????????-----\n");
    
    %% ?????????????????????
    fprintf("\n-----??????????????????-----\n");
    for cur_index=1:1:cfg.index
%         if cfg.pause
%             toobar();
%             fprintf("????????????...??? Next dataseg index: %d \n",cur_index);
%             while cfg.pause
%                 pause(0.1)
%             end
%         end
        tic
        draw_dis(cur_index);
        t = toc;
        fprintf("???????????????...??? Dataseg index: %d  ?????????%.4f\n",cur_index, vpa(t));
    end
    toobar();
    fprintf("-----??????????????????-----\n");
    
 
    toobar();


    
    

end

function cal_resp()
    global cfg
    
    %% cal_resp
    if cfg.ifResp == 1
        
        
%         allcir_real = load_data('cir_real');
%         whos allcir_real
%         allcir_imag = load_data('cir_imag');
%         whos allcir_imag
        last_prefix = cfg.lastCIR
        prefix = get(cfg.handles.edit1, 'string')
        % ????????????CIR???????????????????????????????????????????????????????????????????????????????????????
        time_start_shift = 60; % ?????????????????????
        time_end_shift = -30; 
        if strcmp(cfg.lastCIR, prefix)==0
            
            allcir_real = load_data('cir_real');
            whos allcir_real
            cfg.real_cir = allcir_real(1+time_start_shift:end+time_end_shift, :);
            
            allcir_imag = load_data('cir_imag');
            whos allcir_imag
            cfg.imag_cir = allcir_imag(1+time_start_shift:end+time_end_shift, :);
            
            allcir = allcir_real+allcir_imag*1j;%atan(allcir_imag./allcir_real);
            whos allcir
            cfg.cir1 = allcir;

            cfg.lastCIR = prefix;
        end
%         cfg.cir1 = cfg.cir1(1+10:end-10,:);
        data_len = size(cfg.cir1, 1);
        
        % ????????????
        type = 1; % 1.?????? 2.??????
        
        % ???cir??????
        resp_real = cal_resp(cfg.real_cir, type);
        
        % ???cir??????
        resp_imag = cal_resp(cfg.imag_cir, type);
        
        % ?????????????????????????????????
        resp = resp_real-resp_imag;
        
        
%         resp = resp_real;
        
%         resp = resp_imag;
        
        
        % ???????????????
        local_extreme = get_extreme(resp, type);
        
        
        % ??????
        figure(1002)
        plot(resp,'b')
        hold on
%         plot([1:1:length(resp)], ones(1, length(resp))*s, 'r.');
%         plot([1:1:length(resp)], ones(1, length(resp))*-s, 'r.');
%         hold off
%         plot(local_max, resp(local_max), 'r*');
%         plot(local_min, resp(local_min), 'g*');
        plot(local_extreme, resp(local_extreme), 'r*');
%         plot(avg, 'r--');
        hold off
        xlabel('??????(s)', 'FontSize', 16)
%         set(gca, 'YLim', [-0.04,0.04]);
        set(gca, 'XTick', 0:50:data_len)
        set(gca, 'XTickLabel', 0:5:data_len/10)
        title('????????????', 'FontSize', 16)
%         legend(num2str(1002))


        
        % ????????????
        type = 2; % 1.?????? 2.??????
        
        % ???cir??????
        resp_real = cal_resp(cfg.real_cir, type);
        
        % ???cir??????
        resp_imag = cal_resp(cfg.imag_cir, type);
        
        % ?????????????????????????????????
        resp = resp_real-resp_imag;

        
        % ???????????????
        local_extreme = get_extreme(resp, type);
        
        % ??????
        figure(1003)
        plot(resp,'b')
        hold on
%         plot([1:1:length(resp)], ones(1, length(resp))*s, 'r.');
%         plot([1:1:length(resp)], ones(1, length(resp))*-s, 'r.');
%         hold off
%         plot(local_max, resp(local_max), 'r*');
%         plot(local_min, resp(local_min), 'g*');
        plot(local_extreme, resp(local_extreme), 'r*');
%         plot(avg, 'r--');
        hold off
        xlabel('??????(s)', 'FontSize', 16)
%         set(gca, 'YLim', [-0.04,0.04]);
        set(gca, 'XTick', 0:50:data_len)
        set(gca, 'XTickLabel', 0:5:data_len/10)
        title('????????????', 'FontSize', 16)
%         legend(num2str(1002))
        
    end
    
end




%% Calculate position
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global  cfg
    
    init_para();
    
    %% ????????????????????????
    if cfg.choseCorrect == 0
        dis = load_data('dis');
    else
        dis = load_data('dis_cor');
    end
%     whos dis
    cfg.index = size(dis, 1);
%     cfg.dis1 = dis(:, 1:cfg.nin);
%     cfg.dis2 = dis(:, cfg.nin+1:cfg.nin*2);
    cfg.dis_rcv = dis;
    fprintf("-----????????????????????????-----\n");
    
    %% ??????????????????
    fprintf("\n-----????????????????????????-----\n");

    cfg.pos1 = [];
    cfg.pos2 = [];
    tic;
    % ???data?????????dataseg
    for cur_index = 1:1:cfg.index
        fprintf("?????????????????????...??? Dataseg index: %d\n",cur_index);
        if cfg.pause
            toobar();
            fprintf("????????????...??? Next dataseg index: %d \n",cur_index);
            while cfg.pause
                pause(0.1)
            end
        end

        % ????????????
%         tic;
%         cal_pos(cur_index);
        cal_pos(cur_index);
        cfg.cur_index = cur_index;
        % ??????
%         draw_pos(cur_index);
        
%         t = toc;
%         fprintf("???????????????????????? Dataseg index: %d  ?????????%.4f\n",cur_index, vpa(t));
    end
    
        t = toc;
        fprintf("????????????????????? ???????????????%.4f\n",vpa(t));
    toobar();
    fprintf("-----????????????????????????-----\n");
    
    
    %% ????????????
    pos = cfg.pos_rcv; % 1*12
    if cfg.choseCorrect == 0
        save_data(pos, 'pos')
    else
        save_data(pos, 'pos_cor')
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
    
    %% ????????????????????????
    if cfg.choseCorrect == 0
        pos = load_data('pos');
    else
        pos = load_data('pos_cor');
    end
    cfg.index = size(pos, 1);
    
%     cfg.pos1 = pos(:, 1:3);
%     cfg.pos2 = pos(:, 4:6);  
    cfg.pos_rcv = pos;
    
    %% ?????????????????????
    fprintf("\n-----??????????????????-----\n");
    for cur_index=1:1:cfg.index
        if cfg.pause
            toobar();
            fprintf("????????????...??? Next dataseg index: %d \n",cur_index);
            while cfg.pause
                pause(0.1)
            end
        end
        tic
        draw_pos_new(cur_index);
        t = toc;
        fprintf("???????????????...??? Dataseg index: %d  ?????????%.4f\n",cur_index, vpa(t));
    end
    toobar();
    fprintf("-----??????????????????-----\n");



%     tic;
%     pushbutton3_Callback(hObject, eventdata, handles);
%     t1 = toc;
%     fprintf("???????????????????????????%.4f\n", vpa(t));
%     tic;
%     pushbutton5_Callback(hObject, eventdata, handles);
%     t2 = toc;
%     fprintf("???????????????????????????%.4f\n", vpa(t));
%     tic;
%     pushbutton11_Callback(hObject, eventdata, handles);
%     t3 = toc;
%     fprintf("???????????????????????????%.4f\n", vpa(t));


end

%% ????????????
function queueMoreData(src,event)
global  dev
global  cfg
%fprintf('adddata\n');
queueOutputData(dev,cfg.dataout);
end


%% ??????
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
    
    %% ????????????????????????
    dis = load_data('dis');
    cfg.index = size(dis, 1);
    cfg.dis1 = dis(:, 1:cfg.nin);
    cfg.dis2 = dis(:, cfg.nin+1:cfg.nin*2);
    
    
    %% ????????????
    fprintf("\n-----????????????????????????-----\n");
    
    dis = [cfg.dis1,cfg.dis2];
    for cur_index = 1+1:1:cfg.index-1
        fprintf("?????????????????????????????????...??? Dataseg index: %d\n",cur_index);
        for i=1:1:cfg.nin*2
            if dis(cur_index, i)>dis(cur_index-1, i) && dis(cur_index, i)>dis(cur_index+1, i)...
                || dis(cur_index, i)<dis(cur_index-1, i) && dis(cur_index, i)<dis(cur_index+1, i)
                dis(cur_index, i) = (dis(cur_index-1, i)+dis(cur_index+1, i))/2;
            end
        end
    end
    threhold = cfg.wavelength;
    for cur_index = 1+1:1:cfg.index
        fprintf("??????????????????????????????????????????...??? Dataseg index: %d\n",cur_index);
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
%     % ????????????
%     cfg.dis1(i,:) = smooth(cfg.dis1(i,:),5,'lowess');
%     cfg.dis2(i,:) = smooth(cfg.dis2(i,:),5,'lowess');
    fprintf("-----????????????????????????-----\n");
    
    %% xi???????????????
    fprintf("\n-----??????????????????-----\n");
    for cur_index=1:1:cfg.index
        if cfg.pause
            toobar();
            fprintf("????????????...??? Next dataseg index: %d \n",cur_index);
            while cfg.pause
                pause(0.1)
            end
        end
        tic
%         draw(cur_index);
        draw_dis(cur_index);
        t = toc;
        fprintf("???????????????...??? Dataseg index: %d  ?????????%.4f\n",cur_index, vpa(t));
    end
    toobar();
    fprintf("-----??????????????????-----\n");
    
    
    %% ????????????
    dis_cor = [cfg.dis1,cfg.dis2];
    save_data(dis_cor, 'dis_cor')


end

%% Draw correct distance
% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    init_para();
    
    global cfg
    %% ????????????????????????
    dis = load_data('dis_cor');
    cfg.index = size(dis, 1);
    cfg.dis1 = dis(:, 1:cfg.nin);
    cfg.dis2 = dis(:, cfg.nin+1:cfg.nin*2);
    
    %% ?????????????????????
    fprintf("\n-----??????????????????-----\n");
    for cur_index=1:1:cfg.index
        if cfg.pause
            toobar();
            fprintf("????????????...??? Next dataseg index: %d \n",cur_index);
            while cfg.pause
                pause(0.1)
            end
        end
        tic
        draw_dis(cur_index);
        t = toc;
        fprintf("???????????????...??? Dataseg index: %d  ?????????%.4f\n",cur_index, vpa(t));
    end
    toobar();
    fprintf("-----??????????????????-----\n");
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


%% Calculate dir
% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global  cfg
    
    %save_var(fileName)
    
    init_para();
    
    
        
        %% ??????hmm
%         make_dataset();
%         hmm_train();
        
        
    
    %% ????????????????????????
    if cfg.choseCorrect == 0
        pos = load_data('pos');
    else
        pos = load_data('pos_cor');
    end
%     whos dis
    cfg.index = size(pos, 1);
    cfg.pos1 = pos(:, 1:3);
    cfg.pos2 = pos(:, 4:6);
    
    
    %% ??????????????????
    fprintf("\n-----????????????????????????-----\n");

%     cfg.pos1 = [];
%     cfg.pos2 = [];
    % ???data?????????dataseg
    tic
    for cur_index = 1:1:cfg.index
        %fprintf("?????????????????????...??? Dataseg index: %d\n",cur_index);
        if cfg.pause
            toobar();
            fprintf("????????????...??? Next dataseg index: %d \n",cur_index);
            while cfg.pause
                pause(0.1)
            end
        end

        % ????????????
%         tic
        cal_dir(cur_index);
        cfg.cur_index = cur_index;
        
        draw_dir(cur_index);
%         
%         t = toc;
%         fprintf("???????????????????????? Dataseg index: %d  ?????????%.4f\n",cur_index, vpa(t));
        % ??????
%         draw_dir(cur_index);
        
        t = toc;
        fprintf("???????????????????????? Dataseg index: %d  ?????????%.4f\n",cur_index, vpa(t));
    end
    
        t = toc;
        fprintf("????????????????????? ???????????????%.4f\n",vpa(t));
    toobar();
    fprintf("-----????????????????????????-----\n");
    
    
    %% ????????????
    dir = [cfg.pos3, cfg.dir];
    if cfg.choseCorrect == 0
        save_data(dir, 'dir')
    else
        save_data(dir, 'dir_cor')
    end

    
end

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global cfg
    
    init_para();
    
    %% ?????????????????????????????????
    prefix = get(handles.edit1, 'string');
    % ????????????
    if cfg.choseCorrect == 0
        pos = load_data('pos');
    else
        pos = load_data('pos_cor');
    end
    cfg.index = size(pos, 1);
    
    cfg.pos1 = pos(:, 1:3);
    cfg.pos2 = pos(:, 4:6);  
%     cfg.pos3 = pos(:, 7:9);  
    
    % ????????????
    if cfg.choseCorrect == 0
        dir = load_data('dir');
    else
        dir = load_data('dir_cor');
    end
    cfg.pos3 = dir(:, 1:3);
    cfg.dir = dir(:, 4:6);  
    
    %% ?????????????????????
    fprintf("\n-----??????????????????-----\n");
    for cur_index=1:1:cfg.index
        if cfg.pause
            toobar();
            fprintf("????????????...??? Next dataseg index: %d \n",cur_index);
            while cfg.pause
                pause(0.1)
            end
        end
        tic
        draw_dir(cur_index);
        t = toc;
        fprintf("???????????????...??? Dataseg index: %d  ?????????%.4f\n",cur_index, vpa(t));
    end
    toobar();
    fprintf("-----??????????????????-----\n");

end


% record
% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global  cfg

%     init_para();
  
        
    %% ????????????
    pos1 = cfg.pos1(cfg.index, :);
    pos2 = cfg.pos2(cfg.index, :);
    dir = cfg.dir(cfg.index,:);
    rec = [pos1, pos2, dir];
    cfg.rec = [cfg.rec; rec];
    


end


% save
% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA) 


    global  cfg
    
    
    %?????????????????????
    rec = cfg.rec;
    save_data(rec, 'rec')
    cfg.rec = [];
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
    cfg.drawDir = ~cfg.drawDir;
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



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
end

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
end

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton10
end


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


        allREM = [];
    
        global cfg
        
        address = cfg.dataAddress;
        fileFolder=fullfile(address);
        dirOutput=dir(fullfile(fileFolder,'20211115*'));
        fileNames={dirOutput.name};
        
        class = 6
        for i=0:1:class-1
        cnt = 0;
        for index=1:length(fileNames)
            cnt = cnt + 1;
            fileName = fileNames(index);
            fileName = fileName{1}
            
            set(handles.edit1, 'string', fileName);
            set(handles.edit1, 'string', fileName);
            set(handles.edit1, 'string', fileName);
            
            fileaddress = [address,'/',fileName,'/',fileName,'_REM.txt'];
            if ~exist(fileaddress,'file')
            
            fprintf("REM????????????????????????......");
            
%                error(display('no startup.m file'));


                pushbutton3_Callback(hObject, eventdata, handles)
                
                pushbutton5_Callback(hObject, eventdata, handles)
                
                pushbutton11_Callback(hObject, eventdata, handles)
                
                REM()


            else 
                
                fprintf("REM???????????????");
                
                if cnt<=30 && mod(cnt,class) == i
                    data = load_data('REM');
    %                 allREM = [allREM; data];
                    f = fopen([address,'\allREM_5.txt'], 'a+');
                    fprintf(f, '%f ', data);
                    fclose(f);
                end
                
            end
            
            end
            
                    f = fopen([address,'\allREM_5.txt'], 'a+');
                    fprintf(f, '\n');
                    fclose(f);
        
        end
        
        whos allREM
    

end