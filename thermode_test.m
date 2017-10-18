function thermode_test(ip, port)
%% INFORMATION
%
% This code is only for testing external contorl of Pathway
% 
% by Suwhan Gim (roseno.9@daum.net) 
% 2017-10-17 

%% EXAMPEL of PROGRAM code
% dec2bin(100) -> ans = 1100100
% 
% MATLAB VALUE, PATHWAY VALUE = (100,1100100)
% For example
% ---------------------------------------------------------
% '100: Ramp-up 2sec' 1100100
% '101: Ramp-up 4sec' 1100101
% '102: Ramp-up 6sec' 1100110
%% GLOBAL vaiable
 global theWindow W H; % window property
 global white red orange bgcolor; % color
 global window_rect prompt_ex lb rb tb bb scale_H promptW promptH; % rating scale
 global fontsize anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd; % anchors


%% RAMP-UP Randoization (Strafied randoization)
for i = 1:15 % 3(2,4,6sec) x 15 other combination
    program(i*3-2:i*3) = randperm(3) + 99; % [1 2 3] [2 3 1] ......
end

%% SETUP: Screen 
    window_num = 0;
    window_rect = [1 1 800 640]; % in the test mode, use a little smaller screen
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

%% EXPERIEMENT START
 
% START
	theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
    Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
    %Screen('TextFont', theWindow, font); % setting font
    Screen('TextSize', theWindow, fontsize);
     

% TRIAL
    for j = 1:length(program)
        % MESSAGE
        % Screen(theWindow,'FillRect',bgcolor, window_rect);
        % DrawFormattedText(theWindow, 'Press spacebar to begin stimulation\n', 'center', 'center', white, [], [], [], 1.5);
        % Screen('Flip', theWindow);    
    % ITI (jitter)
        fixPoint(5, white) % Jitter manipulation should added, now fix 5
    % Cue
        % draw_socia_cue(m, std, n, rating_type)
        rating_type = 'semicircular';
        draw_scale('overall_avoidance_semicircular');
        draw_social_cue(0.5, 0.5, 10, rating_type);
        Screen('Flip', theWindow);
        % WaitSecnods(2);
        KbStrokeWait;
    % Delay
        fixPoint(0, white)
    % HEAT and Ratings
        % thermodePrime(ip, port, program(j))
        % KbStrokeWait;
        fixPoint(0, red)
        draw_scale('overall_avoidance_semicircular')
        SetMouse(cir_center(1), cir_center(2)); % set mouse at the center
        lb2 = W/3; rb2 = (W*2)/3; % new bound for or not
        responseStr = main(ip,port,1,program(j)); 
        Screen('Flip', theWindow);
        
        
        if checkStatus(ip,port) 
            sTime = GetSecs;
            while GetSecs - sTime <= 15
                %wait till pain finishes
            end
            main(ip,port,5); % Stop
        end

    end

Screen('Close')
Screen('CloseAll')
end

function fixPoint(seconds, color)
        global theWindow white red;
        stimText = '+';
        % Screen(theWindow,'FillRect', bgcolor, window_rect); 
        DrawFormattedText(theWindow, double(stimText), 'center', 'center', color, [], [], [], 1.2);
        Screen('Flip', theWindow);
        WaitSecs(seconds);
end
