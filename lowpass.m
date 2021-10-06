function y=lowpass(wp, ws, x, fs)
% wp为通带截止频率；ws为阻带截止频率；ap为通带最大衰减（dB）；as为阻带最大衰减(dB)；wc为3dB截止频率;fn为采样率；
% 滤波器设计条件：通带最大衰减ap=1dB，阻带最小衰减as=15dB，通带截止频率为wp=2000Hz，阻带截止频率为ws=5000Hz

fs=16000;
ap=0.1;
as=60;
wp=2000;
ws=5000; %输入滤波器条件
wpp=wp/(fs/2);wss=ws/(fs/2);  %归一化;
[n,wn]=buttord(wpp,wss,ap,as); %计算阶数截止频率
[b,a]=butter(n,wn); %计算N阶巴特沃斯数字滤波器系统函数分子、分母多项式的系数向量b、a。

% freqz(b,a,512,fs);%做出H(z)的幅频、相频图

% t =(1:1000)/16000;
% x=cos(4000*pi*t)+cos(6000*pi*t);  %输入信号
% figure(2);
% subplot(2,1,1);
% plot(t,x); %合成信号时域波形
% axis([0 0.01 -2 2])
% X=fft(x);    %进行傅里叶变换
% subplot(2,1,2);
% plot(abs(X));

y=filter(b,a,x);  %滤波b、a滤波器系数，x滤波前序列

% figure(3);
% subplot(2,1,1); %
% plot(t,y); %分离输出信号的时域波形
% axis([0 0.01 -1.5 1.5]);
% subplot(2,1,2);
% plot(t,cos(4000*pi*t));%cos(4000*pi*t)理论时域波形
% axis([0 0.01 -1.5 1.5])


end