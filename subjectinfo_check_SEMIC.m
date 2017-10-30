function [fname,start_trial,start_run,SID] = subjectinfo_check_SEMIC(savedir, runNbr)

% SUBJECT INFORMATION: file exists?
% [fname,start_line,SID] = subjectinfo_check

% Subject ID    
fprintf('\n');
SID = input('Subject ID? ','s');
    
% check if the data file exists
fname = fullfile(savedir, ['s' SID '.mat']);
if ~exist(savedir, 'dir')
    mkdir(savedir);
    whattodo = 1;
else
    if exist(fname, 'file')
        str = ['The Subject ' SID ' data file exists. Press a button for the following options'];
        disp(str);
        whattodo = input('1:Save new file, 2:Save the data from where we left off, Ctrl+C:Abort? ');
    else
        whattodo = 1;
    end
end
    
if whattodo == 2
    load(fname);
    start_run = runNbr;
    start_trial = numel(data.dat{runNbr}) + 1;
else
    start_trial = 1;
end
   
end