%% SESSION 2 
clc;
clear;
close all;
%% SETUP: DIRECTORY
% ~/functions
% ~/task_functions
addpath(genpath(pwd));
%% SETUP: PARAMETER
% 1) PC A: computer connected with the Pathway and also inter-connected
% comput B 
% 2) PC B: computer for present stimulus and send command to trigger
% pathway also connected with PC A using TCP-IP protocal(i.e., hub or cross
% UTP calbe)

% should put the PC A's IP and port
ip = '192.168.0.3'; %ip = '115.145.189.133'; %ip = '203.252.54.21';
port = 20121;
%% SETUP: Load calibration data & SkinSite sequences
reg = load_cali_results(); disp(reg.skinSite_rs);

%% EXPERIMENT %% 
%% 1. Resting-state run
    SID = ''; %subject ID
    rest_run(SID,'fmri','biopac1','eyelink','test');
%% 2. Structual imaging & Learning phase
    Learning_test(SID, ip, port, reg,'fmri','biopac1','joystick','eyelink','test');
%% 3. Simple motor task 1
    Motor_practice(SID, 1,'fmri','biopac1','joystick','eyelink','test');
%% Main task: using fucntion thermode_test(('biopac1','fmri') ... ... )
%% 4. RUN1 
    thermode_test(SID, 1, ip, port, reg,'fmri','biopac1','joystick','eyelink','test');
%% 5. RUN2
    thermode_test(SID, 2, ip, port, reg,'fmri','biopac1','joystick','eyelink','test');
%% 6. RUN3
    thermode_test(SID, 3, ip, port, reg,'fmri','biopac1','joystick','eyelink','test');
    
    
%% 7. Simple motor task 2
    Motor_practice(SID, 2,'fmri','biopac1','joystick','eyelink','test');
%% 8. RUN4
    thermode_test(SID, 4, ip, port, reg,'fmri','biopac1','joystick','eyelink','test');
%% 9. RUN5
    thermode_test(SID, 5, ip, port, reg,'fmri','biopac1','joystick','eyelink','test');
%% 10. RUN6
    thermode_test(SID, 6, ip, port, reg,'fmri','biopac1','joystick','eyelink','test');
   