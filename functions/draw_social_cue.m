function [xx, th] = draw_social_cue(m, std, n, rating_type)

global theWindow W H; % window property
global white red red_Alpha orange bgcolor; % color
global window_rect prompt_ex tb bb lb rb scale_H anchor_y anchor_y2 anchor promptW promptH joy_speed; % rating scale
global lb1 rb1 lb2 rb2; % For larger semi-circular

% cir_center = [(rb+lb)/2, bb]; previous version 
%radius = (rb-lb)/2; % radius; also,
% Boundary for draw_scale('overall_predict_semicircular')
cir_center = [(rb2+lb2)/2, H*3/4+100];
radius = (rb2-lb2)/2;

draw_scale(rating_type);

semicircular = contains(rating_type, 'semicircular');

xx = [];
th = [];

if semicircular   	
    
    if n == 1
        th = deg2rad(m * 180); % convert 0-1 values to 0-180 degree
    else
        deg = 180-normrnd(m, std, n, 1)*180; % convert 0-1 values to 0-180 degree
        deg(deg > 180) = 180;
        deg(deg < 0) = 0;
        th = deg2rad(deg); 
    end
    
    x = radius*cos(th)+cir_center(1);
    y = cir_center(2)-radius*sin(th);
    
    % Screen('DrawDots', windowPtr, xy [,size] [,color] [,center] [,dot_type][, lenient]);
    % [,dot_type]
    % [,color] surpprt RGBA (RGB + Alpha: level of transprency) 0 - 255
    % 
    Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % For using level of alpha
    Screen('DrawDots', theWindow, [x y]', 22, red_Alpha, [0 0], 1);  %dif color
    
    
else
    
    if n == 1
        x = m * (rb-lb) + lb;
    else
        x = (normrnd(m, std, n,1))*(rb-lb) + lb;
        x(x<lb) = lb; x(x>rb) = rb;
    end
    
    xx = (x-lb)./(rb-lb);
    if n==1
        Screen('DrawLines', theWindow, [reshape(repmat(x, 1, 2)', 1, []); repmat([H/2 H/2+scale_H], 1, n)], 6, red);    %thick
    else
        Screen('DrawLines', theWindow, [reshape(repmat(x, 1, 2)', 1, []); repmat([H/2 H/2+scale_H], 1, n)], 2, red);
    end
    
end

end