%%
%       =========================
%       EYELINK calibration test
%       =========================
%
%   2018.07.08
%% SETUP
global theWindow
window_num = 0;
testmode = true;
if testmode
    window_rect = [1 1 1200 720]; % in the test mode, use a little smaller screen
    %window_rect = [0 0 1900 1200];
    fontsize = 20;
else
    screens = Screen('Screens');
    window_num = screens(end); % the last window
    window_info = Screen('Resolution', window_num);
    Screen('Preference', 'SkipSyncTests', 1);
    window_rect = [0 0 window_info.width window_info.height]; % full screen
    fontsize = 32;
    HideCursor();
end
W = window_rect(3); %width of screen
H = window_rect(4); %height of screen

font = 'NanumBarunGothic';

bgcolor = 80;
white = 255;
red = [255 0 0];
orange = [255 164 0];
yellow = [255 220 0];

%% SETUP: PTB WINDOW
theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
% Screen('TextFont', theWindow, font); % setting font
Screen('TextSize', theWindow, fontsize);

%% SETUP: Eyelink
% need to be revised when the eyelink is here.
eye_start = GetSecs;
edf_filename = 'test'; % name should be equal or less than 8
edfFile = sprintf('%s.EDF', edf_filename);
eyelink_main(edfFile, 'Init');

status = Eyelink('Initialize');
if status
    error('Eyelink is not communicating with PC. Its okay baby.');
end
Eyelink('Command', 'set_idle_mode');
waitsec_fromstarttime(GetSecs, .5);



%%
if GetSecs - eye_start > 100
    eyelink_main(edfFile, 'Shutdown');
    sca;
    
    Screen('Clear');
    Screen('CloseAll');
end
