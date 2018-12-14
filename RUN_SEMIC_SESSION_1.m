%% SESSION 1
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
%% 1. Calibration
SID = ''; %subject ID 
calibration(SID, ip, port,'joystick','test'); % run calibration task 

%% ===================================================================== %% 