function res = createFMCW(f0, B, T, fs, n)

%����chirp�ź�
y0 = createChirp2(f0, B, T, fs);

%n��chirp�ź�����һ��
y = [];
for i=1:n
    y = [y, y0];
end

% %��ͼ
% figure
% subplot(2,1,1);
% plot(y);
% subplot(2,1,2);
% spectrogram(y,256,250,256,44100); 
% title('FMCW')

res = y;
end
