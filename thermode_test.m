function data = thermode_test(runNbr, ip, port, reg, varargin)
%%
% This function triggers heat-pain, report ratings using TCP/IP
%communication. runNbr is number of run. ip and port is obtained from
%"Pathway" device. And there are some optional inputs.
%
%If you want to use this function, you should have a connected computers
%using TCP/IP (for example, connect each other or connect same router).
%However, if didn't, this function will not working
% 
%
% written by Suhwan Gim (roseno.9@daum.net)
% 2017-12-06
% =================EXAMPEL of PROGRAM codes================================
% dec2bin(100) -> ans = 1100100
% (MATLAB Value, PATHWAY Value) = (100,1100100)
% In this experiment,
% ---------------------------------------------------------
% Matlab: Program name : Program code (parameter, 8bit)
% ------------------------------------------------
%   25  : Pulse 49     :   00011001
%   50  : SEMIC_41     :   00110010
%   51  : SEMIC_41.5   :   00110011
%    ~        ~                ~
%   64  : SEMIC_48     :   01000000

%% GLOBAL vaiable
global theWindow W H; % window property
global white red red_Alpha orange bgcolor yellow; % color
global window_rect prompt_ex lb rb tb bb scale_H promptW promptH; % rating scale
global fontsize anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd; % anchors

%% Parse varargin
testmode = false;
USE_BIOPAC = false;
dofmri = false;

% need to be specified differently for different computers
% psytool = 'C:\toolbox\Psychtoolbox';
scriptdir = '/Users/cocoan/Dropbox/github/';

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
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
            case {'eyelink'}
                %
            case {'mouse', 'trackball'}
                % do nothing
        end
    end
end
%%
% addpath(scriptdir); cd(scriptdir);
% addpath(genpath(psytool));
addpath(genpath(pwd));
%% SETUP: DATA and Subject INFO
savedir = 'SEMIC_data';
[fname,start_trial, SID] = subjectinfo_check_SEMIC(savedir,runNbr); % subfunction %start_trial
%[fname, start_trial, SID] = subjectinfo_check(savedir); % subfunction
if exist(fname, 'file'), load(fname, 'data'); load(fname,'ts'); end
% save data using the canlab_dataset object
data.version = 'SEMIC_v1_12-06-2017_Cocoanlab';
data.subject = SID;
data.datafile = fname;
data.starttime = datestr(clock, 0); % date-time
data.starttime_getsecs = GetSecs; % in the same format of timestamps for each trial

%% SETUP: CHEPS PROGRAM(46 to 64) /
% :: It will be adjusted each settings of study Example:[degree decValue
% ProgramNameInPathway]
PathPrg = {39 '00101110' 'SEMIC_39' ; ...
    39.5 '00101111' 'SEMIC_39.5' ; ...
    40 '00110000' 'SEMIC_40' ; ...
    40.5 '00110001' 'SEMIC_40.5'; ...
    41 '00110010' 'SEMIC_41'; ...
    41.5 '00110011' 'SEMIC_41.5'; ...
    42 '00110100' 'SEMIC_42'; ...
    42.5 '00110101' 'SEMIC_42.5'; ...
    43 '00110110' 'SEMIC_43'; ...
    43.5 '00110111' 'SEMIC_43.5'; ...
    44 '00111000' 'SEMIC_44'; ...
    44.5 '00111001' 'SEMIC_44.5'; ...
    45 '00111010' 'SEMIC_45'; ...
    45.5 '00111011' 'SEMIC_45.5'; ...
    46 '00111100' 'SEMIC_46'; ...
    46.5 '00111101' 'SEMIC_46.5'; ...
    47 '00111110' 'SEMIC_47'; ...
    47.5 '00111111' 'SEMIC_47.5'; ...
    48 '01000000' 'SEMIC_48';};
%% SETUP: Generate a trial sequence
% =========================================================================
%   1. Run number - Trial number - Pain type - ITI - Delay - Cue mean - Cue variance - Ramp-up
%   2. ITI - Delay - Delay 2  
%   : Total 15 seconds per one trial. Each is 3 to 7 seconds (5 combination: [3 5 7] [3 6 6] [4 4 7] [4 5 6] [5 5 5])
%   3. Cue mean (2 levels: 0-1). e.g., 0.3(LOW), 0.7(HIGH)
%       : plused random number (such as + and - 0.01~0.05)
%   4. Cue variance (1 levels: 0-1) e.g., 0.1, 0.11, 0.123....
%-------------------------------------------------------------------------
if start_trial==1
    rng('shuffle');
    % Number of trial
    trial_Number=(1:16)'; % and transpose % 4 (stim level) x 2 (two cues) x 2 (two overall questions)
    % Run number
    run_Number = repmat(runNbr,length(trial_Number),1);
    % Cue_mean Randoimzation (Five levels: 0.1, 0.3, 0.5, 0.7 0.9)
    cue_mean = repmat([0.3; 0.7],8,1) + randn(16,1).*0.07; % (LOW HIGH) x 4 = 16 trials
    cue_settings = repmat({"LOW";"HIGH"},8,1);
    rn=randperm(length(cue_mean));
    cue_mean = cue_mean(rn);
    cue_settings = cue_settings(rn);
    % Cue_variance Randoimzation (Three levels: 0.01, 0.05, 0.1)
    cue_var_bs = repmat({0.05;},20,1);
    rn=randperm(20);
    cue_var=abs(cell2mat(cue_var_bs(rn)) + randn(20,1).*0.003);
    % Find the dec value
    for iiii=1:numel(reg.FinalLMH_5Level)        
        for iii=1:length(PathPrg) %find degree
            if reg.FinalLMH_5Level(iiii) == PathPrg{iii,1}
                degree{iiii,1} = bin2dec(PathPrg{iii,2});
            else
                % do nothing
            end
        end
    end
    stim_degree=cell2mat(degree);   
    % LV1 to LV5 (calibrated) program Randoimzation
    for i = 1:4 % 5(LV1 to LV 5) x 4 other combination
        ts_program(i*5-4:i*5,1) = randperm(5); % [1 2 3 4 5] [2 3 4 1 5] ......
        stim_level = repmat({"LV1"; "LV2"; "LV3"; "LV4";"LV5"},4,1);
        program(i*5-4:i*5,1) = stim_degree;
    end
    program = program(ts_program);
    stim_level = stim_level(ts_program);
    % ITI-Delay1-Delay2 combination
    %:In this task, the combination from 17th to 20th will not use. 
    ITI_Delay = repmat({3, 5, 7; 3, 6, 6; 4, 4, 7; 4, 5, 6; 5, 5, 5}, 4, 1); % Five combitnations
    rn=randperm(size(ITI_Delay,1)); % length of vector
    ITI_Delay = ITI_Delay(rn,:);
    ITI = cell2mat(ITI_Delay(:,1));
    Delay = cell2mat(ITI_Delay(:,2));
    Delay2 = cell2mat(ITI_Delay(:,3));
    % Overall_ratings Question randomization
    overall_unpl_Q_txt= repmat({'다른 사람들은 이 자극을 얼마나 아파했을 것 같나요?'; '방금 경험한 자극이 얼마나 아팠나요? '},8,1);
    overall_unpl_Q_cond = repmat({'other_painful';'self_painful'},10,1);
    rn=randperm(numel(overall_unpl_Q_txt));
    overall_unpl_Q_txt = overall_unpl_Q_txt(rn);
    overall_unpl_Q_cond = overall_unpl_Q_cond(rn); 
    %ts = [trial_Number, run_Number, ITI, Delay, cue_mean, cue_var, ts_program, ramp_up_con];
    ts{runNbr} = [trial_Number, run_Number, ITI, Delay, Delay2, cue_mean, cue_settings, cue_var, ts_program, program, stim_level, overall_unpl_Q_txt, overall_unpl_Q_cond];
    % save the trial_sequences
    save(data.datafile, 'ts', 'data');
else
    [trial_Number, run_Number, ITI, Delay, Delay2, cue_mean, cue_settings, cue_var, ts_program, program, stim_level, overall_unpl_Q_txt, overall_unpl_Q_cond] = ts{runNbr};
end
%% SETUP: Experiment settings
rating_type = 'semicircular';
NumberOfCue = 25;

%% SETUP: Screen
Screen('Clear');
Screen('CloseAll');
window_num = 0;
if testmode
    window_rect = [1 1 800 640]; % in the test mode, use a little smaller screen
    %window_rect = [0 0 1900 1200];
    fontsize = 20;
else
    screens = Screen('Screens');
    window_num = screens(end); % the last window
    window_info = Screen('Resolution', window_num);
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
                    abort_experiment;
                end
                display_expmessage('실험자는 모든 것이 잘 준비되었는지 체크해주세요 (PATHWAY, BIOPAC, EYELINK, 등등). \n모두 준비되었으면 SPACE BAR를 눌러주세요.'); % until space; see subfunctions
            end
        end
        % 1 seconds: BIOPAC
        
        if trial_Number(j) == 1
            
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
                display_runmessage(trial_Number(j), run_Number(j), dofmri); % until 5 or r; see subfunctions
            end
            
            if dofmri
                fmri_t = GetSecs;
                % gap between 5 key push and the first stimuli (disdaqs: data.disdaq_sec)
                % 5 seconds: "占쏙옙占쏙옙占쌌니댐옙..."
                Screen(theWindow, 'FillRect', bgcolor, window_rect);
                DrawFormattedText(theWindow, double('시작합니다...'), 'center', 'center', white, [], [], [], 1.2);
                Screen('Flip', theWindow);
                data.dat{runNbr}{trial_Number(j)}.runscan_starttime = GetSecs;
                waitsec_fromstarttime(fmri_t, 4);
                
                % 5 seconds: Blank
                fmri_t2 = GetSecs;
                Screen(theWindow,'FillRect',bgcolor, window_rect);
                Screen('Flip', theWindow);
                waitsec_fromstarttime(fmri_t2, 4); % ADJUST THIS
            end
                        
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
        
        % 1. ITI (jitter)
        fixPoint(ITI(j), white, '-') %
        
        % 2. Cue
        cue_t = GetSecs;
        data.dat{runNbr}{trial_Number(j)}.cue_timestamp = cue_t; %Cue time stamp
        draw_scale('overall_avoidance_semicircular');
        [data.dat{runNbr}{trial_Number(j)}.cue_x, data.dat{runNbr}{trial_Number(j)}.cue_theta] = draw_social_cue(cue_mean(j), cue_var(j), NumberOfCue, rating_type); % draw & save details: draw_socia_cue(m, std, n, rating_type)
        Screen('Flip', theWindow);
        waitsec_fromstarttime(cue_t, 2); % 2 seconds
        data.dat{runNbr}{trial_Number(j)}.cue_end_timestamp = GetSecs;
        
        % 3. Delay
        fixPoint(Delay(j), white, '+')    
        % 4. HEAT and Ratings
        cir_center = [(rb+lb)/2, bb];
        SetMouse(cir_center(1), cir_center(2)); % set mouse at the center
        % lb2 = W/3; rb2 = (W*2)/3; % new bound for or not
        rec_i = 0;
        % thermodePrime(ip, port, ts_program(j))
        tic;
        data.dat{runNbr}{trial_Number(j)}.heat_start_txt = main(ip,port,1,program(j)); % Triggering heat signal
        data.dat{runNbr}{trial_Number(j)}.duration_heat_trigger = toc;
        data.dat{runNbr}{trial_Number(j)}.heat_start_timestamp = GetSecs; % heat-stimulus time stamp
        % if checkStatus(ip,port)
        ready = 0;
        ready2 = 0;
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
            msg = '현재 아픈 정도를 최대한 정확하게 실시간으로 보고해주세요';
            msg = double(msg);
            DrawFormattedText(theWindow, msg, 'center', 250, white, [], [], [], 1.2);
            draw_scale('overall_avoidance_semicircular')
            Screen('DrawDots', theWindow, [x y], 10, orange, [0 0], 1);
            Screen('Flip', theWindow);
            
            % Saving data
            data.dat{runNbr}{trial_Number(j)}.con_time_fromstart(rec_i,1) = GetSecs-sTime;
            data.dat{runNbr}{trial_Number(j)}.con_xy(rec_i,:) = [x-cir_center(1) cir_center(2)-y]./radius;
            data.dat{runNbr}{trial_Number(j)}.con_clicks(rec_i,:) = button;
            data.dat{runNbr}{trial_Number(j)}.con_r_theta(rec_i,:) = [curr_r/radius curr_theta/180];
                      
        end
        
        %5. Delay2
        fixPoint(Delay2(j), white, '+')
        %6. Overall ratings
        cir_center = [(rb+lb)/2, bb];
        SetMouse(cir_center(1), cir_center(2)); % set mouse at the center
        % lb2 = W/3; rb2 = (W*2)/3; % new bound for or not
        rec_i = 0;
        % if checkStatus(ip,port)
        data.dat{runNbr}{trial_Number(j)}.overall_rating_timestamp=GetSecs;
        while GetSecs - data.dat{runNbr}{trial_Number(j)}.overall_rating_timestamp > 5
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
            msg = double(overall_unpl_Q_txt{j});
            DrawFormattedText(theWindow, msg, 'center', 250, white, [], [], [], 1.2);
            draw_scale('overall_avoidance_semicircular')
            Screen('DrawDots', theWindow, [x y], 10, orange, [0 0], 1);
            Screen('Flip', theWindow);
            
            if button(1)
                draw_scale('overall_avoidance_semicircular');
                Screen('DrawDots', theWindow, [x y]', 18, red, [0 0], 1);  % Feedback
                Screen('Flip',theWindow);
                WaitSecs(1);
                break; % break for "if"
            end
            
            % Saving data
            data.dat{runNbr}{trial_Number(j)}.ovr_time_fromstart(rec_i,1) = GetSecs-sTime;
            data.dat{runNbr}{trial_Number(j)}.ovr_xy(rec_i,:) = [x-cir_center(1) cir_center(2)-y]./radius;
            data.dat{runNbr}{trial_Number(j)}.ovr_clicks(rec_i,:) = button;
            data.dat{runNbr}{trial_Number(j)}.ovr_r_theta(rec_i,:) = [curr_r/radius curr_theta/180];                     
%             if GetSecs - sTime > 10 % 7 = plateau + ramp-down
%                 start_stopsignal=GetSecs;
%                 waitsec_fromstarttime(start_stopsignal, 2)
%                 resp = main(ip,port,0); %get system status
%                 systemState = resp{4}; testState = resp{5};
%                 if strcmp(systemState, 'Pathway State: READY') && strcmp(testState,'Test State: IDLE')
%                     data.dat{runNbr}{trial_Number(j)}.heat_exit_txt = main(ip,port,5); % Triggering stop signal
%                     ready2 = 1;
%                     data.dat{runNbr}{trial_Number(j)}.heat_exit_timestamp = GetSecs;
%                     break;
%                 end
%             end
        end
        
        SetMouse(0,0);
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('Flip', theWindow);
        end_trial = GetSecs;
        data.dat{runNbr}{trial_Number(j)}.end_trial_t = end_trial;
        data.dat{runNbr}{trial_Number(j)}.ramp_up_cnd = ramp_up_con(j);
        if mod(trial_Number(j),2) == 0, save(data.datafile, '-append', 'data'); end % save data every two trials
        waitsec_fromstarttime(end_trial, 1); % For your rest,
    end
    
    ShowCursor();
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
global theWindow;
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

