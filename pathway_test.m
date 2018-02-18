function pathway_test(ip, port, type, reg)
%%
% This fucntion is only for stimulating 50 thermal degree before
% participants experiece thermal pain. It needs two inputs, 1) IP adress
% and 2) port.
%
% See this, ---------------------------------------------------------
% Matlab: Program name : Program code (parameter, 8bit)
% ---------------------------------------------------------
%   23  : SEMIC_50     :   00011001
%
% writen by Suhwan Gim
%%
clc;
txt=input('For experiment, participants experience some test. If researcher ready to strat, please type the any text.','s');
switch type
    case 'basic'
        if ~isempty(txt)
            disp('Please wait a second');
            main(ip, port, 1, 24);
            WaitSecs(0.5);
            disp('Ready to start');
            main(ip, port, 2);
            WaitSecs(1.5);
            disp('Start');
            main(ip, port, 2);
            WaitSecs(0.5);
        end
    case 'MRI'
        if ~isempty(txt)
            PathPrg = load_PathProgram('SEMIC');
            % Find the highest themal degree based on the calibration procedure           
            for iii=1:length(PathPrg) %find degree
                if reg.FinalLMH_5Level(5) == PathPrg{iii,1}
                    degree = bin2dec(PathPrg{iii,2});
                else
                    % do nothing
                end
            end
            disp('Please wait a second');
            main(ip, port, 1, degree);
            WaitSecs(0.5);
            clc;
            
            disp('Ready to start');
            main(ip, port, 2);
            WaitSecs(1.5);
            
            clc;
            disp('Start');
            main(ip, port, 2);
            WaitSecs(0.5);
        end
end

end
