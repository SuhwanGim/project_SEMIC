%% GLOBAL vaiable
global theWindow W H; % window property
global white red red_Alpha orange bgcolor yellow; % color
global window_rect prompt_ex lb rb tb bb scale_H promptW promptH; % rating scale
global lb1 rb1 lb2 rb2;
global fontsize anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd; % anchors

sss
%%

Screen('Clear');
Screen('CloseAll');
window_num = 0;
window_rect = [1 1 1280 720]; % in the test mode, use a little smaller screen
fontsize = 20;


W = window_rect(3); %width of screen
H = window_rect(4); %height of screen

font = 'NanumBarunGothic';

bgcolor = 80;
white = 255;
red = [255 0 0];
red_Alpha = [255  164 0 130]; % RGB + A(Level of tranceprency: for social Cue)
orange = [255 164 0];
yellow = [255 220 0];

% rating scale left and right bounds 1/5 and 4/5
lb = 1.5*W/5; % in 1280, it's 384
rb = 3.5*W/5; % in 1280, it's 896 rb-lb = 512

% bigger rating scale
% see draw_scale.m
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


theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
Screen('Preference', 'SkipSyncTests', 0);
%Screen('TextFont', theWindow, font); % setting font
Screen('TextSize', theWindow, fontsize);


% cir_center = [(rb+lb)/2, bb];
% SetMouse(cir_center(1), cir_center(2)); % set mouse at the center

xcenter = (lb1+rb1)/2;
ycenter = H*3/4+100;

cir_center = [(lb2+rb2)/2, H*3/4+100];
radius = (rb2-lb2)/2;


%% EXPERIEMENT START
rating_type = 'semicircular';
joystick = true;
%% Explain
% exp_scale('predict',joystick)

% %% d
% draw_scale('overall_predict_semicircular');
% draw_social_cue(0.22, 0.05, 25, rating_type); % draw & save details: draw_socia_cue(m, std, n, rating_type)
% Screen('Flip', theWindow);
% while (1)
%     [~,~,keyCode] = KbCheck;
%     if keyCode(KbName('space'))==1
%         draw_scale('overall_predict_semicircular');
%         draw_social_cue(0.77, 0.05, 25, rating_type); % draw & save details: draw_socia_cue(m, std, n, rating_type)
%         Screen('Flip', theWindow);
%     elseif keyCode(KbName('q'))==1
%         abort_man;
%     elseif keyCode(KbName('w'))== 1
%         break
%     end
% end
%
% msg = '이번 자극이 최대 얼마나 아플까요?';
% msg = double(msg);
% DrawFormattedText(theWindow, msg, 'center', 150, orange, [], [], [], 2);
% Screen('Flip', theWindow);
% waitsec_fromstarttime(sTime, 6);

ready = 0;
sTime=GetSecs;
x= cir_center(1);
y= cir_center(2);
SetMouse(cir_center(1), cir_center(2));
while true
    if joystick
        [pos, button] = mat_joy(0);
        xAlpha=pos(1);
        x=x+xAlpha*10;
        yAlpha=pos(2);
        y=y+yAlpha*10;
    else
        [x,y,button]=GetMouse(theWindow);
    end
    % if the point goes further than the semi-circle, move the point to
    % the closest point
    radius = (rb2-lb2)/2; %radius = (rb1-lb1)/2; % radius;
    theta = atan2(cir_center(2)-y,x-cir_center(1));
    % current euclidean distance
    curr_r = sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2);
    % current angle (0 - 180 deg)
    curr_theta = rad2deg(-theta+pi);
    if y > cir_center(2)
        y = cir_center(2);
        %SetMouse(x,y);
    end
    % send to arc of semi-circle
    if sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2) > radius
        x = radius*cos(theta)+cir_center(1);
        y = cir_center(2)-radius*sin(theta);
        %SetMouse(x,y);
    end
    
    
    
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    msg1 = GetSecs-sTime;
    msg2 = '조이스틱_테스트_30초동안: ';
    msg_sum = [msg2 ' ' num2str(msg1)];
    msg = double(msg_sum);
    DrawFormattedText(theWindow, msg, 'center', 150, white, [], [], [], 1.5);
    
    
    %draw_scale('cont_predict_semicircular');
    
    draw_scale('overall_predict_semicircular');
    
    
    Screen('DrawDots', theWindow, [x y], 15, orange, [0 0], 1);
    Screen('Flip', theWindow);
    
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
    
    if GetSecs - sTime >30
        pause(1);
        Screen('Flip', theWindow);
        break;
        
    end
    
    %         if button(1)
    %             draw_scale('cont_predict_semicircular')
    %             Screen('DrawDots', theWindow, [x y]', 18, red, [0 0], 1);  % Feedback
    %             Screen('Flip', theWindow);
    %             WaitSecs(2);
    %             break;
    %         end
    
    
end

% while GetSecs - sTime <10
%     if button(1)
%         Screen('Flip', theWindow);
%     end
% end

Screen('Clear');
Screen('CloseAll');



%%w