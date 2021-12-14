function boxplot

gca_size=30;
%x axis font size
xlim_size=36;
%algorithm font size
alg_size=30;
%mark size
mark_size=2;
%line width
line_width=3;%????
mark={'-o','-p','-s','-d','-^'};
mark_index=[1,2,3,4,5];
%algorithm legend
algorithm={'A-A','B-A','A-B','B-B','Merge'};
algorithm_index=[1,2,3,4,5,6];
mark={'-o','--p','-s','-d','-^'};
mark_index=[1,2,3,4,5];
%line color
color=[
%red
198,78,43;  
%green
133,179,26; 
%blue
38,87,153;   
%vivolet
143,63,143;
%yellow
228,209,39;
%cyan
37,141,211;
0,114,189;

]/255;
color_index=[1,2,3,4,5,6,7];
font_size=36;

% figure()
% [f1,x1]=ecdf(error0);
% plot(x1,f1, 'LineWidth', line_width, 'Color', color(3, :), 'LineWidth', line_width)
% hold on;
% [f2,x2]=ecdf(error15);
% plot(x2,f2, 'LineWidth', line_width, 'Color', color(1, :), 'LineWidth', line_width)
% hold on;
% [f3,x3]=ecdf(error30);
% plot(x3,f3, 'LineWidth', line_width, 'Color', color(2, :), 'LineWidth', line_width)
% hold on;
% [f4,x4]=ecdf(error45);
% plot(x4,f4, 'LineWidth', line_width, 'Color', color(4, :), 'LineWidth', line_width)
% hold on;
% [f5,x5]=ecdf(error60);
% plot(x5,f5, 'LineWidth', line_width, 'Color', color(5, :), 'LineWidth', line_width)
% hold on;
% [f6,x6]=ecdf(error75);
% plot(x6,f6, 'LineWidth', line_width, 'Color', color(6, :), 'LineWidth', line_width)
% hold on;
% [f7,x7]=ecdf(error90);
% plot(x7,f7, 'LineWidth', line_width, 'Color', color(7, :), 'LineWidth', line_width)

errors_abs_final = [error0, error15, error30, error45, error60, error75, error90];
groups = [zeros(1, size(error0, 2)), ones(1, size(error15, 2))*15, ...
    ones(1, size(error30, 2))*30, ones(1, size(error45, 2))*45, ones(1, size(error60, 2))*60, ...
    ones(1, size(error75, 2))*75, ones(1, size(error90, 2))*90];
h = boxplot(errors_abs_final, groups);
set(h,'LineWidth',1.5);
% x = (1:size(dis_temp, 2)-199)/ 25;
% plot(x, dis_temp(200:end)-0.5, 'LineWidth', line_width - 1, 'Color', color(3, :))
% hold on;
% plot(x, temp_compare(200:end), 'LineWidth', line_width, 'Color', color(2, :))
% hold on;
% plot(x, filt_temp(151:end)-0.5, 'LineWidth', line_width, 'Color', color(1, :))
% legend('Acoustic','BME280', 'Filtered Acoustic','Location', 'northwest','NumColumns',1)
% plot(ground_truth(:, 1), ground_truth(:, 2), 'r*');
% hold on
% plot(estimated_ro(:, 1), estimated_ro(:, 2), 'g*');
% xlim([-5, 20])
% ylim([-6, 25])

% legend('Ground Truth','Users Ploted', 'Location','southeast','NumColumns',1)
% plot(0.5:1:6.5, (0:1:6)-3, ":", "LineWidth", 1.5)
set(gca,'FontSize',gca_size);
xlabel(['\fontsize {' num2str(xlim_size) '}\fontname {Arial MT} Device Oriention (°)']);
ylabel(['\fontsize {' num2str(xlim_size) '}\fontname {Arial MT} Temperature Error (°C)']);
set(gcf,'Position',[232   246   1000   600], 'color','w');
grid on;

end