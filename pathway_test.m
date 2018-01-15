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
txt=input('지금부터 피부 테스트를 진행하겠습니다. 준비가 되셨으면 아무 키나 입력해주세요','s');
switch type
    case 'basic'
        if ~isempty(txt)
            disp('잠시만 기다려주세요');
            WaitSecs(0.5);
            main(ip, port, 1, 24);
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
            disp('잠시만 기다려주세요');
            WaitSecs(0.5);
            main(ip, port, 1, degree);
        end
end

end
