function make_dataset()
    
    global cfg
    
   
    
        cfg.data_name = 'data1';
%         k = 1;
        
         % 先清空数据集
        % 全部数据
        address = [cfg.dataAddress,cfg.data_name,'\all\'];
        if ~exist(address,'dir')
            mkdir(address);
            fprintf("【新建文件夹】 "+address+"\n");
        end
        fileFolder=fullfile(address);
        dirOutput=dir(fullfile(fileFolder,'*.txt'));
        fileNames={dirOutput.name};
        for index=1:length(fileNames)
            fileName = fileNames(index);
            fileName = fileName{1};
            delete([address,fileName])
        end
        % 训练集
        address = [cfg.dataAddress,cfg.data_name,'\train\'];
        if ~exist(address,'dir')
            mkdir(address);
            fprintf("【新建文件夹】 "+address+"\n");
        end
        fileFolder=fullfile(address);
        dirOutput=dir(fullfile(fileFolder,'*.txt'));
        fileNames={dirOutput.name};
        for index=1:length(fileNames)
            fileName = fileNames(index);
            fileName = fileName{1};
            delete([address,fileName])
        end
        % 测试集
        address = [cfg.dataAddress,cfg.data_name,'\test\'];
        if ~exist(address,'dir')
            mkdir(address);
            fprintf("【新建文件夹】 "+address+"\n");
        end
        fileFolder=fullfile(address);
        dirOutput=dir(fullfile(fileFolder,'*.txt'));
        fileNames={dirOutput.name};
        for index=1:length(fileNames)
            fileName = fileNames(index);
            fileName = fileName{1};
            delete([address,fileName])
        end
        
%     % 遍历每个类别的数据
    for k=1:1:6
        
    fileName = [num2str(k), '_pos.txt'];
    fprintf("【从文件读取位置数据】 "+fileName+"\n");
    address = [cfg.dataAddress,cfg.data_name,'\',fileName];
    data = load(address);
    len = size(data, 1);
    
    % 对数据进行切分和处理
    for num=1:1:len
        index = num*cfg.cut_step;
        if index+cfg.cut_len-1 > len
            break
        end
%         fileName = ['1',num2str(i,'%04d'), '_pos.txt'];
%         fprintf("【创建文件保存子数据】 "+fileName+"\n");
%         address = [cfg.dataAddress,'data\',fileName];
%         sub_data = data(i:i+sub_len-1, :);
%         save(address, 'sub_data', '-ascii')
        
        fileName = [num2str(k), '-',cfg.data_name,'-',num2str(num,'%04d'), '.txt'];
        fprintf("【创建文件保存子数据】 "+fileName+"\n");
        train_address = [cfg.dataAddress,cfg.data_name,'\train\',fileName];
        test_address = [cfg.dataAddress,cfg.data_name,'\test\',fileName];
        all_address = [cfg.dataAddress,cfg.data_name,'\all\',fileName];
        
%         sub_data = sub_data - sub_data(1, :);
%         tmp = zeros(sub_len, 1);
%         for j=1:1:sub_len
%             tmp(j, 1) = get_distance(sub_data(j, :),sub_data(1, :));
%         end
        
       %% 观测值编码%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         % Vector Quantization 对数据进行观测值编码
%         sub_data = data(index:index+cfg.cut_len-1, 1:3);
%         div_angle = 2*pi/cfg.angle_num;
%         tmp = [];
%         for j=2:1:cfg.cut_len
%             mov = sub_data(j, :) - sub_data(j-1, :);
%             
%             angle1 = get_angle(mov(1), mov(2));
%             code1 = floor(angle1/div_angle)*cfg.angle_num;
%             
%             angle2 = get_angle(sqrt(mov(1)^2+mov(2)^2),mov(3));
%             code2 = floor(angle2/div_angle)+1;
%             
%             tmp = [tmp; code1+code2];
%         end
        %% 相对位置%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        sub_data = data(index:index+cfg.cut_len-1, 1:6);
        sub_data = sub_data - sub_data(1, :);
        tmp = sub_data(2:end,:);
        
        
        % 以4:1的比例生成训练集和测试集
        r = rand;
        if r <= 0.8
            save(train_address, 'tmp', '-ascii')
        else
            save(test_address, 'tmp', '-ascii')
        end
        save(all_address, 'tmp', '-ascii')
        
    end
    end

end
%% 求两点间距离
function res = get_distance(a, b)

    c = a-b;
    res = sqrt(sum(c.*c));

end
%% 求角度
function res = get_angle(x, y)
    
    if x == 0
        if y == 0
            res = 0;
        elseif y>0
            res = pi/2;
        else
            res = 3*pi/2;
        end
    else
        res = atan(y/x);
        if x < 0
            res = pi + res;
        elseif x > 0 && y < 0
            res = 2*pi + res;
        end
    end
    

end
