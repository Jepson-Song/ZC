function res = cal_resp(data)%, cur_index, seg_len)

    global cfg
    
    type = 2; % 1.呼吸 2.心跳
    
    %allcir = cfg.cir1(cur_index-seg_len+1:cur_index, :);
    allcir = data;
    %% pca
        sel_cir1 = [];
        all_SNR = [];
        
    % 两发六收一共十二个cir，存储格式是12个并排放到同一行
    for i=1:1:12
        
        % 某个接收端的cir，T*F
        tcir1 = allcir(:, (i-1)*960+1:i*960);
    
        % 画cir
%         draw_pic(cfg.figure7,tcir1')

        % 按时间进行差分
        dcir1 = diff(tcir1, 1, 1);  % para3: 1是列差分 2是行差分
        
        % 画差分cir1
        draw_pic(cfg.figure8,dcir1')

        cir1 = dcir1;
        % 从文件中读出来的数据行号都是时间T
        [T, Frame] = size(cir1);
        
%         cir1 = lowpass(0.5,0.6,cir1,10);

        % 画fft
%         draw_pic(cfg.figure5, fft_cir1(1:51,:)');

        % path selection
        fft_cir1 = abs(fft(cir1,100));
        
        for index=1:1:Frame
            
            % 路径选择
            Emax = max(fft_cir1([1:1:5]+1,index));
            part1 = sum(fft_cir1([1:1:5]+1,index))-Emax;
            part2 = sum(fft_cir1([5:1:50]+1,index));
            w1 = 0.5;
            w2 = 0.5;
            SNR(index) = w1*Emax/part1+w2*Emax/part2;

%             % 先减去复数均值
%             cir1(:, index) = cir1(:, index) - mean(cir1(:, index)); %作用不大

%             % 再做LEVD
%             cir1(:, index) = LEVD(cir1(:, index));

            % 再做滑动平均
            if type==1
            cir1(:, index) = smooth(cir1(:, index), 21); % 有作用
            elseif type==2
            cir1(:, index) = smooth(cir1(:, index), 7); 
            end

        end
        
        % 处理后
        %draw_pic(cfg.figure6, cir1');
        
        % 选择path
        all_SNR = [all_SNR; SNR];
        l_bd = 1;
        r_bd = 960;
        SNR_thr = 0; %SNR_thr设为0意味着不做路径选择
        [, sel]= find(SNR(l_bd:r_bd)>=SNR_thr);
        sel = sel + l_bd - 1;
%         sel = [1:1:960];

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
    
    cfg.SNR = all_SNR;
    
    % 路径选择后的cir
%     sel_cir1 = real(sel_cir1);

    % pca
    [coeff,score,latent] = pca(sel_cir1); % coeff 转换矩阵   score 降维后结果  latent 特征值
    
    latent(1:10)';
    
    for i=1:1:1

        if type==1
        % 低通滤波（呼吸）
        score(:, i) = lowpass(0.5,0.6,score(:, i),10);
        % 对呼吸结果做滑动平均 
        score(:, i) = smooth(score(:, i), 15); % 有作用
        elseif type==2
        % 带通滤波（心跳）
        score(:, i) = bandpass(1,2,score(:, i),10);
        % 对心跳结果做滑动平均 
        score(:, i) = smooth(score(:, i), 5);
        end
        
           
        
%         resp = LEVD(resp);
        
        
        % 画图
%         resp = score(:, i);
%         figure(cur_index+i)
%         plot(resp)
%         title('呼吸波形')
%         legend(num2str(cur_index+i))
    end
    
    res = score(:, 1)';
    
%     resp = score(:, 1)+score(:, 2)+score(:, 3);
%     
%         resp = lowpass(0.5,0.6,resp,10);
%         figure(cur_index+5)
%         plot(resp)
%         title('呼吸波形')
%         legend(num2str(cur_index+5))
        
    
%     resp = score(:,1:5);%+score(:,2)+score(:,3);    
%     % 低通滤波
%     resp = lowpass(0.3,0.4,resp,10);
%     figure(2)
%     plot(resp)
%     title('呼吸波形')
%     legend('1','2','3')

end


function res = LEVD(x)

    thr = std(x)*3;
    
    len = length(x);
    s = zeros(1, len);
    n = 1;
    e = [];
    e = [e, x(1)];
    s(1) = x(1);
    
    ax = [1];
    ay = [x(1)];
%     figure(4)
%     plot(x)
    for i=2:1:len-1
        
%         if i~=1&&i~=n&&()
        if x(i)>=x(i-1)&&x(i)>=x(i+1)||x(i)<=x(i-1)&&x(i)<=x(i+1)

            if abs(x(i)-e(n)) > thr
                n = n + 1;
                e = [e, x(i)];
                ax = [ax, i];
                ay = [ay, x(i)];
            end
                
            
        end
        if n>=2
            s(i) = 0.9*s(i-1)+0.1*(e(n)+e(n-1))/2;
        else
            s(i) = 0.9*s(i-1)+0.1*e(n);
        end
    end
    
%     ax
%     ay
%     figure(5)
%     
%     plot(x)
%     hold on 
% 
%     plot(ax,ay,'*')
% %     plot(tmp)
%     hold off
    res = x-s';
end