function Motor_practice(varargin)

%%INOFMRATION
%
% This script is for motor task that control motor compound effect of
% neural signal. Therefore, this script includes only two steps.
%
% 1) a randomizaed inter-trial interval with white cross-hair point.
% 2) a target bullet point with semi-circular rating.
%
% The goal of this task is simple.
% After fixation point disappear, participants move to target bullet point
% with a joystick.
%
% written by Suhwan Gim (19, December 2017)

%%
Screen('Clear');
Screen('CloseAll');
%% Parse varargin
testmode = false;
dofmri = false;
USE_BIOPAC = false;
for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            case {'test'}
                testmode = true;
            case {'fmri'}
                dofmri = true;
            case {'biopac1'}
                USE_BIOPAC = true;
                channel_n = 3;
                biopac_channel = 0;
                ljHandle = BIOPAC_setup(channel_n); % BIOPAC SETUP
            case {'eyelink'}
                %
            case {'mouse', 'trackball'}
                % do nothing
        end
    end
end

%% SETUP: Global variable
global theWindow W H; % window property
global white red orange bgcolor yellow; % color
global window_rect prompt_ex lb rb tb bb scale_H promptW promptH; % rating scale
global fontsize anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd; % anchors
%%
addpath(genpath(pwd));
%% SETUP: DATA and Subject INFO
savedir = 'MOTOR_SEMIC_data';
[fname,~ , SID] = subjectinfo_check_SEMIC(savedir,1,'Mot'); % subfunction %start_trial
% save data using the canlab_dataset object
mot.version = 'SEMIC_Motor_task_v1_22-01-2018_Cocoanlab';
mot.subject = SID;
mot.datafile = fname;
mot.starttime = datestr(clock, 0); % date-time
mot.starttime_getsecs = GetSecs; % in the same format of timestamps for each trial

%%save?
save(mot.datafile,'mot');
%% SETUP
window_num = 0;
if testmode
    window_rect = [1 1 1200 720]; % in the test mode, use a little smaller screen
    %window_rect = [0 0 1900 1200];
    fontsize = 20;
else
    screens = Screen('Screens');
    window_num = screens(end); % the last window
    window_info = Screen('Resolution', window_num);
    Screen('Preference', 'SkipSyncTests', 1);
    window_rect = [0 0 window_info.width window_info.height]; % full screen
    fontsize = 32;
    HideCursor();
end
W = window_rect(3); %width of screen
H = window_rect(4); %height of screen

font = 'NanumBarunGothic';

bgcolor = 80;
white = 255;
red = [255 0 0];
orange = [255 164 0];
yellow = [255 220 0];

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

%% SETUP: SCREEN

cir_center = [(rb+lb)/2, bb];
radius = (rb-lb)/2; % radius

deg = 180/7.*randi(6,21,1) + randn(21,1)*10; %divided by seven and add jitter number
rn = randperm(21);
deg = deg(rn);
deg(deg > 180) = 180;
deg(deg < 0) = 0;
th = deg2rad(deg);
xx = radius*cos(th)+cir_center(1);
yy = cir_center(2)-radius*sin(th);

%% SETUP: DATA and Subject INFO
%% SETUP: parameter and ISI
rating_type = 'semicircular';
stimText = '+';
ISI = repmat([3;7;10],7,1);
rn=randperm(21);
ISI = ISI(rn);
%% SETUP: PTB WINDOW
theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
Screen('TextFont', theWindow, font); % setting font
Screen('TextSize', theWindow, fontsize);
%% TASK
try
    mot.task_start_timestamp=GetSecs; % trial_star_timestamp
    % 0. Instruction
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('space'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_man;
        end
        display_expmessage('지금부터 조이스틱 연습을 하겠습니다.\n 준비되었으면 SPACE BAR를 눌러주세요.'); % until space; see subfunctions
    end
    
    while (1)
        [~,~,keyCode] = KbCheck;
        % if this is for fMRI experiment, it will start with "s",
        % but if behavioral, it will start with "r" key.
        if dofmri
            if keyCode(KbName('s'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment;
            end
        else
            if keyCode(KbName('r'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment;
            end
        end
        display_runmessage(1, 1, dofmri); % until 5 or r; see subfunctions
    end
    
    if dofmri
        % gap between 5 key push and the first stimuli (disdaqs: data.disdaq_sec)
        % 4 seconds: "占쏙옙占쏙옙占쌌니댐옙..."
        mot.dat{1}{1}.runscan_starttime = GetSecs;
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        DrawFormattedText(theWindow, double('시작합니다...'), 'center', 'center', white, [], [], [], 1.2);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(mot.dat{1}{1}.runscan_starttime,4);
        
        % 4 seconds: Blank
        fmri_t2 = GetSecs;
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(fmri_t2, 4); % ADJUST THIS
    end
    
    if USE_BIOPAC
        bio_t = GetSecs;
        mot.dat.biopac_triggertime = bio_t; %BIOPAC timestamp
        BIOPAC_trigger(ljHandle, biopac_channel, 'on');
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(bio_t, 2); % ADJUST THIS
    end
    
    %?
    if USE_BIOPAC
        BIOPAC_trigger(ljHandle, biopac_channel, 'off');
    end
    
    
    % -------------------------TRIAL START---------------------------------
    for i=1:numel(xx)
        mot.dat{1}{i}.ts_timestamp=GetSecs; % trial_start_timestamp
        % 1. Fixation point
        fixPoint(ISI(i), white, stimText);
        % 2. Moving dot part
        ready = 0;
        rec_i = 0;
        
        mot.dat{1}{i}.move_start_timestamp = GetSecs; % 2 timestamp
        SetMouse(cir_center(1), cir_center(2)); % set mouse at the center
        while GetSecs - mot.dat{1}{i}.move_start_timestamp < 5
            while ~ready
                [x,y,button] = GetMouse(theWindow);
                rec_i= rec_i+1;
                
                draw_scale('overall_motor_semicircular');
                Screen('DrawDots', theWindow, [xx(i) yy(i)]', 20, white, [0 0], 1);  % draw random dot in SemiC
                Screen('DrawDots', theWindow, [x y]', 14, [255 164 0 130], [0 0], 1);  % Cursor
                % if the point goes further than the semi-circle, move the point to
                % the closest point
                radius = (rb-lb)/2; % radius
                theta = atan2(cir_center(2)-y,x-cir_center(1));
                % current euclidean distance
                curr_r = sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2);
                % current angle (0 - 180 deg)
                curr_theta = rad2deg(-theta+pi);
                if y > bb
                    y = bb;
                    SetMouse(x,y);
                end
                % send to arc of semi-circle
                if sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2) > radius
                    x = radius*cos(theta)+cir_center(1);
                    y = cir_center(2)-radius*sin(theta);
                    SetMouse(x,y);
                end
                Screen('Flip',theWindow);
                
                
                mot.dat{1}{i}.time_fromstart(rec_i,1) = GetSecs - mot.dat{1}{i}.move_start_timestamp;
                mot.dat{1}{i}.xy(rec_i,:) = [x-cir_center(1) cir_center(2)-y]./radius;
                mot.dat{1}{i}.clicks(rec_i,:) = button;
                mot.dat{1}{i}.r_theta(rec_i,:) = [curr_r/radius curr_theta/180]; %radius and degree?
                
                if button(1)
                    mot.dat{1}{i}.button_click_timestamp=GetSecs; %
                    mot.dat{1}{i}.button_click_bool=1; % 1 = Click, 0 = not click
                    draw_scale('overall_motor_semicircular');
                    Screen('DrawDots', theWindow, [xx(i) yy(i)]', 20, white, [0 0], 1);  % draw random dot in SemiC
                    Screen('DrawDots', theWindow, [x y]', 18, red, [0 0], 1);  % Feedback
                    Screen('Flip',theWindow);
                    WaitSecs(.1);
                    ready = 1;
                    break;
                elseif GetSecs - mot.dat{1}{i}.move_start_timestamp  > 5
                    mot.dat{1}{i}.move_end_timestamp = GetSecs;
                    mot.dat{1}{i}.button_click_bool=0; 
                    ready = 1;
                    break;
                else
                    %do nothing
                end
            end
            fixPoint(0, white, '');
            Screen('Flip', theWindow);
        end
        mot.dat{1}{i}.trial_end_timestamp=GetSecs; % trial_star_timestamp
        if mod(i,2) == 0, save(mot.datafile, '-append', 'mot'); end % save data every two trials
    end
    mot.task_end_timestamp=GetSecs;
    save(mot.datafile, '-append', 'mot');
    % closing messages
    display_expmessage('지금까지 조이스틱 연습을 하였습니다. 연구자의 안내를 기다려 주세요.');
    WaitSecs(5);
    
    % Close the screen 
    sca;
    ShowCursor();
    Screen('CloseAll');
    
catch err
    % ERROR
    disp(err);
    for i = 1:numel(err.stack)
        disp(err.stack(i));
    end
    abort_experiment;
end
end

function fixPoint(seconds, color, stimText)
global theWindow white red;
% stimText = '+';
% Screen(theWindow,'FillRect', bgcolor, window_rect);
start_fix = GetSecs; % Start_time_of_Fixation_Stimulus
DrawFormattedText(theWindow, double(stimText), 'center', 'center', color, [], [], [], 1.2);
Screen('Flip', theWindow);
waitsec_fromstarttime(start_fix, seconds);
end

function display_runmessage(run_i, run_num, dofmri)

% MESSAGE FOR EACH RUN

% HERE: YOU CAN ADD MESSAGES FOR EACH RUN USING RUN_NUM and RUN_I

global theWindow white bgcolor window_rect; % rating scale

if dofmri
    if run_i <= run_num % you can customize the run start message using run_num and run_i
        Run_start_text = double('참가자가 준비되었으면 이미징을 시작합니다 (s).');
    end
else
    if run_i <= run_num
        Run_start_text = double('참가자가 준비되었으면, r을 눌러주세요.');
    end
end

% display
Screen(theWindow,'FillRect',bgcolor, window_rect);
DrawFormattedText(theWindow, Run_start_text, 'center', 'center', white, [], [], [], 1.5);
Screen('Flip', theWindow);

end

function abort_experiment(varargin)

% ABORT the experiment
%
% abort_experiment(varargin)

str = 'Experiment aborted.';

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'error'}
                str = 'Experiment aborted by error.';
            case {'manual'}
                str = 'Experiment aborted by the experimenter.';
        end
    end
end


ShowCursor; %unhide mouse
Screen('CloseAll'); %relinquish screen control
disp(str); %present this text in command window

end
