function data = SEMIC_MAIN(trial_sequence, varargin)

% This function is for controlling the LabView program to deliver pressure
% pain and collecting ratings (continuous or one-time ratings)
%
% Usage:
% -------------------------------------------------------------------------
% data = pressure_test(trial_sequence, varargin)
%
% Inputs:
% -------------------------------------------------------------------------
% trial_sequence trial_sequence should provide information of intensity,
%                duration, repetition of simulation, rating and scale type 
%                you want to use, and cue/iti duration. 
%
% The generic form of trial sequence:
% trial_sequence{run_number}{trial_number} = ...
%          {intensity(four digits:string), duration(four digits:string),
%           repetition_number, rating_scale_type, cue_duration,
%           post-stim jitter, inter_stim_interval (from the rating to the 
%           next trial), cue_message, during_stim_message};
% For details, see example below.
%
% Optional input:
% -------------------------------------------------------------------------
% 'post_st_rating_dur'  If you are collecting continuous rating, using this 
%                       option, you can specify the duration for the 
%                       post-stimulus rating. The default is 5 seconds.
%                       (e.g., 'post_st_rating_dur', duration_in_seconds)
% 'explain_scale'       If you want to show rating scale before starting
%                       the experiment, you can use this option.
%                       (e.g., 'explain_scale', {'overall_avoidance', 'overall_int'})
% 'test'                running a testmode with partial-screen
% 'scriptdir'           specify the script directory
% 'psychtoolbox'        specify the psychtoolbox directory
% 'fmri'                display some instructions for a fmri experiment
%
% Outputs:
% -------------------------------------------------------------------------
% data.
%
%
%
%
% Example:
% -------------------------------------------------------------------------
% trial_sequence{1}{1} = {'PP', 'LV1', '0010', {'overall_avoidance'}, '0', '3', '7'};
%     ----------------------------
%     {1}{1}: first run, first trial
%     'PP'  : pressure pain
%         -- other options --
%         'TP': thermal pain
%         'PP': thermal pain
%         'AU': aversive sounds
%         'VI': aversive visual
%         ** you can add more stimuli options...
%     'LV1'-'LV4' : intensity levels
%     '0010': duration in seconds (10 seconds)
%     {'overall_avoidance'}: overall avoidance rating (after stimulation ends)
%         -- other options --
%         'no'              : no ratings
%         'cont_int'        : continuous intensity rating
%         'cont_avoidance'  : continuous rating
%         'overall_int'     : overall intensity rating 
%         'overall_unpleasant' : overall intensity rating 
%         'overall_avoidance'  : overall avoidance rating 
%         ** to add more combinations, see "parse_trial_sequence.m" and "draw_scale.m" **
%     '0': cue duration 0 seconds: no cue
%     '3': interval between stimulation and ratings: 3 seconds
%     '7': inter_stim_interval: This defines the interval from the time the rating starts
%          to the next trial starts. Actual ITI will be this number minus RT.
%     ** optional: Using 8th cell array, you can specify cue text.
%                       Or you can also use social cues. In this case, the 8th cell array 
%                       should contain social cue information in the following format:
%                            {'draw_social_cue', [m, sd, n]})
%                  Using 9th cell array, you can specify text during stimulation
%
% trial_sequence{1}{2} = {'AU', 'LV2', '0010', {'overall_int'}, '0', '3', '7', 'How much pressure?'};
%     'How much pressure?' - will be appeared as cue. If the 8th cell is not 
%                            specified, it will display a fixation cross.
%
% trial_sequence{1}{3} = {'TP', 'LV4', '0010', {'overall_pleasant'}, '0', '3', '7'};
% 
% data = mpa1_main(trial_sequence, 'explain_scale', exp_instructions, 'fmri', 'biopac')
%
% -------------------------------------------------------------------------
% Copyright (C) 1/10/2015, Wani Woo
%
% Programmer's note:
% 10/19/2015, Wani Woo -- modified the original code for MPA1


%% SETUP: global
global theWindow W H; % window property
global white red orange yellow bgcolor; % color
global window_rect lb rb tb bb scale_H anchor_y joy_speed; % rating scale
global anchor_xl anchor_xr anchor_yu anchor_yd fontsize;


%% Parse varargin
post_stimulus_t = 5; % post-stimulus continuous rating seconds
doexplain_scale = false;
testmode = false;
dofmri = false;
USE_BIOPAC = false;
joy_speed = .8; % should be between 0.1 and .95(?) or 1, higher = slower
rating_device = 'trackball'; % default is mouse
use_mouse = true;
use_joystick = false;

% need to be specified differently for different computers
% psytool = 'C:\toolbox\Psychtoolbox';
scriptdir = '/Users/cocoan/Dropbox/github/';
savedir = 'SEMIC_data';

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'post_st_rating_dur', 'post_st_rating'}
                post_stimulus_t = varargin{i+1};
            case {'explain_scale'}
                doexplain_scale = true;
                exp_scale.inst = varargin{i+1};
            case {'test'}
                testmode = true;
            case {'scriptdir'}
                scriptdir = varargin{i+1};
            case {'psychtoolbox'}
                psytool = varargin{i+1};
            case {'fmri'}
                dofmri = true;
            case {'biopac1'}
                USE_BIOPAC = true;
                channel_n = 3;
                biopac_channel = 0;
                ljHandle = BIOPAC_setup(channel_n); % BIOPAC SETUP
            case {'joystick'}
                rating_device = 'joystick';
                use_mouse = false;
                use_joystick = true;
            case {'mouse', 'trackball'}
                % do nothing
            case {'CHEPS'}
                ip = '203.252.46.54';
                port = 20121; 
        end
    end
end

addpath(scriptdir); cd(scriptdir);
% addpath(genpath(psytool));


%% SETUP: Screen
if exist('data', 'var'), clear data; end

bgcolor = 80;

if testmode
    window_num = 0;
    window_rect = [1 1 1500 800]; % in the test mode, use a little smaller screen
    %window_rect = [0 0 1900 1200];
    fontsize = 20;
else
    screens = Screen('Screens');
    window_num = screens(end); % the last window
    window_info = Screen('Resolution', window_num); 
    window_rect = [0 0 window_info.width window_info.height]; % full screen
    fontsize = 32;
end

W = window_rect(3); %width of screen
H = window_rect(4); %height of screen

font = 'NanumBarunGothic';

white = 255;
red = [255 0 0];
orange = [255 164 0];
yellow = [255 220 0];

% % rating scale left and right bounds 1/4 and 3/4
% lb = W/4; 
% rb = (3*W)/4;

% rating scale left and right bounds 1/5 and 4/5
lb = 1.5*W/5; % in 1280, it's 384
rb = 3.5*W/5; % in 1280, it's 896 rb-lb = 512

% rating scale upper and bottom bounds 
tb = H/5+100;           % in 800, it's 310
bb = H/2+100;           % in 800, it's 450, bb-tb = 340
scale_H = (bb-tb).*0.25;

anchor_xl = lb-80; % 284
anchor_xr = rb+20; % 916
anchor_yu = tb-40; % 170
anchor_yd = bb+20; % 710    

% y location for anchors of rating scales -
anchor_y = H/2+10+scale_H;
% anchor_lms = [0.014 0.061 0.172 0.354 0.533].*(rb-lb)+lb;

%% SETUP: DATA and Subject INFO
[fname, start_line, SID] = subjectinfo_check(savedir); % subfunction
if exist(fname, 'file'), load(fname, 'data'); end

% save data using the canlab_dataset object
data.version = 'SEMIC_v1_10-19-2017_Cocoanlab';
data.subject = SID;
data.datafile = fname;
data.starttime = datestr(clock, 0); % date-time
data.starttime_getsecs = GetSecs; % in the same format of timestamps for each trial

% initial save of trial sequence
save(data.datafile, 'trial_sequence', 'data');

%% SETUP: Experiment 

[run_num, trial_num, runstart, trial_starts, rating_types] = parse_trial_sequence(trial_sequence, start_line);
%lvs = {'LV1', 'LV2', 'LV3', 'LV4'}; % you can add more..

%% SETUP: STIMULI -- modify this for each study
% see subfunctions
%TP_int = Thermal_pain_setup;

%% START

try
    % START: Screen
	theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
    Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
    %Screen('TextFont', theWindow, font); % setting font
    Screen('TextSize', theWindow, fontsize);
    if ~testmode, HideCursor; end
    
    % EXPLAIN SCALES
    if doexplain_scale
        explain_scale(exp_scale, rating_types, rating_device);
    end
    
    % START: RUN
    for run_i = runstart:run_num % run starts
        
        for tr_i = trial_starts(run_i):trial_num(run_i) % trial starts
            
            % DISPLAY EXPERIMENT MESSAGE:
            if run_i == 1 && tr_i == 1
                while (1)
                    [~,~,keyCode] = KbCheck;
                    if keyCode(KbName('space'))==1
                        break
                    elseif keyCode(KbName('q'))==1
                        abort_man;
                    end 
                    display_expmessage; % until space; see subfunctions
                end
            end
            
            if tr_i == 1 % first trial
                while (1)
                    [~,~,keyCode] = KbCheck;
                    
                    % if this is for fMRI experiment, it will start with "s",
                    % but if behavioral, it will start with "r" key. 
                    if dofmri
                        if keyCode(KbName('s'))==1
                            break
                        elseif keyCode(KbName('q'))==1
                            abort_man;
                        end
                    else
                        if keyCode(KbName('r'))==1
                            break
                        elseif keyCode(KbName('q'))==1
                            abort_man;
                        end
                    end
                    display_runmessage(run_i, run_num, dofmri); % until 5 or r; see subfunctions
                end
                
                if dofmri
                    % gap between 5 key push and the first stimuli (disdaqs: data.disdaq_sec)
                    % 5 seconds: "占쏙옙占쏙옙占쌌니댐옙..."
                    Screen(theWindow, 'FillRect', bgcolor, window_rect);
                    DrawFormattedText(theWindow, double('시작합니다...'), 'center', 'center', white, [], [], [], 1.2);
                    Screen('Flip', theWindow);
                    data.dat{run_i}{tr_i}.runscan_starttime = GetSecs;
                    WaitSecs(4);
                    
                    % 5 seconds: Blank
                    Screen(theWindow,'FillRect',bgcolor, window_rect);
                    Screen('Flip', theWindow);
                    WaitSecs(4); % ADJUST THIS
                end
                
                % 1 seconds: BIOPAC
                if USE_BIOPAC
                    data.dat{run_i}{tr_i}.biopac_triggertime = GetSecs;
                    BIOPAC_trigger(ljHandle, biopac_channel, 'on');
                end
                
                Screen(theWindow,'FillRect',bgcolor, window_rect);
                Screen('Flip', theWindow);
                WaitSecs(2); % ADJUST THIS
                
                if USE_BIOPAC
                    BIOPAC_trigger(ljHandle, biopac_channel, 'off');
                end

                data.dat{run_i}{tr_i}.firsttrial_starttime = GetSecs;
            end
            
            % HERE: CUE or FIXATION CROSS --------------------------------
            cue_t = str2double(trial_sequence{run_i}{tr_i}{5});
            data.dat{run_i}{tr_i}.cue_timestamp = GetSecs;
            
            if cue_t > 0 % if cue_t == 0, this is not running.
                if ~isempty(trial_sequence{run_i}{tr_i}{8})
                    stimtext = trial_sequence{run_i}{tr_i}{8};
                else
                    stimtext = '+';
                end
                
                Screen(theWindow,'FillRect',bgcolor, window_rect);
                if iscell(stimtext) && strcmp(stimtext{1}, 'draw_social_cue')
                    social_m = stimtext{2}(1);
                    social_sd = stimtext{2}(2);
                    social_n = stimtext{2}(3);
                    [data.dat{run_i}{tr_i}.cue_x, data.dat{run_i}{tr_i}.cue_theta] = draw_social_cue(social_m, social_sd, social_n, rating_types.dooverall{run_i}{tr_i}{1}); % use the first rating_type in "dooverall"
                else
                    DrawFormattedText(theWindow, double(stimtext), 'center', 'center', white, [], [], [], 1.2);
                end
                Screen('Flip', theWindow);
                WaitSecs(3);
                
                % (cue_t - 3) seconds with blank
                data.dat{run_i}{tr_i}.cue_end_timestamp = GetSecs;
                Screen(theWindow,'FillRect',bgcolor, window_rect);
                Screen('Flip', theWindow);
                WaitSecs(cue_t-3);
            end
            
            % SETUP: Trial stimulus
            [type, int, dur, data] = parse_trial(data, trial_sequence, run_i, tr_i);
            
            % START: Trial
            % HERE: picture or other texts can be added
            try
                stimtext = trial_sequence{run_i}{tr_i}{9};
            catch
                % stimtext = ' '; 
                stimtext = '+';
            end
            
            Screen(theWindow,'FillRect', bgcolor, window_rect); 
            DrawFormattedText(theWindow, double(stimtext), 'center', 'center', white, [], [], [], 1.2);
            Screen('Flip', theWindow);
            
            % For continuous rating, show rating instruction before stimulus starts
            if ~isempty(rating_types.docont{run_i}{tr_i})
                cont_types = rating_types.docont{run_i}{tr_i}{1};
                eval(['data.dat{run_i}{tr_i}.' cont_types '_timestamp = GetSecs;']);
                
                Screen(theWindow,'FillRect', bgcolor, window_rect); 
                show_cont_prompt(cont_types, rating_types);
                Screen('Flip', theWindow);
            end
            
            % RECORD: Time stamp
            SetMouse(0,0);
            data.dat{run_i}{tr_i}.stim_timestamp = GetSecs;
            
            % HERE: STIMULATION ------------------------------------------
            if strcmp(type, 'TP') % Thermal pain
                thermodePrime(ip, port, program)
                %eval(['fwrite(t, ''1,' PP_int{strcmp(lvs, int)} ',t'');']);
            elseif strcmp(type, 'AU') % aversive auditory
                play(players{strcmp(lvs, int)});
            % elseif strcmp(type, 'TP') % see mpa2 code
            % elseif strcmp(type, 'VI')
            end
            
            start_t = GetSecs; 

            % read message from PPD
%             if strcmp(type, 'PP')
%                 message_1 = deblank(fscanf(r));
%                 if strcmp(message_1,'Read Error')
%                     error(message_1);
%                 else
%                     data.dat{run_i}{tr_i}.logfile = message_1;
%                 end
%             end
            
            rec_i = 0;
            
            % CONTINUOUS RATING
            if ~isempty(rating_types.docont{run_i}{tr_i})
                
                if use_mouse
                    SetMouse(lb,H/2); % set mouse at the left;
                elseif use_joystick
                    joy_pos = mat_joy(0);
                    start_joy_pos = joy_pos(1);
                end
                
                % START: Instruction and rating scale
                deltat = 0;
                while deltat <= (str2double(dur)+post_stimulus_t) % collect data for the duration+post_stimulus_t
                    deltat = GetSecs - start_t; 
                    rec_i = rec_i+1; % the number of recordings
                    
                    if use_mouse
                        x = GetMouse(theWindow);
                    elseif use_joystick
                        joy_pos  = mat_joy(0);
                        x = (joy_pos(1)-start_joy_pos) ./ joy_speed .* (rb-lb) + lb; % only right direction
                        % x = (joy_pos(1)-start_joy_pos) ./ joy_speed .* (rb-lb) + (rb+lb)/2; % both direction
                    end
                    
                    if x < lb, x = lb;
                    elseif x > rb, x = rb;
                    end
                    
                    cur_t = GetSecs;
                    data.dat{run_i}{tr_i}.time_from_start(rec_i,1) = cur_t-start_t;
                    data.dat{run_i}{tr_i}.cont_rating(rec_i,1) = (x-lb)./(rb-lb);
                    
                    show_cont_prompt(cont_types, rating_types);
                    Screen('DrawLine', theWindow, white, x, H/2, x, H/2+scale_H, 6);
                    Screen('Flip', theWindow);
                end
            else
                WaitSecs(str2double(dur));
                if strcmp(type, 'PP')
                    eval(['fwrite(t, ''1,' PP_int{strcmp(lvs, int)} ',s'');']);
                end
            end

            % make sure if the pressure stimulus ends
%             if strcmp(type, 'PP')
%                 message_2 = deblank(fscanf(r));
%                 if ~strcmp(message_2, 's')
%                     disp(message_2);
%                     error('message_2 is not s.');
%                 end 
%             end
            
            end_t = GetSecs;
            data.dat{run_i}{tr_i}.total_dur_recorded = end_t - start_t;
            
            % POST-STIM JITTER
            Screen('FillRect', theWindow, bgcolor, window_rect); % clear the screen
            Screen('Flip', theWindow);
            post_stim_jitter = str2double(trial_sequence{run_i}{tr_i}{6});
            data.dat{run_i}{tr_i}.post_stim_jitter = post_stim_jitter;
            WaitSecs(post_stim_jitter);
            
            % OVERALL RATINGS
            data.dat{run_i}{tr_i}.overall_rating_timestamp = GetSecs;
            
            if ~isempty(rating_types.dooverall{run_i}{tr_i})
                for overall_i = 1:numel(rating_types.dooverall{run_i}{tr_i})
                    overall_types = rating_types.dooverall{run_i}{tr_i}{overall_i};
                    eval(['data.dat{run_i}{tr_i}.' overall_types '_timestamp = GetSecs;']);
                    data = get_overallratings(overall_types, data, rating_types, run_i, tr_i, rating_device);
                end
            end
            
            data.dat{run_i}{tr_i}.overall_RT = GetSecs - data.dat{run_i}{tr_i}.overall_rating_timestamp;
            
            % INTER-TRIAL INTERVAL
            Screen('FillRect', theWindow, bgcolor, window_rect); % basically, clear the screen
            Screen('Flip', theWindow);
            data.dat{run_i}{tr_i}.isi = str2double(trial_sequence{run_i}{tr_i}{7});
            data.dat{run_i}{tr_i}.iti = data.dat{run_i}{tr_i}.isi - data.dat{run_i}{tr_i}.overall_RT;
            if data.dat{run_i}{tr_i}.iti <= 0
                data.dat{run_i}{tr_i}.iti = .01;
            end
            WaitSecs(data.dat{run_i}{tr_i}.iti); % ???if the next is continuous rating, it should remove one second
            
            if mod(tr_i,2) == 0, save(data.datafile, '-append', 'data'); end % save data every two trials
            
            SetMouse(0,0);
        end % trial ends
        
        % save data between runs
        save(data.datafile,'-append', 'data');
        
        % message between runs
        while (1) 
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('space'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_man;
            end
            
            display_runending_message(run_i, run_num);
        end
        
    end % run ends
    
    if exist('t', 'var') || exist('r', 'var')
        fclose(t);
        fclose(r);
    end
    
    Screen('CloseAll');
    disp('Done');
    save(data.datafile, '-append', 'data');
    
catch err
    % ERROR 
    disp(err);
    for i = 1:numel(err.stack)
        disp(err.stack(i));
    end
    fclose(t);
    fclose(r);
    abort_error; 
end

end

%% SUBFUNCTIONS ----------------------------------------------------------

function display_expmessage

% MESSAGE FOR CHECKING SETTING BEFORE STARTING EXPERIMENT

global theWindow white bgcolor window_rect; % rating scale

EXP_start_text = double('실험자는 모든 것이 잘 준비되었는지 체크해주세요 (Biopac, PPD, 등등). \n모두 준비되었으면 SPACE BAR를 눌러주세요.');

% display
Screen(theWindow,'FillRect',bgcolor, window_rect);
DrawFormattedText(theWindow, EXP_start_text, 'center', 'center', white, [], [], [], 1.5);
Screen('Flip', theWindow);

end


function display_runmessage(run_i, run_num, dofmri)

% MESSAGE FOR EACH RUN

% HERE: YOU CAN ADD MESSAGES FOR EACH RUN USING RUN_NUM and RUN_I

global theWindow white bgcolor window_rect; % rating scale

if dofmri
    if run_i <= run_num % you can customize the run start message using run_num and run_i
        Run_start_text = double('피험자가 준비되었으면 이미징을 시작합니다 (s).');
    end
else
    if run_i <= run_num
        Run_start_text = double('피험자가 준비되었으면, r을 눌러주세요.');
    end
end

% display
Screen(theWindow,'FillRect',bgcolor, window_rect);
DrawFormattedText(theWindow, Run_start_text, 'center', 'center', white, [], [], [], 1.5);
Screen('Flip', theWindow);

end

function display_runending_message(run_i, run_num)

global theWindow window_rect white bgcolor; % color

% MESSAGE FOR EACH RUN

% HERE: YOU CAN ADD MESSAGES FOR EACH RUN

if run_i < run_num
    Run_end_text = double([num2str(run_i) '번 세션을 마쳤습니다.\n 피험자가 다음 세션을 진행할 준비가 되면 SPACE BAR를 눌러주세요']);
else
    Run_end_text = double('실험의 이번 파트를 마쳤습니다.\n프로그램에서 나가기 위해서는, SPACE BAR를 눌러주세요.');
end
    
Screen(theWindow,'FillRect',bgcolor, window_rect);
DrawFormattedText(theWindow, Run_end_text, 'center', 'center', white, [], [], [], 1.5);
Screen('Flip', theWindow);

end



function [type, int, dur, data] = parse_trial(data, trial_sequence, run_i, tr_i)

% parse each trial

type = trial_sequence{run_i}{tr_i}{1}; % 'PP', 'TP', 'AU', 'VI'
int = trial_sequence{run_i}{tr_i}{2};  % 'LV1', 'LV2'...
dur = trial_sequence{run_i}{tr_i}{3};  % '0010'...

% RECORD: Trial Info
data.dat{run_i}{tr_i}.type = type;
data.dat{run_i}{tr_i}.intensity = int;
data.dat{run_i}{tr_i}.duration = str2double(dur);
data.dat{run_i}{tr_i}.scale = trial_sequence{run_i}{tr_i}{4};

end



function show_cont_prompt(cont_types, rating_types)

global theWindow orange;

i = strcmp(rating_types.alltypes, cont_types); % which one?
DrawFormattedText(theWindow, double(rating_types.prompts{i}), 'center', 'center', orange, [], [], [], 1.5);
draw_scale(cont_types);

end

