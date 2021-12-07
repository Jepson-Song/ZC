function draw_dir(cur_index)

        global cfg
        
        draw_tim = tic;

        if cfg.drawDir == 1 
            
            dir = cfg.dir(cur_index, :);
            
            p1 = cfg.pos1(cur_index, :);
            p2 = cfg.pos2(cur_index, :);
            p3 = cfg.pos3(cur_index, :);
            po = (p1+p2)/2;
            arrows = [ po; po+dir/100*15];
            triangle = [p3; p1; p2; p3;];
            
                
                %plot3(cfg.figure5, [cfg.pos1(cur_index, 1),cfg.pos2(cur_index, 1),cfg.O(1),cfg.pos1(cur_index, 1)],[cfg.pos1(cur_index, 2),cfg.pos2(cur_index, 2),cfg.O(2),cfg.pos1(cur_index, 2)],[cfg.pos1(cur_index, 3),cfg.pos2(cur_index, 3),cfg.O(3),cfg.pos1(cur_index, 3)]);
                
%                 plot3(cfg.figure5, triangle(:, 1), triangle(:, 2), triangle(:, 3), 'b.-',...
%                                    arrows(:, 1), arrows(:, 2), arrows(:, 3), 'r--')
%                 plot(cfg.figure6, triangle(:, 1), triangle(:, 3), 'b.-',...
%                                    arrows(:, 1), arrows(:, 3), 'r--')
                plot(cfg.figure7, triangle(:, 1), triangle(:, 2), 'b.-',...
                                   arrows(:, 1), arrows(:, 2), 'r--')
%                 plot(cfg.figure8, triangle(:, 2), triangle(:, 3), 'b.-',...
%                                    arrows(:, 2), arrows(:, 3), 'r--')
           
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
            title(cfg.figure5,'三维视图')
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
            title(cfg.figure6,'俯视图（XZ平面 ）')
            set(cfg.figure7,'ydir','reverse','xaxislocation','top');

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
        fprintf("画dir图用时：%.4f\n", vpa(t));
    
end
