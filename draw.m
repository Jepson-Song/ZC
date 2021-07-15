function draw(cur_index)

        draw_tim = tic;
        
        global cfg
        if cfg.drawDis == 1

        dis1 = [zeros(cfg.dislen, cfg.nin); cfg.dis1];
        dis2 = [zeros(cfg.dislen, cfg.nin); cfg.dis2];

    
        %fprintf("【正在画图...】 Dataseg index: %d\n",cur_index);
        % dis
        for i=1:1:cfg.nin
            plot(cfg.figure(1, 2),[1:1:cfg.dislen],dis1(cur_index:cfg.dislen+cur_index-1, i),cfg.color(i));
            hold(cfg.figure(1, 2),'on');
        end
        hold(cfg.figure(1, 2),'off')
        for i=1:1:cfg.nin
            plot(cfg.figure(2, 2),[1:1:cfg.dislen],dis2(cur_index:cfg.dislen+cur_index-1, i),cfg.color(i));
            hold(cfg.figure(2, 2),'on');
        end
        hold(cfg.figure(2, 2),'off')
%         plot(cfg.figure(1, 2),[1:1:cfg.dislen],dis1(cur_index:cfg.dislen+cur_index-1, 1),cfg.color(1) ...
%                         ,[1:1:cfg.dislen],dis1(cur_index:cfg.dislen+cur_index-1, 2),cfg.color(2)...
%                         ,[1:1:cfg.dislen],dis1(cur_index:cfg.dislen+cur_index-1, 3),cfg.color(3));
%         plot(cfg.figure(2, 2),[1:1:cfg.dislen],dis2(cur_index:cfg.dislen+cur_index-1, 1),cfg.color(1) ...
%                         ,[1:1:cfg.dislen],dis2(cur_index:cfg.dislen+cur_index-1, 2),cfg.color(2)...
%                         ,[1:1:cfg.dislen],dis2(cur_index:cfg.dislen+cur_index-1, 3),cfg.color(3));
%         size(cfg.pos1)
        end

        if cfg.drawPos == 1
        if cur_index<=size(cfg.pos1, 1)

            fa_v = cfg.fa_v(cur_index, :);
            
            p1 = cfg.pos1(cur_index, :);
            p2 = cfg.pos2(cur_index, :);
            p3 = cfg.pos3(cur_index, :);
            po = (p1+p2)/2;
            arrows = [ po; po+fa_v/100*15];
            triangle = [p3; p1; p2; p3;];

            if cfg.drawStyle == 1
                plot3(cfg.figure5, cfg.pos1(1:cur_index, 1),  cfg.pos1(1:cur_index, 2), cfg.pos1(1:cur_index, 3), 'b', cfg.pos2(1:cur_index, 1), cfg.pos2(1:cur_index, 2), cfg.pos2(1:cur_index, 3), 'r');
                plot(cfg.figure6, cfg.pos1(1:cur_index, 1), cfg.pos1(1:cur_index, 3), 'b', cfg.pos2(1:cur_index, 1), cfg.pos2(1:cur_index, 3), 'r');
                plot(cfg.figure7, cfg.pos1(1:cur_index, 1), cfg.pos1(1:cur_index, 2), 'b', cfg.pos2(1:cur_index, 1), cfg.pos2(1:cur_index, 2), 'r');

                plot(cfg.figure8, cfg.pos1(1:cur_index, 2), cfg.pos1(1:cur_index, 3), 'b', cfg.pos2(1:cur_index, 2), cfg.pos2(1:cur_index, 3), 'r');
            elseif cfg.drawStyle == 2
                
                %plot3(cfg.figure5, [cfg.pos1(cur_index, 1),cfg.pos2(cur_index, 1),cfg.O(1),cfg.pos1(cur_index, 1)],[cfg.pos1(cur_index, 2),cfg.pos2(cur_index, 2),cfg.O(2),cfg.pos1(cur_index, 2)],[cfg.pos1(cur_index, 3),cfg.pos2(cur_index, 3),cfg.O(3),cfg.pos1(cur_index, 3)]);
                
                plot3(cfg.figure5, triangle(:, 1), triangle(:, 2), triangle(:, 3), 'b.-',...
                                   arrows(:, 1), arrows(:, 2), arrows(:, 3), 'r--')
                plot(cfg.figure6, triangle(:, 1), triangle(:, 3), 'b.-',...
                                   arrows(:, 1), arrows(:, 3), 'r--')
                plot(cfg.figure7, triangle(:, 1), triangle(:, 2), 'b.-',...
                                   arrows(:, 1), arrows(:, 2), 'r--')
                plot(cfg.figure8, triangle(:, 2), triangle(:, 3), 'b.-',...
                                   arrows(:, 2), arrows(:, 3), 'r--')
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
            title(cfg.figure5,'3D')
            xlim(cfg.figure6, [-cfg.lim cfg.lim])
            ylim(cfg.figure6, [-cfg.lim cfg.lim])
            set(cfg.figure6,  'XGrid', 'on')
            set(cfg.figure6,  'YGrid', 'on')
            xlabel(cfg.figure6, 'X')
            ylabel(cfg.figure6, 'Z')
            title(cfg.figure6,'XZ平面 - 俯视图')
            xlim(cfg.figure7, [-cfg.lim cfg.lim])
            ylim(cfg.figure7, [-cfg.lim cfg.lim])
            set(cfg.figure7,  'XGrid', 'on')
            set(cfg.figure7,  'YGrid', 'on')
            xlabel(cfg.figure7, 'X')
            ylabel(cfg.figure7, 'Y')
            title(cfg.figure7,'XY平面 - 正视图')
            xlim(cfg.figure8, [-cfg.lim cfg.lim])
            ylim(cfg.figure8, [-cfg.lim cfg.lim])
            set(cfg.figure8,  'XGrid', 'on')
            set(cfg.figure8,  'YGrid', 'on')
            xlabel(cfg.figure8, 'Y')
            ylabel(cfg.figure8, 'Z')
            title(cfg.figure8,'YZ平面 - 侧视图')
            drawnow();
        end
        end
        
        if cfg.drawVec == 1
            fa_v = cfg.fa_v(cur_index, :);
            
            p1 = cfg.pos1(cur_index, :);
            p2 = cfg.pos2(cur_index, :);
            p3 = cfg.pos3(cur_index, :);
            po = (p1+p2)/2;
            arrows = [ po; po+fa_v/100*15];
            triangle = [p3; p1; p2; p3;];
%         fig = figure
        	plot3(cfg.figure5, triangle(:, 1), triangle(:, 2), triangle(:, 3), 'b.-',...
                                   arrows(:, 1), arrows(:, 2), arrows(:, 3), 'r')
            xlim(cfg.figure5, [-cfg.lim*2 cfg.lim*2])
            ylim(cfg.figure5, [-cfg.lim*2 cfg.lim*2])
            zlim(cfg.figure5, [-cfg.lim*2 cfg.lim*2])
            set(cfg.figure5,  'XGrid', 'on')
            set(cfg.figure5,  'YGrid', 'on')
            set(cfg.figure5,  'ZGrid', 'on')
            xlabel(cfg.figure5, 'X')
            ylabel(cfg.figure5, 'Z')
            zlabel(cfg.figure5, 'Y')
            title(cfg.figure5,'3D')
%             quiver3(cfg.figure5, arrows(1,1),arrows(1,2),arrows(1,3),arrows(2,1),arrows(2,2),arrows(2,3))
            drawnow();
        end
        
        
        t = double(toc(draw_tim));
        fprintf("画图用时：%.4f\n", vpa(t));
    
%     end
end
