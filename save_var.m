function save_var(fileName)
    global cfg
    
    if exist(fileName,'file')%参数文件存在
        % 从文件中读取参数
        fprintf("\n-----【开始读取参数】-----\n");
        fprintf("【从文件读取参数】 "+fileName+"\n");
        address = [cfg.dataAddress,fileName];
        cfg = load(address);
        fprintf("-----【完成读取参数】-----\n");
    else
        % 保存参数
        fprintf("\n-----【开始保存参数】-----\n");
        % 新建文件
        fprintf("【创建文件保存参数】 "+fileName+"\n");
        address = [cfg.dataAddress,fileName];
        %para = [cfg.dis1(cfg.dislen+1:end,:),cfg.dis2(cfg.dislen+1:end,:),cfg.pos1,cfg.pos2];
        save(address)
        fprintf("-----【完成保存参数】-----\n");
    end
end