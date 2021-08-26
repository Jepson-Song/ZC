function draw_dis(cur_index)

        global cfg
        
        draw_tim = tic;
        
        if cfg.drawDis == 1
            
            dis1 = [repmat(cfg.dis1(1, :),cfg.dislen,1); cfg.dis1];
            dis2 = [repmat(cfg.dis2(1, :),cfg.dislen,1); cfg.dis2];
            
            for i=1:1:cfg.nin
                if cfg.dis1(cur_index, i)~=0
                plot(cfg.figure(1, 2),[1:1:cfg.dislen],dis1(1+cur_index:cfg.dislen+cur_index, i),cfg.color(i));
                hold(cfg.figure(1, 2),'on');
                end
            end
            hold(cfg.figure(1, 2),'off')
            xlim(cfg.figure2, [1, cfg.dislen]);
            ylim(cfg.figure2, [0, 1.5]);
            set(cfg.figure2,  'XGrid', 'on')
            set(cfg.figure2,  'YGrid', 'on')
            
            for i=1:1:cfg.nin
                if cfg.dis2(cur_index, i)~=0
                plot(cfg.figure(2, 2),[1:1:cfg.dislen],dis2(1+cur_index:cfg.dislen+cur_index, i),cfg.color(i));
                hold(cfg.figure(2, 2),'on');
                end
            end
            hold(cfg.figure(2, 2),'off')
            xlim(cfg.figure4, [1, cfg.dislen]);
%             ylim(cfg.figure4, [2.45, 2.6]);
%             ylim(cfg.figure4, [1.15, 1.3]);
            ylim(cfg.figure4, [0, 1.5]);
            set(cfg.figure4,  'XGrid', 'on')
            set(cfg.figure4,  'YGrid', 'on')

            drawnow();

        end

        t = double(toc(draw_tim));
        fprintf("画dis图用时：%.4f\n", vpa(t));

end
