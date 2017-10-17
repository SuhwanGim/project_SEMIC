function [xx, th] = draw_social_cue(m, std, n, rating_type)

global theWindow W H; % window property
global white red orange bgcolor; % color
global window_rect prompt_ex tb bb lb rb scale_H anchor_y anchor_y2 anchor promptW promptH joy_speed; % rating scale

cir_center = [(rb+lb)/2, bb];
radius = (rb-lb)/2; % radius

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
    
    Screen('DrawDots', theWindow, [x y]', 8, red, [0 0], 1);  %dif color
    
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