function res = createChirp2(f0, B, T, fs)

%构造单个chirp信号

f1 = f0 + B;

beta = ( f1 - f0 )/T;
t = 0:1/fs:(T-1/fs);
f = f0 + beta * t;

phase = 2*pi*(f0*t+ 0.5*beta*t.^2);
x = 6*cos(phase);
x = x.*hann(length(x))';


% % 画图
% subplot(2,1,1);
% plot(x);
% subplot(2,1,2);
% spectrogram(x,256,250,256,44100); 
% title('Chirp')

res = x;

end