function cal_dis(cur_index)

%         fprintf("【cal_dis...】 Dataseg index: %d\n",cur_index);
    global cfg
    
    dis_tim = tic;
    % 截取dataseg
    dataseg = cfg.datain((cur_index-1)*cfg.seglen+1:cur_index*cfg.seglen, :);

    cir1=zeros(cfg.nin,cfg.zclen,cfg.zcrep);  %we have 3 frames 960*3 points for 3 mics
    dis1 = zeros(1, cfg.nin);
    SIGQUAL1 = zeros(1, cfg.nin);
    chose1 = zeros(1, 3);
    m1 = zeros(1, cfg.nin);
    peak1 = zeros(1, cfg.nin);
    
    cir2=zeros(cfg.nin,cfg.zclen,cfg.zcrep);  %we have 3 frames 960*3 points for 3 mics
    dis2 = zeros(1, cfg.nin);
    SIGQUAL2 = zeros(1, cfg.nin);
    chose2 = zeros(1, 3);
    m2 = zeros(1, cfg.nin);
    peak2 = zeros(1, cfg.nin);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 开始奇偶插值

    for i=1:1:3                 %for each mic
        
        data=reshape(dataseg(:,i),cfg.zclen,cfg.zcrep );  %make the data to be 1920*10
        data_fft=fft(data,[],1);                 %FFT

        temp_fft1=zeros(size(data));

        for j=1:1%size(temp_fft,2)                 %correlation on frequency domain with ZC
            temp_fft1((cfg.zclen/2-(cfg.zc_l-1)/2)+1:2:(cfg.zclen/2+(cfg.zc_l-1)/2-1),j)=data_fft(cfg.leftpoint+1:2:cfg.rightpoint-1,j).*cfg.zc_fft1(2:2:end-1)';
        end

    %     figure(1)
    %     plot(abs(temp_fft1))

        cir1(i,:,:)=ifft(fftshift(temp_fft1,1),[],1);  %ifft and get the CIR
        cir1(i,:,:) = conj(cir1(i,:,:));
    %     size(cir(i,:,:)) % 1 480 16

        %% 处理左声道
        [tm1, p1] = max(abs(cir1(i,cfg.left_bd(1, i):cfg.right_bd(1, i),1)));
%         tmp = cfg.left_bd(1, i)
        peak1(i) = cfg.left_bd(1, i) + p1 - 1;
%         peak1(i) = p1 - 1;
        m1(i) = cir1(i,peak1(i),1);

        % 峰值窗口左右边界
%         cfg.left_bd(1, i) = max([peak1(i) - cfg.windows/2, 1]);
%         cfg.right_bd(1, i) = min([peak1(i) + cfg.windows/2, cfg.zclen/2]);

        % 用采样点粗粒度计算距离
        dis1(i) = peak1(i)*cfg.soundspeed/cfg.fs;
        % 整数倍波长
        dis1(i) = fix(dis1(i)/cfg.wavelength)*cfg.wavelength;
        
        real_part1 = real(m1(i));
        imag_part1 = imag(m1(i));

        phase1 = atan(imag_part1/real_part1);
    %         phase = angle(imag_part1/real_part1);

        % 用相位计算细粒度距离
        dis1(i) = dis1(i) + phase1/(2*pi)*cfg.wavelength;
        
        
        SIGQUAL1(i) = tm1/(sum(abs(cir1(i,1:cfg.zclen/2,1)))-tm1)*(cfg.zclen/2-1);
        
        chose1(i) = i;
        
        % 更新初始距离
        if SIGQUAL1(i) > cfg.SIG_LOS && dis1(i) < cfg.init_dis(1, i)
            cfg.init_dis(1, i) = dis1(i);
        end
        
        if i==cfg.nin/2
%             dis1
%             SIGQUAL1
        end


        
    end
    
    
    for i=cfg.nin/2+1:1:cfg.nin                  %for each mic
        data=reshape(dataseg(:,i),cfg.zclen,cfg.zcrep );  %make the data to be 1920*10
        data_fft=fft(data,[],1);                 %FFT

        temp_fft2=zeros(size(data));

        for j=1:1%size(temp_fft,2)                 %correlation on frequency domain with ZC
            temp_fft2((cfg.zclen/2-(cfg.zc_l-1)/2):2:(cfg.zclen/2+(cfg.zc_l-1)/2),j)=data_fft(cfg.leftpoint:2:cfg.rightpoint,j).*cfg.zc_fft2(1:2:end)';
        end

        cir2(i,:,:)=ifft(fftshift(temp_fft2,1),[],1);  %ifft and get the CIR
        cir2(i,:,:) = conj(cir2(i,:,:));

    %     size(cir(i,:,:)) % 1 480 16


        %% 处理右声道
        [tm2, p2] = max(abs(cir2(i,cfg.left_bd(2, i):cfg.right_bd(2, i),1)));

        peak2(i) = cfg.left_bd(2, i) + p2 - 1;

        m2(i) = cir2(i,peak2(i),1);

        % 峰值窗口左右边界
%         cfg.left_bd(2, i) = max([peak2(i) - cfg.windows/2, 1]);
%         cfg.right_bd(2, i) = min([peak2(i) + cfg.windows/2, cfg.zclen]);


        dis2(i) = peak2(i)*cfg.soundspeed/cfg.fs;
        dis2(i) = fix(dis2(i)/cfg.wavelength)*cfg.wavelength;

        real_part2 = real(m2(i));
        imag_part2 = imag(m2(i));

        phase2 = atan(imag_part2/real_part2);

        dis2(i) = dis2(i) + phase2/(2*pi)*cfg.wavelength;
        
        
        SIGQUAL2(i) = tm2/(sum(abs(cir2(i,1:cfg.zclen/2,1)))-tm2)*(cfg.zclen/2-1);
        
        chose2(i-3) = i;
        
        % 更新初始距离
        if SIGQUAL2(i) > cfg.SIG_LOS && dis2(i) < cfg.init_dis(2, i)
            cfg.init_dis(2, i) = dis2(i);
        end
        
        if i==cfg.nin
%             dis2
%             SIGQUAL2
        end
        
        
    end
    
    t = toc(dis_tim);
    fprintf("计算距离用时：%.4f\n", vpa(t));
    
    %dis = [dis1, dis2];
    %% 计算shift_dis
        if cur_index==1
            cfg.shift_dis = [dis1; dis2];
        end
    
%         size(dis1)
%         size(cfg.shift_dis)
%         size(cfg.init_dis)

    %% 真实距离
    % 零点校准
%     cfg.dis1 = [cfg.dis1; dis1-cfg.shift_dis(1, :)+cfg.init_dis(1, :)];
%     cfg.dis2 = [cfg.dis2; dis2-cfg.shift_dis(2, :)+cfg.init_dis(2, :)];
    dis1 = dis1-cfg.init_dis(1, :);
    dis2 = dis2-cfg.init_dis(2, :);
    % 不校准直接用计算出来的坐绝对距离
    notchose1 = [4, 5, 6];
    notchose2 = [1, 2, 3];
    dis1(notchose1) = ones(1, 3)*-1;
    dis2(notchose2) = ones(1, 3)*-1;
    cfg.dis1 = [cfg.dis1; dis1];
    cfg.dis2 = [cfg.dis2; dis2];
    cfg.SIGQUAL1 = [cfg.SIGQUAL1; SIGQUAL1];
    cfg.SIGQUAL2 = [cfg.SIGQUAL2; SIGQUAL2];
    cfg.chose1 = [cfg.chose1, chose1];
    cfg.chose2 = [cfg.chose2, chose2];
    
 
    
    %% 实时画图，画cir
    if cfg.drawCir
        draw_tim = tic;
%         plot(cfg.figure(1, 1),[1:1:cfg.zclen/2],abs(cir1(1,1:end/2,1)),cfg.color(1)...
%                         ,[1:1:cfg.zclen/2],abs(cir1(2,1:end/2,1)),cfg.color(2)...
%                         ,[1:1:cfg.zclen/2],abs(cir1 (3,1:end/2,1)),cfg.color(3)...
%                         ,[peak1(1), peak1(1)],[0, abs(m1(1))], strcat('--*',cfg.color(1))...
%                         ,[peak1(2), peak1(2)],[0, abs(m1(2))], strcat('--*',cfg.color(2))...
%                         ,[peak1(3), peak1(3)],[0, abs(m1(3))], strcat('--*',cfg.color(3)));

    %     plot(cfg.figure(1, 2),[1:1:cfg.dislen],cfg.dis1(1,end-cfg.dislen+1:end),cfg.color(1) ...
    %                     ,[1:1:cfg.dislen],cfg.dis1(2,end-cfg.dislen+1:end),cfg.color(2)...
    %                     ,[1:1:cfg.dislen],cfg.dis1(3,end-cfg.dislen+1:end),cfg.color(3));

%         plot(cfg.figure(2, 1),[1:1:cfg.zclen/2],abs(cir2(1,1:end/2,1)),cfg.color(1)...
%                         ,[1:1:cfg.zclen/2],abs(cir2(2,1:end/2,1)),cfg.color(2)...
%                         ,[1:1:cfg.zclen/2],abs(cir2(3,1:end/2,1)),cfg.color(3)...
%                         ,[peak2(1), peak2(1)],[0, abs(m2(1))], strcat('--*',cfg.color(1))...
%                         ,[peak2(2), peak2(2)],[0, abs(m2(2))], strcat('--*',cfg.color(2))...
%                         ,[peak2(3), peak2(3)],[0, abs(m2(3))], strcat('--*',cfg.color(3)));
%         legend_str = zeros(1, cfg.nin);
        legend_line = [];
        for i=1:1:cfg.nin/2
            h = plot(cfg.figure(1, 1),[1:1:cfg.zclen/2],abs(cir1(i,1:end/2,1)),cfg.color(i),...
                [peak1(i), peak1(i)],[0, abs(m1(i))], strcat('--*',cfg.color(i)));
            hold(cfg.figure(1, 1),'on');
%             legend_str = [legend_str, ['距离',num2str(i)]];
            legend_line = [legend_line, h(1)];
            legend_str{i} = ['距离',num2str(i)];
        end
        hold(cfg.figure(1, 1),'off')
        title(cfg.figure(1, 1),'左耳机CIR')
        legend(cfg.figure(1, 1),legend_line, legend_str)
        
        
        legend_line = [];
        for i=cfg.nin/2+1:1:cfg.nin
            h = plot(cfg.figure(2, 1),[1:1:cfg.zclen/2],abs(cir2(i,1:end/2,1)),cfg.color(i),...
                [peak2(i), peak2(i)],[0, abs(m2(i))], strcat('--*',cfg.color(i)));
            hold(cfg.figure(2, 1),'on');
            legend_line = [legend_line, h(1)];
            legend_str{i-cfg.nin/2} = ['距离',num2str(i)];
        end
        hold(cfg.figure(2, 1),'off')
        title(cfg.figure(2, 1),'右耳机CIR')
        legend(cfg.figure(2, 1),legend_line, legend_str)
%         legend(cfg.figure(2, 1),'距离1','距离2','距离3')
    %     plot(cfg.figure(2, 2),[1:1:cfg.dislen],cfg.dis2(1,end-cfg.dislen+1:end),cfg.color(1) ...
    %                     ,[1:1:cfg.dislen],cfg.dis2(2,end-cfg.dislen+1:end),cfg.color(2)...
    %                     ,[1:1:cfg.dislen],cfg.dis2(3,end-cfg.dislen+1:end),cfg.color(3));

        drawnow();
        t = toc(draw_tim);
        draw(cur_index)
        fprintf("画图用时：%.4f\n", vpa(t));
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
    drawnow();
    
end