%% SESSEION2
clc;
clear; 
close all;
%% SETUP: PARAMETER
ip = '115.145.189.133'; % or LocalHost?
port = 20121;
addpath(genpath(pwd));
%% SETUP: Load calibration data

%% 0. PATHWAY TEST 
    pathway_test(ip, port);
%% 1. T1 & Learning phase

%% 2. Motor TASK
    Motor_practice('test');
%% 3. STUDY % thermode_test(Number of run, ip, port, options...), 
    % RUN1
    data1 = thermode_test(1, ip, port, 'test'); 
    % RUN2
    data2 = thermode_test(2, ip, port, 'test'); 
    % PATHWAY TEST 
    pathway_test(ip, port);
    % RUN3
    data3 = thermode_test(3, ip, port, 'test'); 
    % RUN4
    data4 = thermode_test(4, ip, port, 'test'); 
    % PATHWAY TEST 
    pathway_test(ip, port);
    % RUN5
    data5 = thermode_test(5, ip, port, 'test'); 
    % RUN6
    data6 = thermode_test(6, ip, port, 'test'); 




