function cal_pos(cur_index)

    %% 计算坐标
    global  cfg
    
    
    [pos1, pos2, pos3] = solve_equations(cfg.dis1(cur_index, :), cfg.dis2(cur_index, :));
    cfg.pos1 = [cfg.pos1; pos1];
    cfg.pos2 = [cfg.pos2; pos2];
    cfg.pos3 = [cfg.pos3; pos3];
%     size(cfg.pos2)
%     fa = tic;
%     cfg.O = (pos1+pos2)/2 - [0 0 0.08];
    
    po = (pos1+pos2)/2;
    fa_v = fa_vector(pos1, pos2, pos3);
    cfg.fa_v = [cfg.fa_v; fa_v];
    
%     arrows = [ po; po+fa_v/100*15];
%     if cfg.drawVec == 1
% %         fig = figure
%         plot3(cfg.figure5, arrows(:, 1), arrows(:, 2), arrows(:, 3), 'r')
%             xlim(cfg.figure5, [-cfg.lim cfg.lim])
%             ylim(cfg.figure5, [-cfg.lim cfg.lim])
%             zlim(cfg.figure5, [-cfg.lim cfg.lim])
%             set(cfg.figure5,  'XGrid', 'on')
%             set(cfg.figure5,  'YGrid', 'on')
%             set(cfg.figure5,  'ZGrid', 'on')
%             xlabel(cfg.figure5, 'X')
%             ylabel(cfg.figure5, 'Y')
%             zlabel(cfg.figure5, 'Z')
%             title(cfg.figure5,'3D')
% %             quiver3(cfg.figure5, arrows(1,1),arrows(1,2),arrows(1,3),arrows(2,1),arrows(2,2),arrows(2,3))
%             drawnow();
%     end
    
%     t = toc(fa);
%     fprintf("求法向量用时：%.4f\n", vpa(t));
%     size(cfg.fa_v)
    
    draw(cur_index);
    
end


%求三角形法向量
function res=fa_vector(p1, p2, p3)
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