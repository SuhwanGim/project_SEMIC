function output=load_cali_results()
%
%
%clc;
originPWD = pwd;
cd Cali_Semic_data;
current_path = [pwd '/'];
filename = ['*.mat'];
filelist = dir([current_path filename] );
ready = 0;
while ~ready
    targetFile = input('Ķ���극�̼� �� �Է������ϸ��� ��Ȯ�� �Է����ּ���:','s');
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
cd(originPWD);
end
