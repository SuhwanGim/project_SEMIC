%% SESSEION1
%%
clc;
clear; 
close all;
%% SETUP: PARAMETER
ip = '115.145.189.133'; % or LocalHost?
port = 20121;
addpath(genpath(pwd));
%% 1. PATHWAY TEST 
pathway_test(ip, port);
%% 2. Calibration
calibration(ip, port,'test');
