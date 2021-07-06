function res = createFMCW(f0, B, T, fs, n)

%单个chirp信号
y0 = createChirp2(f0, B, T, fs);

%n个chirp信号连到一起
y = [];
for i=1:n
    y = [y, y0];
end

% %画图
% figure
% subplot(2,1,1);
% plot(y);
% subplot(2,1,2);
% spectrogram(y,256,250,256,44100); 
% title('FMCW')

res = y;
end
