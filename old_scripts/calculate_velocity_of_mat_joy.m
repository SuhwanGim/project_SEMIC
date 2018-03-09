%10*1/60

% 도달할 초, 1초, 주사율
hz=60;
sec = 1;
ds = 10;

screens = Screen('Screens');
window_info = Screen('Resolution', 0);
window_rect = [0 0 window_info.width window_info.height];
W = window_rect(3); %width of screen
lb1 = 1*W/18; %
rb1 = 17*W/18; %

distance=(rb1-lb1)/2;

syms tr;
%distance = ds*sec/hz*tr;

velocity = solve(distance/hz*sec == ds*sec/hz*tr);

disp(velocity);


% %%
%        syms x
%        S = solve(x^(5/2) == 8^(sym(10/3)), 'PrincipalValue', true)
%        selects one of these:


