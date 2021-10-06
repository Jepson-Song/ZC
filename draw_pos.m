function draw_pos(cur_index)

        global cfg
        
        draw_tim = tic;

        if cfg.drawPos == 1
            
            if cfg.drawStyle == 1
                start_index = 10;
                if cur_index>=start_index
                plot3(cfg.figure5, cfg.pos1(start_index:cur_index, 1),  cfg.pos1(start_index:cur_index, 2), cfg.pos1(start_index:cur_index, 3), 'b', cfg.pos2(start_index:cur_index, 1), cfg.pos2(start_index:cur_index, 2), cfg.pos2(start_index:cur_index, 3), 'r');
                plot(cfg.figure6, cfg.pos1(start_index:cur_index, 1), cfg.pos1(start_index:cur_index, 3), 'b', cfg.pos2(start_index:cur_index, 1), cfg.pos2(start_index:cur_index, 3), 'r');
                plot(cfg.figure7, cfg.pos1(start_index:cur_index, 1), cfg.pos1(start_index:cur_index, 2), 'b', cfg.pos2(start_index:cur_index, 1), cfg.pos2(start_index:cur_index, 2), 'r');
                plot(cfg.figure8, cfg.pos1(start_index:cur_index, 2), cfg.pos1(start_index:cur_index, 3), 'b', cfg.pos2(start_index:cur_index, 2), cfg.pos2(start_index:cur_index, 3), 'r');
                end
            else
            
                p1 = cfg.pos1(cur_index, :);
                p2 = cfg.pos2(cur_index, :);

                head = [p1; p2;];
                    plot3(cfg.figure5, head(:, 1), head(:, 2), head(:, 3), 'b.-');
                    plot(cfg.figure6, head(:, 1), head(:, 3), 'b.-');
                    plot(cfg.figure7, head(:, 1), head(:, 2), 'b.-');
                    plot(cfg.figure8, head(:, 2), head(:, 3), 'b.-');
            end
                
%             % 会议室
%             myxlim = [1.0 1.6];
%             myylim = [0.1 0.6];
%             myzlim = [0.5 1.5];
            % 工位
            myxlim = [0 1.4];
            myylim = [0 1.4];
            myzlim = [-0.3 0.3];
            
            xlim(cfg.figure5, myxlim)
            ylim(cfg.figure5, myylim)
            zlim(cfg.figure5, myzlim)
            set(cfg.figure5,  'XGrid', 'on')
            set(cfg.figure5,  'YGrid', 'on')
            set(cfg.figure5,  'ZGrid', 'on')
            xlabel(cfg.figure5, 'X')
            ylabel(cfg.figure5, 'Y')
            zlabel(cfg.figure5, 'Z')
            title(cfg.figure5,'三维轨迹')
            rotate3d(cfg.figure5, 'on')
            set(cfg.figure5,'ydir','reverse','xaxislocation','top');
            
            xlim(cfg.figure6, myxlim)
            ylim(cfg.figure6, myzlim)
            set(cfg.figure6,  'XGrid', 'on')
            set(cfg.figure6,  'YGrid', 'on')
            xlabel(cfg.figure6, 'X')
            ylabel(cfg.figure6, 'Z')
            title(cfg.figure6,'俯视图（XZ平面 ）')

            xlim(cfg.figure7, myxlim)
            ylim(cfg.figure7, myylim)
            set(cfg.figure7,  'XGrid', 'on')
            set(cfg.figure7,  'YGrid', 'on')
            xlabel(cfg.figure7, 'X')
            ylabel(cfg.figure7, 'Y')
            title(cfg.figure7,' 正视图（XY平面）')
            set(cfg.figure7,'ydir','reverse');%,'xaxislocation','top');

            xlim(cfg.figure8, myylim)
            ylim(cfg.figure8, myzlim)
            set(cfg.figure8,  'XGrid', 'on')
            set(cfg.figure8,  'YGrid', 'on')
            xlabel(cfg.figure8, 'Y')
            ylabel(cfg.figure8, 'Z')
            title(cfg.figure8,'侧视图（YZ平面）')
            
            
            drawnow();
        end
        
        t = double(toc(draw_tim));
        fprintf("画pos图用时：%.4f\n", vpa(t));
    
end
