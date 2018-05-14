function rest_run(SID,varargin)
%Rest run
%   Input variable
%       (1) test: 1280 720 resoultion
%       (2) fmri: for receive 's' trigger from sync box
%       (3) biopac1: for signal biopac sync timing
%% Parse varargin
testmode = false;
USE_BIOPAC = false;
dofmri = false;
for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            case {'test'}
                testmode = true;
            case {'fmri'}
                dofmri = true;
            case {'biopac1'}
                USE_BIOPAC = true;
                channel_n = 3;
                biopac_channel = 0;
                ljHandle = BIOPAC_setup(channel_n); % BIOPAC SETUP
            case {'eyelink', 'eye', 'eyetrack'}
                USE_EYELINK = true;
        end
    end
end

%% GLOBAL vaiable
global theWindow W H; % window property
global white red red_Alpha orange bgcolor yellow; % color
global window_rect % rating scale
global fontsize;

%% SETUP: DATA and Subject INFO
savedir = 'REST_SEMIC_data';
[fname,~, SID] = subjectinfo_check_SEMIC(SID,savedir,1,'Rest'); % subfunction %start_trial
%[fname, start_trial, SID] = subjectinfo_check(savedir); % subfunction
if exist(fname, 'file'), load(fname, 'rest'); load(fname,'ts'); end
% save data using the canlab_dataset object
rest.version = 'SEMIC_v1_03-28-2018_Cocoanlab';
rest.subject = SID;
rest.datafile = fname;
rest.starttime = datestr(clock, 0); % date-time
rest.starttime_getsecs = GetSecs; % in the same format of timestamps for each trial

save(rest.datafile,'rest');
%% SETUP: Screen
Screen('Clear');
Screen('CloseAll');
window_num = 0;
if testmode
    window_rect = [1 1 1280 720]; % in the test mode, use a little smaller screen [but, wide resoultions]
    %window_rect = [0 0 1900 1200];
    fontsize = 20;
else
    screens = Screen('Screens');
    window_num = screens(end); % the last window
    Screen('Preference', 'SkipSyncTests', 1);
    window_info = Screen('Resolution', window_num);
    window_rect = [0 0 window_info.width window_info.height]; % full screen
    fontsize = 32;
    HideCursor();
end


W = window_rect(3); %width of screen
H = window_rect(4); %height of screen

bgcolor = 80;
white = 255;
red = [255 0 0];
red_Alpha = [255 164 0 130]; % RGB + A(Level of tranceprency: for social Cue)
orange = [255 164 0];
yellow = [255 220 0];
%% SETUP: Eyelink
% need to be revised when the eyelink is here.
% It must be located after open screen
runNbr=1;

if USE_EYELINK
    new_SID = erase(SID,'SEM'); % For limitation of file name 
    edf_filename = ['R_' new_SID '_' num2str(runNbr)]; % name should be equal or less than 8
    edfFile = sprintf('%s.EDF', edf_filename);
    eyelink_main(edfFile, 'Init');
    
    status = Eyelink('Initialize');
    if status
        error('Eyelink is not communicating with PC. Its okay baby.');
    end
    Eyelink('Command', 'set_idle_mode');
    waitsec_fromstarttime(GetSecs, .5);
end

%% Parameter
stimText = '+';
seconds = 382; %duration: 6 min 20 seoncds

%%
try
    theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
    Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
    
    %Start
    
    rest.dat{1}{1}.run_start_timestamp=GetSecs;
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('space'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_experiment;
        end
        display_expmessage('실험자는 모든 것이 잘 준비되었는지 체크해주세요 (PATHWAY, BIOPAC, 등등). \n모두 준비되었으면 SPACE BAR를 눌러주세요.'); % until space; see subfunctions
    end
    
    % 1 seconds: BIOPAC
    while (1)
        [~,~,keyCode] = KbCheck;
        % if this is for fMRI experiment, it will start with "s",
        % but if behavioral, it will start with "r" key.
        if dofmri
            if keyCode(KbName('s'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment;
            end
        else
            if keyCode(KbName('r'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment;
            end
        end
        display_runmessage(1, 1, dofmri); % until 5 or r; see subfunctions
    end
    
    
    if dofmri
        fmri_t = GetSecs;
        % gap between 5 key push and the first stimuli (disdaqs: data.disdaq_sec)
        % 5 seconds: "占쏙옙占쏙옙占쌌니댐옙..."
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        DrawFormattedText(theWindow, double('시작합니다...'), 'center', 'center', white, [], [], [], 1.2);
        Screen('Flip', theWindow);
        rest.dat{1}{1}.runscan_starttime = GetSecs;
        waitsec_fromstarttime(fmri_t, 4);
        
        % 5 seconds: Blank
        fmri_t2 = GetSecs;
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(fmri_t2, 4); % ADJUST THIS
    end
    
    if USE_BIOPAC
        bio_t = GetSecs;
        rest.dat{1}{1}.biopac_triggertime = bio_t; %BIOPAC timestamp
        BIOPAC_trigger(ljHandle, biopac_channel, 'on');
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(bio_t, 2); % ADJUST THIS
    end
    
    %?
    if USE_BIOPAC
        BIOPAC_trigger(ljHandle, biopac_channel, 'off');
    end
    
    if USE_EYELINK
        Eyelink('StartRecording');
        rest.dat{1}{1}.eyetracker_starttime = GetSecs; % eyelink timestamp
        Eyelink('Message','Run start');
    end
    
    
    %==========================START: Gray screen with crosshair===========
    if USE_EYELINK
        Eyelink('Message','Gray screen starts');
    end
    t_time=GetSecs;
    rest.dat{1}{1}.screen_start_timestamp = t_time;
    DrawFormattedText(theWindow, double(stimText), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    
    waitsec_fromstarttime(t_time, seconds);
    
    rest.dat{1}{1}.screen_end_timestamp = GetSecs;
    save(rest.datafile, '-append', 'rest');
    
    if USE_EYELINK
        Eyelink('Message','Gray screen ends');
    end
    %==========================END: Gray screen with crosshair=============
    
    %%
    if USE_EYELINK % end Eyelink
        Eyelink('Message','Run ends');
        eyelink_main(edfFile, 'Shutdown');
    end
    
    if USE_BIOPAC %end BIOPAC
        bio_t = GetSecs;
        rest.dat{1}{1}.biopac_endtime = bio_t;% biopac end timestamp
        BIOPAC_trigger(ljHandle, biopac_channel, 'on');
        waitsec_fromstarttime(bio_t, 0.1);
        BIOPAC_trigger(ljHandle, biopac_channel, 'off');
    end
    save(rest.datafile, '-append', 'rest');
    WaitSecs(3);
    
    display_expmessage('잠시만 기다려주세요.');
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('q'))==1
            break
        elseif keyCode(KbName('space'))== 1
            break
        end
    end
    
    
    ShowCursor();
    Screen('Clear');
    Screen('CloseAll');
    
    
catch
    % ERROR
    disp(err);
    for i = 1:numel(err.stack)
        disp(err.stack(i));
    end
    abort_experiment;
end


end

function display_runmessage(run_i, run_num, dofmri)

% MESSAGE FOR EACH RUN

% HERE: YOU CAN ADD MESSAGES FOR EACH RUN USING RUN_NUM and RUN_I

global theWindow white bgcolor window_rect; % rating scale

if dofmri
    if run_i <= run_num % you can customize the run start message using run_num and run_i
        Run_start_text = double('참가자가 준비되었으면 이미징을 시작합니다 (s).');
    end
else
    if run_i <= run_num
        Run_start_text = double('참가자가 준비되었으면, r을 눌러주세요.');
    end
end

% display
Screen(theWindow,'FillRect',bgcolor, window_rect);
DrawFormattedText(theWindow, Run_start_text, 'center', 'center', white, [], [], [], 1.5);
Screen('Flip', theWindow);

end

function abort_experiment(varargin)

% ABORT the experiment
%
% abort_experiment(varargin)

str = 'Experiment aborted.';

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'error'}
                str = 'Experiment aborted by error.';
            case {'manual'}
                str = 'Experiment aborted by the experimenter.';
            case {'IP'}
                str = 'No information about IP adress';
        end
    end
end


ShowCursor; %unhide mouse
Screen('CloseAll'); %relinquish screen control
disp(str); %present this text in command window

end

function display_expmessage(msg)
% diplay_expmessage("ad;slkja;l불라불라 \nㅂㅣㅏ넝리ㅏㅓ");
% type each MESSAGE

global theWindow white bgcolor window_rect; % rating scale

EXP_start_text = double(msg);

% display
Screen(theWindow,'FillRect',bgcolor, window_rect);
DrawFormattedText(theWindow, EXP_start_text, 'center', 'center', white, [], [], [], 1.5);
Screen('Flip', theWindow);

end

