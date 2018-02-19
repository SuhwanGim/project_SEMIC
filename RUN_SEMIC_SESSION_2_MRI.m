%% SESSEION2
clc;
clear;
close all;
%% SETUP: PARAMETER
%ip = '115.145.189.133'; % or LocalHost?
ip = '203.252.54.6';
port = 20121;
addpath(genpath(pwd));
%% SETUP: Load calibration data
reg = load_cali_results();




%% 0. PATHWAY TEST
    pathway_test(ip, port, 'MRI', reg);
%% 1. T1 & Learning phase
    Learning_test(ip, port, reg,'test','fmri');
%% 2. Motor TASK
    Motor_practice(1,'test','fmri');
%% 3. Main STUDY % thermode_test(Number of run, ip, port, options...),
%% PATHWAY TEST
    pathway_test(ip, port, 'MRI', reg);
%% RUN1
    thermode_test(1, ip, port, reg,'test','biopac1','fmri');
%% PATHWAY TEST
    pathway_test(ip, port, 'MRI', reg);
%% RUN2
    thermode_test(2, ip, port, reg,'test','fmri');
%% PATHWAY TEST
    pathway_test(ip, port, 'MRI', reg);
%% RUN3
    thermode_test(3, ip, port, reg,'test','fmri');
%% PATHWAY TEST
    pathway_test(ip, port, 'MRI', reg);
%% RUN4
    thermode_test(4, ip, port, reg,'test','fmri');
%% PATHWAY TEST
    pathway_test(ip, port, 'MRI', reg);
%% RUN5
    thermode_test(5, ip, port, reg,'test');
%% PATHWAY TEST
    pathway_test(ip, port, 'MRI', reg);
%% RUN6
    thermode_test(6, ip, port, reg,'test');
