% You should edit this area based on Pathway settings 
% If not using fixed IP adresses, it usally changed every time
% runNbr = Run Number (1-3)
clear all;
close all;

ip = '115.145.189.133'; % or LocalHost?
port = 20121;

%% Learning


%% STUDY
data = thermode_test(1, ip, port, 'test'); %gazePoint, biopac1, explain_scale, test and so on

%thermodecccctest( 1,'LocalHost',port);