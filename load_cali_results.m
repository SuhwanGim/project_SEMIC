function output=load_cali_results()
%
%
clc;
basedir = pwd;
cd Cali_Semic_data;
current_path = [pwd '/'];
filename = '*.mat';
filelist = dir([current_path filename] );
ready = 0;
ls;
while ~ready
    targetFile = input('캘리브레이션 때 입력한 파일명을 정확히 입력해주세요(s+파일명+.mat):','s');
    FullText = strcat('s',targetFile, '.mat');
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
end
