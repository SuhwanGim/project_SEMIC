function output=load_cali_results()
%
%
clc;
basedir = pwd;
current_path = [pwd '/CALI_SEMIC_data/'];%it should be same as name of cali data folder (see 'savedir' on calibration.m)
filename = '*.mat';
filelist = dir([current_path filename] );
ready = 0;
cd(current_path);
ls;
while ~ready
    targetFile = input('Type the "Subject ID" exatly: ','s');
    FullText = strcat('Calib_',targetFile, '.mat');
    for i=1:length(filelist)
        if strcmp(FullText, filelist(i).name) == 1
            ready=1;
            break;
        else
            %do nothing
        end
    end
end
load(FullText, 'reg');
output=reg;
cd(basedir);
clc;
disp(output.version); %show a version of datafile
end
