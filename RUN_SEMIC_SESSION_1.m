%% SESSEION1
clc;
clear;
close all;
%% SETUP: PARAMETER
ip = '115.145.189.133'; %ip = '203.252.54.21';
port = 20121;
addpath(genpath(pwd));
%% 1. Calibration
calibration(ip, port,'test');





%% 
    subj_name=;
    SEMIC_Senddata(subj_name,'Calibration')