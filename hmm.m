function hmm()
O = 18*18;
Q = 6;

% "true" parameters
prior0 = normalise(rand(Q,1));
transmat0 = mk_stochastic(rand(Q,Q));
obsmat0 = mk_stochastic(rand(Q,O));

% training data
% T = 5;
% nex = 10;
% data = dhmm_sample(prior0, transmat0, obsmat0, T, nex);

% initial guess of parameters
prior0 = normalise(rand(Q,1));
transmat0 = mk_stochastic(rand(Q,Q));
obsmat0 = mk_stochastic(rand(Q,O));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = load_dataset(1);
% improve guess of parameters using EM
[LL1, prior1, transmat1, obsmat1] = dhmm_em(data, prior0, transmat0, obsmat0, 'max_iter', 5);
LL1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = load_dataset(2);
% improve guess of parameters using EM
[LL2, prior2, transmat2, obsmat2] = dhmm_em(data, prior0, transmat0, obsmat0, 'max_iter', 5);
LL2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = load_dataset(3);
% improve guess of parameters using EM
[LL3, prior3, transmat3, obsmat3] = dhmm_em(data, prior0, transmat0, obsmat0, 'max_iter', 5);
LL3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = load_dataset(4);
% improve guess of parameters using EM
[LL4, prior4, transmat4, obsmat4] = dhmm_em(data, prior0, transmat0, obsmat0, 'max_iter', 5);
LL4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = load_dataset(5);
% improve guess of parameters using EM
[LL5, prior5, transmat5, obsmat5] = dhmm_em(data, prior0, transmat0, obsmat0, 'max_iter', 5);
LL5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = load_dataset(6);
% improve guess of parameters using EM
[LL6, prior6, transmat6, obsmat6] = dhmm_em(data, prior0, transmat0, obsmat0, 'max_iter', 5);
LL6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%% test


    global cfg
    address = [cfg.dataAddress,'data\'];
    
    fileFolder=fullfile(address);

    dirOutput=dir(fullfile(fileFolder,'*.txt'));
%     a = dirOutput.name
%     whos a
    fileNames={dirOutput.name};
    len = length(fileNames);
    num = 10000;
    cnt = 0;
    
    for i=1:1:num
        
        randi = unidrnd(len);
        fileName = fileNames(randi);
        fileName = fileName{1};
        sub_data = load([address, fileName]);
        sub_data = sub_data';
        
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
        
        y = index(6);
        
        
        fprintf("数据编号："+fileName+" 分类结果：%d\n",y);
%         str2num(fileName(1))
        if str2num(fileName(1)) == y
            cnt = cnt + 1;
        end
        
    end
    
    
        fprintf("acc: %f\n",cnt/num);
    


end

function test()


end