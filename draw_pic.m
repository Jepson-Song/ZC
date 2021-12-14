% 在某个图上画某段数据
function draw_pic(fig,data)
    if ~isreal(data)
        data = real(data);
    end
    len = length(data(1,:));
            imagesc(fig,data);
            set(fig, 'XTick', 0:50:len)
            set(fig, 'XTickLabel', 0:5:len/10)
            set(fig, 'YTick', [0:100:960])
            xlabel(fig, 'Time(s)')
            ylabel(fig, 'Distance')
            
end