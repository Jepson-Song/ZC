function niconfig = initcfg()
% close all
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

niconfig.fs = 96000;  %sampling frequency
niconfig.volume =2;  %output Vpp/2  %1

niconfig.dev = 'Dev1';
niconfig.nout=2;
niconfig.output={'ao0', 'ao1'};  %NI output ports

niconfig.nin=3;
niconfig.input={'ai0','ai4','ai2'}; %NI input ports

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
niconfig.freq =40000;%[32000, 42500];%[40000, 27000];  %27000 %central frequency %39000
niconfig.zclen=960*2;   %FFT size 
niconfig.zc_l=307;%253;  %253   %ZC length must be odd 
% niconfig.zc_u=1;       %ZC u
niconfig.zc_u1=5;       %ZC u
niconfig.zc_u2=7;       %ZC u
niconfig.zcrep = 10 ; %4*1920/niconfig.zclen; % 16

niconfig.seglen = niconfig.zclen*niconfig.zcrep;
niconfig.notifysample = niconfig.seglen;
niconfig.notifytime = niconfig.notifysample/niconfig.fs;    

niconfig.duration = 120; %Total testing time in seconds


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

ofdm1(end:-1:(niconfig.zclen/2+1))=conj(ofdm1(1:niconfig.zclen/2)); %image of the spectrum 
ofdm2(end:-1:(niconfig.zclen/2+1))=conj(ofdm2(1:niconfig.zclen/2)); %image of the spectrum 
 
niconfig.zcseq1=ifft(ofdm1);   
niconfig.zcseq2=ifft(ofdm2);   

if niconfig.nout==1
% niconfig.dataout =repmat( real(niconfig.zcseq1),100,1);%, repmat( real(niconfig.zcseq2),100,1)];           % repeat 100 symbols longer than one second
% niconfig.dataout =repmat( real(niconfig.zcseq2),100,1);%, repmat( real(niconfig.zcseq2),100,1)];           % repeat 100 symbols longer than one second
elseif niconfig.nout==2
niconfig.dataout =[repmat( real(niconfig.zcseq1),100,1), repmat( real(niconfig.zcseq2),100,1)];%, repmat( real(niconfig.zcseq2),100,1)];           % repeat 100 symbols longer than one second
end

niconfig.dataout=niconfig.dataout./max(abs(niconfig.dataout))*niconfig.volume;  % adjust Vpp

niconfig.index = 0;                             %record for frames
niconfig.samples = 1;                           %record for samples
niconfig.dc=ones(1,niconfig.nin)*0.78;          %microphone DC offset
niconfig.rawdata =zeros(niconfig.fs*15,niconfig.nin);

niconfig.temp=20;
niconfig.soundspeed=(331.3+0.606*niconfig.temp);%*100;
niconfig.wavelength= niconfig.soundspeed/niconfig.freq;  %temperature and wavelength


% zcrep 16次在接收时只计算一次就可以?
% niconfig.dc 纠正误差？
% ofdm(end:-1:(niconfig.zclen/2+2))=conj(ofdm(2:niconfig.zclen/2)); 去掉也可以？

niconfig.dislen = 300;
% niconfig.dis = zeros(niconfig.nout, niconfig.nin, niconfig.dislen);%niconfig.fs*30
niconfig.phase = [];
niconfig.m = [];

niconfig.windows = 40;%niconfig.seglen*2;

niconfig.color = ["r", "g", "b"];


niconfig.A = [0 0 -0.05];
niconfig.B = [-0.1 0 0.1];
niconfig.C = [0.1 0 0.1];

niconfig.P1 = [-0.05 0.25 0];%[0 0.15 -0.25+0.005];
niconfig.P2 = [0.05 0.25 0];%[0.1 0.15 -0.25+0.005];
tmp = (niconfig.P1-niconfig.P2).*(niconfig.P1-niconfig.P2);
niconfig.width = sqrt(tmp(1)+tmp(2)+tmp(3));

niconfig.Q = [niconfig.A; niconfig.B; niconfig.C];

niconfig.P = [niconfig.P1; niconfig.P2];

niconfig.O = (niconfig.P1+ niconfig.P2)/2 - [0 0 0.08]

niconfig.left_bd = ones(niconfig.nout, niconfig.nin)*10;
niconfig.right_bd = ones(niconfig.nout, niconfig.nin)*100;%*niconfig.zclen/2;
% niconfig.init_peak = ones(niconfig.nout, niconfig.nin)*0;
niconfig.dis1 = [];%zeros(niconfig.nin, niconfig.dislen);
niconfig.dis2 = [];%zeros(niconfig.nin, niconfig.dislen);
niconfig.pos1 = [];
niconfig.pos2 = [];
niconfig.fa_v = [];


% 初始距离
niconfig.init_dis = zeros(3, 2);
for k=1:1: 2 %两个发射端
    for i=1:1:3 %三个接收端
        sum = 0;
        for j=1:1:3% 三维
            sum = sum + (niconfig.P(k, j)-niconfig.Q(i, j))^2;
        end
        niconfig.init_dis(i, k) = sqrt(sum);
    end
end
niconfig.init_dis = niconfig.init_dis';

% 偏移距离
niconfig.shift_dis = zeros(3, 2)';

niconfig.datain = [];
niconfig.data_len = 0;
niconfig.seg_index = 0;
niconfig.ifCalAloneRead = 0;
% niconfig.ifCalAfterRead = 1;
niconfig.ifDrawAloneCal = 1; % 实时画图花费的时间不大
niconfig.ifDrawAfterCal = 1;

niconfig.lim = 0.5;
% niconfig.time = 0;
% niconfig.prefix = 0;
niconfig.drawStyle = 2;

niconfig.dataAddress = 'C:\Users\Dell\seadrive_root\宋金鹏 MF20\我的资料库\Data\';

end