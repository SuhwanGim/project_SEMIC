%%
% IT IS JUST FOR SCREEN TEST,
% -----------------------------------------------
% For example
% 1) test a color of social cue,
% 2) identify a font size
% 3) to verify function that collect a mouse information (x, y, button[0,0,0]
% and so on.


%% Global variable
global theWindow W H; % window property
global white red orange bgcolor; % color
global window_rect prompt_ex lb rb tb bb scale_H promptW promptH; % rating scale
global fontsize anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd anchor_lms anchor_lms_y anchor_lms_x; % anchors


%%
GetSecs;
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
anchor_lms = [0.1000 0.2881 0.5966 0.9000];
% anchor_lms = [0.061 0.172 0.354 0.533].*(rb-lb)+lb;
% anchor_lms = [0.014 0.061 0.172 0.354 0.533].*(rb-lb)+lb;

%%
cir_center = [(rb+lb)/2, bb];
radius = (rb-lb)/2; % radius
deg = 180-normrnd(0.5, 0.1, 20, 1)*180; % convert 0-1 values to 0-180 degree
deg(deg > 180) = 180;
deg(deg < 0) = 0;
th = deg2rad(deg);
x = radius*cos(th)+cir_center(1);
y = cir_center(2)-radius*sin(th);

% anchor_lms_y = bb - sqrt(radius.^2 - (anchor_lms_x-(lb+rb)/2).^2);

%%
theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % For alpha value of color: [R G B alpha]
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
Screen('TextFont', theWindow, font); % setting font
Screen('TextSize', theWindow, fontsize);
%%
sTime = GetSecs;
ready2=0;
rec=0;
while ~ready2
    rec=rec+1;
    [x,y,button] = GetMouse(theWindow);
    xc(rec,:)=x; 
    yc(rec,:)=y;
    
    rating_type = 'semicircular';
    draw_scale('overall_motor_semicircular');
    Screen('DrawDots', theWindow, [x y]', 20, [255 164 0 130], [0 0], 1);  %dif color
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
    
    draw_scale('overall_motor_semicircular');
    theta = rad2deg(theta);
    theta= 180 - theta;
    theta = num2str(theta);
    DrawFormattedText(theWindow, theta, 'center', 'center', white, [], [], [], 1.2); %Display the degree of the cursur based on cir_center
    disp(theta); %angle
    Screen('DrawDots', theWindow, [xc yc]', 5, yellow, [0 0], 1);  %dif color
    %Screen(theWindow,'DrawLines', [xc yc]', 5, 255);
    Screen('Flip',theWindow);
    if button(1)
        draw_scale('overall_avoidance_semicircular');
        Screen('DrawDots', theWindow, [x y]', 18, red, [0 0], 1);  % Feedback
        Screen('Flip',theWindow);
        WaitSecs(0.5);
        ready3=0;
        while ~ready3 %GetSecs - sTime> 5
            msg = double(' ');
            DrawFormattedText(theWindow, msg, 'center', 250, white, [], [], [], 1.2);
            Screen('Flip',theWindow);
            if  GetSecs - sTime > 5
                break
            end
        end
        
        break;
        
        
    elseif GetSecs - sTime > 20
        ready2=1;
        break;
    else
        %do nothing
    end
end

sca;
Screen('CloseAll');