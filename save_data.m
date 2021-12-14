
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
