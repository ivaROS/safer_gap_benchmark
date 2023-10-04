close all
clear
clc

load("ablation_study_data.mat")

font_size = 40;
font_weight = 'normal';
color_alpha = 0.7;
legend_list = ["Success", "Abort", "Collision"];
legend_rect = [0, 0, 1, 1];

method_order = ["pg", "pg-", "pg-mpc", "pg-p", "sg", "sg-p", "sg-p-1", "sg-p-2"];
method_size = method_order.size(2);
rate_order = ["success", "abort", "collision"];
rate_size = rate_order.size(2);

step_size = 1;
y_range = step_size*(1:1:method_size);
bar_size = 0.8;

f1 = figure(1);
figure_position = [1000 0 200 200];
% f1.Position = figure_position;

stdr_rates = zeros([method_size, rate_size]);
for i=1:method_size
    method_idx = find(data.methods == method_order(i));
    for j=1:rate_size
        rate_idx = find(data.labels == rate_order(j));
        stdr_rates(i, j) = data.stdr(method_idx, rate_idx);
    end
end
h1 = barh(y_range, stdr_rates, bar_size, "stacked");
alpha(color_alpha)

% set(gcf,'Position',figure_position);
l1 = legend(legend_list,'Orientation','horizontal');
l1.ItemTokenSize(1) = 40;
l1.ItemTokenSize(2) = 20;
HeightScaleFactor = 0.8;
legend_rect(4) = legend_rect(4) * HeightScaleFactor;
set(gcf,'Position',(get(l1,'Position')...
    .*legend_rect.*get(gcf,'Position')));
set(l1, 'Position', legend_rect, "FontSize", font_size)

NewHeight = l1.Position(4) * HeightScaleFactor;
l1.Position(2) = l1.Position(2) - (NewHeight - l1.Position(4));
l1.Position(4) = NewHeight;
figure_position(4) = figure_position(4) * HeightScaleFactor;
set(gcf, 'Position', get(gcf,'Position') + figure_position);
exportgraphics(gcf, 'ab_legend.png')