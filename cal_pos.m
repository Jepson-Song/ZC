function cal_pos(cur_index)

    %% 计算坐标
    global  cfg
    
    
    [pos1, pos2] = solve_equations(cfg.dis1(cur_index, :), cfg.dis2(cur_index, :));
    cfg.pos1 = [cfg.pos1; pos1];
    cfg.pos2 = [cfg.pos2; pos2];
%     size(cfg.pos2)
    fa_v = fa_vector(pos1, pos2, cfg.O);
    cfg.fa_v = [cfg.fa_v; fa_v];
%     size(cfg.fa_v)
    
    if cfg.ifDrawAloneCal

        draw(cur_index);
    
    drawnow();
    end
    
end


%求三角形法向量
function res=fa_vector(p1, p2, p3)
% size(p1)
% size(p2)
% size(p3)
%三个点的坐标
% p1=[nodes(x1,2),nodes(x1,3),nodes(x1,4)];
% p2=[nodes(x2,2),nodes(x2,3),nodes(x1,4)];
% p3=[nodes(x3,2),nodes(x3,3),nodes(x3,4)];
%两个边向量
a=p2-p1;
b=p3-p1;
%求法向量
c=cross(b,a);
%归一化
 norm = sqrt(c(1,1)^2+c(1,2)^2+c(1,3)^2);
 x=c(1,1)/norm;
 y=c(1,2)/norm;
 z=c(1,3)/norm;
 res = [x,y,z];
end