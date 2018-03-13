col2 = [0.9922    0.6824    0.3804];
trial_number = 18;

%%
i=1;
for j=1:18
    subplot(4,5,j);
    theta = data.dat{i}{j}.con_r_theta(:,2);
    t1 = data.dat{i}{j}.con_time_fromstart;
    theta = rad2deg(theta);
    theta= 180 - theta;
    
    
    %subplot(4,5,j);
    plot(t1, theta);
    title([data.dat{1,i}{1,j}.ts(6) data.dat{1,i}{1,j}.ts(9)]);
    axis([-1 t1(numel(t1)) 0 180]);
    xlabel('TIME(0-14.5)') % x-axis label
    ylabel('DEGREE(0-180)') % y-axis label
end