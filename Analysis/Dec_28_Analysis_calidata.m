%% Introdction
% A script for anlayzing calibration data at 17.12.28

%%
clear;
basedir = pwd;
cali_dir='/Users/WIWIFH/Dropbox/2017-summer,2/CocoanLab/SEMIC/data/Calibration/Pilot_with_Cocoan_(s+Name+Date)/';
filename = '*.mat';
filelist = dir([cali_dir filename]);

for i=1:length(filelist) 
    subplot(3,3,i); 
    load([cali_dir filelist(i).name]);
    plot(reg.total_fit);
    axis([41 50 -1 100]);
    title(filelist(i).name);
    xlabel('Themal degree') % x-axis label
    ylabel('Rating score (0 to 100)') % y-axis label
end

