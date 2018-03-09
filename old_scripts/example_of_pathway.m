%% SETUP: PARAMETER
%ip = '115.145.189.133';
ip = '203.252.54.4';
port = 20121;
addpath(genpath(pwd));
%%

main(ip, port, 0); %get status of pathway
main(ip, port, 1, 40); %select the pre-registered program (and if you check "automatic start", it trigger thermal pain)
main(ip, port, 2); % start a program
main(ip, port, 3); % pasue a program
main(ip, port, 4); % trigger a program 
main(ip, port, 5); % stop program
