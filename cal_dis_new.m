function cal_dis_new(cur_index)

%         fprintf("【cal_dis...】 Dataseg index: %d\n",cur_index);
    global cfg
    
    dis_tim = tic;
    
    % 截取dataseg
    dataseg = cfg.datain((cur_index-1)*cfg.seglen+1:cur_index*cfg.seglen, :);

    cir1=zeros(cfg.zclen, cfg.nin);  %we have 3 frames 960*3 points for 3 mics

    cir2=zeros(cfg.zclen, cfg.nin);  %we have 3 frames 960*3 points for 3 mics

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 开始奇偶插值
    
    allcir = zeros(1, cfg.zclen/2*cfg.nout*cfg.nin); % 960*16 [cirS1-R1,cirS1-R2,...,cirS1-Rn,cirS2-R1,cirS2-R2,...,cirS2-Rn]
%     whos allcir
    dis_rcv = zeros(1, cfg.nin*cfg.nout); % [disR1-S1,disR1-S2,disR2-S1,disR2-S2,...,disRn-S1,disRn-S2]
    
    dis_snd1 = zeros(1, cfg.nin);
    dis_snd2 = zeros(1, cfg.nin);
    
    %% 左右发射端
    for i=1:1:cfg.nin                 %for each mic
        
        data = dataseg(1:cfg.zclen, i);
        
        data_fft=fft(data);                 %FFT

        temp_fft1=zeros(size(data));     
        temp_fft2=zeros(size(data));       
        
        temp_fft1((cfg.zclen/2-(cfg.zc_l-1)/2)+1:2:(cfg.zclen/2+(cfg.zc_l-1)/2-1))=data_fft(cfg.leftpoint+1:2:cfg.rightpoint-1).*cfg.zc_fft1(2:2:end-1)';
        temp_fft2((cfg.zclen/2-(cfg.zc_l-1)/2):2:(cfg.zclen/2+(cfg.zc_l-1)/2))=data_fft(cfg.leftpoint:2:cfg.rightpoint).*cfg.zc_fft2(1:2:end)';
 
        cir1(:, i) = conj(ifft(fftshift(temp_fft1,1))); %ifft and get the CIR
        cir2(:, i) = conj(ifft(fftshift(temp_fft2,1))); %ifft and get the CIR
        
        
        [tm1, p1] = max(abs(cir1(cfg.left_bd(1, i):cfg.right_bd(1, i), i)));
        peak1 = cfg.left_bd(1, i) + p1 - 1;
%         m = cir(peak);

        [tm2, p2] = max(abs(cir2(cfg.left_bd(2, i):cfg.right_bd(2, i), i)));
        peak2 = cfg.left_bd(2, i) + p2 - 1;

        % 用采样点粗粒度计算距离
        d1 = peak1*cfg.soundspeed/cfg.fs;
        d2 = peak2*cfg.soundspeed/cfg.fs;


%         % 用相位计算细粒度距离
%         % 整数倍波长
%         d1 = fix(d1/cfg.wavelength)*cfg.wavelength;
%         phase1 = atan(imag(tm1)/real(tm1));
%         d1 = d1 + phase1/(2*pi)*cfg.wavelength;


        dis_rcv((i-1)*cfg.nout+1) = d1;
        dis_rcv((i-1)*cfg.nout+2) = d2;
        
        dis_snd1(i) = d1;
        dis_snd2(i) = d2;
        
        % 把所有cir放到一行
        allcir((i-1)*960+1:i*960) = cir1(1:960, i)';
        allcir((i-1+cfg.nin)*960+1:(i+cfg.nin)*960) = cir2(1:960, i)';
        
    end

    t = toc(dis_tim);
    fprintf("计算距离用时：%.4f\n", vpa(t));
    
    %dis = [dis1, dis2];
%     %% 计算shift_dis
%         if cur_index==1
%             cfg.shift_dis = [dis1; dis2];
%         end
    
    %% 真实距离
%     % 零点校准
%     dis1 = dis1-cfg.init_dis(1, :);
%     dis2 = dis2-cfg.init_dis(2, :);

    % 从接收端角度
    cfg.dis_rcv = [cfg.dis_rcv; dis_rcv];
    % 从发射端角度
    cfg.dis1 = [cfg.dis1; dis_snd1];
    cfg.dis2 = [cfg.dis2; dis_snd2];

    cfg.cir1 = [cfg.cir1; allcir];

    %% 实时画图，画cir
    if cfg.drawCir
        draw_tim = tic;
        
        legend_line = [];
        for i=1:1:cfg.nin
            h = plot(cfg.figure(1, 1),[1:1:cfg.zclen/2],abs(cir1(1:end/2,i)),cfg.color(i));
%                 [peak1(i), peak1(i)],[0, abs(m1(i))], strcat('--*',cfg.color(i)));
            hold(cfg.figure(1, 1),'on');
%             legend_str = [legend_str, ['距离',num2str(i)]];
            legend_line = [legend_line, h(1)];
            legend_str{i} = ['距离S1-R',num2str(i)];
        end
        hold(cfg.figure(1, 1),'off')
        title(cfg.figure(1, 1),'左耳机CIR')
        legend(cfg.figure(1, 1),legend_line, legend_str)
        
        
        legend_line = [];
        for i=1:1:cfg.nin
            h = plot(cfg.figure(2, 1),[1:1:cfg.zclen/2],abs(cir2(1:end/2,i)),cfg.color(i));
%                 [peak2(i), peak2(i)],[0, abs(m2(i))], strcat('--*',cfg.color(i)));
            hold(cfg.figure(2, 1),'on');
            legend_line = [legend_line, h(1)];
            legend_str{i} = ['距离S2-R',num2str(i)];
        end
        hold(cfg.figure(2, 1),'off')
        title(cfg.figure(2, 1),'右耳机CIR')
        legend(cfg.figure(2, 1),legend_line, legend_str)

        drawnow();
        
        t = toc(draw_tim);
        fprintf("画cir图用时：%.4f\n", vpa(t));
    end
    

    
end