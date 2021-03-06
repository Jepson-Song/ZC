function PPAC()

%     global cfg

    data = load_data('pos');
    pos1 = data(:, 1:3);
    pos2 = data(:, 4:6);
    
    len = size(data,1);
    
    rate = 10;
    first_time = 1;
    seconde_time = first_time+7;
    
    mid_first = [0 0 0];
    cnt = 0;
    for i=first_time*rate:1:(first_time+3)*rate
        
        mid_first = mid_first+(pos1(i,:)+pos2(i,:))/2;
        cnt = cnt + 1;
        
    end
    mid_first = mid_first/cnt
    
    mid_second = [0 0 0];
    cnt = 0;
    for i=seconde_time*rate:1:(seconde_time+3)*rate
        
        mid_second = mid_second+(pos1(i,:)+pos2(i,:))/2;
        cnt = cnt + 1;
        
    end
    mid_second = mid_second/cnt
    
    ub = mid_first - [0 0 0.05];
    lb = mid_first - [0 0 0.25];
    pos3 = ub;
    while(ub(3)-lb(3)>0.00001)
        pos3 = (ub+lb)/2;
        
        vec_first = mid_first-pos3
        vec_second = mid_second-pos3
        angle = acos(sum(vec_first.*vec_second)/(sqrt(sum(vec_first.*vec_first))*sqrt(sum(vec_second.*vec_second))))/pi*180
    
        if angle>60
            ub = pos3;
        else
            lb = pos3;
        end
        
    end
    
    fprintf("距离：%.4f\n", vpa(mid_first(3)-pos3(3)));

end