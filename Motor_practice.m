function Motor_practice(SID, runNbr,varargin)

%%INOFMRATION
%
% This script is for motor task that control motor compound effect of
% neural signal. Therefore, this script includes only two steps.
%
% 1) a randomizaed inter-trial interval with white cross-hair point.
% 2) a target bullet point with semi-circular rating.
%
% The goal of this task is simple. After fixation point disappear,
% participants should move to target bullet point with a joystick.
%
% written by Suhwan Gim (19, December 2017)

%%
Screen('Clear');
Screen('CloseAll');
%% Parse varargin
testmode = false;
dofmri = false;
USE_BIOPAC = false;
joystick = false;
USE_EYELINK = false;
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
                USE_EYELINK = true;
            case {'joystick'}
                joystick = true;
                % do nothing
        end
    end
end

%% SETUP: Global variable
global theWindow W H; % window property
global white red orange bgcolor yellow; % color
global window_rect prompt_ex lb rb tb bb scale_H promptW promptH; % rating scale
global lb1 rb1 lb2 rb2;% For larger semi-circular
global fontsize anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd; % anchors
%%
addpath(genpath(pwd));
%% SETUP: DATA and Subject INFO
savedir = 'MOTOR_SEMIC_data';
[fname,~ , SID] = subjectinfo_check_SEMIC(SID, savedir,runNbr,'Mot'); % subfunction %start_trial
% save data using the canlab_dataset object
mot.version = 'SEMIC_Motor_task_v1_18-04-2018_Cocoanlab';
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

% For cont rating scale
lb1 = 1*W/18; %
rb1 = 17*W/18; %

% For overall rating scale
lb2 = 5*W/18; %
rb2 = 13*W/18; %s

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

% cir_center = [(rb+lb)/2, bb];
% radius = (rb-lb)/2; % radius
cir_center = [(lb2+rb2)/2, H*3/4+100];
radius = (rb2-lb2)/2; %%radius = (rb-lb)/2; % radius

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
ISI = repmat([3;5;7],7,1);
rn=randperm(21);
ISI = ISI(rn);
velocity = cal_vel_joy('overall');
%% SETUP: PTB WINDOW
theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
% Screen('TextFont', theWindow, font); % setting font
Screen('TextSize', theWindow, fontsize);

%% SETUP: Eyelink
% need to be revised when the eyelink is here.
if USE_EYELINK
    new_SID = erase(SID,'SEM'); % For limitation of file name 
    edf_filename = ['O_' new_SID '_' num2str(runNbr)]; % name should be equal or less than 8
    edfFile = sprintf('%s.EDF', edf_filename);
    eyelink_main(edfFile, 'Init');
    
    status = Eyelink('Initialize');
    if status
        error('Eyelink is not communicating with PC. Its okay baby.');
    end
    Eyelink('Command', 'set_idle_mode');
    waitsec_fromstarttime(GetSecs, .5);
end

%% TASK
try
    % 0. Instruction
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('space'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_man;
        end
        display_expmessage('지금부터 단순동작과제를 시작 하겠습니다.\n 선에 있는 점을 향해 조이스틱을 조작해주시면 됩니다.(SPACE BAR)'); % until space; see subfunctions
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
        mot.dat{runNbr}{1}.runscan_starttime = GetSecs;
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        DrawFormattedText(theWindow, double('시작합니다...'), 'center', 'center', white, [], [], [], 1.2);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(mot.dat{runNbr}{1}.runscan_starttime,4);
        
        % 4 seconds: Blank
        fmri_t2 = GetSecs;
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(fmri_t2, 4); % ADJUST THIS
    end
    
    if USE_BIOPAC
        bio_t = GetSecs;
        mot.dat{runNbr}{1}.biopac_triggertime = bio_t; %BIOPAC timestamp
        BIOPAC_trigger(ljHandle, biopac_channel, 'on');
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(bio_t, 2); % ADJUST THIS
    end
    
    %?
    if USE_BIOPAC
        BIOPAC_trigger(ljHandle, biopac_channel, 'off');
    end
    
    % EYELINK
    if USE_EYELINK
        Eyelink('StartRecording');
        mot.dat{runNbr}{1}.eyetracker_starttime = GetSecs; % eyelink timestamp
        Eyelink('Message','Run start');
    end
    
    mot.task_start_timestamp{runNbr}=GetSecs; % trial_star_timestamp
    % -------------------------TRIAL START---------------------------------
    for i=1:numel(xx)
        TrSt_t = GetSecs;
        mot.dat{runNbr}{i}.ts_timestamp=TrSt_t; % trial_start_timestamp
        % 1. Fixation point
        fixPoint(TrSt_t, ISI(i), white, stimText);
        mot.dat{runNbr}{i}.fix_end_timestamp = GetSecs; % 2 timestamp
        % 2. Moving dot part
        %ready = 0;
        rec_i = 0;
        %SetMouse(cir_center(1), cir_center(2)); % set mouse at the center
        cir_center = [(lb2+rb2)/2, H*3/4+100];
        SetMouse(cir_center(1), cir_center(2)); % set mouse at the center
        x=cir_center(1); y=cir_center(2);
        %
        start_while = GetSecs;
        mot.dat{runNbr}{i}.while_start_timestamp = start_while;
        while GetSecs - TrSt_t < 6 + ISI(i)            
            if joystick
                [pos, button] = mat_joy(0);
                xAlpha=pos(1);
                x=x+xAlpha*velocity;
                yAlpha=pos(2);
                y=y+yAlpha*velocity;
            else
                [x,y,button]=GetMouse(theWindow);
            end
            %[x,y,button] = GetMouse(theWindow);
            rec_i= rec_i+1;
            
            draw_scale('overall_predict_semicircular')
            Screen('DrawDots', theWindow, [xx(i) yy(i)]', 20, white, [0 0], 1);  % draw random dot in SemiC
            Screen('DrawDots', theWindow, [x y]', 14, [255 164 0 130], [0 0], 1);  % Cursor
            % if the point goes further than the semi-circle, move the point to
            % the closest point
            radius = (rb2-lb2)/2; %%radius = (rb-lb)/2; % radius
            theta = atan2(cir_center(2)-y,x-cir_center(1));
            % current euclidean distance
            curr_r = sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2);
            % current angle (0 - 180 deg)
            curr_theta = rad2deg(-theta+pi);
            if y > cir_center(2)
                y = cir_center(2);
                SetMouse(x,y);
            end

            if sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2) > radius
                x = radius*cos(theta)+cir_center(1);
                y = cir_center(2)-radius*sin(theta);
                SetMouse(x,y);
            end
            draw_scale('overall_predict_semicircular')
            Screen('DrawDots', theWindow, [xx(i) yy(i)]', 20, orange, [0 0], 1);  % draw random dot in SemiC
            Screen('DrawDots', theWindow, [x y]', 14, [255 164 0 130], [0 0], 1);  % Cursor
            Screen('Flip',theWindow);
            
            
            mot.dat{runNbr}{i}.time_fromstart(rec_i,1) = GetSecs - start_while;
            mot.dat{runNbr}{i}.xy(rec_i,:) = [x-cir_center(1) cir_center(2)-y]./radius;
            mot.dat{runNbr}{i}.clicks(rec_i,:) = button;
            mot.dat{runNbr}{i}.r_theta(rec_i,:) = [curr_r/radius curr_theta/180]; %radius and degree?
            
            if button(1)
                mot.dat{runNbr}{i}.button_click_timestamp=GetSecs; %
                mot.dat{runNbr}{i}.button_click_bool=1; % 1 = Click, 0 = not click
                draw_scale('overall_predict_semicircular')
                Screen('DrawDots', theWindow, [xx(i) yy(i)]', 20, white, [0 0], 1);  % draw random dot in SemiC
                Screen('DrawDots', theWindow, [x y]', 18, red, [0 0], 1);  % Feedback
                Screen('Flip',theWindow);
                WaitSecs(.1);
                break;
            else
                mot.dat{runNbr}{i}.button_click_bool=0;
                mot.dat{runNbr}{i}.move_end_timestamp = GetSecs;
            end
        end
        
        while GetSecs - TrSt_t < 6 + ISI(i)
            if button(1)
                Screen('Flip',theWindow);
            end
        end
        mot.dat{runNbr}{i}.trial_end_timestamp=GetSecs; % trial_star_timestamp
        mot.dat{runNbr}{i}.ISI = ISI(i);
        mot.dat{runNbr}{i}.target_dot_location = [xx(i) yy(i)]';
        if mod(i,2) == 0, save(mot.datafile, '-append', 'mot'); end % save data every two trials
    end
    mot.task_end_timestamp{runNbr}=GetSecs;
    
    if USE_EYELINK
        Eyelink('Message','Run ends');
        eyelink_main(edfFile, 'Shutdown');
    end
    
    
    if USE_BIOPAC %end BIOPAC
        bio_t = GetSecs;
        mot.dat{runNbr}{i}.biopac_endtime = bio_t;% biopac end timestamp
        BIOPAC_trigger(ljHandle, biopac_channel, 'on');
        waitsec_fromstarttime(bio_t, 0.1);
        BIOPAC_trigger(ljHandle, biopac_channel, 'off');
    end
    
    save(mot.datafile, '-append', 'mot');
    
    %closing message utill stoke specific keyboard
    Screen('Flip',theWindow);
    WaitSecs(10);
    
    display_expmessage('단순동작과제가 끝났습니다. 연구자의 안내를 기다려 주세요.');
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('q'))==1
            break
        elseif keyCode(KbName('space'))== 1
            break
        end
    end
    
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

function fixPoint(t_time, seconds, color, stimText)
global theWindow;
% stimText = '+';
% Screen(theWindow,'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double(stimText), 'center', 'center', color, [], [], [], 1.2);
Screen('Flip', theWindow);
waitsec_fromstarttime(t_time, seconds);
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
