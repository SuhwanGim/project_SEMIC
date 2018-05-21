
col2 = [0.9922 0.6824 0.3804];
load('/Main_SEM013.mat')

%% Just one run
trial_number = 18;
i=1; %Run Number
for j=1:trial_number
    subplot(4,5,j);
    theta = data.dat{i}{j}.con_r_theta(:,2);
    t1 = data.dat{i}{j}.con_time_fromstart;
    % curr_theta = rad2deg(-theta+pi)/180
    theta = 180*theta;
    theta = deg2rad(theta)-pi;
    theta = -theta;
    theta = rad2deg(theta);
    theta= 180 - theta;
    
    
    %subplot(4,5,j);
    plot(t1, theta);
    title([ts{1,i}(j,6) ts{1,i}(j,9)]);
    %title([data.dat{1,i}{1,j}.ts(6) data.dat{1,i}{1,j}.ts(9)]);
    axis([-1 t1(numel(t1)) 0 185]);
    xlabel('TIME(0-14.5)') % x-axis label
    ylabel('DEGREE(0-180)') % y-axis label
end

%% 
trial_number = 18;
run_number = 6;
temp_theta = [];
for i = 1:run_number
    for j= 1:trial_number
        data.dat{1,i}{1,j}.ts(6)
        data.dat{1,i}{1,j}.ts(9)
        temp_theta = temp_theta + data.dat{i}{j}.con_r_theta(:,2);
    end
end

mean(data.dat{i}{j}.con_r_theta(:,2),2)
