close all
clear
clc

load("ablation_study_data.mat")

font_size = 20;
method_order = ["pg", "pg-", "pg-mpc", "pg-p", "sg", "sg-p", "sg-p-1", "sg-p-2"];
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
x_range = step_size*(1:1:method_size);
bar_size = 0.9;

ytick_step = 20;

figure_position = [1000 0 1000 500];

range_buff = 5;
move_bot_offset = 1.5;
move_top_offset = 1.5;

draw_stdr = false;
draw_gazebo = true;

%% stdr rate bar
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
h1 = bar(x_range, stdr_rates, bar_size, "stacked");
set(gca,'XTick',[])
ylim([0, 100])
yticks(0:ytick_step:100)
ytickformat('percentage')
set(gca,'YMinorTick','on')
ytickLabel1 = get(gca,'YTickLabel');
set(gca,'YTickLabel',ytickLabel1,'fontsize',font_size)
yAx1 = get(gca,'YAxis');
yAx1.MinorTickValues = 0:ytick_step/2:100;

xbarCnt1 = vertcat(h1.XEndPoints)';
ybarTop1 = vertcat(h1.YEndPoints)';
ybarCnt1 = ybarTop1 - stdr_rates/2;
ybarBot1 = ybarCnt1 - 2 * (ybarTop1 - ybarCnt1); 
ybarRange1 = ybarTop1 - ybarBot1;
ybarCnt1_max = max(ybarCnt1(:,success_idx));
ybarCnt1_min = min(ybarCnt1(:,success_idx));

% Create text strings
txt1 = compose('%.1f%%',stdr_rates);
% Add text 
for i=1:method_size
    for j=1:rate_size
        if(stdr_rates(i, j) ~= 0)
            if(j == success_idx)
                text(xbarCnt1(i, j), ybarCnt1_min, txt1(i, j), ...
                'HorizontalAlignment', 'center', ....
                'VerticalAlignment', 'middle', ...
                'Color', 'k',....
                'FontSize', font_size);
            else
                if(ybarRange1(i, j) <= range_buff)
                    text(xbarCnt1(i, j), ybarBot1(i, j)-move_bot_offset, txt1(i, j), ...
                    'HorizontalAlignment', 'center', ....
                    'VerticalAlignment', 'middle', ...
                    'Color', 'k',....
                    'FontSize', font_size);
                else
                    text(xbarCnt1(i, j), ybarCnt1(i, j), txt1(i, j), ...
                    'HorizontalAlignment', 'center', ....
                    'VerticalAlignment', 'middle', ...
                    'Color', 'k',....
                    'FontSize', font_size);
                end
            end
        end
    end
end

if(enable_legend)
    l1 = legend(legend_list);
    set(l1, 'Position', legend_rect, "FontSize", font_size)
end

exportgraphics(gcf,'ab_rates_stdr.png')
end
%% gazebo rate bar
if draw_gazebo
f2 = figure(2);
f2.Position = figure_position;

gazebo_rates = zeros([method_size, rate_size]);
for i=1:method_size
    method_idx = find(data.methods == method_order(i));
    for j=1:rate_size
        rate_idx = find(data.labels == rate_order(j));
        gazebo_rates(i, j) = data.gazebo(method_idx, rate_idx);
    end
end
h2 = bar(x_range, gazebo_rates, bar_size, "stacked");
set(gca,'XTick',[])
ytickformat('percentage')
ylim([0, 100])
yticks(0:ytick_step:100)
ytickformat('percentage')
set(gca,'YMinorTick','on')
ytickLabel2 = get(gca,'YTickLabel');
set(gca,'YTickLabel',ytickLabel2,'fontsize',font_size)
yAx2 = get(gca,'YAxis');
yAx2.MinorTickValues = 0:ytick_step/2:100;

xbarCnt2 = vertcat(h2.XEndPoints)'; 
ybarTop2 = vertcat(h2.YEndPoints)';
ybarCnt2 = ybarTop2 - gazebo_rates/2;
ybarBot2 = ybarCnt2 - 2 * (ybarTop2 - ybarCnt2); 
ybarRange2 = ybarTop2 - ybarBot2;
ybarCnt2_max = max(ybarCnt2(:,success_idx));
ybarCnt2_min = min(ybarCnt2(:,success_idx));

% Create text strings
txt2 = compose('%.1f%%',gazebo_rates);
% Add text 
for i=1:method_size
    for j=1:rate_size
        if(gazebo_rates(i, j) ~= 0)
            if(j == success_idx)
                text(xbarCnt2(i, j), ybarCnt2_min, txt2(i, j), ...
                'HorizontalAlignment', 'center', ....
                'VerticalAlignment', 'middle', ...
                'Color', 'k',....
                'FontSize', font_size);
            else
                if(ybarRange2(i, j) <= range_buff)
                    if(j == collision_idx)
                        text(xbarCnt2(i, j), ybarTop2(i, j)+move_top_offset, txt2(i, j), ...
                        'HorizontalAlignment', 'center', ....
                        'VerticalAlignment', 'middle', ...
                        'Color', 'k',....
                        'FontSize', font_size);
                    else
                        text(xbarCnt2(i, j), ybarBot2(i, j)-move_bot_offset, txt2(i, j), ...
                        'HorizontalAlignment', 'center', ....
                        'VerticalAlignment', 'middle', ...
                        'Color', 'k',....
                        'FontSize', font_size);
                    end
                else
                    text(xbarCnt2(i, j), ybarCnt2(i, j), txt2(i, j), ...
                    'HorizontalAlignment', 'center', ....
                    'VerticalAlignment', 'middle', ...
                    'Color', 'k',....
                    'FontSize', font_size);
                end
            end
        end
    end
end

if(enable_legend)
    l2 = legend(legend_list);
    set(l2, 'Position', legend_rect, "FontSize", font_size)
end

exportgraphics(gcf,'ab_rates_gazebo.png')
end