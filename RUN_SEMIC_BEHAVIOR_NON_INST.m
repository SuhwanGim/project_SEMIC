% You should edit this area based on Pathway settings 
% If not using fixed IP adresses, it usally changed every time
clear; 
close all;

ip = '115.145.189.133'; % or LocalHost?
port = 20121;

%% Learning


%% STUDY
% thermode_test(Number of run, ip, port, options...), 
%====== OPTION: gazePoint, biopac1, explain_scale, test and so on
% runNbr = Run Number (1-3)
data = thermode_test(1, ip, port, 'test'); 

%thermodecccctest( 1,'LocalHost',port);