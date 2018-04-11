function data = thermode_test(SID, runNbr, ip, port, reg, varargin)
%%
% This function triggers thermal-pain externally using TCP/IP communication
%and shows ratings.The 'runNbr' is number of run. The 'ip' and 'port' are
%obtained from the "Pathway" device. And there are some optional inputs.
%
%To using this function, two computers (or more) should have a connected
%each other or same router. However, if didn't, this function will not
%working properly.
%
% Written by Suhwan Gim (roseno.9@daum.net)
% 2018-02-18
%
% see also load_PathProgram calibration
%
% -------------------------------------------------------------------------

%% GLOBAL vaiable
global theWindow W H; % window property
global white red red_Alpha orange bgcolor yellow; % color
global window_rect prompt_ex lb rb tb bb scale_H promptW promptH; % rating scale
global lb1 rb1 lb2 rb2;% For larger semi-circular
global fontsize anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd; % anchors

%% Chekc ip/port
if ~isempty(ip)
    % do nothing
else
    abort_experiment('IP');
end
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
% addpath(scriptdir); cd(scriptdir);
% addpath(genpath(psytool));
addpath(genpath(pwd));
%% SETUP: DATA and Subject INFO
savedir = 'Main_SEMIC_data';
[fname,start_trial, SID] = subjectinfo_check_SEMIC(SID, savedir,runNbr,'Main'); % subfunction %start_trial
if exist(fname, 'file'), load(fname, 'data'); load(fname,'ts'); end
% save data using the canlab_dataset object
data.version = 'SEMIC_v1_03-01-2018_Cocoanlab';
data.subject = SID;
data.datafile = fname;
data.starttime = datestr(clock, 0); % date-time
data.starttime_getsecs = GetSecs; % in the same format of timestamps for each trial
%% SETUP: load the pathway program
PathPrg = load_PathProgram('SEMIC');
%% SETUP: Generate a trial sequence
% =========================================================================
%   1. Run number - Trial number - ITI - Delay - Delay2, Cue mean - Cue
%   settings - Cue variance - program - quetions - condition of quetions
%   2. ITI - Delay - Delay 2
%   : Total 15 seconds per one trial. Each is 3 to 7 seconds
%   (5 combination: [3 5 7] [3 6 6] [4 4 7] [4 5 6] [5 5 5])
%   3. Cue mean (2 levels: 0-1). e.g., 0.22(LOW), 0.77(HIGH)
%       : added jitter (such as + and - 0.01~0.05)
%   4. Cue variance (1 levels: 0-1) e.g., 0.1, 0.11, 0.123....
%--------------------------------------------------------------------------
if start_trial==1
    rng('shuffle');
    % Number of trial
    trial_Number=(1:18)'; % and transpose % 4 (stim level) x 2 (two cues) x 2 (two overall questions) + 8(only pain trial:LV2,3,4 x 2 + LV1,5x1)
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
    % Make stritedfied randomization of [Program, cue_settings, mean,
    % variance]
    program = zeros(18,1);
    cue_mean = zeros(18,1);
    while ~((numel(find(diff(program)==0))) < 2) || ~((numel(find(diff(cue_mean)==0))) < 2)
        % A DESIGN within a one run divided three parts (1+2+3 = 18 trials)
        % 1) Only pain trials: [LV2, 3, 4] x 2 = 6 trials
        % 2) Self Q (overall questions): 2 (social cues: Low/High) x 4 (temp levels: LV 1  to 4 / LV2 to 5) = 8 trials
        % 3) Other Q (overall questions): 2 (Social cues: Low/High) x 2 (temp levels Lv3 and 4 / Lv 2 and 3) = 4 trials
        % mean duration: 0.27, max: 0.8552, min: 0.0210, mode= 0.210
        stim_level = ["LV2"; "LV3"; "LV4"; "LV2";"LV3"; "LV4"; "LV1"; "LV2";"LV3"; "LV4"; "LV2";"LV3"; "LV4"; "LV5";"LV3";"LV4";"LV2";"LV3"]; % A group of [low cue,High cue]x2
        program = [stim_degree(2:4);stim_degree(2:4);stim_degree(1:4);stim_degree(2:5);stim_degree(3:4);stim_degree(2:3)]; % A group of [low cue,High cue]x2
        cue_settings = ["NO";"NO";"NO";"NO";"NO";"NO";"LOW";"LOW";"LOW";"LOW";"HIGH";"HIGH";"HIGH";"HIGH";"LOW";"LOW";"HIGH";"HIGH"];
        cue_mean = [99;99;99;99;99;99;0.22; 0.22; 0.22;0.22; 0.77; 0.77; 0.77; 0.77;0.22; 0.22; 0.77; 0.77;]; % (LOWx4 HIGHx4) x 2 = 16 trials
        cue_var = abs(repmat(0.05,24,1) + randn(24,1).*0.003); %
        overall_unpl_Q_txt= [repmat({'다른 사람들은 얼마나 아팠을까요?'},3,1); repmat({'얼마나 아팠나요?'},3,1); repmat({'얼마나 아팠나요?'},8,1); repmat({'다른 사람들은 얼마나 아팠을까요?'},4,1)];
        overall_unpl_Q_cond = [repmat({'other_painful'},6,1); repmat({'self_painful'},8,1); repmat({'other_painful'},4,1);];
        %generate a randome sequence
        rn = randperm(numel(cue_settings));
        %randomization
        stim_level = stim_level(rn);
        program =  program(rn);
        cue_settings = cue_settings(rn);
        cue_mean = cue_mean(rn);
        cue_var = cue_var(rn);
        overall_unpl_Q_txt = overall_unpl_Q_txt(rn);
        overall_unpl_Q_cond = overall_unpl_Q_cond(rn);
        %i=i+1;
    end
    % ITI-Delay1-Delay2 combination
    bin = [3, 5, 7; 3, 6, 6; 4, 4, 7; 4, 5, 6; 5, 5, 5];%-0.5;
    for i=1:length(bin)
        rng('shuffle');
        rn=randperm(3);
        bin(i,:)=bin(i,rn);
    end
    ITI_Delay = repmat(bin, 6, 1); % Five combitnations
    rn=randperm(size(ITI_Delay,1)); % length of vector
    ITI_Delay = ITI_Delay(rn,:);
    ITI_Delay = ITI_Delay(1:length(trial_Number),:);
    
    no_iti = repmat([5;7], 3, 1);
    idx = randperm(6);
    ITI_Delay(contains(cue_settings, 'NO'),:) = [no_iti(idx) NaN(6,1) 12-no_iti(idx)];
    
    ITI = ITI_Delay(:,1);
    Delay = ITI_Delay(:,2);
    Delay2 = ITI_Delay(:,3);
    % trial sequences
    ts{runNbr} = [run_Number, trial_Number, ITI, Delay, Delay2, cue_settings, cue_mean, cue_var, stim_level, program, overall_unpl_Q_cond, overall_unpl_Q_txt];
    % save the trial_sequences
    save(data.datafile, 'ts', 'data');
else
    [run_Number, trial_Number, ITI, Delay, Delay2, cue_settings, cue_mean, cue_var, stim_level, program, overall_unpl_Q_cond, overall_unpl_Q_txt] = ts{runNbr};
end
%% SETUP: Screen
Screen('Clear');
Screen('CloseAll');
window_num = 0;
if testmode
    window_rect = [1 1 1280 720]; % in the test mode, use a little smaller screen [but, wide resoultions]
    %window_rect = [0 0 1900 1200];
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

%% SETUP: Experiment settings
rating_type = 'semicircular';
NumberOfCue = 25;
velocity_ovr = cal_vel_joy('overall');
velocity_cot = cal_vel_joy('cont');


%% SETUP: Screen
    theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
    Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
    Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % For alpha value of e.g.,[R G B alpha]
%     Screen('TextFont', theWindow, font); % setting font
    Screen('TextSize', theWindow, fontsize);
%% SETUP: Eyelink
% need to be revised when the eyelink is here.
% It located after open screen
if USE_EYELINK
    new_SID = erase(SID,'SEM'); % For limitation of file name 
    edf_filename = ['M_' new_SID '_' num2str(runNbr)]; % name should be equal or less than 8
    edfFile = sprintf('%s.EDF', edf_filename);
    eyelink_main(edfFile, 'Init');
    
    status = Eyelink('Initialize');
    if status
        error('Eyelink is not communicating with PC. Its okay baby.');
    end
    Eyelink('Command', 'set_idle_mode');
    waitsec_fromstarttime(GetSecs, .5);
end

%% EXPERIEMENT START
try
    % settings of ts
    if start_trial ~= 1,    k=start_trial; else, k=1; end
    
    
    % Themode_test (with highest degree based on calibration data)
    pathway_test(ip, port, 'MRI', reg);
    % Explain grid-scale every run
    exp_scale('predict',joystick);
    
 
    % START: RUN
    data.run_start_timestamp{runNbr}=GetSecs;
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
            
            if USE_EYELINK
                Eyelink('StartRecording');
                data.dat{runNbr}{trial_Number(j)}.eyetracker_starttime = GetSecs; % eyelink timestamp
                Eyelink('Message','Run start');
            end           
        end
        
        TrSt_t = GetSecs; %
        data.dat{runNbr}{trial_Number(j)}.trial_start_t = TrSt_t; %Trial start_timestamp
        %==============TRIAL===================================%
        %NORMAL TRIAL
        if cue_mean(j)<1
            % 1. ITI (jitter)
            fixPoint(TrSt_t, ITI(j), white, '+') % ITI
            if USE_EYELINK
                Eyelink('Message','ITI ends');
            end
            data.dat{runNbr}{trial_Number(j)}.ITI_endtimestamp = GetSecs;
            
            
            % 2. Cue
            draw_scale('overall_predict_semicircular');
            [~ , data.dat{runNbr}{trial_Number(j)}.cue_theta] = draw_social_cue(cue_mean(j), cue_var(j), NumberOfCue, rating_type); % draw & save details: draw_socia_cue(m, std, n, rating_type)
            Screen('Flip', theWindow);
            %-------------Ready for Pathway------------------
            main(ip,port,1,program(j)); %select the program
            WaitSecs(0.5);
            main(ip,port,2); %ready to pre-start
            %-------------------------------------------------
            waitsec_fromstarttime(TrSt_t, ITI(j) + 2); % 2 seconds
            if USE_EYELINK
                Eyelink('Message','Social cue ends');
            end
            data.dat{runNbr}{trial_Number(j)}.cue_end_timestamp = GetSecs;
            
            
            % 3. Delay
            fixPoint(TrSt_t , ITI(j) + 2 + Delay(j), white, '+') % Delay
            if USE_EYELINK
                Eyelink('Message','Delay1 ends');
            end            
            data.dat{runNbr}{trial_Number(j)}.Delay1_end_timestamp = GetSecs;
            
            
            % 4. HEAT and Ratings
            rec_i = 0;
            ready3=0;
            % set the mouse location to zero point
            
            % xcenter = (lb1+rb1)/2;
            % ycenter = H*3/4+100;
            
            cir_center = [(lb1+rb1)/2 H*3/4+100];
            % set the mouse or x y position to center of semi-circular
            % cir_center = [(rb1+lb1)/2, bb]; --> 
            SetMouse(cir_center(1), cir_center(2)); % set mouse at the center
            x=cir_center(1); y=cir_center(2);
            % lb2 = W/3; rb2 = (W*2)/3; % new bound for or not
            start_while=GetSecs;
            data.dat{runNbr}{trial_Number(j)}.contRating_start_timestamp = start_while;
            if USE_EYELINK
                Eyelink('Message','Continuous rating start');
            end
            while GetSecs - TrSt_t < 14.5 + ITI(j) + 2 + Delay(j)
                if joystick
                    [pos, button] = mat_joy(0);
                    xAlpha=pos(1);
                    x=x+xAlpha*velocity_cot;
                    yAlpha=pos(2);
                    y=y+yAlpha*velocity_cot;
                    %[x y]=[x+pos(1)*velocity y+pos(2)*velocity]
                else
                    [x,y,button]=GetMouse(theWindow);
                end
                % [x,y,button]=GetMouse(theWindow);
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
%                 msg = '이번 자극이 최대 얼마나 아플까요?';
%                 msg = double(msg);
%                 DrawFormattedText(theWindow, msg, 'center', 150, orange, [], [], [], 2);
                draw_scale('cont_predict_semicircular');
                Screen('DrawDots', theWindow, [x y], 15, orange, [0 0], 1);
                Screen('Flip', theWindow);
                
                
                % thermodePrime(ip, port, ts_program(j))
                if ready3 == 0
                    if GetSecs - start_while > 1
                        tic;
                        data.dat{runNbr}{trial_Number(j)}.heat_start_txt = main(ip,port,2); % start heat signal
                        data.dat{runNbr}{trial_Number(j)}.duration_heat_trigger = toc;
                        data.dat{runNbr}{trial_Number(j)}.heat_start_timestamp = GetSecs; % heat-stimulus time stamp                        
                        if USE_EYELINK
                            Eyelink('Message','heat_stimulation_start');
                        end
                        ready3=1;
                    end
                end
                
                % Saving data
                data.dat{runNbr}{trial_Number(j)}.con_time_fromstart(rec_i,1) = GetSecs-start_while;
                data.dat{runNbr}{trial_Number(j)}.con_xy(rec_i,:) = [x-cir_center(1) cir_center(2)-y]./radius;
                data.dat{runNbr}{trial_Number(j)}.con_clicks(rec_i,:) = button;
                data.dat{runNbr}{trial_Number(j)}.con_r_theta(rec_i,:) = [curr_r/radius curr_theta/180]; %radius and degree?
            end
            data.dat{runNbr}{trial_Number(j)}.contRating_end_timestamp = GetSecs;
            if USE_EYELINK
                Eyelink('Message','Continuous rating ends');
            end
            
            %5. Delay2
            fixPoint(TrSt_t, Delay2(j)+14.5 + ITI(j) + 2 + Delay(j), white, '+')
            data.dat{runNbr}{trial_Number(j)}.Delay2_end_timestamp_end = GetSecs;
            if USE_EYELINK
            Eyelink('Message','Delay2 rating ends');
            end
        
            %6. Overall ratings
            cir_center = [(lb2+rb2)/2, H*3/4+100];
            SetMouse(cir_center(1), cir_center(2)); % set mouse at the center
            x=cir_center(1); y=cir_center(2);
            
            rec_i = 0;
            sTime=GetSecs;
            data.dat{runNbr}{trial_Number(j)}.overallRating_start_timestamp=sTime; % overall rating time stamp
            if USE_EYELINK
                Eyelink('Message','Overall rating starts');
            end
            
            while GetSecs - TrSt_t < 5 + Delay2(j)+14.5 + ITI(j) + 2 + Delay(j)
                if joystick
                    [pos, button] = mat_joy(0);
                    xAlpha=pos(1);
                    x=x+xAlpha*velocity_ovr;
                    yAlpha=pos(2);
                    y=y+yAlpha*velocity_ovr;
                else
                    [x,y,button]=GetMouse(theWindow);
                end
                %[x,y,button]=GetMouse(theWindow);
                rec_i= rec_i+1;
                % if the point goes further than the semi-circle, move the point to
                % the closest point
                % radius = (rb-lb)/2; % radius
                radius = (rb2-lb2)/2;
                theta = atan2(cir_center(2)-y,x-cir_center(1));
                % current euclidean distance
                curr_r = sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2);
                % current angle (0 - 180 deg)
                curr_theta = rad2deg(-theta+pi);
                % For control a mouse cursor:
                % send to diameter of semi-circle
                if y > cir_center(2)
                    y = cir_center(2);
                    SetMouse(x,y);
                end
                % send to arc of semi-circle
                if sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2) > radius
                    x = radius*cos(theta)+cir_center(1);
                    y = cir_center(2)-radius*sin(theta);
                    SetMouse(x,y);
                end
                msg = double(overall_unpl_Q_txt{j});
                Screen('TextSize', theWindow, fontsize);
                DrawFormattedText(theWindow, msg, 'center', 1/2*H-100, white, [], [], [], 2);
                draw_scale('overall_predict_semicircular')
                Screen('DrawDots', theWindow, [x y], 15, orange, [0 0], 1);
                Screen('Flip', theWindow);
                
                
                % Saving data
                data.dat{runNbr}{trial_Number(j)}.ovr_time_fromstart(rec_i,1) = GetSecs-sTime;
                data.dat{runNbr}{trial_Number(j)}.ovr_xy(rec_i,:) = [x-cir_center(1) cir_center(2)-y]./radius;
                data.dat{runNbr}{trial_Number(j)}.ovr_clicks(rec_i,:) = button;
                data.dat{runNbr}{trial_Number(j)}.ovr_r_theta(rec_i,:) = [curr_r/radius curr_theta/180];
                
                
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
            data.dat{runNbr}{trial_Number(j)}.overallRating_end_timestamp = GetSecs;
            if USE_EYELINK
                Eyelink('Message','Overall rating ends');
            end
            
            
            %
            SetMouse(0,0);
            Screen(theWindow,'FillRect',bgcolor, window_rect);
            Screen('Flip', theWindow);
            end_trial = GetSecs;
            % Saving trial sequence(i)
            data.dat{runNbr}{trial_Number(j)}.ts = ts{1,1}(j,:);
            data.dat{runNbr}{trial_Number(j)}.end_trial_t = end_trial;
            
        else
            %ONLY PAIN TRIAL          
            % 1. ITI (jitter) ( 3 - 7 )
            DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
            Screen('Flip', theWindow);
%             if ITI(j)<=3, ITI(j)=ITI(j)+2;end
            %-------------Ready for themal------------------
            WaitSecs(3);
            main(ip,port,1,program(j)); %select the program
            WaitSecs(0.5);
            main(ip,port,2); %ready to pre-start
            waitsec_fromstarttime(TrSt_t, ITI(j));
            % fixPoint(TrSt_t, ITI(j), white, '+') % ITI
            if USE_EYELINK
                Eyelink('Message','ITI ends');
            end
            data.dat{runNbr}{trial_Number(j)}.ITI_endtimestamp = GetSecs;
            
            % 2. HEAT and Ratings
            rec_i = 0;
            ready = 0;
            ready1=0;
            ready3=0;
            % set the mouse location to zero point
            %%cir_center = [(rb1+lb1)/2, bb];
            cir_center = [(lb1+rb1)/2 H*3/4+100];
            
            x=cir_center(1); y=cir_center(2);
            SetMouse(cir_center(1), cir_center(2)); % set mouse at the center
            % lb2 = W/3; rb2 = (W*2)/3; % new bound for or not
            start_while=GetSecs;
            if USE_EYELINK
                Eyelink('Message','Continuous rating start');
            end
            data.dat{runNbr}{trial_Number(j)}.contRating_start_timestamp = start_while;
            while GetSecs - TrSt_t < 14.5 + ITI(j)
                if joystick
                    [pos, button] = mat_joy(0);
                    xAlpha=pos(1);
                    x=x+xAlpha*velocity_cot;
                    yAlpha=pos(2);
                    y=y+yAlpha*velocity_cot;
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
                if y > cir_center(2)%%bb
                    y = cir_center(2); %%bb;
                    SetMouse(x,y);
                end
                % send to arc of semi-circle
                if sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2) > radius
                    x = radius*cos(theta)+cir_center(1);
                    y = cir_center(2)-radius*sin(theta);
                    SetMouse(x,y);
                end
%                 msg = '이번 자극이 최대 얼마나 아플까요?';
%                 msg = double(msg);
%                 DrawFormattedText(theWindow, msg, 'center', 150, orange, [], [], [], 2);
                draw_scale('cont_predict_semicircular');
                Screen('DrawDots', theWindow, [x y], 15, orange, [0 0], 1);
                Screen('Flip', theWindow);
                
                
                % thermodePrime(ip, port, ts_program(j))
                if ready3 == 0
                    if GetSecs - start_while > 1
                        tic;
                        data.dat{runNbr}{trial_Number(j)}.heat_start_txt = main(ip,port,2); % start heat signal
                        data.dat{runNbr}{trial_Number(j)}.duration_heat_trigger = toc;
                        data.dat{runNbr}{trial_Number(j)}.heat_start_timestamp = GetSecs; % heat-stimulus time stamp
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

                % Saving data
                data.dat{runNbr}{trial_Number(j)}.con_time_fromstart(rec_i,1) = GetSecs-start_while;
                data.dat{runNbr}{trial_Number(j)}.con_xy(rec_i,:) = [x-cir_center(1) cir_center(2)-y]./radius;
                data.dat{runNbr}{trial_Number(j)}.con_clicks(rec_i,:) = button;
                data.dat{runNbr}{trial_Number(j)}.con_r_theta(rec_i,:) = [curr_r/radius curr_theta/180]; %radius and degree?
            end
            data.dat{runNbr}{trial_Number(j)}.contRating_end_timestamp = GetSecs;
            if USE_EYELINK
                Eyelink('Message','Continuous rating ends');
            end
            
            %5. Delay2
            fixPoint(TrSt_t, Delay2(j)+ 14.5 + ITI(j), white, '+')
            data.dat{runNbr}{trial_Number(j)}.Delay2_end_timestamp_end = GetSecs;
            if USE_EYELINK
                Eyelink('Message','Delay2 rating ends');
            end
            
            
            %6. Overall ratings
            cir_center = [(lb2+rb2)/2, H*3/4+100];
            SetMouse(cir_center(1), cir_center(2)); % set mouse at the center
            x=cir_center(1); y=cir_center(2);
            
            rec_i = 0;
            ready2=0;
            sTime=GetSecs;
            if USE_EYELINK
                Eyelink('Message','Overall rating starts');
            end
            data.dat{runNbr}{trial_Number(j)}.overallRating_start_timestamp=sTime; % overall rating time stamp
            while GetSecs - TrSt_t < 5 + Delay2(j)+14.5 + ITI(j) % overall rating 5 seconds
                if joystick
                    [pos, button] = mat_joy(0);
                    xAlpha=pos(1);
                    x=x+xAlpha*velocity_ovr;
                    yAlpha=pos(2);
                    y=y+yAlpha*velocity_ovr;
                else
                    [x,y,button]=GetMouse(theWindow);
                end
                % [x,y,button]=GetMouse(theWindow);
                rec_i= rec_i+1;
                % if the point goes further than the semi-circle, move the point to
                % the closest point
                % radius = (rb-lb)/2; % radius
                radius = (rb2-lb2)/2;
                theta = atan2(cir_center(2)-y,x-cir_center(1));
                % current euclidean distance
                curr_r = sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2);
                % current angle (0 - 180 deg)
                curr_theta = rad2deg(-theta+pi);
                % For control a mouse cursor:
                % send to diameter of semi-circle
                if y > cir_center(2)
                    y = cir_center(2);
                    SetMouse(x,y);
                end
                % send to arc of semi-circle
                if sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2) > radius
                    x = radius*cos(theta)+cir_center(1);
                    y = cir_center(2)-radius*sin(theta);
                    SetMouse(x,y);
                end
                msg = double(overall_unpl_Q_txt{j});
                Screen('TextSize', theWindow, fontsize);
                DrawFormattedText(theWindow, msg, 'center', 1/2*H-100, white, [], [], [], 2);
                draw_scale('overall_predict_semicircular')
                Screen('DrawDots', theWindow, [x y], 15, orange, [0 0], 1);
                Screen('Flip', theWindow);
                
                
                % Saving data
                data.dat{runNbr}{trial_Number(j)}.ovr_time_fromstart(rec_i,1) = GetSecs-sTime;
                data.dat{runNbr}{trial_Number(j)}.ovr_xy(rec_i,:) = [x-cir_center(1) cir_center(2)-y]./radius;
                data.dat{runNbr}{trial_Number(j)}.ovr_clicks(rec_i,:) = button;
                data.dat{runNbr}{trial_Number(j)}.ovr_r_theta(rec_i,:) = [curr_r/radius curr_theta/180];
                
                
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
            data.dat{runNbr}{trial_Number(j)}.overallRating_end_timestamp = GetSecs;
            if USE_EYELINK
                Eyelink('Message','Overall rating ends');
            end
            
            %
            SetMouse(0,0);
            Screen(theWindow,'FillRect',bgcolor, window_rect);
            Screen('Flip', theWindow);
            end_trial = GetSecs;
            % Saving trial sequence(i)
            data.dat{runNbr}{trial_Number(j)}.ts = ts{1,1}(j,:);
            data.dat{runNbr}{trial_Number(j)}.end_trial_t = end_trial;
        end
        % send a stop program signal
        %if end_trial - (data.dat{runNbr}{trial_Number(j)}.contRating_end_stamp_end + 1) < 10, main(ip,port,5); end
        % data.dat{runNbr}{trial_Number(j)}.ramp_up_cnd = ramp_up_con(j);
        if mod(trial_Number(j),2) == 0, save(data.datafile, '-append', 'data'); end % save data every two trials
        % waitsec_fromstarttime(end_trial, 1); % For your rest,
    end
    data.run_endtime_timestamp{runNbr}=GetSecs;
    
    if USE_EYELINK
        Eyelink('Message','Run ends');
        eyelink_main(edfFile, 'Shutdown');
    end
    
    if USE_BIOPAC %end BIOPAC
        bio_t = GetSecs;
        data.dat{runNbr}{trial_Number(j)}.biopac_endtime = bio_t;% biopac end timestamp
        BIOPAC_trigger(ljHandle, biopac_channel, 'on');
        waitsec_fromstarttime(bio_t, 0.1);
        BIOPAC_trigger(ljHandle, biopac_channel, 'off');
    end
    
    save(data.datafile, '-append', 'data');
    
    %closing message utill stoke specific keyboard
    if runNbr==6
        Screen('Flip',theWindow);
        WaitSecs(10);
        display_expmessage('모든 실험이 종료되었습니다\n잠시만 기다려주세요');
    else
        Screen('Flip',theWindow);
        WaitSecs(10);
        display_expmessage('잠시만 기다려주세요.');
    end
    
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('q'))==1
            break
        elseif keyCode(KbName('space'))== 1
            break
        end
    end
    
    ShowCursor();
    Screen('Clear');
    Screen('CloseAll');
    disp('Done');

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
            case {'IP'}
                str = 'No information about IP adress';
        end
    end
end


ShowCursor; %unhide mouse
Screen('CloseAll'); %relinquish screen control
disp(str); %present this text in command window

end