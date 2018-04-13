%% DAY1
clc;
clear;
close all;
%% SETUP: PARAMETER
ip = '192.168.0.3'; %ip = '115.145.189.133'; %ip = '203.252.54.21';
port = 20121;
addpath(genpath(pwd));



%% 1. Calibration
SID = 입력하세요;
calibration(SID, ip, port,'joystick','test');





%% 
    SEMIC_Senddata(SID,'Calibration')