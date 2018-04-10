% calibration data


clear;
basedir = pwd;
cali_dir = '/Cali_SEMIC_data/';
dirs = [pwd cali_dir];
filename = '*.mat';
filelist = dir([dirs filename]);

for i=1:length(filelist)
    load([dirs filelist(i).name]);
    five_level(i,1:5)=reg.FinalLMH_5Level;
    stim_degree(i*12-11:i*12)=reg.stim_degree;
    stim_rating(i*12-11:i*12)=reg.stim_rating;
end

%% 근데이historgam별로마음에안듬
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


%%
std_rating=[30 40 50 60 70];
P=polyfit(stim_degree,stim_rating,1); % (x,y, dimension) regression
for i=1:5 % Trial 4~
    non_corrected_degree=(std_rating(i)-P(2))./P(1);
    cur_heat_LMH(1,i) = non_corrected_degree;
end
disp(cur_heat_LMH);

    