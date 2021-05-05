function draw(cur_index)

    global cfg
    
%     for curr_index=1:1:cfg.index

%     dis1 =  cfg.dis1;
%     dis2 =  cfg.dis2;
%     if cur_index<cfg.dislen
        dis1 = [zeros(cfg.nin, cfg.dislen), cfg.dis1];
        dis2 = [zeros(cfg.nin, cfg.dislen), cfg.dis2];
%     end
    
        fprintf("【正在画图...】 Dataseg index: %d\n",cur_index);
        % dis
        plot(cfg.figure(1, 2),[1:1:cfg.dislen],dis1(1,cur_index:cfg.dislen+cur_index-1),cfg.color(1) ...
                        ,[1:1:cfg.dislen],dis1(2,cur_index:cfg.dislen+cur_index-1),cfg.color(2)...
                        ,[1:1:cfg.dislen],dis1(3,cur_index:cfg.dislen+cur_index-1),cfg.color(3));
        plot(cfg.figure(2, 2),[1:1:cfg.dislen],dis2(1,cur_index:cfg.dislen+cur_index-1),cfg.color(1) ...
                        ,[1:1:cfg.dislen],dis2(2,cur_index:cfg.dislen+cur_index-1),cfg.color(2)...
                        ,[1:1:cfg.dislen],dis2(3,cur_index:cfg.dislen+cur_index-1),cfg.color(3));
        
        p1 = cfg.pos1(:,cur_index);
        p2 = cfg.pos2(:,cur_index);
        po = (p1+p2)/2;
        k1 = (p1(2)-p2(2))/(p1(1)-p2(1));
        k2 = -1/k1;
        pp = po;
        d = 0.1;
        sign = 1;
        if k2 > 0
            sign = -1;
        end
        pp(1) = po(1)+ sign* d*sqrt(1/(1+k2^2));
        pp(2) = po(2)-  d*sqrt(k2^2/(1+k2^2));
        
        % pos
        if cfg.drawStyle == 1
            plot3(cfg.figure5, cfg.pos1(1,1:cur_index),  cfg.pos1(2,1:cur_index), cfg.pos1(3,1:cur_index), 'b', cfg.pos2(1,1:cur_index), cfg.pos2(2,1:cur_index), cfg.pos2(3,1:cur_index), 'r');
            plot(cfg.figure6, cfg.pos1(1,1:cur_index), cfg.pos1(3,1:cur_index), 'b', cfg.pos2(1,1:cur_index), cfg.pos2(3,1:cur_index), 'r');
            plot(cfg.figure7, cfg.pos1(1,1:cur_index), cfg.pos1(2,1:cur_index), 'b', cfg.pos2(1,1:cur_index), cfg.pos2(2,1:cur_index), 'r');
            
            plot(cfg.figure8, cfg.pos1(2,1:cur_index), cfg.pos1(3,1:cur_index), 'b', cfg.pos2(2,1:cur_index), cfg.pos2(3,1:cur_index), 'r');
        elseif cfg.drawStyle == 2
            plot3(cfg.figure5, [cfg.pos1(1,cur_index),cfg.pos2(1,cur_index)],[cfg.pos1(2,cur_index),cfg.pos2(2,cur_index)],[cfg.pos1(3,cur_index),cfg.pos2(3,cur_index)]);
            plot(cfg.figure6, [cfg.pos1(1,cur_index),cfg.pos2(1,cur_index)],[cfg.pos1(3,cur_index),cfg.pos2(3,cur_index)]);
            plot(cfg.figure7, [cfg.pos1(1,cur_index),cfg.pos2(1,cur_index)],[cfg.pos1(2,cur_index),cfg.pos2(2,cur_index)],'b',[po(1),pp(1)],[po(2),pp(2)],'r--');
            
            plot(cfg.figure8, [cfg.pos1(2,cur_index),cfg.pos2(2,cur_index)],[cfg.pos1(3,cur_index),cfg.pos2(3,cur_index)]);
        end
        xlim(cfg.figure5, [-cfg.lim cfg.lim])
        ylim(cfg.figure5, [-cfg.lim cfg.lim])
        zlim(cfg.figure5, [-cfg.lim cfg.lim])
        set(cfg.figure5,  'XGrid', 'on')
        set(cfg.figure5,  'YGrid', 'on')
        set(cfg.figure5,  'ZGrid', 'on')
        xlabel(cfg.figure5, 'X')
        ylabel(cfg.figure5, 'Y')
        zlabel(cfg.figure5, 'Z')
        xlim(cfg.figure6, [-cfg.lim cfg.lim])
        ylim(cfg.figure6, [-cfg.lim cfg.lim])
        set(cfg.figure6,  'XGrid', 'on')
        set(cfg.figure6,  'YGrid', 'on')
        xlabel(cfg.figure6, 'X')
        ylabel(cfg.figure6, 'Z')
%         title(cfg.figure6,'XZ平面')
        xlim(cfg.figure7, [-cfg.lim cfg.lim])
        ylim(cfg.figure7, [-cfg.lim cfg.lim])
        set(cfg.figure7,  'XGrid', 'on')
        set(cfg.figure7,  'YGrid', 'on')
        xlabel(cfg.figure7, 'X')
        ylabel(cfg.figure7, 'Y')
%         title(cfg.figure7,'XY平面')
        xlim(cfg.figure8, [-cfg.lim cfg.lim])
        ylim(cfg.figure8, [-cfg.lim cfg.lim])
        set(cfg.figure8,  'XGrid', 'on')
        set(cfg.figure8,  'YGrid', 'on')
        xlabel(cfg.figure8, 'Y')
        ylabel(cfg.figure8, 'Z')
%         title(cfg.figure8,'YZ平面')
        
        

        drawnow();
    
%     end
end