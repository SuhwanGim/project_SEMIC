%% INFORMATION
%
% This code is only for testing external contorl of Pathway
% 
% by Suwhan Gim (roseno.9@daum.net) 
% 2017-10-17 

%% EXAMPEL of PROGRAM code
% dec2bin(100) -> ans = 1100100
% 
% MATLAB VALUE, PATHWAY VALUE = (100,1100100)
% For example
% ---------------------------------------------------------
% '100: Ramp-up 2sec' 1100100
% '101: Ramp-up 4sec' 1100101
% '102: Ramp-up 6sec' 1100110


%% TEST START

ip = '203.252.46.54';
port = 20121;
program;

for i = 1:15 % 3(2,4,6sec) x 15 other combination
    program(i*3-2:i*3) = randperm(3) + 99; % Strafied randomization [1 2 3] [2 3 1] ......
end

thermodePrime(ip, port, program) 