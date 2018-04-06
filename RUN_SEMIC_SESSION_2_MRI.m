%% SESSEION2
clc;
clear;
close all;
%% SETUP: PARAMETER
%ip = '115.145.189.133'; % or LocalHost?
ip = '203.252.54.21';
port = 20121;
addpath(genpath(pwd));
%% SETUP: Load calibration data
reg = load_cali_results();
%% SETUP: SkinSite sequences
disp(reg.skinSite_rs); %after 2018/03/01 calibration data

%% 0. Rest run
    SID = 입력하세요 %Participant
    rest_run(SID,'test','fmri','biopac1');
%% 1. T1 & Learning phase
    Learning_test(SID, ip, port, reg,'fmri','biopac1','joystick','test');
%% 2. Motor TASK
    Motor_practice(SID, 1,'fmri','biopac1','joystick','test');
%% 3. Main STUDY % thermode_test(('biopac1','fmri') ... ... ),
%% RUN1 
    thermode_test(SID, 1, ip, port, reg,'fmri','biopac1','joystick','test');
%% RUN2
    thermode_test(SID, 2, ip, port, reg,'fmri','biopac1','joystick','test');
%% RUN3
    thermode_test(SID, 3, ip, port, reg,'fmri','biopac1','joystick','test');
    
    
%% Motor task
    Motor_practice(SID, 2,'fmri','biopac1','joystick','test');
%% RUN4
    thermode_test(SID, 4, ip, port, reg,'fmri','biopac1','joystick','test');
%% RUN5
    thermode_test(SID, 5, ip, port, reg,'fmri','biopac1','joystick','test');
%% RUN6
    thermode_test(SID, 6, ip, port, reg,'fmri','biopac1','joystick','test');
   
%% SEND DATA
    SEMIC_Senddata(SID,'mri')