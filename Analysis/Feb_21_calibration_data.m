% calibration data


clear;
basedir = pwd;
cali_dir = '/Cali_SEMIC_data/';
dir = [pwd cali_dir];
filename = '*.mat';
filelist = dir([dir filename]);

for i=1:length(filelist)
    load([cali_dir filelist(i).name]);
    five_level(i,1:5)=reg.FinalLMH_5Level;
    stim_degree(i*12-11:i*12)=reg.stim_degree;
    stim_rating(i*12-11:i*12)=reg.stim_rating;
end

% 근데이historgam별로마음에안듬
mean_LMH = [mean(five_level(:,1)); mean(five_level(:,3)); mean(five_level(:,5))];
h1=histogram(five_level(:,1));
hold on
h2=histogram(five_level(:,3));
hold on
h3=histogram(five_level(:,5));
h1.BinWidth = 0.2;
h2.BinWidth = 0.2;
h3.BinWidth = 0.2;

%
mean(stim_degree);
mean(stim_rating);

scatter(stim_degree, stim_rating);
lm = fitlm(stim_degree, stim_rating);
plot(lm)

    