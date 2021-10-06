function PhaseRange(cur_index)

    global cfg
    
    % 截取dataseg
    dataseg = cfg.datain((cur_index-1)*cfg.seglen+1:cur_index*cfg.seglen, :);
    
    chose_mic = 1;
    
    for i=1:1:cfg.nin                 %for each mic
        
        if i ~= chose_mic
            continue
        end
        
        data = dataseg(1:cfg.seglen, i);
        
        yr = data;
        whos yr
        
%         yr = bandpass(23000, 25000, yr, cfg.fs);
        yr = lowpass(1, 2, yr, cfg.fs);
        whos yr
        yi = yr.*repmat(cfg.cos_seq,50/cfg.rate,1);
        
        yq = yr.*repmat(cfg.sin_seq,50/cfg.rate,1);
        
        ph = atan(yq./yi);
        
%         figure(1)
%         plot(ph)
        figure(2)
        spectrogram(yr,256,250,256,cfg.fs)
    
    end

end