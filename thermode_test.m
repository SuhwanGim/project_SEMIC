function data = thermode_test(runNbr, ip, port, varargin)
%% INFORMATION
%
% 2017-10-19

%% EXAMPEL of PROGRAM code
% dec2bin(100) -> ans = 1100100
% (MATLAB Value, PATHWAY Value) = (100,1100100)
%
% In this experiment,
% ---------------------------------------------------------
% Matlab: Program name : Program code (parameter, 8bit)
% ------------------------------------------------
%   50  : Pulse 49     :   00110010
%  100  : Ramp-up 2sec':   01100100
%  101  : Ramp-up 4sec':   01100101
%  102  : Ramp-up 6sec':   01100110
% ...
%% GLOBAL vaiable
global theWindow W H; % window property
global white red red_Alpha orange bgcolor yellow; % color
global window_rect prompt_ex lb rb tb bb scale_H promptW promptH; % rating scale
global fontsize anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd; % anchors

%% Parse varargin
doexplain_scale = false;
testmode = false;
USE_BIOPAC = false;


% need to be specified differently for different computers
% psytool = 'C:\toolbox\Psychtoolbox';
scriptdir = '/Users/cocoan/Dropbox/github/';
savedir = 'SEMIC_data';

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            case {'explain_scale'}
                doexplain_scale = true;
                exp_scale.inst = varargin{i+1};
            case {'test'}
                testmode = true;
            case {'scriptdir'}
                scriptdir = varargin{i+1};
            case {'psychtoolbox'}
                psytool = varargin{i+1};
            case {'biopac1'}
                USE_BIOPAC = true;
                channel_n = 3;
                biopac_channel = 0;
                ljHandle = BIOPAC_setup(channel_n); % BIOPAC SETUP
            case {'gazePoint'}
                % What I should type?
            case {'mouse', 'trackball'}
                % do nothing
        end
    end
end

% addpath(scriptdir); cd(scriptdir);
% addpath(genpath(psytool));
addpath('pathwaySupportCode');
addpath('pathwaySupportCode/Classess');
%% SETUP: DATA and Subject INFO
savedir = 'SEMIC_data';
[fname,start_trial, SID] = subjectinfo_check_SEMIC(savedir,runNbr); % subfunction %start_trial
%[fname, start_trial, SID] = subjectinfo_check(savedir); % subfunction
if exist(fname, 'file'), load(fname, 'data'); load(fname,'ts'); end 
% save data using the canlab_dataset object
data.version = 'SEMIC_v1_10-27-2017_Cocoanlab';
data.subject = SID;
data.datafile = fname;
data.starttime = datestr(clock, 0); % date-time
data.starttime_getsecs = GetSecs; % in the same format of timestamps for each trial

%% SETUP: Trial sequence handle
% =========================================================================
%   1. Run number - Trial number - Pain type - ITI - Delay - Cue mean - Cue variance - Ramp-up
%   2. ITI and Delay ) 3 to 7 seconds (5 combination: 3-7, 4-6, 5-5, 6-4, 7-3)
%   3. Cue mean (5 levels: 0-1). e.g., 0.1, 0.3, 0.5, 0.7 0.9
%       : included jitter number (such as + and - 0.01~0.05)
%   4. Cue variance (3 levels: 0-1) e.g., 0.1, 0.25, 0.4
%       : How to determine this score?
%   5. Program: Ramp-up (3 levels: 100, 101, 102; Strafied randomization)
%-------------------------------------------------------------------------
% For TEST,
% runNbr=1;
if start_trial==1  
    rng('shuffle');
    % Number of trial
    trial_Number=(1:45)'; % and transpose
    % Run number
    run_Number = repmat(runNbr,length(trial_Number),1);
    % Cue_mean Randoimzation (Five levels: 0.1, 0.3, 0.5, 0.7 0.9)
    c_mean_bs = repmat({0.1; 0.3; 0.5; 0.7; 0.9},9,1); % 5 levels x 9 repetition = 45 trials
    rn=randperm(45);
    c_mean = cell2mat(c_mean_bs(rn));
    % Cue_variance Randoimzation (Three levels: 0.01, 0.05, 0.1)
    c_var_bs = repmat({0.01; 0.05; 0.1},15,1);
    rn=randperm(45);
    c_var=cell2mat(c_var_bs(rn));
    % RAMP-UP program Randoimzation
    for i = 1:15 % 3(2,4,6sec) x 15 other combination
        program(i*3-2:i*3,1) = randperm(3) + 99; % [1 2 3] [2 3 1] ......
    end
    % Create ramp-up seconds
    for ii = 1:length(program)
        if program(ii) == 100
            ramp_up_con(ii) = 2;
        elseif program(ii) == 101
            ramp_up_con(ii) = 4;
        else
            ramp_up_con(ii) = 6;
        end
    end
    % ITI-Delay acombination
    ITI_Delay = repmat({3, 7; 4, 6; 5, 5; 6, 4; 7,3}, 9, 1); % Five combitnations
    rn=randperm(45);
    ITI_Delay = ITI_Delay(rn,:);
    ITI = cell2mat(ITI_Delay(:,1));
    Delay = cell2mat(ITI_Delay(:,2));
    %ts = [trial_Number, run_Number, ITI, Delay, c_mean, c_var, program, ramp_up_con];
    ts{runNbr} = [trial_Number, run_Number, ITI, Delay, c_mean, c_var, program];
    % save the trial_sequences
    save(data.datafile, 'ts', 'data');
else
    [trial_Number, run_Number, ITI, Delay, c_mean, c_var, program] = ts{runNbr};
end
%% SETUP: Experiment settings
rating_type = 'semicircular';
NumberOfCue = 25;
%% SETUP: Screen
Screen('Clear');
Screen('CloseAll');
window_num = 0;
if testmode
    window_rect = [1 1 1280 720]; % in the test mode, use a little smaller screen
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

bgcolor = 80;
white = 255;
red = [255 0 0];
red_Alpha = [255 164 0 130]; % RGB + A(Level of tranceprency: for social Cue)
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

%% EXPERIEMENT START

% START
try
    theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
    Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
    Screen('TextFont', theWindow, font); % setting font
    Screen('TextSize', theWindow, fontsize);
    % settings of ts
    if start_trial ~= 1
        k=start_trial; 
    else 
        k=1;
    end
    % START: RUN
    % Loop of Trials
    for j = k:length(trial_Number)       
        % DISPLAY EXPERIMENT MESSAGE:
        if trial_Number(j) == 1 && run_Number(j) == 1
            while (1)
                [~,~,keyCode] = KbCheck;
                if keyCode(KbName('space'))==1
                    break
                elseif keyCode(KbName('q'))==1
                    abort_man;
                end
                display_expmessage('실험자는 모든 것이 잘 준비되었는지 체크해주세요 (PATHWAY, BIOPAC, GAZEPOINT, 등등). \n모두 준비되었으면 SPACE BAR를 눌러주세요.'); % until space; see subfunctions
            end
        end
        % 1 seconds: BIOPAC
        
        if trial_Number(j) == 1
            if USE_BIOPAC
                bio_t = GetSecs;
                data.dat{runNbr}{trial_Number(j)}.biopac_triggertime = bio_t; %BIOPAC timestamp
                BIOPAC_trigger(ljHandle, biopac_channel, 'on');
                Screen(theWindow,'FillRect',bgcolor, window_rect);
                Screen('Flip', theWindow);
                waitsec_fromstarttime(bio_t, 2); % ADJUST THIS
            end

            %?
            if USE_BIOPAC
                BIOPAC_trigger(ljHandle, biopac_channel, 'off');
            end
        end
        data.dat{runNbr}{trial_Number(j)}.trial_start_t = GetSecs; %Trial start
        
        % ITI (jitter)
        fixPoint(ITI(j), white, '-') %
        % Cue
        cue_t = GetSecs;
        data.dat{runNbr}{trial_Number(j)}.cue_timestamp = cue_t; %Cue time stamp
        draw_scale('overall_avoidance_semicircular');
        [data.dat{runNbr}{trial_Number(j)}.cue_x, data.dat{runNbr}{trial_Number(j)}.cue_theta] = draw_social_cue(c_mean(j), c_var(j), NumberOfCue, rating_type); % draw & save details: draw_socia_cue(m, std, n, rating_type)
        Screen('Flip', theWindow);
        waitsec_fromstarttime(cue_t, 2);
        data.dat{runNbr}{trial_Number(j)}.cue_end_timestamp = GetSecs;
        % Delay
        fixPoint(Delay(j), white, '+')
        % HEAT and Ratings
        % thermodePrime(ip, port, program(j))
        cir_center = [(rb+lb)/2, bb];
        SetMouse(cir_center(1), cir_center(2)); % set mouse at the center
        % lb2 = W/3; rb2 = (W*2)/3; % new bound for or not
        rec_i = 0;
        
        data.dat{runNbr}{trial_Number(j)}.heat_start_txt = main(ip,port,1,program(j)); % Triggering heat signal
        data.dat{runNbr}{trial_Number(j)}.heat_start_timestamp = GetSecs; % heat-stimulus time stamp
        % if checkStatus(ip,port)
        ready = 0;
        ready2 =0;
        while ~ready2
            start_while=GetSecs;
            while ~ready
                waitsec_fromstarttime(start_while, 1)
                resp = main(ip,port,0); %get system status
                systemState = resp{4}; testState = resp{5};
                if strcmp(systemState, 'Pathway State: TEST') && strcmp(testState,'Test State: RUNNING')
                    ready = 1;
                    sTime = GetSecs;
                    break;
                else
                    ready = 0;
                end
            end
            [x,y,button]=GetMouse(theWindow);
            rec_i= rec_i+1;
            % if the point goes further than the semi-circle, move the point to
            % the closest point
            radius = (rb-lb)/2; % radius
            theta = atan2(cir_center(2)-y,x-cir_center(1));
            % current euclidean distance
            curr_r = sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2);
            % current angle (0 - 180 deg)
            curr_theta = rad2deg(-theta+pi);
            % For control a mouse cursor:
            % send to diameter of semi-circle
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
            msg = '현재 고통의 정도를 최대한 가깝게 표현해주세요';
            msg = double(msg);
            DrawFormattedText(theWindow, msg, 'center', 250, white, [], [], [], 1.2);
            draw_scale('overall_avoidance_semicircular')
            Screen('DrawDots', theWindow, [x y], 10, orange, [0 0], 1);
            Screen('Flip', theWindow);
            
            % Saving data
            data.dat{runNbr}{trial_Number(j)}.time_fromstart(rec_i,1) = GetSecs-sTime;
            data.dat{runNbr}{trial_Number(j)}.xy(rec_i,:) = [x-cir_center(1) cir_center(2)-y]./radius;
            data.dat{runNbr}{trial_Number(j)}.clicks(rec_i,:) = button;
            data.dat{runNbr}{trial_Number(j)}.r_theta(rec_i,:) = [curr_r/radius curr_theta/180];
            
            if GetSecs - sTime > ramp_up_con(j) + 7 % 7 = plateau + ramp-down
                data.dat{runNbr}{trial_Number(j)}.heat_exit_txt = main(ip,port,5); % Triggering stop signal
                start_stopsignal=GetSecs;
                waitsec_fromstarttime(start_stopsignal, 1)
                resp = main(ip,port,0); %get system status
                systemState = resp{4}; testState = resp{5};
                if strcmp(systemState, 'Pathway State: READY') && strcmp(testState,'Test State: IDLE')
                    ready2 = 1;
                    data.dat{runNbr}{trial_Number(j)}.heat_exit_timestamp = GetSecs;
                    break;
                end
            end
            
        end
        %end
        SetMouse(0,0);
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('Flip', theWindow);
        end_trial = GetSecs;
        data.dat{runNbr}{trial_Number(j)}.end_trial_t = end_trial;
        data.dat{runNbr}{trial_Number(j)}.ramp_up_cnd = ramp_up_con(j);
        if mod(trial_Number(j),2) == 0, save(data.datafile, '-append', 'data'); end % save data every two trials
        if mod(trial_Number(j),5) == 0 % Because of IRB, When end of every fifth trial, have a rest within 15 seconds
            display_expmessage('Every 5th trial 대기 해야함\n뿌잉뿌잉뿌뿌이잉');
            waitsec_fromstarttime(end_trial, 15);
            end_trial = end_trial + 15;
        end
        waitsec_fromstarttime(end_trial, 1); % For your rest,
    end
    
    Screen('Clear');
    Screen('CloseAll');
    disp('Done');
    save(data.datafile, '-append', 'data');
    
catch err
    % ERROR
    disp(err);
    for i = 1:numel(err.stack)
        disp(err.stack(i));
    end
    abort_experiment;
end
end




% data, timestamp, save data (once per two trials) and trial information 중간중간에
% redundancy is good thing for data, physio, gazepoint, prompt
% practice trial if needed, cue: 20-30, try-catch, show error messages,
% abort_experiment function, indent, documentation
% trial_sequence (randomization)

%% ::::::::::::::::::::::: SUBFUNCTION ::::::::::::::::::::::::::::::::::
function fixPoint(seconds, color, stimText)
global theWindow white red;
% stimText = '+';
% Screen(theWindow,'FillRect', bgcolor, window_rect);
start_fix = GetSecs; % Start_time_of_Fixation_Stimulus
DrawFormattedText(theWindow, double(stimText), 'center', 'center', color, [], [], [], 1.2);
Screen('Flip', theWindow);
waitsec_fromstarttime(start_fix, seconds);
end


function waitsec_fromstarttime(starttime, duration)
% Using this function instead of WaitSecs()
% function waitsec_fromstarttime(starttime, duration)

while true
    if GetSecs - starttime >= duration
        break;
    end
end

end

function display_expmessage(msg)
% diplay_expmessage("ad;slkja;l불라불라 \nㅂㅣㅏ넝리ㅏㅓ");
% type each MESSAGE

global theWindow white bgcolor window_rect; % rating scale

EXP_start_text = double(msg);

% display
Screen(theWindow,'FillRect',bgcolor, window_rect);
DrawFormattedText(theWindow, EXP_start_text, 'center', 'center', white, [], [], [], 1.5);
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
