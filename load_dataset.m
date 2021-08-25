function data = load_dataset(label, str)
%     label = 1;
    global cfg
    address = [cfg.dataAddress,'data\',str,'\'];
    
    fileFolder=fullfile(address);

    dirOutput=dir(fullfile(fileFolder,[num2str(label),'*.txt']));
%     a = dirOutput.name
%     whos a
    fileNames={dirOutput.name};
    data = [];
    for i=1:length(fileNames)
        fileName = fileNames(i);
        fileName = fileName{1};
%         i
        sub_data = load([address, fileName]);
        data = [data; sub_data'];
    end
    
end