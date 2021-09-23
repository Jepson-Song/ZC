function pred = LSTM_class(net, sub_data)
    % 单个数据分类
    % sub_data 6*19
    
    data_cell{1, 1} = sub_data;
    
    pred = classify(net,data_cell);

end