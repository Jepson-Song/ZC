function cal_resp_rt(cur_index, start, step)
    if cur_index<start
        return
    end
    
    global cfg
    %% 从文件中读取结果
    
    %% 
    if cfg.ifResp == 1
            
    allcir = cfg.cir1(cur_index-start+1:cur_index, :);
            
    cfg.index = size(allcir, 1);

    % 20211015_123426
    
    %% pca
    sel_cir1 = [];
    all_SNR = [];
    for i=1:1:12
        
        % 某个接收端的cir
        cir1 = allcir(:, (i-1)*960+1:i*960);
        
        % tcir转置一下，cir是T*F，tcir转置成F*T
        tcir1 = cir1';
%         tcir1 = tcir1(:, end-cfg.dislen+1:end);
    
        % 画cir
%         draw_pic(cfg.figure7,tcir1)

        % 按时间进行差分
        dcir1 = diff(tcir1, 1, 2);  % para3: 1是列差分 2是行差分
        
        % 画差分cir1
%         draw_pic(cfg.figure8,dcir1)
    
        % 从文件中读出来的数据行号都是时间T
        [T, Frame] = size(cir1);
        
        
%         cir1 = lowpass(0.5,0.6,cir1,10);

        cir1 = dcir1';
        
%         cir1 = lowpass(0.5,0.6,cir1,10);

        % path selection
        fft_cir1 = abs(real(fft(cir1,100)));

        % 画fft
%         draw_pic(cfg.figure5, fft_cir1(1:51,:)');


        for index=1:1:Frame %960
            
            % 路径选择
            Emax = max(fft_cir1([1:1:5]+1,index));
            part1 = sum(fft_cir1([1:1:5]+1,index))-Emax;
            part2 = sum(fft_cir1([5:1:50]+1,index));
            w1 = 0.5;
            w2 = 0.5;
            SNR(index) = w1*Emax/part1+w2*Emax/part2;

            % 先减去复数均值
%             cir1(:, index) = cir1(:, index) - mean(cir1(:, index)); %作用不大

            % 再做LEVD
%             cir1(:, index) = LEVD(cir1(:, index)); %作用不大

            % 再做滑动平均
            cir1(:, index) = smooth(cir1(:, index), 9); % 有作用
        end
        
        if cur_index==start
            all_SNR = [all_SNR; SNR];
        else
            SNR = cfg.SNR(i, :);
        end
        
        % 处理后
%         draw_pic(cfg.figure6, cir1');
        
        % 选择path
        l_bd = 1;
        r_bd = 960;
        SNR_thr = 0.9;
        
        
        [, sel]= find(SNR(l_bd:r_bd)>=SNR_thr);
        
        sel = sel + l_bd - 1;
%         sel = [300:400];

%         % 画出选择的path
%         figure(10)
%         plot(SNR,'b')
%         hold on
%         title('SNR')
%         plot(sel, SNR(sel),'r*');
%         hold off
        
        one_cir1 = cir1( :, sel );
        sel_cir1 = [sel_cir1, one_cir1];

    end
    
    % 路径选择后的cir
    sel_cir1 = real(sel_cir1);
    
    if cur_index==start
%         cfg.SNR = all_SNR;
%         cfg.sel_cir1 = sel_cir1;
    else
%         sel_cir1 = cfg.sel_cir1;
    end
    
    % pca
    [coeff,score,latent] = pca(sel_cir1); % coeff 转换矩阵   score 降维后结果  latent 特征值
    
    for i=1:1:6
        resp = score(:,i);%+score(:,2)+score(:,3);    
        % 低通滤波
        resp = lowpass(0.5,0.6,resp,10);
        
        % 画前六个特征值对应的呼吸
%         figure(i)
%         plot(resp)
%         title('呼吸波形')
%         legend(num2str(i))
        
    end
    
    if cur_index==start
        cfg.resp = [cfg.resp, resp(:, 1)'];
    else
        cfg.resp = [cfg.resp, resp(end-step+1:end, 1)'];
    end
    

    
%     resp = score(:,1:5);%+score(:,2)+score(:,3);    
%     % 低通滤波
%     resp = lowpass(0.3,0.4,resp,10);
%     figure(2)
%     plot(resp)
%     title('呼吸波形')
%     legend('1','2','3')
    
    end

end