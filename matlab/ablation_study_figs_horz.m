close all
clear
clc

% load("ablation_study_data.mat")
load("ablation_study_second_data.mat")

font_size = 40;
font_weight = 'normal';
color_alpha = 0.7;
% method_order = ["pg", "pg-", "pg-mpc", "pg-p", "sg", "sg-p", "sg-p-1", "sg-p-2"];
method_order = ["pg", "pg-po", "sg", "sg-tuned", "sg-track", "sg-mpc", "sg-mpc-po"];
method_size = method_order.size(2);
rate_order = ["success", "abort", "collision"];
rate_size = rate_order.size(2);
success_idx = find(rate_order=="success");
abort_idx = find(rate_order=="abort");
collision_idx = find(rate_order=="collision");

enable_legend = false;
legend_list = ["Success", "Abort", "Collision"];
legend_rect = [0.85, 0.7, .15, .25];

step_size = 1;
y_range = step_size*(1:1:method_size);
bar_size = 0.8;

xtick_step = 20;

figure_position = [1000 0 1500 800];

stdr_enable = true;

draw_stdr = true;
draw_gazebo = false;
if(~stdr_enable)
    draw_stdr = false;
    draw_gazebo = true;
end

%% stdr rate bar
range_buff = 15;
move_left_offset = 12;

if draw_stdr
f1 = figure(1);
f1.Position = figure_position;

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
set(gca,'YTick',[],'YDir','reverse')
xlim([0, 100])
xticks(0:xtick_step:100)
xtickformat('percentage')
ylim([y_range(1)/3, y_range(end) + y_range(1)/3*2])
set(gca,'XMinorTick','on')
xtickLabel1 = get(gca,'XTickLabel');
set(gca,'XTickLabel',xtickLabel1,'fontsize',font_size,'fontweight',font_weight)
xAx1 = get(gca,'XAxis');
xAx1.MinorTickValues = 0:xtick_step/2:100;

ybarCnt1 = vertcat(h1.XEndPoints)';
xbarTop1 = vertcat(h1.YEndPoints)';
xbarCnt1 = xbarTop1 - stdr_rates/2; 
xbarBot1 = xbarTop1 - stdr_rates; 
xbarRange1 = xbarTop1 - xbarBot1;
xbarCnt1_max = max(xbarCnt1(:,success_idx));
xbarCnt1_min = min(xbarCnt1(:,success_idx));

% Create text strings
txt1 = compose('%.1f%%',stdr_rates);
% Add text 
for i=1:method_size
    for j=1:rate_size
        if(stdr_rates(i, j) ~= 0)
            if(j == success_idx)
                text(xbarCnt1_min, ybarCnt1(i, j), txt1(i, j), ...
                'HorizontalAlignment', 'center', ....
                'VerticalAlignment', 'middle', ...
                'Color', 'k',....
                'FontSize', font_size,'FontWeight',font_weight);
            else
                if(xbarRange1(i, j) <= range_buff)
                    text(xbarBot1(i, j)-move_left_offset, ybarCnt1(i, j), txt1(i, j), ...
                    'HorizontalAlignment', 'left', ....
                    'VerticalAlignment', 'middle', ...
                    'Color', 'k',....
                    'FontSize', font_size,'FontWeight',font_weight);
                else
                    text(xbarCnt1(i, j), ybarCnt1(i, j), txt1(i, j), ...
                    'HorizontalAlignment', 'center', ....
                    'VerticalAlignment', 'middle', ...
                    'Color', 'k',....
                    'FontSize', font_size,'FontWeight',font_weight);
                end
            end
        end
    end
end

if(enable_legend)
    l1 = legend(legend_list);
    set(l1, 'Position', legend_rect, "FontSize", font_size)
end

exportgraphics(gcf,'ab_rates_horz_stdr.png')
end
%% gazebo rate bar
range_buff = 10;
move_left_offset = 10;
move_right_offset = 10;

if draw_gazebo
f2 = figure(2);
figure_position(3) = figure_position(3) + 50;
f2.Position = figure_position;

gazebo_rates = zeros([method_size, rate_size]);
for i=1:method_size
    method_idx = find(data.methods == method_order(i));
    for j=1:rate_size
        rate_idx = find(data.labels == rate_order(j));
        gazebo_rates(i, j) = data.gazebo(method_idx, rate_idx);
    end
end
h2 = barh(y_range, gazebo_rates, bar_size, "stacked");
alpha(color_alpha)
set(gca,'YTick',[],'YDir','reverse')
xlim([0, 100])
xticks(0:xtick_step:100)
xtickformat('percentage')
ylim([y_range(1)/3, y_range(end) + y_range(1)/3*2])
set(gca,'XMinorTick','on')
xtickLabel1 = get(gca,'XTickLabel');
set(gca,'XTickLabel',xtickLabel1,'fontsize',font_size,'fontweight',font_weight)
xAx1 = get(gca,'XAxis');
xAx1.MinorTickValues = 0:xtick_step/2:100;

ybarCnt2 = vertcat(h2.XEndPoints)'; 
xbarTop2 = vertcat(h2.YEndPoints)';
xbarCnt2 = xbarTop2 - gazebo_rates/2;
xbarBot2 = xbarTop2 - gazebo_rates; 
xbarRange2 = xbarTop2 - xbarBot2;
xbarCnt2_max = max(xbarCnt2(:,success_idx));
xbarCnt2_min = min(xbarCnt2(:,success_idx));

% Create text strings
txt2 = compose('%.1f%%',gazebo_rates);
% Add text 
for i=1:method_size
    for j=1:rate_size
        if(gazebo_rates(i, j) ~= 0)
            if(j == success_idx)
                text(xbarCnt2_min, ybarCnt2(i, j), txt2(i, j), ...
                'HorizontalAlignment', 'center', ....
                'VerticalAlignment', 'middle', ...
                'Color', 'k',....
                'FontSize', font_size,'FontWeight',font_weight);
            else
                if(xbarRange2(i, j) <= range_buff)
                    if(j == collision_idx)
                        text(xbarTop2(i, j)+move_right_offset, ybarCnt2(i, j), txt2(i, j), ...
                        'HorizontalAlignment', 'right', ....
                        'VerticalAlignment', 'middle', ...
                        'Color', 'k',....
                        'FontSize', font_size,'FontWeight',font_weight);
                    else
                        text(xbarBot2(i, j)-move_left_offset, ybarCnt2(i, j), txt2(i, j), ...
                        'HorizontalAlignment', 'left', ....
                        'VerticalAlignment', 'middle', ...
                        'Color', 'k',....
                        'FontSize', font_size,'FontWeight',font_weight);
                    end
                else
                    text(xbarCnt2(i, j), ybarCnt2(i, j), txt2(i, j), ...
                    'HorizontalAlignment', 'center', ....
                    'VerticalAlignment', 'middle', ...
                    'Color', 'k',....
                    'FontSize', font_size,'FontWeight',font_weight);
                end
            end
        end
    end
end

if(enable_legend)
    l2 = legend(legend_list);
    set(l2, 'Position', legend_rect, "FontSize", font_size)
end

exportgraphics(gcf,'ab_rates_horz_gazebo.png')
end