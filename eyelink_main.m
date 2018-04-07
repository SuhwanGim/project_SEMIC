function eyelink_main(edfFile, varargin)
global theWindow
% eyelink_main(savefilename, varargin)
% 
% varargin: 'Init', 'Shutdown'
% 
%
%
% edfFile =
%           M_ = main task
%           L_ = Learning phase
%           
% From Byeol Etoile Kim's github
% URL:     https://github.com/ByeolEtoileKim/fast_fmri_v1
%

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            case 'Init'               
                commandwindow;
                dummymode=0;
                
                try
                    el=EyelinkInitDefaults(theWindow); 
                    
                    
                    if ~EyelinkInit(dummymode)
                        fprintf('Eyelink Init aborted. Cannot connect to Eyelink\n');
                        Eyelink('Shutdown');
                        Screen('CloseAll');
                        commandwindow;
                        return;
                    end

                    Eyelink('Openfile', edfFile);
      
                    % Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, width-1, height-1); % wani: don't need calibration
                    % Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, width-1, height-1); % wani: don't need calibration
                    % set calibration type.
                    % Eyelink('command', 'calibration_type = HV9'); % wani: don't need calibration

                    Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT');
                    
                    % make sure we're still connected.
                    if Eyelink('IsConnected')~=1 && dummymode == 0
                        fprintf('not connected at step 5, clean up\n');
                        % cleanup;
                        % function cleanup
                        Eyelink('Shutdown');
                        Screen('CloseAll');
                        commandwindow;
                        return;
                    end
                    
                    EyelinkDoTrackerSetup(el); % wani: don't need calibration
                    EyelinkDoDriftCorrection(el); % add from Song, driftcorrection
                    
                catch exc
                    %this "catch" section executes in case of an error in the "try" section
                    %above.  Importantly, it closes the onscreen window if its open.
                    % cleanup;
                    % function cleanup
                    getReport(exc,'extended')
                    disp('EYELINK CAUGHT')
                    Eyelink('Shutdown');
                    Screen('CloseAll');
                    commandwindow;
                end
                
            case 'Shutdown'
                
                Eyelink('Command', 'set_idle_mode');
                WaitSecs(0.5);
                Eyelink('StopRecording');
                Eyelink('CloseFile');
                Eyelink('ReceiveFile', edfFile, edfFile);

                %Shutdown Eyelink
                Eyelink('Shutdown');
                
            otherwise, warning(['Unknown input string option:' varargin{i}]);
        end
    end
end
