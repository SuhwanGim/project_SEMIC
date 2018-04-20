%% DAY2
clc;
clear;
close all;
%% SETUP: PARAMETER
%ip = '115.145.189.133'; 
ip = '192.168.0.3'; port = 20121; addpath(genpath(pwd));
%% SETUP: Load calibration data & SkinSite sequences
reg = load_cali_results(); disp(reg.skinSite_rs);

%% EXPERIMENT %% 
%% 1. Rest run
    SID = 입력하세요 %Participants
    rest_run(SID,'fmri','biopac1','eyelink','test');
%% 2. T1 & Learning phase
    Learning_test(SID, ip, port, reg,'fmri','biopac1','joystick','eyelink','test');
%% 3. Motor TASK
    Motor_practice(SID, 1,'fmri','biopac1','joystick','eyelink','test');
%% Main STUDY % thermode_test(('biopac1','fmri') ... ... ),
%% 4. RUN1 
    thermode_test(SID, 1, ip, port, reg,'fmri','biopac1','joystick','eyelink','test');
%% 5. RUN2
    thermode_test(SID, 2, ip, port, reg,'fmri','biopac1','joystick','eyelink','test');
%% 6. RUN3
    thermode_test(SID, 3, ip, port, reg,'fmri','biopac1','joystick','eyelink','test');
    
    
%% 7. Motor task
    Motor_practice(SID, 2,'fmri','biopac1','joystick','eyelink','test');
%% 8. RUN4
    thermode_test(SID, 4, ip, port, reg,'fmri','biopac1','joystick','eyelink','test');
%% 9. RUN5
    thermode_test(SID, 5, ip, port, reg,'fmri','biopac1','joystick','eyelink','test');
%% 10. RUN6
    thermode_test(SID, 6, ip, port, reg,'fmri','biopac1','joystick','eyelink','test');
   
    
    
%% SEND DATA
    SEMIC_Senddata(SID,'mri')