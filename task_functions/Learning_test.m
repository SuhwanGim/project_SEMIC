function learn = Learning_test(SID, ip, port, reg, varargin)
%%
%**THERE IS ONLY DIFFERENT THING THAT THIS FUCNTION TRIGGER THERMAL PAIN
%WITH CONGURENT SOICAL CUE CONCOMPARED WITH THERMODE_TEST
%
% written by Suhwan Gim (roseno.9@daum.net) 2017-12-06
% =========================================================================
% You can see details of this fucntion (see below)
% see also thermode_test
 

%% GLOBAL vaiable
global theWindow W H; % window property
global white red red_Alpha orange bgcolor yellow; % color
global window_rect prompt_ex lb rb tb bb scale_H promptW promptH; % rating scale
global lb1 rb1 lb2 rb2;% For larger semi-circular
global fontsize anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd; % anchors
%global reg;

%% SETUP: Design parameters
runNbr = 1;
N = 8; % Number of Trial
%% Parse varargin
testmode = false;
USE_BIOPAC = false;
dofmri = false;
joystick= false;
USE_EYELINK = false;
% need to be specified differently for different computers
% psytool = 'C:\toolbox\Psychtoolbox';
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
            case {'joystick'}
                joystick=true;
            case {'eyelink', 'eye', 'eyetrack'}
                USE_EYELINK = true;
        end
    end
end
%%
addpath(genpath(pwd));
%% SETUP: DATA and Subject INFO
savedir = 'LEARN_SEMIC_data';
[fname,start_trial, SID] = subjectinfo_check_SEMIC(SID,savedir,1,'Learn'); % subfunction %start_trial
%[fname, start_trial, SID] = subjectinfo_check(savedir); % subfunction
if exist(fname, 'file'), load(fname, 'learn'); load(fname,'ts'); end
% save data using the canlab_dataset object
learn.version = 'SEMIC_v1_02-22-2018_Cocoanlab';
learn.subject = SID;
learn.datafile = fname;
learn.starttime = datestr(clock, 0); % date-time
learn.starttime_getsecs = GetSecs; % in the same format of timestamps for each trial

%% SETUP: the pathway program
PathPrg = load_PathProgram('SEMIC');
%% SETUP: Generate a trial sequence
% =========================================================================
%   1. Run number - Trial number - ITI - Delay - Delay2, Cue mean - Cue
%   settings - Cue variance - program - quetions - condition of quetions
%   2. ITI - Delay - Delay 2
%   : Total 15 seconds per one trial. Each is 3 to 7 seconds
%   (5 combination: [3 5 7] [3 6 6] [4 4 7] [4 5 6] [5 5 5])
%   3. Cue mean (2 levels: 0-1). e.g., 0.3(LOW), 0.7(HIGH)
%       : added random number (such as + and - 0.01~0.05)
%   4. Cue variance (1 levels: 0-1) e.g., 0.1, 0.11, 0.123....
%--------------------------------------------------------------------------
if start_trial==1
    rng('shuffle');
    % Number of trial
    trial_Number=(1:N)'; % and transpose % 4 (stim level) x 2 (two cues) x 2 (two overall questions)
    % Run number
    run_Number = repmat(runNbr,length(trial_Number),1);
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
    % Program, cue_settings, mean, variance (Compare to the thermode_test,
    % this procedure didn't suffle the sequecne.
    stim_level = ["LV1"; "LV2"; "LV3"; "LV4";"LV2"; "LV3"; "LV4";"LV5"]; % A group of [low cue,High cue]x2
    program = [stim_degree(1:4);stim_degree(2:5)]; % A group of [low cue,High cue]x2
    cue_settings = ["LOW";"LOW";"LOW";"LOW";"HIGH";"HIGH";"HIGH";"HIGH"];
    cue_mean = [0.16; 0.33; 0.5; 0.66; 0.33; 0.5; 0.66; 0.83;] + randn(8,1).*0.02; % (LOWx4 HIGHx4) x 2 = 16 trials
    cue_var = abs(repmat(0.05,8,1) + randn(8,1).*0.003); %
    % randomization
    rn=randperm(length(cue_mean));
    program = program(rn);
    stim_level = stim_level(rn);
    cue_mean = cue_mean(rn);
    cue_settings = cue_settings(rn);
    cue_var = cue_var(rn);
    % ITI-Delay1-Delay2 combination
    %:In this task, the combination from 17th to 20th will not use.
    ITI_Delay = repmat({3, 5, 7; 3, 6, 6; 4, 4, 7; 4, 5, 6; 5, 5, 5}, 4, 1); % Five combitnations
    rn=randperm(size(ITI_Delay,1)); % length of vector
    ITI_Delay = ITI_Delay(rn,:);
    ITI_Delay = ITI_Delay(1:N,:);
    ITI = cell2mat(ITI_Delay(:,1));
    Delay = cell2mat(ITI_Delay(:,2));
    Delay2 = cell2mat(ITI_Delay(:,3));
    % Overall_ratings Question randomization
    overall_unpl_Q_txt= repmat({'다른 사람들은 이 자극을 얼마나 아파했을 것 같나요?'; '방금 경험한 자극이 얼마나 아팠나요? '},4,1);
    overall_unpl_Q_cond = repmat({'other_painful';'self_painful'},4,1);
    rn=randperm(numel(overall_unpl_Q_txt));
    overall_unpl_Q_txt = overall_unpl_Q_txt(rn);
    overall_unpl_Q_cond = overall_unpl_Q_cond(rn);
    %ts = [trial_Number, run_Number, ITI, Delay, cue_mean, cue_var, ts_program, ramp_up_con];
    ts{runNbr} = [run_Number, trial_Number, ITI, Delay, Delay2, cue_settings, cue_mean, cue_var, stim_level, program, overall_unpl_Q_cond, overall_unpl_Q_txt];
    % save the trial_sequences
    save(learn.datafile, 'ts', 'learn');
else
    [run_Number, trial_Number, ITI, Delay, Delay2, cue_settings, cue_mean, cue_var, stim_level, program, overall_unpl_Q_cond, overall_unpl_Q_txt] = ts{runNbr};
end

%% SETUP: Screen
Screen('Clear');
Screen('CloseAll');
window_num = 0;
if testmode
    window_rect = [1 1 800 640]; % in the test mode, use a little smaller screen
    fontsize = 20;
else
    screens = Screen('Screens');
    window_num = screens(end); % the last window
    Screen('Preference', 'SkipSyncTests', 1);
    window_info = Screen('Resolution', window_num);
    window_rect = [0 0 window_info.width window_info.height]; % full screen
    fontsize = 32;
    HideCursor();
end

W = window_rect(3); %width of screen
H = window_rect(4); %height of screen

%font = 'NanumBarunGothic';

bgcolor = 80;
white = 255;
red = [255 0 0];
red_Alpha = [255 164 0 130]; % RGB + A(Level of tranceprency: for social Cue)
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
%% SETUP: Screen
theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % For alpha value of e.g.,[R G B alpha]
%Screen('TextFont', theWindow, font); % setting font
Screen('TextSize', theWindow, fontsize);


%% SETUP: Eyelink
% need to be revised when the eyelink is here.
if USE_EYELINK
    new_SID = erase(SID,'SEM'); % For limitation of file name 
    edf_filename = ['L_' new_SID '_' num2str(runNbr)]; % name should be equal or less than 8
    edfFile = sprintf('%s.EDF', edf_filename);
    eyelink_main(edfFile, 'Init');
    
    status = Eyelink('Initialize');
    if status
        error('Eyelink is not communicating with PC. Its okay baby.');
    end
    Eyelink('Command', 'set_idle_mode');
    waitsec_fromstarttime(GetSecs, .5);
end
%% SETUP: Experiment settings
rating_type = 'semicircular';
NumberOfCue = 25;
velocity = cal_vel_joy('overall');

%% EXPERIEMENT START
try
    % settings of ts
    if start_trial ~= 1,    k=start_trial; else, k=1; end
    % Explain grid-scale every run
    
    pathway_test(ip, port, 'MRI',reg);
    exp_scale('predict',joystick);
    
    
    % START: RUN
    learn.run_start_timestamp{runNbr}=GetSecs;
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
                display_expmessage('실험자는 모든 것이 잘 준비되었는지 체크해주세요 (PATHWAY, BIOPAC, 등등). \n모두 준비되었으면 SPACE BAR를 눌러주세요.'); % until space; see subfunctions
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
                % gap between 5 key push and the first stimuli (disdaqs: learn.disdaq_sec)
                % 5 seconds: "占쏙옙占쏙옙占쌌니댐옙..."
                Screen(theWindow, 'FillRect', bgcolor, window_rect);
                DrawFormattedText(theWindow, double('시작합니다...'), 'center', 'center', white, [], [], [], 1.2);
                Screen('Flip', theWindow);
                learn.dat{runNbr}{trial_Number(j)}.runscan_starttime = GetSecs;
                waitsec_fromstarttime(fmri_t, 4);
                
                % 5 seconds: Blank
                fmri_t2 = GetSecs;
                Screen(theWindow,'FillRect',bgcolor, window_rect);
                Screen('Flip', theWindow);
                waitsec_fromstarttime(fmri_t2, 4); % ADJUST THIS
            end
            
            if USE_BIOPAC
                bio_t = GetSecs;
                learn.dat{runNbr}{trial_Number(j)}.biopac_triggertime = bio_t; %BIOPAC timestamp
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
                learn.dat{runNbr}{trial_Number(j)}.eyetracker_starttime = GetSecs; % eyelink timestamp
                Eyelink('Message','Run start');
            end
            
        end
        
        TrSt_t = GetSecs; %
        learn.dat{runNbr}{trial_Number(j)}.trial_start_t = TrSt_t; %Trial start_timestamp
        %==============TRIAL===================================%
        % 1. ITI (jitter)
        fixPoint(TrSt_t, ITI(j), white, '+') % ITI
        learn.dat{runNbr}{trial_Number(j)}.ITI_endtimestamp = GetSecs;
        if USE_EYELINK
            Eyelink('Message','ITI ends');
        end
        
        % 2. Cue
        draw_scale('overall_predict_semicircular');
        [~ , learn.dat{runNbr}{trial_Number(j)}.cue_theta] = draw_social_cue(cue_mean(j), cue_var(j), NumberOfCue, rating_type); % draw & save details: draw_socia_cue(m, std, n, rating_type)
        Screen('Flip', theWindow);
        %-------------Ready------------------
        main(ip,port,1,program(j)); %select the program
        WaitSecs(0.5);
        main(ip,port,2); %ready to pre-start
        
        waitsec_fromstarttime(TrSt_t, ITI(j) + 2); % 2 seconds
        learn.dat{runNbr}{trial_Number(j)}.cue_end_timestamp = GetSecs;
        if USE_EYELINK
            Eyelink('Message','Social cue ends');
        end
        
        % 3. Delay
        fixPoint(TrSt_t , ITI(j) + 2 + Delay(j), white, '+') % Delay
        learn.dat{runNbr}{trial_Number(j)}.Delay1_end_timestamp = GetSecs;
        if USE_EYELINK
            Eyelink('Message','Delay1 ends');
        end        
        % 4. HEAT and Ratings
        rec_i = 0;
        ready3=0;
        % set the mouse location to zero point
        
        % xcenter = (lb1+rb1)/2;
        % ycenter = H*3/4+100;
        
        % cir_center = [(lb1+rb1)/2 H*3/4+100];
        cir_center = [(lb1+rb1)/2, H*3/4+100];
        SetMouse(cir_center(1), cir_center(2)); % set mouse at the center
        x=cir_center(1); y=cir_center(2);
        
        % lb2 = W/3; rb2 = (W*2)/3; % new bound for or not
        start_while=GetSecs;
        learn.dat{runNbr}{trial_Number(j)}.start_rating_timestamp = start_while;
        if USE_EYELINK
            Eyelink('Message','Continuous rating start');
        end                
        while GetSecs - TrSt_t < 14.5 + ITI(j) + 2 + Delay(j)
            if joystick
                [pos, button] = mat_joy(0);
                xAlpha=pos(1);
                x=x+xAlpha*velocity;
                yAlpha=pos(2);
                y=y+yAlpha*velocity;
                %[x y]=[x+pos(1)*velocity y+pos(2)*velocity]
            else
                [x,y,button]=GetMouse(theWindow);
            end
            %[x,y,button]=GetMouse(theWindow);
            rec_i= rec_i+1;
            % if the point goes further than the semi-circle, move the point to
            % the closest point
            radius = (rb1-lb1)/2; % radius
            theta = atan2(cir_center(2)-y,x-cir_center(1));
            % current euclidean distance
            curr_r = sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2);
            % current angle (0 - 180 deg)
            curr_theta = rad2deg(-theta+pi);
            % For control a mouse cursor:
            % send to diameter of semi-circle
            if y > cir_center(2) %bb
                y = cir_center(2); %bb;
                SetMouse(x,y);
            end
            % send to arc of semi-circle
            if sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2) > radius
                x = radius*cos(theta)+cir_center(1);
                y = cir_center(2)-radius*sin(theta);
                SetMouse(x,y);
            end
            %             msg = '이번 자극이 얼마나 아플 것이라고 예상하시나요?';
            %             msg = double(msg);
            %             DrawFormattedText(theWindow, msg, 'center', 150, white, [], [], [], 1.2);
            draw_scale('cont_predict_semicircular');
            Screen('DrawDots', theWindow, [x y], 15, orange, [0 0], 1);
            Screen('Flip', theWindow);
            
            
            % thermodePrime(ip, port, ts_program(j))
            if ready3 == 0
                if GetSecs - start_while > 1
                    tic;
                    learn.dat{runNbr}{trial_Number(j)}.heat_start_txt = main(ip,port,2); % start heat signal
                    learn.dat{runNbr}{trial_Number(j)}.duration_heat_trigger = toc;
                    learn.dat{runNbr}{trial_Number(j)}.heat_start_timestamp = GetSecs; % heat-stimulus time stamp
                    if USE_EYELINK
                        Eyelink('Message','heat_stimulation_start');
                    end
                    ready3=1;
                else
                    %do nothing
                end
            else
                %do nothing
            end
            
            % Saving learn
            learn.dat{runNbr}{trial_Number(j)}.con_time_fromstart(rec_i,1) = GetSecs-start_while;
            learn.dat{runNbr}{trial_Number(j)}.con_xy(rec_i,:) = [x-cir_center(1) cir_center(2)-y]./radius;
            learn.dat{runNbr}{trial_Number(j)}.con_clicks(rec_i,:) = button;
            learn.dat{runNbr}{trial_Number(j)}.con_r_theta(rec_i,:) = [curr_r/radius curr_theta/180]; %radius and degree?
        end
        learn.dat{runNbr}{trial_Number(j)}.contRating_end_stamp_end = GetSecs;
        if USE_EYELINK
            Eyelink('Message','Continuous rating ends');
        end
        
        %5. Delay2
        fixPoint(TrSt_t, Delay2(j)+14.5 + ITI(j) + 2 + Delay(j), white, '+')
        learn.dat{runNbr}{trial_Number(j)}.Delay2_end_timestamp_end = GetSecs;
        if USE_EYELINK
            Eyelink('Message','Delay2 rating ends');
        end
        
        %6. Overall ratings
        cir_center = [(rb2+lb2)/2 H*3/4+100];
        % cir_center = [(rb+lb)/2, bb];
        SetMouse(cir_center(1), cir_center(2)); % set mouse at the center
         x=cir_center(1); y=cir_center(2);
        
        rec_i = 0;
        sTime=GetSecs;
        if USE_EYELINK
            Eyelink('Message','Overall rating starts');
        end
        learn.dat{runNbr}{trial_Number(j)}.overall_rating_time_stamp=sTime; % overall rating time stamp
        while GetSecs - TrSt_t < 5 + Delay2(j)+ 14.5 + ITI(j) + 2 + Delay(j)
            if joystick
                [pos, button] = mat_joy(0);
                xAlpha=pos(1);
                x=x+xAlpha*velocity;
                yAlpha=pos(2);
                y=y+yAlpha*velocity;
                %[x y]=[x+pos(1)*velocity y+pos(2)*velocity]
            else
                [x,y,button]=GetMouse(theWindow);
            end
            % [x,y,button]=GetMouse(theWindow);
            rec_i= rec_i+1;
            % if the point goes further than the semi-circle, move the point to
            % the closest point
            radius = (rb2-lb2)/2;%radius = (rb-lb)/2; % radius
            theta = atan2(cir_center(2)-y,x-cir_center(1));
            % current euclidean distance
            curr_r = sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2);
            % current angle (0 - 180 deg)
            curr_theta = rad2deg(-theta+pi);
            % For control a mouse cursor:
            % send to diameter of semi-circle
            if y > cir_center(2)%bb
                y = cir_center(2);%bb;
                SetMouse(x,y);
            end
            % send to arc of semi-circle
            if sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2) > radius
                x = radius*cos(theta)+cir_center(1);
                y = cir_center(2)-radius*sin(theta);
                SetMouse(x,y);
            end
            msg = double(overall_unpl_Q_txt{j});
            Screen('TextSize', theWindow, 26);
            DrawFormattedText(theWindow, msg, 'center', 1/2*H-100, white, [], [], [], 1.2);
            draw_scale('overall_predict_semicircular')
            Screen('DrawDots', theWindow, [x y], 15, orange, [0 0], 1);
            Screen('Flip', theWindow);
            
            
            % Saving data
            learn.dat{runNbr}{trial_Number(j)}.ovr_time_fromstart(rec_i,1) = GetSecs-sTime;
            learn.dat{runNbr}{trial_Number(j)}.ovr_xy(rec_i,:) = [x-cir_center(1) cir_center(2)-y]./radius;
            learn.dat{runNbr}{trial_Number(j)}.ovr_clicks(rec_i,:) = button;
            learn.dat{runNbr}{trial_Number(j)}.ovr_r_theta(rec_i,:) = [curr_r/radius curr_theta/180];
            
            
            if button(1)
                draw_scale('overall_predict_semicircular');
                Screen('DrawDots', theWindow, [x y]', 18, red, [0 0], 1);  % Feedback
                Screen('Flip',theWindow);
                WaitSecs(min(0.5, 5-(GetSecs-sTime)));
                ready3=0;
                while ~ready3 %GetSecs - sTime> 5
                    msg = double(' ');
                    DrawFormattedText(theWindow, msg, 'center', 150, white, [], [], [], 1.2);
                    Screen('Flip',theWindow);
                    if  GetSecs - sTime > 5
                        break
                    end
                end
                break;
            else
                %do nothing
            end
            
        end %end of a overall rating
        learn.dat{runNbr}{trial_Number(j)}.overallRating_end_timestamp_end = GetSecs;
        if USE_EYELINK
            Eyelink('Message','Overall rating ends');
        end
        %
        SetMouse(0,0);
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('Flip', theWindow);
        end_trial = GetSecs;
        % Saving trial sequence(i)
        learn.dat{runNbr}{trial_Number(j)}.ts = ts{1,1}(j,:);
        learn.dat{runNbr}{trial_Number(j)}.end_trial_t = end_trial;
        
        % learn.dat{runNbr}{trial_Number(j)}.ramp_up_cnd = ramp_up_con(j);
        if mod(trial_Number(j),2) == 0, save(learn.datafile, '-append', 'learn'); end % save data every two trials
        % waitsec_fromstarttime(end_trial, 1); % For your rest,
    end
    
    if USE_EYELINK
        Eyelink('Message','Run ends');
        eyelink_main(edfFile, 'Shutdown');
    end
    
    if USE_BIOPAC %end BIOPAC
        bio_t = GetSecs;
        learn.dat{runNbr}{trial_Number(j)}.biopac_endtime = bio_t;% biopac end timestamp
        BIOPAC_trigger(ljHandle, biopac_channel, 'on');
        waitsec_fromstarttime(bio_t, 0.1);
        BIOPAC_trigger(ljHandle, biopac_channel, 'off');
    end
    
    
    learn.run_endtime_timestamp{runNbr}=GetSecs;
    save(learn.datafile, '-append', 'learn');
    
    %closing image until when acquiring T1 image is end
    msg='연습이 끝났습니다. 구조촬영이 계속 진행 중 입니다. \n몸을 움직이지 마시고 기다려 주시기 바랍니다.';
    DrawFormattedText(theWindow, double(msg), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    WaitSecs(10);
    
    DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('q'))==1
            break
        elseif keyCode(KbName('space'))== 1
            break
        end
    end
    learn.close_fixation_timestamp{runNbr} = GetSecs;
    
    ShowCursor();
    Screen('Clear');
    Screen('CloseAll');
    disp('Done');
    save(learn.datafile, '-append', 'learn');
    
catch err
    % ERROR
    disp(err);
    for i = 1:numel(err.stack)
        disp(err.stack(i));
    end
    abort_experiment;
end
end

% redundancy is good thing for data, physio, gazepoint, prompt
%% ::::::::::::::::::::::: SUBFUNCTION ::::::::::::::::::::::::::::::::::
function fixPoint(t_time, seconds, color, stimText)
global theWindow;
% stimText = '+';
% Screen(theWindow,'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double(stimText), 'center', 'center', color, [], [], [], 1.2);
Screen('Flip', theWindow);
waitsec_fromstarttime(t_time, seconds);
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

