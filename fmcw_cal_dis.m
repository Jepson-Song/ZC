function fmcw_cal_dis(cur_index)

%         fprintf("【cal_dis...】 Dataseg index: %d\n",cur_index);
    global cfg
    
    dis_tim = tic;
    % 截取dataseg
    dataseg = cfg.datain((cur_index-1)*cfg.seglen+1:cur_index*cfg.seglen, :);
    
    dis1 = zeros(1, cfg.nin);
    dis2 = zeros(1, cfg.nin);
    for i=1:cfg.nin                  %for each mic
        yr = bandpass(cfg.fl1, cfg.fr1, dataseg(:, 1), cfg.fs);
%         whos yr 
        len = length(yr);
        ys = cfg.datain(1:1:len, 1);
%         whos ys
        ym = ys.*yr;
%         whos ym
        
        tmp = my_spectrogram(ym, cfg.fs)
        dis1(i) = cfg.soundspeed*tmp*cfg.T/cfg.B1;
        
%         figure(1)
%         spectrogram(yr,256,250,256,cfg.fs);
%         figure(2)
%         spectrogram(ys,256,250,256,cfg.fs);
        
%         spectrogram(yr,128,120,128,1E3);
        
        
        yr = bandpass(cfg.fl1, cfg.fr1, dataseg(:, 2), cfg.fs);
%         whos yr 
        len = length(yr);
        ys = cfg.datain(1:1:len, 2);
%         whos ys
        ym = ys.*yr;
%         whos ym
        
        tmp = my_spectrogram(ym, cfg.fs);
        dis2(i) = cfg.soundspeed*tmp*cfg.T/cfg.B2;
    end
    
    
    
    
    t = toc(dis_tim);
    fprintf("计算距离用时：%.4f\n", vpa(t));
    
    %dis = [dis1, dis2];
    %% 计算shift_dis
        if cur_index==1
            cfg.shift_dis = [dis1, dis2];
        end
    
%         size(dis1)
%         size(cfg.shift_dis)
%         size(cfg.init_dis)

    %% 真实距离
    % 零点校准
%     cfg.dis1 = [cfg.dis1; dis1-cfg.shift_dis(1, :)+cfg.init_dis(1, :)];
%     cfg.dis2 = [cfg.dis2; dis2-cfg.shift_dis(2, :)+cfg.init_dis(2, :)];
    
    % 不校准直接用计算出来的坐绝对距离
    cfg.dis1 = [cfg.dis1; dis1];
    cfg.dis2 = [cfg.dis2; dis2];
    
 
    
    %% 实时画图，画cir
    if cfg.drawCir && strcmp(cfg.signal, 'zc')==1
        draw_tim = tic;
        plot(cfg.figure(1, 1),[1:1:cfg.zclen/2],abs(cir1(1,1:end/2,1)),cfg.color(1)...
                        ,[1:1:cfg.zclen/2],abs(cir1(2,1:end/2,1)),cfg.color(2)...
                        ,[1:1:cfg.zclen/2],abs(cir1 (3,1:end/2,1)),cfg.color(3)...
                        ,[peak1(1), peak1(1)],[0, abs(m1(1))], strcat('--*',cfg.color(1))...
                        ,[peak1(2), peak1(2)],[0, abs(m1(2))], strcat('--*',cfg.color(2))...
                        ,[peak1(3), peak1(3)],[0, abs(m1(3))], strcat('--*',cfg.color(3)));
        title(cfg.figure(1, 1),'左耳机CIR')
        legend(cfg.figure(1, 1),'距离1','距离2','距离3')
    %     plot(cfg.figure(1, 2),[1:1:cfg.dislen],cfg.dis1(1,end-cfg.dislen+1:end),cfg.color(1) ...
    %                     ,[1:1:cfg.dislen],cfg.dis1(2,end-cfg.dislen+1:end),cfg.color(2)...
    %                     ,[1:1:cfg.dislen],cfg.dis1(3,end-cfg.dislen+1:end),cfg.color(3));

        plot(cfg.figure(2, 1),[1:1:cfg.zclen/2],abs(cir2(1,1:end/2,1)),cfg.color(1)...
                        ,[1:1:cfg.zclen/2],abs(cir2(2,1:end/2,1)),cfg.color(2)...
                        ,[1:1:cfg.zclen/2],abs(cir2(3,1:end/2,1)),cfg.color(3)...
                        ,[peak2(1), peak2(1)],[0, abs(m2(1))], strcat('--*',cfg.color(1))...
                        ,[peak2(2), peak2(2)],[0, abs(m2(2))], strcat('--*',cfg.color(2))...
                        ,[peak2(3), peak2(3)],[0, abs(m2(3))], strcat('--*',cfg.color(3)));
        title(cfg.figure(2, 1),'右耳机CIR')
        legend(cfg.figure(2, 1),'距离1','距离2','距离3')
    %     plot(cfg.figure(2, 2),[1:1:cfg.dislen],cfg.dis2(1,end-cfg.dislen+1:end),cfg.color(1) ...
    %                     ,[1:1:cfg.dislen],cfg.dis2(2,end-cfg.dislen+1:end),cfg.color(2)...
    %                     ,[1:1:cfg.dislen],cfg.dis2(3,end-cfg.dislen+1:end),cfg.color(3));

        drawnow();
        t = toc(draw_tim);
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