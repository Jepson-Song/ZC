%==========================================================
function confusion_matrix1(act1,det1)
 
[mat,order] = confusionmat(act1,det1);
k=max(order);             %k为分类的个数

% 改成百分比
num = zeros(1, k);
for i=1:length(act1)
    num(act1(i)) = num(act1(i)) + 1;
end
for i=1:k
    mat(i,:) = mat(i,:)/num(i);
end
 
%也可作实验，自己随机产生矩阵
%mat = rand(5);  %# A 5-by-5 matrix of random values from 0 to 1
%mat(3,3) = 0;   %# To illustrate
%mat(5,2) = 0;   %# To illustrate
 
imagesc(mat); %# Create a colored plot of the matrix values
colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
 
%#black and lower values are white)
title('混淆矩阵');
textStrings = num2str(mat(:),'%0.02f');       %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
 
%% ## New code: ###这里是不显示小矩阵块里的0，用空白代替
% idx = strcmp(textStrings(:), '0.00');
% textStrings(idx) = {'   '};
%% ################
 
%# Create x and y coordinates for the strings %meshgrid是MATLAB中用于生成网格采样点的函数
[x,y] = meshgrid(1:k); 
hStrings=text(x(:),y(:),textStrings(:),'HorizontalAlignment','center');
midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(mat(:) > midValue,1,3);  %# Choose white or black for the
                                             %#   text color of the strings so
                                             %#   they can be easily seen over
                                             %#   the background color
%将矩阵[mat(:) >midValue]复制1X3块的矢量(颜色值必须为包含3个元素的数值矢量），即把矩阵[mat(:) > midValue]作为矩阵textColors的元素。
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors；
%num2cell(textColors, 2)中2 代表「直行被切割」将结构阵列转换成异质阵列 将结构阵列转换成异质阵列；
%然后set去重后放在hStrings；
 
%下面这个数字8可根据自己的分类需求进行更改
set(gca,'XTick',1:8,...                                   
        'XTickLabel',{'前后','左右','上下','倾斜','俯仰','旋转','7',8'},...  %#   and tick labels
        'YTick',1:8,...                                    %同上
        'YTickLabel',{'前后','左右','上下','倾斜','俯仰','旋转','7',8'},...
        'TickLength',[0 0]);
%==========================================================   
end