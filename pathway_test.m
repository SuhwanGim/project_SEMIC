function pathway_test(ip, port, type, reg)
%%
% This fucntion is only for stimulating 50 thermal degree before
% participants experiece thermal pain. It needs two inputs, 1) IP adress
% and 2) port.
%
% See this, ------------------------------------------------
% Matlab: Program name : Program code (parameter, 8bit)
% ---------------------------------------------------------
%   23  : SEMIC_50     :   00011001
%
% writen by Suhwan Gim
%%

global theWindow W H; % window property
global window_rect lb rb tb bb scale_H; % rating scale
global bgcolor;
global fontsize;


Screen(theWindow,'FillRect',bgcolor, window_rect);

msg=double('이동한 열패드의 상태를 확인하기 위해 테스트를 진행하겠습니다(space)');
display_expmessage(msg);

while (1)
    [~,~,keyCode] = KbCheck;
    if keyCode(KbName('q'))==1
        break
    elseif keyCode(KbName('space'))== 1
        break
    end
end

Screen('Flip', theWindow);

switch type
    case 'basic'
        for i = 1:4
            msg = strcat('연구자는 열패드를 해당 위치로 이동시켜주세요 (Space):  ', num2str(i));
            while (1)
                [~,~,keyCode] = KbCheck;
                if keyCode(KbName('space'))==1
                    break;
                elseif keyCode(KbName('q'))==1
                    abort_experiment;
                end
                display_expmessage(msg);
            end
            
            if ~isempty(msg)
                %disp('Please wait a second');
                main(ip, port, 1, 24);
                WaitSecs(0.5);
                clc;
                
                %disp('Ready to start');
                main(ip, port, 2);
                WaitSecs(2);
                clc;
                
                %disp('Start');
                main(ip, port, 2);
                
                sTime=GetSecs;         %      
                msg='';
                display_expmessage(msg);
                
                disp('Done');
            end
            while GetSecs - sTime <14.5 + 10
                % pause
            end
        end
        msg=double('이제부터 조이스틱 연습을 시작하겟습니다(space)');
        
    case 'MRI'
        if ~isempty(msg)
            PathPrg = load_PathProgram('SEMIC');
            % Find the highest themal degree based on the calibration procedure
            for iii=1:length(PathPrg) %find degree
                if reg.FinalLMH_5Level(5) == PathPrg{iii,1}
                    degree = bin2dec(PathPrg{iii,2});
                else
                    % do nothing
                end
            end
            %disp('Please wait a second');
            main(ip, port, 1, degree);
            WaitSecs(0.5);
            clc;
            
            %disp('Ready to start');
            main(ip, port, 2);
            WaitSecs(2);
            clc;
            
            %disp('Start');
            main(ip, port, 2);
            WaitSecs(0.5);
            clc;
            %disp('Done');
            
            sTime=GetSecs;         %
            msg='';
            display_expmessage(msg);
        end
        while GetSecs - sTime <14.5 + 10
            % pause
        end
        msg=double('확인하였습니다.\n다음으로는 척도 확인 및 연습을 시작하겠습니다(space)');
end

while (1)
    [~,~,keyCode] = KbCheck;
    if keyCode(KbName('q'))==1
        break
    elseif keyCode(KbName('space'))== 1
        break
    end
    display_expmessage(msg);
end


end
