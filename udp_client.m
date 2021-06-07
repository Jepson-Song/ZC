function udp_client(data)
    
    %count = 0;
    %data_all=[];%用于存储所有的数据
    u = udp('127.0.0.1', 54377, 'Timeout', 60,'InputBufferSize',10240);%连接这个ip和这个端口的UDP服务器，60秒超时，缓冲大小10240个字节
    fopen(u);
    %发送一段数据给udp服务器，以便让服务器获取matlab的ip和端口
    %fwrite(u,'get');
    %while(1)
        %disp('正在等待服务器发送数据...');
        %读取UDP服务器传来的数据
        %receive = fread(u, 40960);
        %将ASCII码转换为str，再将str转换为数组
        %data=str2num(char(receive(2:end-1)')); 
        %data_all=[data_all;data];
        %data
        %pause(0.0001);
        %info_to_send = [0.1, 0.2, 0.3, count];
        fwrite(u, data);
        %count = count + 1;
        %disp(['数据已发送 ', data]);
    %end
    fclose(u);
    delete(u);
end