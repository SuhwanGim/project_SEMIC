col2 = [0.9922    0.6824    0.3804];
trial_number = 18;
%% 1 RUN within a plot
for i = 1:2 % number of runs
    subplot(1,2,i); 
    for j = 1:trial_number % number of trials
        h = plot(data.dat{1,i}{1,j}.con_xy(:,1), data.dat{i}{j}.con_xy(:,2), 'color', col2, 'linewidth', .3);
        axis([-1 1 0 1]);
        hold on;
    end
end

%% Each plot 1 RUN


i=1; % first run
for j = 1:trial_number
    subplot(4,5,j);
    h = plot(data.dat{1,i}{1,j}.con_xy(:,1), data.dat{i}{j}.con_xy(:,2), 'color', col2, 'linewidth', .3);
    axis([-1 1 0 1]);
    title([data.dat{1,i}{1,j}.ts(6) data.dat{1,i}{1,j}.ts(9)]);
    xlabel('X') % x-axis label
    ylabel('Y') % y-axis label
end

% %% 3d plot? 
% i=1; % first run
% for j = 1:trial_number
%     subplot(4,5,j);
%     plot3(data.dat{1,i}{1,j}.con_xy(:,1), data.dat{i}{j}.con_xy(:,2), data.dat{i}{j}.con_time_fromstart(:,1)); %, 'color', col2, 'linewidth', .3);
%     %h = plot3(data.dat{1,i}{1,j}.con_xy(:,1), data.dat{i}{j}.con_xy(:,2), data.dat{i}{j}.con_time_fromstart(:,1)); %, 'color', col2, 'linewidth', .3);
%     axis([-1 1 0 1]);
%     title([data.dat{1,i}{1,j}.ts(6) data.dat{1,i}{1,j}.ts(9)]);
%     xlabel('X');  % x-axis label
%     ylabel('Y'); % y-axis label
%     zlabel('Z');
% end
%% 같은 조건 별로 모든 run


%% To see rating trends with thermal degrees 
plot(1:12,reg.stim_rating)
hold on; 
plot(1:12, reg.stim_degree')