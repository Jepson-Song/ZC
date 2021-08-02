function cal_pos(cur_index)

    pos_tim = tic;

    %% 计算坐标
    global  cfg
    
    %% 先选出三个信号最好的
    % TODO
    
    
    %% 解方程
    [pos1, pos2, pos3] = solve_equations(cur_index);%solve_equations(cfg.dis1(cur_index, :), cfg.dis2(cur_index, :));
    cfg.pos1 = [cfg.pos1; pos1];
    cfg.pos2 = [cfg.pos2; pos2];
    cfg.pos3 = [cfg.pos3; pos3];
    
    cal_dir(cur_index);

    
    %%
%     arrows = [ po; po+dir/100*15];
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
%     size(cfg.dir)
    
%     draw(cur_index);
    
    t = toc(pos_tim);
    fprintf("计算位置用时：%.4f\n", vpa(t));
end
