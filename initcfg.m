function niconfig = initcfg()
% close all
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

niconfig.fs = 96000;  %sampling frequency
niconfig.volume =2;  %output Vpp/2  %1

niconfig.dev = 'Dev1';
niconfig.nout=2;
niconfig.output={'ao0', 'ao1'};  %NI output ports

niconfig.nin=6;
niconfig.input={'ai0','ai1','ai2','ai4','ai5','ai6'};%{'ai0','ai4','ai2'}; %NI input ports

niconfig.figure1=[];
niconfig.figure2=[];
niconfig.figure3=[];
niconfig.figure4=[];
niconfig.figure5=[];
niconfig.figure6=[];
niconfig.figure7=[];
niconfig.figure8=[];

niconfig.figure=[];



niconfig.inputlistener=[];
niconfig.outputlistener=[];

niconfig.outlength = niconfig.fs; %output sample buffer, one second

niconfig.signal = 'zc';%'zc'

niconfig.rate = 10;
niconfig.notifysample = niconfig.fs/niconfig.rate;
niconfig.seglen = niconfig.notifysample;
niconfig.notifytime = niconfig.notifysample/niconfig.fs;    


niconfig.duration = 120; %Total testing time in seconds

niconfig.temp=26;
niconfig.soundspeed=(331.3+0.606*niconfig.temp);%*100;

niconfig.dislen = 300;


if strcmp(niconfig.signal, 'fmcw')==1
    niconfig.fs = 96000;
    %chirp周期
    niconfig.T = 0.1;
    niconfig.n = 1/niconfig.T;
    %初始频率
    niconfig.fl1 = 5000;
    %最高频率
    niconfig.fr1 = 23000;
    %chirp带宽
    niconfig.B1 = niconfig.fr1-niconfig.fl1;
    %初始频率
    niconfig.fl2 = 35000;
    %最高频率
    niconfig.fr2 = 45000;
    %chirp带宽
    niconfig.B2 = niconfig.fr2-niconfig.fl2;
    niconfig.dataout = [createFMCW(niconfig.fl1, niconfig.B1, niconfig.T, niconfig.fs, niconfig.n)', createFMCW(niconfig.fl2, niconfig.B2, niconfig.T, niconfig.fs, niconfig.n)'];%, repmat( real(niconfig.zcseq2),100,1)];           % repeat 100 symbols longer than one second
    niconfig.dataout = niconfig.dataout./max(abs(niconfig.dataout))*niconfig.volume;  % adjust Vpp
    spectrogram(niconfig.dataout(:,1),128,120,128,niconfig.fs);

elseif strcmp(niconfig.signal, 'zc')==1
niconfig.freq =40000;%[32000, 42500];%[40000, 27000];  %27000 %central frequency %39000
% niconfig.zclen=960*2;   %FFT size 
niconfig.zc_l=307;%253;  %253   %ZC length must be odd 
% niconfig.zc_u=1;       %ZC u
niconfig.zc_u1=5;       %ZC u
niconfig.zc_u2=7;       %ZC u

niconfig.rate = 1;
niconfig.zclen=960*2;   %FFT size 
% niconfig.zcrep = 50 ; %4*1920/niconfig.zclen; % 16
niconfig.maxrate = niconfig.fs/niconfig.zclen;
niconfig.zcrep = niconfig.maxrate/niconfig.rate;
niconfig.seglen = niconfig.zclen*niconfig.zcrep;
% niconfig.rate = niconfig.fs/niconfig.seglen;
niconfig.notifysample = niconfig.seglen;
niconfig.notifytime = niconfig.notifysample/niconfig.fs;    

zcseq1 = zadoff_chu(niconfig.zc_l,niconfig.zc_u1); %generate ZC in time
zcseq2 = zadoff_chu(niconfig.zc_l,niconfig.zc_u2); %generate ZC in time

niconfig.zc_fft1=fftshift(fft(zcseq1));    %FFT, 127 points to spectrum
niconfig.zc_fft2=fftshift(fft(zcseq2));    %FFT, 127 points to spectrum
wind=hamming(niconfig.zc_l);                     %add hamming window in freq 127*1
niconfig.zc_fft1=niconfig.zc_fft1.*wind';
niconfig.zc_fft2=niconfig.zc_fft2.*wind'; %1*127

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 奇偶插值

ofdm1=zeros(niconfig.zclen,1);                    %OFDM symbol in spectrum, 1024 points 127*1
ofdm2=zeros(niconfig.zclen,1);                    %OFDM symbol in spectrum, 1024 points

% niconfig.ofdm_zc_l = niconfig.zc_l;%*2;
niconfig.startpoint=floor(niconfig.freq/niconfig.fs*niconfig.zclen);%, floor(niconfig.freq2/niconfig.fs*niconfig.zclen)];  %find the center subcarrier for the given central freq
niconfig.leftpoint = niconfig.startpoint-(niconfig.zc_l-1)/2;%+1;
niconfig.rightpoint = niconfig.startpoint+(niconfig.zc_l-1)/2;
 
% u不同
ofdm1(niconfig.leftpoint+1:2:niconfig.rightpoint-1)=niconfig.zc_fft1(2:2:end-1);%(2:2:end); % modulate, copy ZC to OFDM subcarrier
ofdm2(niconfig.leftpoint:2:niconfig.rightpoint)=niconfig.zc_fft2(1:2:end);%(1:2:end-1); % modulate, copy ZC to OFDM subcarrier

% 实部对称虚部反对称
ofdm1(end:-1:(niconfig.zclen/2+1+1))=conj(ofdm1(2:niconfig.zclen/2)); %image of the spectrum 
ofdm2(end:-1:(niconfig.zclen/2+1+1))=conj(ofdm2(2:niconfig.zclen/2)); %image of the spectrum 
 
niconfig.zcseq1=ifft(ofdm1);   
% a = niconfig.zcseq1
niconfig.zcseq2=ifft(ofdm2);   
% b = niconfig.zcseq2

if niconfig.nout==1
% niconfig.dataout =repmat( real(niconfig.zcseq1),100,1);%, repmat( real(niconfig.zcseq2),100,1)];           % repeat 100 symbols longer than one second
% niconfig.dataout =repmat( real(niconfig.zcseq2),100,1);%, repmat( real(niconfig.zcseq2),100,1)];           % repeat 100 symbols longer than one second
elseif niconfig.nout==2
niconfig.dataout =[repmat(niconfig.zcseq1,100,1), repmat(niconfig.zcseq2,100,1)];%, repmat( real(niconfig.zcseq2),100,1)];           % repeat 100 symbols longer than one second
end

niconfig.dataout=niconfig.dataout./max(abs(niconfig.dataout))*niconfig.volume;  % adjust Vpp

niconfig.index = 0;                             %record for frames
niconfig.samples = 1;                           %record for samples
niconfig.dc=ones(1,niconfig.nin)*0.78;          %microphone DC offset
niconfig.rawdata =zeros(niconfig.fs*15,niconfig.nin);



% zcrep 16次在接收时只计算一次就可以?
% niconfig.dc 纠正误差？
% ofdm(end:-1:(niconfig.zclen/2+2))=conj(ofdm(2:niconfig.zclen/2)); 去掉也可以？

% niconfig.dis = zeros(niconfig.nout, niconfig.nin, niconfig.dislen);%niconfig.fs*30
niconfig.phase = [];
niconfig.m = [];

niconfig.windows = 40;%niconfig.seglen*2;


niconfig.init_left_bd = 1;
niconfig.init_right_bd = 960;
niconfig.left_bd = ones(niconfig.nout, niconfig.nin)*niconfig.init_left_bd;
niconfig.right_bd = ones(niconfig.nout, niconfig.nin)*niconfig.init_right_bd;%*niconfig.zclen/2;



end




niconfig.color = ["r", "g", "b","c", "m", "y"];


niconfig.A = [0 -0.05 0];
niconfig.B = [-0.1 0.1 0];
niconfig.C = [0.1 0.1 0];
niconfig.AB = sqrt(sum((niconfig.A-niconfig.B).*(niconfig.A-niconfig.B)));
niconfig.BC = sqrt(sum((niconfig.B-niconfig.C).*(niconfig.B-niconfig.C)));
niconfig.AC = sqrt(sum((niconfig.A-niconfig.C).*(niconfig.A-niconfig.C)));

niconfig.P1 = [-0.05 0 -0.25];%[0 0.15 -0.25+0.005];
niconfig.P2 = [0.05 0 -0.25];%[0.1 0.15 -0.25+0.005];
% tmp = (niconfig.P1-niconfig.P2).*(niconfig.P1-niconfig.P2);
% niconfig.width = sqrt(tmp(1)+tmp(2)+tmp(3));
niconfig.width = sqrt(sum((niconfig.P1-niconfig.P2).*(niconfig.P1-niconfig.P2)));

niconfig.Q = [niconfig.A; niconfig.B; niconfig.C];

% niconfig.Q = [0 0 1.2;
%               0 0.3 1.1;
%               0 0.6 1.2;
%               3.865 0 1.2;
%               3.865 0.3 1.1;
%               3.865 0.6 1.2];
niconfig.Q = [0 1.40 0-0.003;
              0 1.00 -0.15-0.003;
              0 0.60 0-0.003;
              0.60 0 0-0.003;
              1.00 0 -0.15-0.003;
              1.30 0.40 0-0.003];
niconfig.P = [niconfig.P1; niconfig.P2];

niconfig.ear2neck = [0 0 0.2];
niconfig.O = [1.3 0.3 0.8];%(niconfig.P1+ niconfig.P2)/2 + niconfig.ear2neck;
niconfig.cur_index = 0;
% 
niconfig.wavelength= niconfig.soundspeed/niconfig.freq;  %temperature and wavelength

% niconfig.init_peak = ones(niconfig.nout, niconfig.nin)*0;
niconfig.dis1 = [];%zeros(niconfig.nin, niconfig.dislen);
niconfig.dis2 = [];%zeros(niconfig.nin, niconfig.dislen);
niconfig.pos1 = [];
niconfig.pos2 = [];
niconfig.pos3 = [];
niconfig.dir = []; % direction
niconfig.mov = []; % movement

niconfig.SIGQUAL1 = [];%zeros(niconfig.nout, niconfig.nin);
niconfig.SIGQUAL2 = [];%zeros(niconfig.nout, niconfig.nin);

niconfig.chose1 = [];
niconfig.chose2 = [];


% 初始距离
% niconfig.init_dis = zeros(3, 2);
% for k=1:1: 2 %两个发射端
%     for i=1:1:3 %三个接收端
%         sumn = 0;
%         for j=1:1:3% 三维
%             sumn = sumn + (niconfig.P(k, j)-niconfig.Q(i, j))^2;
%         end
%         niconfig.init_dis(i, k) = sqrt(sumn);
%     end
% end
% niconfig.init_dis = niconfig.init_dis';
% niconfig.init_dis = ones(niconfig.nout, niconfig.nin)*100;
niconfig.init_dis = [0.0723 0.0723 0.0651 0 0 0;
                        0 0 0 0.0759 0.0723 0.0723];
niconfig.handles = [];
niconfig.SIG_LOS = 4;

% 偏移距离
niconfig.shift_dis = zeros(3, 2)';

niconfig.datain = [];
niconfig.data_len = 0;
niconfig.seg_index = 0;
niconfig.ifRealTime = 0;
niconfig.ifDrawAloneCal = 1; % 实时画图花费的时间
niconfig.ifDrawAfterCal = 0;
niconfig.drawCir = 1;
niconfig.drawDis = 1;
niconfig.drawPos = 1;
niconfig.drawDir = 1;
% niconfig.drawVec = 0;
niconfig.drawStyle = 3;

niconfig.choseCorrect = 0;
niconfig.lastDataNum = '0';

niconfig.pause = 0;

niconfig.lim = 0.5;
% niconfig.time = 0;
% niconfig.prefix = 0;

niconfig.dataAddress = 'E:\seadrive_root\宋金鹏 MF20\我的资料库\Data\';
% niconfig.dataAddress = 'C:\Users\Jepson\seadrive_root\宋金鹏 MF20\我的资料库\Data\';

niconfig.timeTree = 0;


niconfig.static = 0; % 静止
niconfig.surge = 1; % 前后移动
niconfig.sway = 2; % 左右移动
niconfig.heave = 3; % 上下移动
niconfig.roll = 4; % 左右倾斜
niconfig.pitch = 5; % 前后俯仰
niconfig.yaw = 6; % 左右旋转
niconfig.translation = -1; % 平移/移动
niconfig.rotation = -2; % 转动
niconfig.pitch_surge = -3; % 

niconfig.class_num = 6; % 分类的数目
niconfig.angle_num = 18; % 观测值编码时角度划分的数量
niconfig.iter_numm = 10; % hmm训练时迭代最大次数
niconfig.cut_len = 20; % 数据集切分的长度



niconfig.init_dir = [-1 -1 0]; % 初始时大概视线方向
niconfig.init_pos1 = [0.3 1 0]; % 初始时左耳机的大概位置
niconfig.init_pos2 = [1 0.3 0]; % 初始时右耳机的大概位置
end
