
function vlc=cal_vel_joy (type)
%%
% sec = 6;
% cont_vlc = 1.2929
% 
% sec = 11;
% ovl_vlc = 1.1852
%%
global lb1 lb2 rb1 rb2;

%distance between center and line in SEMIC
switch type
    case 'overall'
        sec = 6;
        distance=(rb2-lb2)/2;
    case 'cont'
        sec = 11;
        distance=(rb1-lb1)/2;
end


% calculate velocity depends on screen size and given seconds
% syms tr;
% velocity = solve(distance == 60*seconds*tr); %60 repetition * 11 second * velocity
velocity=distance/60/sec;
vlc=velocity;


%vlc = double(velocity);
%disp(vlc);

end