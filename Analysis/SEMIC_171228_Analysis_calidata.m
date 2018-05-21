%% Introdction
% A script for anlayzing calibration data at 17.12.28
% Outlier = 'SEM014', 'SEM022';


%% Settings
clear;
basedir = pwd;
cali_dir='/Users/WIWIFH/Dropbox/github/SEMIC_CODE_COCOAN/CALI_SEMIC_data/'; % it depends on location of data
filename = '*.mat';
filelist = dir([cali_dir filename]);

%load([cali_dir filelist(i).name]);

%% Text summary


%% 12 each participant's response plot 

col = 6;
row = floor(length(filelist)/col);
mod1 = mod(length(filelist),col);
if mod1 > 0
    row = row+1;
end

for i=1:length(filelist) 
    subplot(row,col,i); 
    load([cali_dir filelist(i).name]);
    plot(reg.total_fit);
    axis([39 50 -1 100]);
    title(filelist(i).name);
    xlabel('Themal degree') % x-axis label
    ylabel('Rating score (0 to 100)') % y-axis label
end



%%
% cali_rating = zeros(length(filelist),12);
% cali_stim_level = zeros(length(filelist),12);
clear cali_rating
clear cali_stim_level
for i=1:length(filelist) 
    load([cali_dir filelist(i).name]);
    cali_rating(i*12-11:i*12) = reg.stim_rating;
    cali_stim_level(i*12-11:i*12) = reg.stim_degree;
end

total_cali_regression = fitlm(cali_stim_level, cali_rating,'linear');
plot(total_cali_regression);
axis([39 50 -1 100]);
xlabel('Themal degree') % x-axis label
ylabel('Rating score (0 to 100)') % y-axis label

%% mean data
cali_mean = zeros(length(filelist),5);
cali_std = zeros(length(filelist),5);
for i=1:length(filelist) 
    load([cali_dir filelist(i).name]);
    cali_mean(i,:) = reg.FinalLMH_5Level;
end

% plot
disp (mean(cali_mean));
disp (std(cali_mean));
level = {'LV1', 'LV2', 'LV3', 'LV4', 'LV5'};
for i=1:5 % Five level 
    subplot(5,1,i); 
    hist(cali_mean(:,i))
    axis([39 50 0 length(filelist)./2]);
    title(['heat level' level{i}]);
    xlabel('themal degree') % x-axis label
    ylabel('number') % y-axis label
end


%% Distribution for R-squared

cali_r_squared = zeros(length(filelist),1);
for i=1:length(filelist) 
    load([cali_dir filelist(i).name]);
    cali_r_squared(i) = reg.total_fit.Rsquared.Ordinary;
end

hist(cali_r_squared);
title_str = num2str(length(filelist));
title(['distribution for R-squared' ' N=' title_str]);
xlabel('r-squared')

disp(mean(cali_r_squared));
disp(std(cali_r_squared));