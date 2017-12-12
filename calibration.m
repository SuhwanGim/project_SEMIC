% INFORMATION 
% Start date: 17/11/27 
% Name: Suhwan Gim 
% : A calibraition for heat-pain machine
% --------------------------------------------------------------------------
% 1.Degree of first three heat-stimulations is randomly given at any skin
% sites:[41 44 47] 2. After calculate the linear regression,
%%

%%
clear;
close all;

%% Global variable
global theWindow W H; % window property
global white red orange bgcolor; % color
global window_rect prompt_ex lb rb tb bb scale_H promptW promptH; % rating scale
global fontsize anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd; % anchors
global reg; % regression data

%% SETUP: DATA and Subject INFO
scriptdir = '/Users/cocoan/Dropbox/github/';
savedir = 'Cali_Semic_data';
[fname,~, SID] = subjectinfo_check_SEMIC(savedir,1); % subfunction %start_trial
% save data using the canlab_dataset object
reg.version = 'SEMIC_Calibration_v1_04-12-2017_Cocoanlab';
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
window_rect = [2 2 800 600]; % in the test mode, use a little smaller screen
%window_rect = [0 0 1900 1200];
fontsize = 20;
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
% anchor_lms = [0.0200 0.1069 0.3123 0.6490 0.9801].*(rb-lb)+lb  % adapted
% anchor_lms = [0.014 0.061 0.172 0.354 0.533].*(rb-lb)+lb; for VAS

%% Parameter
NumOfTr = 12;
stimText = '+';
init_stim={'00110010' '00111000' '00111110'}; % Initial degree of heat pain [41 44 47]
% Pathway setting
ip = '203.252.46.249'; % should activate both 'external control' and 'automatic start' options
port = 20121;
% save?
save(reg.datafile,'reg','init_stim');
%% 
cir_center = [(rb+lb)/2, bb];
radius = (rb-lb)/2; % radius
deg = 180-normrnd(0.5, 0.1, 20, 1)*180; % convert 0-1 values to 0-180 degree
deg(deg > 180) = 180;
deg(deg < 0) = 0;
th = deg2rad(deg);
x = radius*cos(th)+cir_center(1);
y = cir_center(2)-radius*sin(th);

%% skin site / LMH sequence
rng('shuffle');
% reg.skin_site = repmat({1,2,3,4,5,6}, 1, 3); % Five combitnations
for i = 1:3 % 4(Skin sites:1 to 4) x 3 (number of stimulation) combination
    reg.skin_site(i*4-3:i*4,1) = randperm(4); % [1 2 3 4] [2 3 1 4] ......
end

for z = 1:4 % four skin_site %Each skin site stimulated by LMH heat-pain
    [I, V] = find(reg.skin_site==z); % [Index, Value]
    rn=randperm(3);
    for zz=1:size(I,1)
        reg.skin_LMH(I(zz)) = rn(zz); 
    end
end

%% Pathway program (50 to 64) /
% :: It will be adjusted each settings of study Example:[degree decValue
% ProgramNameInPathway]
PathPrg = {41 '00110010' 'SEMIC_41'; ...
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
%%
theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % For alpha value of e.g.,[R G B alpha]
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
Screen('TextFont', theWindow, font); % setting font
Screen('TextSize', theWindow, fontsize);
%% START: Calibration
try
    %0. Instructions
    display_expmessage('지금부터 Calibration을 시작하겠습니다.\n참가자는 편안하게 계시고 진행자의 지시를 따라주시기 바랍니다.');
    WaitSecs(1);
    random_value = randperm(3);
    for i=1:NumOfTr %Total trial
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
        
        %1. Display where the skin site stimulates (1-6)
        msg = strcat('다음 위치의 thermode를 이동하신 후 SPACE 키를 누르십시오 :  ', num2str(reg.skin_site(i)));
        while (1)
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('space'))==1
                break;
            elseif keyCode(KbName('q'))==1
                abort_experiment;
            end
            display_expmessage(msg);
        end
        
        %2. Fixation
        start_fix = GetSecs; % Start_time_of_Fixation_Stimulus
        DrawFormattedText(theWindow, double(stimText), 'center', 'center', white , [], [], [], 1.2);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(start_fix, 2);
        
%         %3. Stimulation
%         main(ip,port,1,current_stim); %trigerring heat-pain %
%         
%         start_while=GetSecs;
%         while GetSecs - start_while < 10 % same as the test,
%             resp = main(ip,port,0); % get system status
%             systemState = resp{4}; testState = resp{5};
%             if strcmp(systemState, 'Pathway State: TEST') && strcmp(testState,'Test State: RUNNING')
%                 start_stim=GetSecs;
%                 waitsec_fromstarttime(start_stim,10);
%                 break;
%             else
%                 %do nothing
%             end
%         end
        
        %4. Ratings
        start_ratings=GetSecs;
        cir_center = [(rb+lb)/2, bb];
        SetMouse(cir_center(1), cir_center(2));
        while GetSecs - start_ratings < 10 % Under 10 seconds,
            [x,y,button] = GetMouse(theWindow);
            rating_type = 'semicircular';
            draw_scale('overall_avoidance_semicircular');
            Screen('DrawDots', theWindow, [x y]', 14, [255 164 0 130], [0 0], 1);  %dif color
            
            % if the point goes further than the semi-circle, move the
            % point to the closest point
            radius = (rb-lb)/2; % radius
            theta = atan2(cir_center(2)-y,x-cir_center(1));
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
            
            draw_scale('overall_avoidance_semicircular');
            
            %For draw theta text on 'theWindow' screen
            % theta = num2str(theta); DrawFormattedText(theWindow, theta,
            % 'center', 'center', white, [], [], [], 1.2);
            disp(theta);
            disp(i);
            disp(current_stim);
            Screen('Flip',theWindow);
            
            % Feedback
            if button(1)
                draw_scale('overall_avoidance_semicircular');
                Screen('DrawDots', theWindow, [x y]', 18, red, [0 0], 1);  % Feedback
                Screen('Flip',theWindow);
                WaitSecs(1);
                break; % break for "if"
            end
        end
        
        %5. Inter-stimulus inteval, 3 seconds
        start_fix = GetSecs; % Start_time_of_Fixation_Stimulus
        DrawFormattedText(theWindow, double(stimText), 'center', 'center', white, [], [], [], 1.2);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(start_fix, 3);
        
        %6. Linear regression (excuted from 4th trial)
        % IF: 1-3rd trial
        %                : [41 44 47] randomized matrix --> End
        % or ELSEIF 4th~18th trial
        %                : create converted rating 30 50 70 matrix from
        %                below flow
        %           --> Calculating converted rating from linear regrssion
        %           --> Selete the closest degree of heat pain program -->
        %           End
        % END
        
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
        
        %calibration
        cali_regression (degree, vas_rating, i, NumOfTr); % cali_regression (stim_degree in this trial, rating, order of trial, Number of Trial)       
        save(reg.datafile, '-append', 'reg');
    end %trial 
    

    
    % End of calibration
    save(reg.datafile, '-append', 'reg');
    reg.endtime_getsecs = GetSecs;
    msg='캘리브레이션이 종료되었습니다\n이제 실험자의 지시를 따라주시기 바랍니다';
    display_expmessage(msg);
    waitsec_fromstarttime(reg.endtime_getsecs, 10);
    sca;
    Screen('CloseAll');
    
    % disp(best skin site)
    disp(reg.studySkinSite);
catch err
    % ERROR
    disp(err);
    for i = 1:numel(err.stack)
        disp(err.stack(i));
    end
    abort_experiment;
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


