% INFORMATION
% Start date: 17/11/27
% Name: Suhwan Gim
% : A calibraition for heat-pain machine
%
% -----------------------------------------------
% 1. Degree of first three heat-stimulations is randomly given at any skin sites:[41 44 47]
% 2. After calculate the linear regression,

%% Global variable
global theWindow W H; % window property
global white red orange bgcolor; % color
global window_rect prompt_ex lb rb tb bb scale_H promptW promptH; % rating scale
global fontsize anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd; % anchors
global reg; % regression data



%%

Screen('Clear');
Screen('CloseAll');
window_num = 0;
window_rect = [1 1 1200 720]; % in the test mode, use a little smaller screen
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
% anchor_lms = [0.014 0.061 0.172 0.354 0.533].*(rb-lb)+lb;

%% Parameter
stimText = '+';



%%
cir_center = [(rb+lb)/2, bb];
radius = (rb-lb)/2; % radius
deg = 180-normrnd(0.5, 0.1, 20, 1)*180; % convert 0-1 values to 0-180 degree
deg(deg > 180) = 180;
deg(deg < 0) = 0;
th = deg2rad(deg);
x = radius*cos(th)+cir_center(1);
y = cir_center(2)-radius*sin(th);

%% skin site
rng('shuffle');
% reg.skin_site = repmat({1,2,3,4,5,6}, 1, 3); % Five combitnations
for i = 1:3 % 6(Skin sites:1 to 6) x 3 (number of stimulation) combination
    reg.skin_site(i*6-5:i*6,1) = randperm(6); % [1 2 3 4 5 6] [2 3 1 4 6 5] ......
end

%% Pathway program (50 to 64) / [degree decValue ProgramName]
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
%        for ii=1:15
%            disp(bin2dec(PathPrg{ii,2}));
%        end
%        bin2dec(PathPrg{i,2});

%%
theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % For alpha value of color: [R G B alpha]
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
Screen('TextFont', theWindow, font); % setting font
Screen('TextSize', theWindow, fontsize);
%% START: Calibration
%0. Instructions
try
    display_expmessage('���ݺ��� Calibration�� �����ϰڽ��ϴ�.\n�����ڴ� �����ϰ� ��ð� �������� ���ø� �����ֽñ� �ٶ��ϴ�.');
    WaitSecs(1);
    for i=1:18 %Total trial
        random_value = randperm(3);
        % manipulate the current stim
        if i<4
            init_stim={'00110010' '00111000' '00111110'}; %���α׷��ڵ�� [41 44 47]
            current_stim=bin2dec(init_stim{random_value(i)}); 
        else
            current_stim=reg.cur_heat_LMH(i/3); % random
            %���α׷��ڵ�: reg.cur_heat_LMH(randperm(3,1))
        end
        
        %1. Display where the skin site stimulates (1-6)
        msg = strcat('���� ��ġ�� thermode�� �̵��Ͻ� �� SPACE Ű�� �����ʽÿ�: ', num2str(reg.skin_site(i)));
        while (1)
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('space'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_man;
            end
            display_expmessage(msg);
        end
        
        %2. Fixation
        start_fix = GetSecs; % Start_time_of_Fixation_Stimulus
        DrawFormattedText(theWindow, double(stimText), 'center', 'center', color, [], [], [], 1.2);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(start_fix, 2);
        
        %3. Stimulation
        main(ip,port,1,current_stim); %trigerring heat-pain %
        
        start_while=GetSecs;
        while GetSecs - start_while < 10 % same as the test,
            resp = main(ip,port,0); % get system status
            systemState = resp{4}; testState = resp{5};
            if strcmp(systemState, 'Pathway State: TEST') && strcmp(testState,'Test State: RUNNING')
                start_stim=GetSecs;
                waitsec_fromstarttime(start_stim,10);
                break;
            else
                %do nothing
            end
        end
        
        %4. Ratings
        start_ratings=GetSecs;
        while GetSecs - start_ratings < 10 % Under 10 seconds,
            [x,y,button] = GetMouse(theWindow);
            rating_type = 'semicircular';
            draw_scale('overall_avoidance_semicircular');
            Screen('DrawDots', theWindow, [x y]', 14, [255 164 0 130], [0 0], 1);  %dif color
            
            % if the point goes further than the semi-circle, move the point to
            % the closest point
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
            theta = rad2deg(theta);
            theta = 180-theta;
            
            vas_rating = theta/180*100; % [0 180] to [0 100]
            
            %For draw theta text on 'theWindow' screen
            % theta = num2str(theta);
            % DrawFormattedText(theWindow, theta, 'center', 'center', white, [], [], [], 1.2);
            % disp(theta);
            Screen('Flip',theWindow);
            
            %
            
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
        DrawFormattedText(theWindow, double(stimText), 'center', 'center', color, [], [], [], 1.2);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(start_fix, 3);
        
        %6. Linear regression (excuted from 4th trial)
        % IF: 1-3rd trial
        %                : [41 44 47] randomized matrix --> End
        % or
        % ELSEIF 4th~18th trial
        %                : create converted rating 30 50 70 matrix from below flow
        %           --> Calculating converted rating from linear regrssion
        %           --> Selete the closest degree of heat pain program
        %           --> End
        % END
        if current_stim?
            degree? fghfg
        end
        
        degree? 
        rating? 
        if i<4
            cali_regression (degree, rating, i); % cali_regression (stim_degree, rating, order of trial)
        else
            cali_regression (degree, rating, i);
        end
        
    end %trial end
    
    % End of calibration
    start_endMsg = GetSecs;
    msg='Ķ���극�̼��� ����Ǿ����ϴ�\n���� �������� ���ø� �����ֽñ� �ٶ��ϴ�';
    display_expmessage(msg);
    waitsec_fromstarttime(start_endMsg, 10);
    sca;
    Screen('CloseAll');
    
catch err
    % ERROR
    disp(err);
    for i = 1:numel(err.stack)
        disp(err.stack(i));
    end
    abort_experiment;
end

