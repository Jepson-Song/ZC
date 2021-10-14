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
            
            
            % 画cir
            tcir1 = [repmat(0*ones(1,length(cfg.cir1(1, :))),cfg.dislen,1); cfg.cir1]';
%             tcir1 = tcir1(:, end-cfg.dislen+1:end);
            dcir1 = diff(tcir1, 1, 2);  % para3: 1是列差分 2是行差分
            
            imagesc(cfg.figure7,tcir1(:, 1+cur_index:cfg.dislen+cur_index));
%             colormap jet
%             colorbar
            len = length(tcir1(1,:));
            set(cfg.figure7, 'XTick', 0:50:len)
            set(cfg.figure7, 'XTickLabel', 0:5:len/10)
%             set(cfg.figure7, 'YDir', 'normal')
            set(cfg.figure7, 'YTick', [0:100:960])
%             set(cfg.figure7, 'YTickLabel', [0:100:960]*0.35);%*cfg.soundspeed/cfg.fs*100)
            xlabel(cfg.figure7, 'Time(s)')
            ylabel(cfg.figure7, 'Distance(cm)')
%             set(cfg.figure7,'YGrid','on')
            
            imagesc(cfg.figure8,dcir1(:, 1+cur_index:cfg.dislen+cur_index-1));
            set(cfg.figure8, 'XTick', 0:50:300)
            set(cfg.figure8, 'XTickLabel', 0:5:30)
%             set(cfg.figure8, 'YDir', 'normal')
            set(cfg.figure8, 'YTick', [0:100:960])
%             set(cfg.figure8, 'YTickLabel', [0:100:960]*0.35);%*cfg.soundspeed/cfg.fs*100)
            xlabel(cfg.figure8, 'Time(s)')
            ylabel(cfg.figure8, 'Distance(cm)')
            colormap jet
            colorbar

            drawnow();

        end

        t = double(toc(draw_tim));
        fprintf("画dis图用时：%.4f\n", vpa(t));

end
