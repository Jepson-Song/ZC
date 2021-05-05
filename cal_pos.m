function cal_pos(cur_index)

    %% 计算坐标
    global  cfg
    
    
    [pos1, pos2] = solve_equations(cfg.dis1(:, cur_index), cfg.dis2(:, cur_index));
    cfg.pos1 = [cfg.pos1, pos1];
    cfg.pos2 = [cfg.pos2, pos2];
    
    if cfg.ifDrawAloneCal

        draw(cur_index);
    
    drawnow();
    end
    
end