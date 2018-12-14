
function vlc=cal_vel_joy (type)
%%
% Calculate a level of velocity of joystick depends on rating type. You can
% easily edit this function, especially, seconds. 
% 
% And, if your refresh ratio of monitor is not 60hz, you should change the
% 'hz' based on your monitor's refresh ratio.
%
% Written by Suhwan Gim
% 2018. 03. 10 
% 
% ============================INPUT VALUE==================================
% ::type::
% 1) 'cont'   :For continuous rating. 
%              - secconds = 11;
%              - Then, usally, a level of velocity was 1.1852
% 2) 'overall':For overall rating.
%              - seconds = 6;
%              - Then, usally, a level of velocity was 1.2929

%% Setting: Variable
global lb1 lb2 rb1 rb2;
hz = 60; %refresh ratio
%% Setting: rating
%distance between center and line in SEMIC
switch type
    case 'overall'
        sec = 4;
        distance=(rb2-lb2)/2;
    case 'cont'
        sec = 11;
        distance=(rb1-lb1)/2;
end

%% Calculation
% calculate velocity depends on screen size and given seconds
% syms tr;
% velocity = solve(distance == 60*seconds*tr); %60 repetition * 11 second * velocity
velocity=distance/hz/sec;
vlc=velocity; %output


end