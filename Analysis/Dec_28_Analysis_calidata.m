%% Introdction
% A script for anlayzing calibration data at 17.12.28

%%
clear;
basedir = pwd;
cali_dir='/Users/WIWIFH/Dropbox/github/SEMIC_CODE_COCOAN/CALI_SEMIC_data/';
filename = '*.mat';
filelist = dir([cali_dir filename]);

for i=1:length(filelist) 
    subplot(3,4,i); 
    load([cali_dir filelist(i).name]);
    plot(reg.total_fit);
    axis([39 50 -1 100]);
    title(filelist(i).name);
    xlabel('Themal degree') % x-axis label
    ylabel('Rating score (0 to 100)') % y-axis label
end

