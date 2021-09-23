function LSTM_train()%(dataStandardlized, dataStandardlizedLable)

    %% 数据格式转换
    % dataStandardlized是原始数据标准化后的数据，dataStandardlizedLable是每条数据对应的类别标签，num型。
    % 获得XTrain需要通过XTrainData转换成元胞数组，XTrain每一行是一条负荷训练样本数据，即1*96的数据。
    
    %提取训练样本数据
%     XTrainSize = 9821;
%     XTrainData = dataStandardlized(1:XTrainSize,:);
%     XTrainLabel = dataStandardlizedLable(1:XTrainSize,:);
    
%     XTrainData = [];
%     XTrainLabel = [];
%     for i=1:1:6
%         XTrainData = [XTrainData; load_dataset(i, 'train')];
%         XTrainLabel = [XTrainLabel; i*ones(size(XTrainData, 1)-size(XTrainLabel, 1),1)];
%     end
%     XTrainSize = size(XTrainData, 1);
% %     whos XTrainData
% %     whos XTrainLabel
% 
%     %XTrain
%     for i = 1:size(XTrainData,1)
%         XTrain{i,1} = XTrainData(i,:);
%     end
%     whos XTrain
% %     XTrain{1,1}

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global cfg
    address = [cfg.dataAddress,cfg.data_name,'\','all','\']
    fileFolder=fullfile(address);
    
    XTrainSize = 0;
    XTestSize = 0;
    XTrainLabel = [];
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
                XTrainSize = XTrainSize + 1;
                XTrain{XTrainSize,1} = sub_data';
                XTrainLabel = [XTrainLabel; k];
            else
                XTestSize = XTestSize + 1;
                XTest{XTestSize,1} = sub_data';
                XTestLabel = [XTestLabel; k];
            end
        end
    end
    whos XTrain
%     whos XTrainLabel
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %YTrain
    TrainstrLable = num2str(XTrainLabel);% num to str
    for i = 1:XTrainSize% str matrix to cell
        TraincellLable{i,1} = TrainstrLable(i,1);
    end
    YTrain = categorical(TraincellLable);%cell to categorical
%     whos YTrain
    
    %YTest
    TeststrLable = num2str(XTestLabel);% num to str
    for i = 1:XTestSize
        TestcellLable{i,1} = TeststrLable(i,1);% str matrix to cell
    end
    YTest = categorical(TestcellLable);%cell to categorical
    
    
    %% 网络参数设置
    
    % layers
    inputSize = 6; % 输入数据的维度,指同一时间下的数据维度
    numHiddenUnits = 200; % 隐含单元个数
    numClasses = 6;

    layers = [ ...
        sequenceInputLayer(inputSize)
        bilstmLayer(numHiddenUnits,'OutputMode','last')
        fullyConnectedLayer(numClasses)
        softmaxLayer
        classificationLayer]
    
    % options
    maxEpochs = 200;
    miniBatchSize = 50;

    options = trainingOptions('adam', ...
        'ExecutionEnvironment','cpu', ...
        'GradientThreshold',1, ...
        'MaxEpochs',maxEpochs, ...
        'MiniBatchSize',miniBatchSize, ...
        'SequenceLength','longest', ...
        'Shuffle','every-epoch', ...
        'Verbose',0, ...
        'Plots','training-progress',...
        'InitialLearnRate', 0.001);
    
    
    %% 训练LSTM网络
    
    net = trainNetwork(XTrain,YTrain,layers,options);
    whos net
    
    %% 保存网络到net.mat
    save('lstm_net','net')

    
    %% 利用LSTM网络进行分类 
    miniBatchSize = 100;
    YPred = classify(net,XTest, ...
        'SequenceLength','longest','MiniBatchSize',miniBatchSize);
    %计算分类准确度
    acc = sum(YPred == YTest)./numel(YTest)
%     whos YPred
%     whos YTest


    % 混淆矩阵
    confusion_matrix1(double(YTest), double(YPred))
    
    
    

end