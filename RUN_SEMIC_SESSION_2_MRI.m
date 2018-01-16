%% SESSEION2
clc;
clear;
close all;
%% SETUP: PARAMETER
ip = '115.145.189.133'; % or LocalHost?
port = 20121;
addpath(genpath(pwd));
%% SETUP: Load calibration data
reg = load_cali_results();
%% 0. PATHWAY TEST
pathway_test(ip, port, 'MRI', reg);
%% 1. T1 & Learning phase
Learning_test(ip, port, reg,'test');
%% 2. Motor TASK
Motor_practice('test');
%% 3. STUDY % thermode_test(Number of run, ip, port, options...),
%% PATHWAY TEST
pathway_test(ip, port, 'MRI', reg);
%% RUN1
data1 = thermode_test(1, ip, port, reg,'test');
%% RUN2
data2 = thermode_test(2, ip, port, reg,'test');
%% PATHWAY TEST
pathway_test(ip, port, 'MRI', reg);
%% RUN3
data3 = thermode_test(3, ip, port, reg,'test');
%% RUN4
data4 = thermode_test(4, ip, port, reg,'test');
%% PATHWAY TEST
pathway_test(ip, port, 'MRI', reg);
%% RUN5
data5 = thermode_test(5, ip, port, reg,'test');
%% RUN6
data6 = thermode_test(6, ip, port, reg,'test');




