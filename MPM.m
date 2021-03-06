function MPM()
%     global cfg
    
    rec = load_data('rec');
    pos1 = rec(:, 1:3);
    pos2 = rec(:, 4:6);
    dir = rec(:, 7:9);
    
    % 初始的所有备选标记点
    point_end = [
%                 0 1.20 0;
              0 0.90 -0;
              0 0.60 0;
              0 0 0;
              0.60 0 0;
              0.90 0 -0;
              ];
    start_ub = (pos1+pos2)/2;
    dir
    
    
    len = size(pos1,1);
    mn_err = 360;
    point_start = start_ub;
    shift = [0,0,0];
    shift_rem = shift;
    while(1)
%         dir_truth = point_end - point_start;
%         include_angle = cal_angle(dir, dir_truth);
        include_angle = auto(dir, point_start, point_end);
        
        avg_err = sum(include_angle)/len;
        % 修正头部朝向groundtruth的起点
        if avg_err < mn_err
            mn_err = avg_err;
            shift_rem = shift;
        end
        shift = shift - [0,0,0.001];
        point_start = start_ub + shift;
        % 修正的下边界是下移20cm
        if shift(3) < -0.2
            break
        end
    end
    
    shift_rem
    point_start = start_ub + shift_rem;
    
%     dir_truth = point_end - point_start;
%     include_angle  = cal_angle(dir, dir_truth);
    
    
    include_angle = auto(dir, point_start, point_end);
    
    
    avg_err = sum(include_angle)/len
    
        
    
    figure(1)
    plot(include_angle);
    xlabel('Samle')
    ylabel('Error (degree)')


end

%% 自动选择标记点
function include_angle= auto(dir, point_start, init_point_end)
    
    len = size(point_start,1);
    len_end = size(init_point_end,1);
    include_angle = [];
    for i=1:1:len
        mn_angle = 360;
        % 选择方法是使用所有标记点计算朝向和系统的朝向比较，选择夹角最小的那个标记点。
        for j=1:1:len_end
            dir_truth = init_point_end(j,:) - point_start(i, :);
            angle = acos(sum(dir_truth.*dir(i,:))/(sqrt(sum(dir_truth.*dir_truth))*sqrt(sum(dir(i,:).*dir(i,:)))))/pi*180;
            if angle < mn_angle
                mn_angle = angle;
            end
        end
        include_angle = [include_angle, mn_angle];
    end
        

end
