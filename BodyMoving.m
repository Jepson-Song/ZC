function  BodyMoving()

    data = load_data('dir');
    
    
    pos3 = data(:, 1:3);
    dir = data(:, 4:6)
%     dir = rec(:, 7:9);
    
    
    len = size(dir,1);
    
    dir_init = dir(1, :)
    
    dir_truth = [];
    
    for i=1:1:len
        dir_truth = [dir_truth; dir_init];
    end
    
    whos dir
    whos dir_truth
    
    
    
    
    include_angle = real(cal_angle(dir, dir_truth));
    
    
    
    
    figure(3)
    plot(include_angle, 'r.-')
    xlabel('Samle')
    ylabel('Error(degree)')
    
    
    
    save_data(include_angle,'BM');
    
    avg_err = sum(include_angle)/len
    
    
    
    



end


function include_angle = cal_angle(dir, dir_truth)

    include_angle  =[];
    len = size(dir_truth,1);
    for i=1:1: len
%         dir_truth(i,:).*dir(i,:)
        include_angle = [include_angle, acos(sum(dir_truth(i,:).*dir(i,:))/(sqrt(sum(dir_truth(i,:).*dir_truth(i,:)))*sqrt(sum(dir(i,:).*dir(i,:)))))/pi*180];
    end
%     figure(1)
%     plot(include_angle);
    avg_err = sum(include_angle)/len;

end




function data = load_data(type)
    
    global cfg
    
%     prefix = '20211107_104931';%
    prefix = get(cfg.handles.edit1, 'string');
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


function save_data(data, type)

    global cfg
    
    %% 保存数据
    fprintf("\n-----【开始保存数据】-----\n");
    
    %新建文件夹
    prefix = get(cfg.handles.edit1, 'string');
    dir_address = [cfg.dataAddress,prefix];
    if ~exist(dir_address,'dir')
    fprintf("【新建文件夹】 "+prefix+"\n");
        mkdir(dir_address);
    end
    
    % 新建文件
    if isempty(type)
        fileName =  [prefix, '.txt'];
    else
        fileName =  [prefix, '_', type '.txt'];
    end
    fprintf("【创建文件保存数据】 "+fileName+"\n");
    
    address = [dir_address,'\',fileName];
%     cfg.address = address;
%     data = mat2str(data);
    save(address, 'data', '-ascii')
%     dlmwrite(address, data)
%     whos datain
    fprintf("-----【完成保存数据】-----\n");

end

