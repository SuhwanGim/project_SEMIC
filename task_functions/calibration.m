function calibration(SID, ip, port, varargin)
%%INFORMATION
% This function is for finding each participant's a pain space. There are
% sub-fucntions and cali_regression function. This functino is for
% calculating a linear line.
% : A calibraition for heat-pain machine
%
% See also cali_regression

%%
%% Parse varargin
testmode = false;
joystick = false;
for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            case {'test'}
                testmode = true;
            case {'joystick'}
                joystick=true;
        end
    end
end
%% Global variable
global theWindow W H; % window property
global white red orange bgcolor; % color
global window_rect prompt_ex lb rb tb bb scale_H promptW promptH; % rating scale
global lb1 rb1 lb2 rb2;% % For larger semi-circular
global fontsize anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd; % anchors
global reg; % regression data

%% SETUP: DATA and Subject INFO
savedir = 'Cali_Semic_data';
[fname, start_trial , SID] = subjectinfo_check_SEMIC(SID, savedir,1,'Cali'); % subfunction %start_trial
% save data using the canlab_dataset object
reg.version = 'SEMIC_Calibration_v1_01-03-2018_Cocoanlab';
reg.subject = SID;
reg.datafile = fname;
reg.starttime = datestr(clock, 0); % date-time
reg.starttime_getsecs = GetSecs; % in the same format of timestamps for each trial
%%
addpath(genpath(pwd));
%%
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
% anchor_semic = [0.1000 0.2881 0.5966 0.9000] % adjusted for SEMIC
% anchor_lms = [0.014 0.061 0.172 0.354 0.533].*(rb-lb)+lb; for VAS

%% SETUP: Parameter
motorN = 4; % number of motor practice trial
NumOfTr = 12;
stimText = '+';
init_stim={'00101111' '00111001' '01000011'}; % Initial degrees of a heat pain [43.4 45.4 47.4]
rating_type = 'semicircular';
velocity = cal_vel_joy('overall');
start_value =1;

% save?
save(reg.datafile,'reg','init_stim');
%%
% cir_center = [(rb+lb)/2, bb];
% radius = (rb-lb)/2; % radius
cir_center = [(lb2+rb2)/2, H*3/4+100];
radius = (rb2-lb2)/2;

deg = 180-normrnd(0.5, 0.1, 20, 1)*180; % convert 0-1 values to 0-180 degree
deg(deg > 180) = 180;
deg(deg < 0) = 0;
th = deg2rad(deg);
% x = radius*cos(th)+cir_center(1);
% y = cir_center(2)-radius*sin(th);
%% SETUP: the pathway program
PathPrg = load_PathProgram('SEMIC');
%% Setup: generate sequence of skin site and LMH (Low, middle and high)
rng('shuffle');
% % reg.skin_site = repmat({1,2,3,4,5,6}, 1, 3); % Five combitnations
% for i = 1:3 % 4(Skin sites:1 to 4) x 3 (number of stimulation) combination
%     reg.skin_site(i*4-3:i*4,1) = randperm(4); % [1 2 3 4] [2 3 1 4] ......
% end
%
% for z = 1:4 % four skin_site %Each skin site stimulated by LMH heat-pain
%     [I, ~] = find(reg.skin_site==z); % [Index, Value]
%     rn=randperm(3);
%     for zz=1:size(I,1)
%         reg.skin_LMH(I(zz)) = rn(zz);
%     end
% end

reg.skin_site = zeros(12,1);

while sum(prod(reshape(reg.skin_site, 4, 3))==24)~=3
    reg.skin_LMH = repmat(1:3, 4, 1)';
    reg.skin_LMH = reg.skin_LMH(:);
    
    reg.skin_site = zeros(12,1);
    for i = 1:3
        reg.skin_site(reg.skin_LMH == i) = randperm(4); % site mix
    end
    
    for i = 1:4
        idx = (i-1)*3+1:(i-1)*3+3;
        temp = reg.skin_site(idx);
        mix_temp = randperm(3);
        reg.skin_site(idx) = temp(mix_temp);
        reg.skin_LMH(idx) = mix_temp;
    end
    
end
%% START: Screen
theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % For alpha value of e.g.,[R G B alpha]
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
Screen('TextFont', theWindow, font); % setting font
Screen('TextSize', theWindow, fontsize);
%% START: Experiment
%: Motor_practice --> calibration

try
    if start_trial == 1
        %PART0. Motor_practice (3-4 trials)
        % 1. pathwaty test
        pathway_test(ip, port, 'basic');
        
        % 2. Moving dot part
        for i=1:motorN % Four trials
            % -1.1. Fixation point
            fixPoint(2, white, stimText);
            % -1.2. Moving dot part
            ready = 0;
            moving_start_timestamp = GetSecs;
            
            SetMouse(cir_center(1), cir_center(2));
            x=cir_center(1); y=cir_center(2);
            while GetSecs - moving_start_timestamp < 5
                while ~ready
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
                    %[x,y,button] = GetMouse(theWindow);
                    draw_scale('overall_predict_semicircular');
                    Screen('DrawDots', theWindow, [x y]', 14, [255 164 0 130], [0 0], 1);  % Cursor
                    % if the point goes further than the semi-circle, move the point to
                    % the closest point
                    radius = (rb2-lb2)/2;%radius = (rb-lb)/2; % radius
                    theta = atan2(cir_center(2)-y,x-cir_center(1));
                    if y > cir_center(2) %bb
                        y = cir_center(2);
                        SetMouse(x,y);
                    end
                    % send to arc of semi-circle
                    if sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2) > radius
                        x = radius*cos(theta)+cir_center(1);
                        y = cir_center(2)-radius*sin(theta);
                        SetMouse(x,y);
                    end
                    Screen('Flip',theWindow);
                    
                    if button(1)
                        button_click_timestamp=GetSecs; %
                        draw_scale('overall_predict_semicircular');
                        Screen('DrawDots', theWindow, [x y]', 18, red, [0 0], 1);  % Feedback
                        Screen('Flip',theWindow);
                        WaitSecs(.5);
                        ready = 1;
                        break;
                    end
                end
                fixPoint(0, white, '');
                Screen('Flip', theWindow);
            end
            moving_end_timestamp = GetSecs;
        end
    else
        start_value = start_trial; 
    end
    
    
    
    %PART1. Calibrtaion
    % 0. Instructions
    display_expmessage('지금부터는 캘리브레이션을 시작하겠습니다.\n참가자는 편안하게 계시고 진행자의 지시를 따라주시기 바랍니다.');
    WaitSecs(3);
    random_value = randperm(3); %randomized order for 1st, 2nd and 3rd stimulus
    for i=start_value:NumOfTr %Total trial
        reg.trial_start_timestamp{i,1}=GetSecs; % trial_star_timestamp
        % manipulate the current stim
        if i<4
            current_stim=bin2dec(init_stim{random_value(i)});
        else
            % current_stim=reg.cur_heat_LMH(i,rn); % random
            for iiii=1:length(PathPrg) %find degree
                if reg.cur_heat_LMH(i,reg.skin_LMH(i)) == PathPrg{iiii,1}
                    current_stim = bin2dec(PathPrg{iiii,2});
                else
                    % do nothing
                end
            end
        end
        
        % 1. Display where the skin site stimulates (1-6)
        WaitSecs(2);
        main(ip,port,1,current_stim); % Select the program
        WaitSecs(1);
        main(ip,port,2,current_stim); % Pre-start
        msg = strcat('연구자는 다음 위치의 열패드를 이동하신 후 SPACE 키를 누르십시오 :  ', num2str(reg.skin_site(i)));
        while (1)
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('space'))==1
                break;
            elseif keyCode(KbName('q'))==1
                abort_experiment;
            end
            display_expmessage(msg);
        end
        
        % 2. Fixation
        start_fix = GetSecs; % Start_time_of_Fixation_Stimulus
        DrawFormattedText(theWindow, double(stimText), 'center', 'center', white , [], [], [], 1.2);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(start_fix, 2);
        
        % 3. Stimulation
        start_while=GetSecs;
        ready=0;
        while GetSecs - start_while < 12.5 % same as the test,
            Screen('Flip', theWindow);
            if ~ready
                main(ip,port,2); % start thermal pain
                ready=1;
            end
        end
        
        % Fixation
        start_fix = GetSecs; % Start_time_of_Fixation_Stimulus
        DrawFormattedText(theWindow, double(stimText), 'center', 'center', white , [], [], [], 1.2);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(start_fix, 2);
        
        % 4. Ratings
        start_ratings=GetSecs;
        SetMouse(cir_center(1), cir_center(2));
        x=cir_center(1); y=cir_center(2);
        
        while GetSecs - start_ratings < 10 % Under 10 seconds,
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
            %[x,y,button] = GetMouse(theWindow);
            msg = double('얼마나 아팠나요?');
            Screen('TextSize', theWindow, fontsize);
            DrawFormattedText(theWindow, msg, 'center', 1/2*H-100, white, [], [], [], 2);
            draw_scale('overall_predict_semicircular');
            Screen('DrawDots', theWindow, [x y]', 14, [255 164 0 130], [0 0], 1);  %dif color
            
            % if the point goes further than the semi-circle, move the
            % point to the closest point
            radius = (rb2-lb2)/2; %radius = (rb-lb)/2; % radius
            theta = atan2(cir_center(2)-y,x-cir_center(1));
            if y > cir_center(2) %bb
                y = cir_center(2);
                SetMouse(x,y);
            end
            % send to arc of semi-circle
            if sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2) > radius
                x = radius*cos(theta)+cir_center(1);
                y = cir_center(2)-radius*sin(theta);
                SetMouse(x,y);
            end
            
            Screen('Flip',theWindow);
            
            % Feedback
            if button(1)
                draw_scale('overall_predict_semicircular');
                Screen('DrawDots', theWindow, [x y]', 18, red, [0 0], 1);  % Feedback
                Screen('Flip',theWindow);
                WaitSecs(1);
                break; % break for "if"
            end
        end
        while GetSecs - start_ratings < 10
            if button(1)
                Screen('Flip',theWindow);
            end
        end
        
        % 5. Inter-stimulus inteval, 3 seconds
        start_fix = GetSecs; % Start_time_of_Fixation_Stimulus
        DrawFormattedText(theWindow, double(stimText), 'center', 'center', white, [], [], [], 1.2);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(start_fix, 3);
        
        theta = rad2deg(theta);
        theta = 180-theta;
        vas_rating = theta/180*100; % [0 180] to [0 100]
        
        for iii=1:length(PathPrg) %find degree
            if str2double(dec2bin(current_stim)) == str2double(PathPrg{iii,2})
                degree = PathPrg{iii,1};
            else
                % do nothing
            end
        end
        
        %Calculating regression line
        reg.trial_end_timestamp{i,1}=GetSecs;
        cali_regression (degree, vas_rating, i, NumOfTr); % cali_regression (stim_degree in this trial, rating, order of trial, Number of Trial)
        save(reg.datafile, '-append', 'reg');
    end %trial
    
    
    
    % End of calibration
    %reg.stduySkinSite_ts = [reg.stduySkinSite reg.stduySkinSite];
    reg.endtime_getsecs = GetSecs;
    
    reg.skinSite_rs = [0,0,0,0,0,0];
    
    
    while ~((numel(find(diff(reg.skinSite_rs)==0))) < 1)
        rng('shuffle');
        reg.skinSite_rs = [reg.studySkinSite reg.studySkinSite];
        reg.skinSite_rs=reg.skinSite_rs(randperm(6));
    end
    
    
    save(reg.datafile, '-append', 'reg');
    msg='캘리브레이션이 종료되었습니다\n이제 연구자의 지시를 따라주시기 바랍니다';
    display_expmessage(msg);
    waitsec_fromstarttime(reg.endtime_getsecs, 10);
    sca;
    ShowCursor();
    Screen('CloseAll');
    
    % disp(best skin site)
    % disp(reg.studySkinSite);
    %
    % ---------------------------------------------------------------------
    % IF Rsquared value of fitted line was below 0.4, display this message
    % This value is our criteria for screen experiment .
    % ---------------------------------------------------------------------
    if reg.total_fit.Rsquared.Ordinary <= 0.4
        disp("===================WARNING=======================");
        disp("=================================================");
        disp("PLEASE, check calibration data carefully.");
        disp("This participant may inappripriate for pain experiment");
        disp("=================================================");
    end
        
        
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
global theWindow;
% stimText = '+';
% Screen(theWindow,'FillRect', bgcolor, window_rect);
start_fix = GetSecs; % Start_time_of_Fixation_Stimulus
DrawFormattedText(theWindow, double(stimText), 'center', 'center', color, [], [], [], 1.2);
Screen('Flip', theWindow);
waitsec_fromstarttime(start_fix, seconds);
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


