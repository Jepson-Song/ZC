function hmm()


    global cfg
    
    O = cfg.angle_num*cfg.angle_num; % 观测状态数目
    Q = cfg.class_num; % 分类数目

    % "true" parameters
    prior0 = normalise(rand(Q,1));
    transmat0 = mk_stochastic(rand(Q,Q));
    obsmat0 = mk_stochastic(rand(Q,O));

    % initial guess of parameters
    prior1 = normalise(rand(Q,1));
    transmat1 = mk_stochastic(rand(Q,Q));
    obsmat1 = mk_stochastic(rand(Q,O));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % training data
    fprintf("开始训练第1个HMM模型");
    data = load_dataset(1, 'train');
    % improve guess of parameters using EM
    [LL1, prior1, transmat1, obsmat1] = dhmm_em(data, prior0, transmat0, obsmat0, 'max_iter', cfg.iter_numm);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf("开始训练第2个HMM模型");
    data = load_dataset(2, 'train');
    % improve guess of parameters using EM
    [LL2, prior2, transmat2, obsmat2] = dhmm_em(data, prior0, transmat0, obsmat0, 'max_iter', cfg.iter_numm);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf("开始训练第3个HMM模型");
    data = load_dataset(3, 'train');
    % improve guess of parameters using EM
    [LL3, prior3, transmat3, obsmat3] = dhmm_em(data, prior0, transmat0, obsmat0, 'max_iter', cfg.iter_numm);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf("开始训练第4个HMM模型");
    data = load_dataset(4, 'train');
    % improve guess of parameters using EM
    [LL4, prior4, transmat4, obsmat4] = dhmm_em(data, prior0, transmat0, obsmat0, 'max_iter', cfg.iter_numm);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf("开始训练第5个HMM模型");
    data = load_dataset(5, 'train');
    % improve guess of parameters using EM
    [LL5, prior5, transmat5, obsmat5] = dhmm_em(data, prior0, transmat0, obsmat0, 'max_iter', cfg.iter_numm);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf("开始训练第6个HMM模型");
    data = load_dataset(6, 'train');
    % improve guess of parameters using EM
    [LL6, prior6, transmat6, obsmat6] = dhmm_em(data, prior0, transmat0, obsmat0, 'max_iter', cfg.iter_numm);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%% test

    address = [cfg.dataAddress,'data\test\'];
    
    fileFolder=fullfile(address);

    dirOutput=dir(fullfile(fileFolder,'*.txt'));
%     a = dirOutput.name
%     whos a
    fileNames={dirOutput.name};
    len = length(fileNames);
    test_num = 10000;
    cnt = 0;
    label_list = [];
    pred_list = [];
    for i=1:1:test_num
        
        randi = unidrnd(len);
        fileName = fileNames(randi);
        fileName = fileName{1};
        sub_data = load([address, fileName]);
        sub_data = sub_data';
        
        label = str2num(fileName(1));
        label_list = [label_list, label];
        
        % use model to compute log likelihood
        loglik1 = dhmm_logprob(sub_data, prior1, transmat1, obsmat1);
        loglik2 = dhmm_logprob(sub_data, prior2, transmat2, obsmat2);
        loglik3 = dhmm_logprob(sub_data, prior3, transmat3, obsmat3);
        loglik4 = dhmm_logprob(sub_data, prior4, transmat4, obsmat4);
        loglik5 = dhmm_logprob(sub_data, prior5, transmat5, obsmat5);
        loglik6 = dhmm_logprob(sub_data, prior6, transmat6, obsmat6);
        % log lik is slightly different than LL(end), since it is computed after the final M step
        
        loglik = [loglik1, loglik2, loglik3, loglik4, loglik5, loglik6];
        
        
        [val, index] = sort(loglik);
        
        pred = index(6);
        pred_list = [pred_list, pred];
        
%         fprintf("数据编号："+fileName(isstrprop(fileName,'digit'))+" 分类结果：%d\n",y);
%         str2num(fileName(1))
        if label == pred
            cnt = cnt + 1;
        else
            fprintf("错误数据编号："+fileName(isstrprop(fileName,'digit'))+" 分类结果：%d\n",pred);
        end
        
    end
    
    
    fprintf("acc: %f\n",cnt/test_num);
    confusion_matrix1(label_list, pred_list)
    


end
