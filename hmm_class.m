function pred = hmm_class(data)
    
    global cfg
        % use model to compute log likelihood
        loglik1 = dhmm_logprob(data, cfg.prior1, cfg.transmat1, cfg.obsmat1);
        loglik2 = dhmm_logprob(data, cfg.prior2, cfg.transmat2, cfg.obsmat2);
        loglik3 = dhmm_logprob(data, cfg.prior3, cfg.transmat3, cfg.obsmat3);
        loglik4 = dhmm_logprob(data, cfg.prior4, cfg.transmat4, cfg.obsmat4);
        loglik5 = dhmm_logprob(data, cfg.prior5, cfg.transmat5, cfg.obsmat5);
        loglik6 = dhmm_logprob(data, cfg.prior6, cfg.transmat6, cfg.obsmat6);
        % log lik is slightly different than LL(end), since it is computed after the final M step
        loglik = [loglik1, loglik2, loglik3, loglik4, loglik5, loglik6];
        
        
        [val, index] = sort(loglik);
        
        pred = index(6);

end