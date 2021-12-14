function cal_dis_2O6I(cur_index)

%         fprintf("【cal_dis...】 Dataseg index: %d\n",cur_index);
    global cfg
    
    dis_tim = tic;
    
    % 截取dataseg
    dataseg = cfg.datain((cur_index-1)*cfg.seglen+1:cur_index*cfg.seglen, :);
%     whos dataseg


    cir1=zeros(cfg.zclen, cfg.nin);  %we have 3 frames 960*3 points for 3 mics
    dis1 = zeros(1, cfg.nin);
    SIGQUAL1 = zeros(1, cfg.nin);
    chose1 = zeros(1, 3);
    
%     cir2=zeros(cfg.nin,cfg.zclen,cfg.zcrep);  %we have 3 frames 960*3 points for 3 mics
    cir2=zeros(cfg.zclen, cfg.nin);  %we have 3 frames 960*3 points for 3 mics
    dis2 = zeros(1, cfg.nin);
    SIGQUAL2 = zeros(1, cfg.nin);
    chose2 = zeros(1, 3);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 开始奇偶插值
    
    allcir = zeros(1, 960*12);
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
        
%         if i==3
% %             cfgcir1 = real(cir1(1:960, i)');
%             cfgcir1 = cir1(1:960, i)';
% %             whos cfgcir1
%         end
        
        [tm1, p1] = max(abs(cir1(cfg.left_bd(1, i):cfg.right_bd(1, i), i)));
        peak1 = cfg.left_bd(1, i) + p1 - 1;
%         m = cir(peak);

        [tm2, p2] = max(abs(cir2(cfg.left_bd(2, i):cfg.right_bd(2, i), i)));
        peak2 = cfg.left_bd(2, i) + p2 - 1;

        % 用采样点粗粒度计算距离
        d1 = peak1*cfg.soundspeed/cfg.fs;
        d2 = peak2*cfg.soundspeed/cfg.fs;


        dis1(i) = d1;
        dis2(i) = d2;
        
        
%         % 用相位计算细粒度距离
%         % 整数倍波长
%         d1 = fix(d1/cfg.wavelength)*cfg.wavelength;
%         phase1 = atan(imag(tm1)/real(tm1));
%         d1 = d1 + phase1/(2*pi)*cfg.wavelength;
%         
%         dis2(i) = d1;
        
        
%         chose1(i) = i;
%         chose2(i) = i;

        SIGQUAL1(i) = tm1/(sum(abs(cir1(1:cfg.zclen/2)))-tm1)*(cfg.zclen/2-1);
        SIGQUAL2(i) = tm2/(sum(abs(cir2(1:cfg.zclen/2)))-tm2)*(cfg.zclen/2-1);
        
        % 更新初始距离
        if SIGQUAL2(i) > cfg.SIG_LOS && dis2(i) < cfg.init_dis(2, i)
            cfg.init_dis(2, i) = dis2(i);
        end
        
        % 把所有cir放到一行
        allcir((i-1)*960+1:i*960) = cir1(1:960, i)';
        allcir((i-1+6)*960+1:(i+6)*960) = cir2(1:960, i)';
    end
%     whos allcir
%     cfgcir1 = ;

    
    t = toc(dis_tim);
    fprintf("计算距离用时：%.4f\n", vpa(t));
    
    %dis = [dis1, dis2];
%     %% 计算shift_dis
%         if cur_index==1
%             cfg.shift_dis = [dis1; dis2];
%         end
    
    %% 真实距离
    % 零点校准
    dis1 = dis1-cfg.init_dis(1, :);
    dis2 = dis2-cfg.init_dis(2, :);
    
    %     dis1
    [val, index1] = sort(SIGQUAL1);
    chose1 = index1(cfg.nin-2:cfg.nin);
    [val, index2] = sort(SIGQUAL2);
    chose2 = index2(cfg.nin-2:cfg.nin);
    
    notchose1 = index1(1:cfg.nin-3);
    notchose2 = index2(1:cfg.nin-3);

    % 固定每个发射端对应的接收端
    chose1 = [1 2 3];
    chose2 = [4 5 6];
    notchose1 = [4 5 6];
    notchose2 = [1 2 3];
    
%     chose2 = chose1;
%     notchose2 = notchose1;
    
    dis1(notchose1) = ones(1, 3)*0;
    dis2(notchose2) = ones(1, 3)*0;
    
    cfg.dis1 = [cfg.dis1; dis1];
    cfg.dis2 = [cfg.dis2; dis2];
    cfg.cir1 = [cfg.cir1; allcir];
%     tmp = cfg.cir1;
%     whos tmp
    cfg.SIGQUAL1 = [cfg.SIGQUAL1; SIGQUAL1];
    cfg.SIGQUAL2 = [cfg.SIGQUAL2; SIGQUAL2];
    cfg.chose1 = [cfg.chose1; chose1];
    cfg.chose2 = [cfg.chose2; chose2];
    
 
%     figure(2)
%     legend_line = [];
%         for i=1:1:3
%             h = plot([1:1:cfg.zclen],abs(cir1(1:end,i)),cfg.color(i));
% %                 [peak1(i), peak1(i)],[0, abs(m1(i))], strcat('--*',cfg.color(i)));
%             hold on
% %             legend_str = [legend_str, ['距离',num2str(i)]];
%             legend_line = [legend_line, h(1)];
%             legend_str{i} = ['Reciever',num2str(i)];
%         end
%         hold off
% %         title(cfg.figure(1, 1),'左耳机CIR')
%         legend(legend_line, legend_str)
        
    
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
            legend_str{i} = ['距离',num2str(i)];
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
            legend_str{i} = ['距离',num2str(i)];
        end
        hold(cfg.figure(2, 1),'off')
        title(cfg.figure(2, 1),'右耳机CIR')
        legend(cfg.figure(2, 1),legend_line, legend_str)

        drawnow();
        
        t = toc(draw_tim);
        fprintf("画cir图用时：%.4f\n", vpa(t));
    end
    

    
%         %% 三个同源麦克风对于同一个发射端的零点漂移很可能是相同的
%         dis1 = [zeros(cfg.dislen, cfg.nin); cfg.dis1];
%         dis2 = [zeros(cfg.dislen, cfg.nin); cfg.dis2];
%         %fprintf("【正在画图...】 Dataseg index: %d\n",cur_index);
%         % dis
%         plot(cfg.figure(1, 2),[1:1:cfg.dislen],dis1(cur_index:cfg.dislen+cur_index-1, 1),cfg.color(1) ...
%                         ,[1:1:cfg.dislen],dis1(cur_index:cfg.dislen+cur_index-1, 2),cfg.color(2)...
%                         ,[1:1:cfg.dislen],dis1(cur_index:cfg.dislen+cur_index-1, 3),cfg.color(3));
% %             ylim(cfg.figure(1, 2), [0 0.2])
%         plot(cfg.figure(2, 2),[1:1:cfg.dislen],dis2(cur_index:cfg.dislen+cur_index-1, 1),cfg.color(1) ...
%                         ,[1:1:cfg.dislen],dis2(cur_index:cfg.dislen+cur_index-1, 2),cfg.color(2)...
%                         ,[1:1:cfg.dislen],dis2(cur_index:cfg.dislen+cur_index-1, 3),cfg.color(3));
% %             ylim(cfg.figure(2, 2), [0 0.2])
%     drawnow();
    
end