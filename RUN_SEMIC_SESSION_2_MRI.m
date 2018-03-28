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
    rest_run('test','fmri','biopac1');
%% 1. T1 & Learning phase
    Learning_test(ip, port, reg,'test','fmri','biopac1','joystick');
%% 2. Motor TASK
    Motor_practice(1,'test','fmri','biopac1','joystick');
%% 3. Main STUDY % thermode_test(('biopac1','fmri') ... ... ),
%% RUN1 
    thermode_test(1, ip, port, reg,'test','fmri','biopac1','joystick');
%% RUN2
    thermode_test(2, ip, port, reg,'test','fmri','biopac1','joystick');
%% RUN3
    thermode_test(3, ip, port, reg,'test','fmri','biopac1','joystick');
    
    
%% Motor task
    Motor_practice(2,'test','fmri','biopac1','joystick');
%% RUN4
    thermode_test(4, ip, port, reg,'test','fmri','biopac1','joystick');
%% RUN5
    thermode_test(5, ip, port, reg,'test','fmri','biopac1','joystick');
%% RUN6
    thermode_test(6, ip, port, reg,'test','fmri','biopac1','joystick');
    
    
    
%% PATHWAY TEST
    pathway_test(ip, port, 'MRI', reg);

    
    
    
%% SEND DATA
    sujb_name='INPUT HERE';
    SEMIC_Senddata(subj_name,'mri')