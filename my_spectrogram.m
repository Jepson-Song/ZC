function res = my_spectrogram(y, fs)

[YfreqDomain,frequencyRange] = centeredFFT(y,fs);

%»­ÆµÆ×Í¼
% my_stem(YfreqDomain, frequencyRange);

mx = 0;
fb = 0;

for(i=(int32(length(frequencyRange)/2):int32(length(frequencyRange))))
    if(abs(YfreqDomain(i))>=mx)
        fb = frequencyRange(i);
        mx = abs(YfreqDomain(i));
    end
end
%fb;
res = fb;

end

function my_stem(YfreqDomain, frequencyRange)
figure
 
%remember to take the abs of YfreqDomain to get the magnitude!
 
stem(frequencyRange,abs(YfreqDomain));
 
xlabel('Freq (Hz)')
 
ylabel('Amplitude')
 
title('spectrogram')

grid

end
 
