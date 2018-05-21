%% Load data

clear;
basedir = pwd;
cali_dir = '/Main_SEMIC_data/';
dirs = [pwd cali_dir];
filename = '*.mat';
filelist = dir([dirs filename]);

%%

%
new_name = ['Main_' filename]
new_filelist = [dirs ;
    
trNumb = 18;
for i=1:length(filelist) %number of participants
    load([dirs filelist(i).name]); 
    for runNbr=1:length(ts) % number of run
        for j=1:trNumb % number of trial
            data.dat{runNbr}{trial_Number(j)}.ts = ts{1,runNbr}(j,:);
            % ts{1,runNbr}(j,:);% data.dat{1,runNbr}{1,j}.ts;
        end
    end
    save([dirs filelist(i).name], '-append', 'data');
end

