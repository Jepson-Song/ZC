function draw_dis(cur_index)

        draw_tim = tic;
        
        
        
        
        global cfg
        if cfg.drawDis == 1

            dis1 = [zeros(cfg.dislen, cfg.nin); cfg.dis1];
            dis2 = [zeros(cfg.dislen, cfg.nin); cfg.dis2];
            
            
        figure(1)
        plot(dis1,'.-')
%         zoom on
        grid on
    
            for i=1:1:cfg.nin
                if cfg.dis1(cur_index, i)~=-1
                plot(cfg.figure(1, 2),[1:1:cfg.dislen],dis1(1+cur_index:cfg.dislen+cur_index, i),cfg.color(i));
                hold(cfg.figure(1, 2),'on');
                end
            end
            hold(cfg.figure(1, 2),'off')
%             xlim(cfg.figure(1, 2), [1, cfg.dislen]);
%             ylim(cfg.figure(1, 2), [1.3, 1.7]);
            xlim(cfg.figure(1, 2), [1, cfg.dislen]);
            ylim(cfg.figure(1, 2), [1.15, 1.3]);
            for i=1:1:cfg.nin
                if cfg.dis2(cur_index, i)~=-1
                plot(cfg.figure(2, 2),[1:1:cfg.dislen],dis2(1+cur_index:cfg.dislen+cur_index, i),cfg.color(i));
                hold(cfg.figure(2, 2),'on');
                end
            end
            hold(cfg.figure(2, 2),'off')
%             xlim(cfg.figure(2, 2), [1, cfg.dislen]);
%             ylim(cfg.figure(2, 2), [2.2, 2.6]);
            xlim(cfg.figure(2, 2), [1, cfg.dislen]);
            ylim(cfg.figure(2, 2), [2.45, 2.6]);
            drawnow();

        end

        t = double(toc(draw_tim));
        fprintf("画dis图用时：%.4f\n", vpa(t));

end
