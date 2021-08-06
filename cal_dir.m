function cal_dir(cur_index)
    
    global cfg
    
    dir_tim = tic;
    cfg.timeTree = cfg.timeTree + 1;
    
    pos1 = cfg.pos1(cur_index, :);
    pos2 = cfg.pos2(cur_index, :);
%     pos3 = cfg.pos3(cur_index, :);
    mov = 0;

    if (cur_index==1)
        pos3 = (pos1+pos2)/2 - cfg.ear2neck;
        cfg.O = pos3;
        mov = 0;
        sita = 0;
    else
        pos3 = cfg.O;
        l_vec = pos1 - cfg.pos1(cur_index-1, :);
        r_vec = pos2 - cfg.pos2(cur_index-1, :);
        nl = norm(l_vec);
        nr = norm(r_vec);
        if nl==0 || nr==0 % 没移动
            sita = 0;
            mov = cfg.mov(cur_index-1);
        else
            sita = acos(dot(l_vec,r_vec)/(nl*nr))*180/pi; % 求向量夹角 %todo：除数是0的问题
            
            if sita < 10
                mov = 1;
            else
                mov = 2;
            end
            
        end
    end
    set(cfg.handles.edit2,'string',num2str(sita));
    cfg.pos3 = [cfg.pos3; pos3];
    cfg.mov = [cfg.mov; mov];
    
%     po = (pos1+pos2)/2;
    dir = get_dir(pos1, pos2, pos3);
    
    % 调整向量方向
    if cur_index == 1
        init_dir = [-1 -1 0];
        if dir.*init_dir < 0
            dir = -1*dir;
        end
        
    else
        if dir.*cfg.dir(cur_index-1, :) < 0
            dir = -1*dir;
        end
        
    end
    
    cfg.dir = [cfg.dir; dir];
    
    %% 发送数据
%     send_time = tic;
%     send_data = [num2str(dir(1)),' ',num2str(dir(2)),' ',num2str(dir(3))];
%     udp_client(send_data);
%     t = toc(send_time);
%     fprintf("发送数据用时：%.4f\n", vpa(t));


    t = toc(dir_tim);
    cfg.timeTree = cfg.timeTree - 1;
    for i=1:1:cfg.timeTree
        fprintf(" # ");
    end
    fprintf("计算方向用时：%.4f\n", vpa(t));

end



%求三角形法向量
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