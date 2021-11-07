function compareOrientarion()
%     global cfg
    
    rec = load_data('rec');
    pos1 = rec(:, 1:3);
    pos2 = rec(:, 4:6);
    dir = rec(:, 7:9);
    
    point_end = [
%                 0 1.20 0;
              0 0.90 -0;
              0 0.60 0;
              0 0 0;
              0.60 0 0;
              0.90 0 -0;
%               1.20 0 0;
              0 0.90 -0;
              0 0.60 0;
              0 0 0;
              0.60 0 0;
              0.90 0 -0;
              0 0.90 -0;
              0 0.60 0;
              0 0 0;
              0.60 0 0;
              0.90 0 -0;];
    start_ub = (pos1+pos2)/2;
    dir
    
    
    len = size(pos1,1);
    mn_err = 360;
    point_start = start_ub;
    shift = [0,0,0];
    shift_rem = shift;
    while(1)
        dir_m = point_end - point_start;
        include_angle = cal_angle(dir, dir_m);
        avg_err = sum(include_angle)/len;
        if avg_err < mn_err
            mn_err = avg_err;
            shift_rem = shift;
        end
        shift = shift - [0,0,0.001];
        point_start = start_ub + shift;
        if shift(3) < -0.2
            break
        end
    end
    
    shift_rem
    point_start = start_ub + shift_rem;
    dir_m = point_end - point_start;
    
    include_angle  = cal_angle(dir, dir_m);
    avg_err = sum(include_angle)/len
    
        
    
    figure(1)
    plot(include_angle);
    xlabel('Samle')
    ylabel('Error (degree)')


end

function include_angle = cal_angle(dir, dir_m)

    include_angle  =[];
    len = size(dir_m,1);
    for i=1:1: len
%         dir_m(i,:).*dir(i,:)
        include_angle = [include_angle, acos(sum(dir_m(i,:).*dir(i,:))/(sqrt(sum(dir_m(i,:).*dir_m(i,:)))*sqrt(sum(dir(i,:).*dir(i,:)))))/pi*180];
    end
%     figure(1)
%     plot(include_angle);
    avg_err = sum(include_angle)/len;

end


function data = load_data(type)
    
    global cfg
    
    prefix = '20211107_104931';%get(cfg.handles.edit1, 'string');
    dir_address = [cfg.dataAddress,prefix];
    if ~exist(dir_address,'dir')
        fprintf("文件夹不存在\n");
        return;
    end

    fprintf("\n-----【开始读取数据】-----\n");
    if isempty(type)
        fileName =  [prefix, '.txt'];
    else
        fileName =  [prefix, '_', type '.txt'];
    end
    fprintf("【从文件读取数据】 "+fileName+"\n");
    address = [dir_address,'\',fileName];
    data = load(address);
    fprintf("-----【完成读取数据】-----\n");
    

end