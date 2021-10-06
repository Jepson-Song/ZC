function cal_dir(cur_index)
    
    global cfg
    
    dir_tim = tic;
    
    pos1 = cfg.pos1(cur_index, :);
    pos2 = cfg.pos2(cur_index, :);
%     pos3 = cfg.pos3(cur_index, :);
%     mov_class = 0;

%     if (cur_index==1)
%         pos3 = (pos1+pos2)/2 - cfg.ear2neck;
%         cfg.O = pos3;
%         l_r_angle = -1;
%         l_d_angle = -1;
%         mov = 0;
%     else
%         last_index = cur_index - 1; % 上一帧
%         l_vec = pos1 - cfg.pos1(last_index, :); % 左耳机移动方向
%         r_vec = pos2 - cfg.pos2(last_index, :); % 右耳机移动方向
%         [div, l_r_angle] = get_angle(l_vec, r_vec);
%         last_dir = cfg.dir(last_index, :); % 上一帧的视线方向
%         [div2, l_d_angle] = get_angle(l_vec, last_dir);
%         
%         
%         %% 分类思路1
%         % 根据移动向量长度是否为零判断是否有动作
%         if div==0 % 长度为零，没动作。
%             mov = cfg.mov(last_index);
%         else % 长度不为零，有动作。
%             
%             % 根据两个移动向量是否一致将动作分为两类：一致是旋转动作和倾斜动作；不一致是三种平移动作和俯仰动作。
%             if l_r_angle < 10 % 一致，旋转动作和倾斜动作。
%                 
%                 % 根据耳机移动方向与视线方向是否垂直来分类：垂直是倾斜动作，不垂直是旋转动作。
%                 if l_d_angle>=85 && l_d_angle <=95 % 垂直，倾斜动作。
%                     mov = cfg.roll;
%                 else % 不垂直，旋转动作。
%                     mov = cfg.yaw;
%                 end
%             else % 不一致，三种平移动作和俯仰动作。
%                 
%                 % 根据耳机移动方向与视线方向是否垂直来分类：垂直是左右移动或上下移动，不垂直是前后移动或俯仰动作。
%                 if l_d_angle>=85 && l_d_angle <=95 % 垂直，左右移动或上下移动。
%                     
%                     % 根据耳机移动向量竖直方向分量是否最大来分类，最大则是上下移动，不是最大则是左右移动。
%                     if abs(l_vec(3))>=abs(l_vec(2)) && abs(l_vec(3))>=abs(l_vec(1)) % 是，上下移动。
%                         mov = cfg.heave;
%                     else % 不是，左右移动
%                         mov = cfg.sway;
%                     end
%                 else % 不垂直，前后移动或俯仰动作。
%                     
%                     % 根据耳机移动向量竖直方向分量是否最大来分类，最大则是俯仰动作，不是最大则是前后移动。
%                     if abs(l_vec(3))>=abs(l_vec(2)) && abs(l_vec(3))>=abs(l_vec(1)) % 是，俯仰动作。
%                         mov = cfg.heave;
%                     else % 不是，前后移动
%                         mov = cfg.surge;
%                     end
%                 end
%             end
%         end
        
%         %% 分类思路2
%         if div == 0 % 耳机移动距离为0，没动作
%             mov = 0;
%         else
%             % 两耳机移动方向是否一致
%             if l_r_angle < 90 % 方向一致，平移或者俯仰
% %                 if l_d_angle > 90
% %                     l_d_angle = 180 - l_d_angle;
% %                 end
%                 
%                 % 耳机移动方向和视线方向的关系
%                 if l_d_angle > 45 && l_d_angle <135 % 垂直关系，左右或上下移动
%                     mov = cfg.translation;
%                 else % 平行关系，可能是前后移动也可能是俯仰
%                     mov = cfg.pitch_surge;
%                 end
%                 
%             else % 方向不一致，旋转或者倾斜
%                 mov = cfg.rotation;
%             end 
%         end

%         %% 思路3
%         m = (pos1 + pos2)/2;
%         n = cfg.O;
%         m_n_dis = get_distance(m,n);
%         fix_dis = get_distance(cfg.ear2neck, [0,0,0]);
%         diff = abs(m_n_dis-fix_dis);
%         if diff > 0.05
%             mov = cfg.translation;
%         else
%             mov = cfg.rotation;
%         end

%         %% 思路4，默认为转动，特殊情况下认为是移动
%         mov = cfg.rotation;

       
%     set(cfg.handles.edit5,'string', num2str(l_r_angle));
%     set(cfg.handles.edit6,'string', num2str(l_d_angle));
        
%     end
    
%     %% hmm分类思路
%     class_tim = tic;
%     
%         % 计算观测状态obs
%         obs = 1;
%         if cur_index == 1
%             obs = 1;
%             pos3 = (pos1+pos2)/2 - cfg.ear2neck;
%             cfg.O = pos3;
%         else
%             last_index = cur_index - 1; % 上一帧
%             pos1_mov = pos1 - cfg.pos1(last_index, :); % 左耳机移动方向
%             
%             div_angle = 2*pi/cfg.angle_num;
%             
%             angle1 = get_angle2(pos1_mov(1), pos1_mov(2));
%             code1 = floor(angle1/div_angle)*cfg.angle_num;
%             
%             angle2 = get_angle2(sqrt(pos1_mov(1)^2+pos1_mov(2)^2),pos1_mov(3));
%             code2 = floor(angle2/div_angle)+1;
%             
%             obs = code1+code2;
%         end
%         cfg.obs = [cfg.obs, obs];
%         
%         % hmm分类
%         if cur_index < cfg.cut_len
%             mov_class = cfg.static;
%         else
%             obs_data = cfg.obs(cur_index-cfg.cut_len+1+1:cur_index);
% %             mov_class = hmm_class(obs_data);
%             mov_class = hmm_class(obs_data);
%         end
        
    %% LSTM分类思路
    class_tim = tic;
    if cur_index < cfg.cut_len
        mov_class = cfg.static;
    else
        sub_data = [cfg.pos1(cur_index-cfg.cut_len+1:cur_index, 1:3), cfg.pos2(cur_index-cfg.cut_len+1:cur_index, 1:3)];

        sub_data = sub_data - sub_data(1, :);
        sub_data = sub_data(2:end,:);

        mov_class = double(LSTM_class(cfg.net, sub_data'));
    end
    
    
%     mov_class = cfg.static;
    if (cur_index==1)
        pos3 = (pos1+pos2)/2 - cfg.ear2neck;
        cfg.O = pos3;
    end
        
    t = toc(class_tim);
    fprintf("hmm分类用时：%.4f\n", vpa(t));
            
    
    if mov_class == cfg.static % 静止
        str = "静止";
        pos3 = cfg.O;
    elseif mov_class == cfg.surge % 前后移动
        str = "前后移动";
        pos3 = (pos1+pos2)/2 - cfg.ear2neck;
    elseif mov_class == cfg.sway % 左右移动
        str = "左右移动";
        pos3 = (pos1+pos2)/2 - cfg.ear2neck;
    elseif mov_class == cfg.heave % 上下移动
        str = "上下移动";
        pos3 = (pos1+pos2)/2 - cfg.ear2neck;
    elseif mov_class == cfg.roll % 左右倾斜
        str = "左右倾斜";
        pos3 = cfg.O;
    elseif mov_class ==  cfg.pitch % 前后俯仰
        str = "前后俯仰";
        pos3 = cfg.O;
    elseif mov_class == cfg.yaw % 左右旋转
        str = "左右旋转";
        pos3 = cfg.O;
    elseif mov_class == cfg.translation % 移动
        str = "移动";
        pos3 = (pos1+pos2)/2 - cfg.ear2neck;
    elseif mov_class == cfg.rotation % 转动
        str = "转动";
        pos3 = cfg.O;
    elseif mov_class == cfg.pitch_surge % 俯仰或前后移动
        str = "俯仰或前后移动";
        pos3 = cfg.O;
    else
        str = "未定义动作";
        pos3 = cfg.O;
    end
    cfg.O = pos3;
    
    fprintf("--------------------------------------------------- hmm分类为：【 %d 】【 %s 】\n", mov_class, str);
    set(cfg.handles.edit7,'string', str);%num2str(mov));
    cfg.pos3 = [cfg.pos3; pos3];
    cfg.mov = [cfg.mov; mov_class];
    
%     po = (pos1+pos2)/2;
    dir = get_dir(pos1, pos2, pos3);
    
    % 调整向量方向
    if cur_index == 1
        if dir.*cfg.init_dir < 0
            dir = -1*dir;
        end
        
    else
        if dir.*cfg.dir(cur_index-1, :) < 0
            dir = -1*dir;
        end
        
    end
    
    cfg.dir = [cfg.dir; dir];
    
    %% 发送数据
    send_time = tic;
    send_data = [num2str(dir(2)),' ',num2str(dir(3)),' ',num2str(dir(1))];
    udp_client(send_data);
    t = toc(send_time);
    fprintf("发送数据用时：%.4f\n", vpa(t));


    t = toc(dir_tim);
    fprintf("计算方向用时：%.4f\n", vpa(t));

end


%% 求三角形法向量
function res=get_dir(p1, p2, p3)
    % size(p1)
    % size(p2)
    % size(p3)
    % 三个点的坐标
    % p1=[nodes(x1,2),nodes(x1,3),nodes(x1,4)];
    % p2=[nodes(x2,2),nodes(x2,3),nodes(x1,4)];
    % p3=[nodes(x3,2),nodes(x3,3),nodes(x3,4)];
    % 两个边向量
    a=p2-p1;
    b=p3-p1;
    % 求法向量
    c=cross(b,a);
    % 归一化
    norm = sqrt(c(1,1)^2+c(1,2)^2+c(1,3)^2);
    x=c(1,1)/norm;
    y=c(1,2)/norm;
    z=c(1,3)/norm;
    res = [x,y,z];
end

%% 求两个向量的夹角
function [div, angle] = get_angle(a, b)

    na = norm(a);
    nb = norm(b);
    if na==0 || nb==0
        div = 0;
        angle = 0;
    else
        div = 1;
        angle = acos(dot(a,b)/(na*nb))*180/pi;
    end
end


%% 求角度
function res = get_angle2(x, y)
    
    if x == 0
        if y == 0
            res = 0;
        elseif y>0
            res = pi/2;
        else
            res = 3*pi/2;
        end
    else
        res = atan(y/x);
        if x < 0
            res = pi + res;
        elseif x > 0 && y < 0
            res = 2*pi + res;
        end
    end
    

end

%% 求两点间距离
function res = get_distance(a, b)

    c = a-b;
    res = sqrt(sum(c.*c));

end