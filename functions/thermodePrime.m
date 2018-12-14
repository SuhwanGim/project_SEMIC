function thermodePrime(ip, port, program)
% This is a quick Matlab commandline program to trigger thermode stimulation to
% 3 sites in sequence for 10s each

%Input args:
% ip : ip of the Medoc laptop in External Control Mode
% port: output port of the Medoc laptop in External Control Mode
% program: 

% Works by calling the main() program which takes 4 arguments:
%1) ip of the Medoc machine
%2) open port of the Medoc machine
%3) command code to issue; I believe 0 = get system status, 1 = prep pre-test, 4 = start, 5 = stop
%4) program name to execute this is a decimal value that maps on to the 8-bit
%binary code of the program built in the pathway program (e.g. 100 ==
%1100100, details see below), which is a program created to deliver pain at a constant temperature
%for 10s)
%
%FUNCTION:: for commandID code (in pathway system) and demical value (in
%Matlab)
%  
% dec2bin(100) -----> ans = 1100100 (You can use this value into pathway
% program 8bit binary code)
% bin2dec('1100100') -----> ans = 100 (Also, you can use this value into
% Matlab demical value)
%

commandId = program;

for i = 1:1
    fprintf('Press spacebar to begin stimulation\n');
    KbStrokeWait;
    main(ip,port,1,commandId(i)); % pre-test
    if checkStatus(ip,port)
        main(ip,port,4,100); % Start 
        sTime = GetSecs;
        while GetSecs - sTime <= 15
            %wait till pain finishes
        end
        main(ip,port,5,commandId(i)); % Stop
    end
end