function draw(cur_index)

        draw_tim = tic;
        
        global cfg

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
                plot3(cfg.figure5, cfg.pos1(1:cur_index, 1),  cfg.pos1(1:cur_index, 2), cfg.pos1(1:cur_index, 3), 'b');%, cfg.pos2(1:cur_index, 1), cfg.pos2(1:cur_index, 2), cfg.pos2(1:cur_index, 3), 'r');
                plot(cfg.figure6, cfg.pos1(1:cur_index, 1), cfg.pos1(1:cur_index, 3), 'b');%, cfg.pos2(1:cur_index, 1), cfg.pos2(1:cur_index, 3), 'r');
                plot(cfg.figure7, cfg.pos1(1:cur_index, 1), cfg.pos1(1:cur_index, 2), 'b');%, cfg.pos2(1:cur_index, 1), cfg.pos2(1:cur_index, 2), 'r');

                plot(cfg.figure8, cfg.pos1(1:cur_index, 2), cfg.pos1(1:cur_index, 3), 'b');%, cfg.pos2(1:cur_index, 2), cfg.pos2(1:cur_index, 3), 'r');
                
%                 drawnow();
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
            myxlim = [0 2.5];
            myylim = [-0.2 0.4];
            myzlim = [0.5 1.5];
            xlim(cfg.figure5, myxlim)
            ylim(cfg.figure5, myylim)
            zlim(cfg.figure5, myzlim)
            set(cfg.figure5,  'XGrid', 'on')
            set(cfg.figure5,  'YGrid', 'on')
            set(cfg.figure5,  'ZGrid', 'on')
            xlabel(cfg.figure5, 'X')
            ylabel(cfg.figure5, 'Y')
            zlabel(cfg.figure5, 'Z')
            title(cfg.figure5,'3D')
            
            xlim(cfg.figure6, myxlim)
            ylim(cfg.figure6, myzlim)
            set(cfg.figure6,  'XGrid', 'on')
            set(cfg.figure6,  'YGrid', 'on')
            xlabel(cfg.figure6, 'X')
            ylabel(cfg.figure6, 'Z')
            title(cfg.figure6,'XZ平面 - 俯视图')
            
            xlim(cfg.figure7, myxlim)
            ylim(cfg.figure7, myylim)
            set(cfg.figure7,  'XGrid', 'on')
            set(cfg.figure7,  'YGrid', 'on')
            xlabel(cfg.figure7, 'X')
            ylabel(cfg.figure7, 'Y')
            title(cfg.figure7,'XY平面 - 正视图')
            
            xlim(cfg.figure8, myylim)
            ylim(cfg.figure8, myzlim)
            set(cfg.figure8,  'XGrid', 'on')
            set(cfg.figure8,  'YGrid', 'on')
            xlabel(cfg.figure8, 'Y')
            ylabel(cfg.figure8, 'Z')
            title(cfg.figure8,'YZ平面 - 侧视图')
            
            drawnow();
        end
        end
        
        t = double(toc(draw_tim));
        fprintf("画pos图用时：%.4f\n", vpa(t));
    
end