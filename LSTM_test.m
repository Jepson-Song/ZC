function LSTM_test()
    
    %% 读取数据
    global cfg
    address = [cfg.dataAddress,cfg.data_name,'\','all','\']
    fileFolder=fullfile(address);
    
    XTestSize = 0;
    XTestLabel = [];
    for k=1:1:6

        dirOutput=dir(fullfile(fileFolder,[num2str(k),'*.txt']));
        fileNames={dirOutput.name};
        
        for i=1:length(fileNames)
            fileName = fileNames(i);
            fileName = fileName{1};
            
            sub_data = load([address, fileName]);
            
            r = rand;
            if r <= 0.8
                
            else
                XTestSize = XTestSize + 1;
                XTest{XTestSize,1} = sub_data';
                XTestLabel = [XTestLabel; k];
%                 if XTestSize==1
%                     break;
%                 end
            end
        end
        
%                 if XTestSize==1
%                     break;
%                 end
    end
    %YTest
    TeststrLable = num2str(XTestLabel);% num to str
    for i = 1:XTestSize
        TestcellLable{i,1} = TeststrLable(i,1);% str matrix to cell
    end
    YTest = categorical(TestcellLable);%cell to categorical
    
    %% 读取网络
    
    net = coder.loadDeepLearningNetwork('lstm_net.mat');
    
    net.Layers
    
    whos XTest
    tmp = XTest(700);
    whos tmp
    %% 利用LSTM网络进行分类 
    % 批量分类
%     miniBatchSize = 100;
%     YPred = classify(net,XTest, ...
%         'SequenceLength','longest','MiniBatchSize',miniBatchSize);
%     %计算分类准确度
%     acc = sum(YPred == YTest)./numel(YTest)
%     confusion_matrix1(double(YTest), double(YPred))
%     whos YPred
%     whos YTest
    
    % 单个分类
    YPred = [];
    for i=1:1:length(XTest)
        YPred = [YPred; classify(net,XTest(i))];
%         YPred(i)
    end
    acc = sum(YPred == YTest)./numel(YTest)


    %% 混淆矩阵
    confusion_matrix1(double(YTest), double(YPred))
    

end