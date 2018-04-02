function [fname,start_trial,SID] = subjectinfo_check_SEMIC(SID,savedir, runNbr, varargin)

% Get subject information, and check if the data file exists?
%
% :Usage:
% ::
%     [fname, start_line, SID] = subjectinfo_check(savedir, run_number,varargin)
%
%
% :Inputs:
%
%   **savedir:**
%       The directory where you save the data
%
% :Optional Inputs:
%
%   **'Mot':**
%       Check the data file for Motor_task.m
%
%   **'Main':**
%       Check the data file for thermode_test.m
%
%   **'Cali':**
%       Check the data file for calibration.m
%
%   **'Learn':**
%       Check the data file for Learning_phase.m
%   **'Rest' :**
%       Check the data file for rest_run.m
%
% ..
%    Copyright (C) 2017  Wani Woo (Cocoan lab)
% ..


% SETUP: varargin
mot = false;
main2 = false; % It's for avoid distinct main.m (related to pathway function)
cali = false;
learn = false;
rest = false;

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'Mot'}
                mot = true;
            case {'Main'}
                main2 = true;
            case {'Cali'}
                cali = true;
            case {'Learn'}
                learn = true;
            case {'Rest'}
                rest = true;
        end
    end
end


% Get Subject ID
fprintf('\n');
% SID = input('Subject ID? ','s');

% check if the data file exists
if mot
    fname = fullfile(savedir, ['Motor_' SID '.mat']);
elseif main2
    fname = fullfile(savedir, ['Main_' SID  '.mat']);
elseif cali
    fname = fullfile(savedir, ['Calib_' SID '.mat']);
elseif learn
    fname = fullfile(savedir, ['Learning_' SID '.mat']);
elseif rest
    fname = fullfile(savedir, ['Rest_' SID '.mat']);
else
    error('Unknown input');
end

% What to do if the file exits?
if ~exist(savedir, 'dir')
    mkdir(savedir);
    whattodo = 1;
else
    if exist(fname, 'file')
        if runNbr == 1
            str = ['The Subject ' SID ' data file exists. Press a button for the following options'];
            disp(str);
            whattodo = input('1:Save new file, 2:Save the data from where we left off, Ctrl+C:Abort? ');
        else
            str = ['The Subject ' SID ' data file exists and not first trial. Press a button for the follwing options'];
            disp(str);
            whattodo = input('1:Go next run, 2:Save the data from where we left off, Ctrl+C: Abort? ');
        end
    else
        whattodo = 1;
    end
end

if whattodo == 2
    load(fname);
    
    if cali
        start_trial = numel(reg.stim_degree) + 1;
    elseif main2
        start_trial = numel(data.dat{runNbr}) + 1;
    else
        disp('Unknown strat_point');
    end
    
else
    start_trial = 1;
end

end