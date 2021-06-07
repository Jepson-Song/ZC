function tcp_client(data)
    tcpclient = tcpip('127.0.0.01', 54378, 'Timeout', 60,'OutputBufferSize',10240,'InputBufferSize',10240);%连接这个ip和这个端口的UDP服务器
    %t.BytesAvailableFcnMode='byte'
    %while(1)
        %a=1:10
        fopen(tcpclient);
        fwrite(tcpclient,data);%发送一段数据给tcp服务器。服务器好知道matlab的ip和端口
%         while(1) %轮询，直到有数据了再fread
%             nBytes = get(tcpclient,'BytesAvailable');
%             if nBytes>0
%                 break;
%             end
%         end
        %receive = fread(tcpclient,nBytes);%读取tcp服务器传来的数据
        %fread(t)
        %关闭连接
        fclose(tcpclient);
        %data=str2num(char(receive(2:end-1)')); %将ASCII码转换为str，再将str转换为数组
        %disp(data)
    %end
    delete(tcpclient);
end