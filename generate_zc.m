function y = generate_zc_ofdm(zc_len,fft_size)
zc_len = 127;
fft_size = 1024;
x = [0:1:zc_len];
q = 0;
u = 1;
cf = mod(zc_len,2);
zc_seq = exp(-j*pi*u*x.*(x+cf+2*q)/zc_len);
zc_half_len = (zc_len-1)/2;

startpoint = 18750*1024/48000;
ofdm = zeros(1,1024);
zc_fft = fft(zc_seq);

%插值为1024个点，调制在0Hz
% end
% %把zc序列同样调制在负频域上，保证得到的是一个实信号
% for i=2:fft_size/2
%     ofdm(fft_size-i+2) = real(ofdm(i))-j*imag(ofdm(i));

% ofdm(1:(zc_len+1)/2) = zc_fft(1:(zc_len+1)/2);
% ofdm(end-(zc_len-3)/2:end) = zc_fft(end-(zc_len-3)/2:end);

%调制在18.75kHz
for i=1:zc_len
    ofdm(startpoint-zc_half_len+i) = zc_fft(i);
end
y = ifft(ofdm);
% 
an = zeros(1,fft_size);
for i=1:fft_size
    for k=1:fft_size
        an(i) = an(i) + y(k)*conj(y(mod((k+i-1),fft_size)+1));
    end
end
plot([1:1:1024],real(an),[1:1:1024],imag(an));
end
