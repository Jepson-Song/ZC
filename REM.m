function REM()
%     global cfg
    
%     data_num = '20211109_102305';
    data = load_data('dir');
    pos3 = data(:, 1:3);
    dir = data(:, 4:6);
%     dir = rec(:, 7:9);
    
    
    len = size(dir,1);
%     whos dir
%     
%     dir_zero = [];
%     for i=1:1:len
%         dir_zero = [dir_zero; [-1 0 0]];
%     end
%     whos dir_zero
%     
%     
%     dir_angle = cal_angle(dir, dir_zero);
    
    dir_gt = [0:90/(len-1):90];
    
%     include_angle = abs(dir_angle-dir_gt);
    
    tmp = zeros(len,3);
    tmp(:, 1) = -cos(dir_gt/180*pi)/pi*180;
    tmp(:, 2) = -sin(dir_gt/180*pi)/pi*180;
    dir_gt = tmp;
    
    whos dir_angle
    whos dir_gt
    
    include_angle = cal_angle(dir, dir_gt);
    
    
%     figure(1)
%     plot(dir_angle, 'b.-');
%     hold on
%     plot(dir_gt, 'b--');
%     hold off
%     xlabel('Samle')
%     ylabel('Angle(degree)')
    
    figure(2)
    plot(include_angle, 'r.-')
    xlabel('Samle')
    ylabel('Error(degree)')
    
    
    
    save_data(include_angle,'REM');
    
    avg_err = sum(include_angle)/len
    
        


end


function include_angle = cal_angle(dir, dir_truth)

    include_angle  =[];
    len = size(dir_truth,1);
    for i=1:1: len
%         dir_truth(i,:).*dir(i,:)
        include_angle = [include_angle, acos(sum(dir_truth(i,:).*dir(i,:))/(sqrt(sum(dir_truth(i,:).*dir_truth(i,:)))*sqrt(sum(dir(i,:).*dir(i,:)))))/pi*180];
    end
%     figure(1)
%     plot(include_angle);
    avg_err = sum(include_angle)/len;

end



