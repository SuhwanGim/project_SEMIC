function explain_scale(exp_scale, rating_types, varargin)

% EXPLAIN SCALE
% explain_scale(exp_scale)

global theWindow W H; % window property
global white red orange bgcolor; % color
global window_rect lb rb scale_H promptW promptH joy_speed; % rating scale

use_joystick = false;
use_mouse = false;

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'joystick'}
                use_joystick = true;
            case {'mouse', 'trackball'}
                use_mouse = true;
        end
    end
end

%% Prompt setup
prompt_ex = prompt_setup; 

%% parse the inputs
for i = 1:numel(exp_scale.inst)
    
    % first: START page
    if i == 1
        while (1) % space
            DrawFormattedText(theWindow, prompt_ex{4}, 'center', 100, white);
            DrawFormattedText(theWindow, prompt_ex{5}, 'center', 150, white);
            Screen('Flip', theWindow);
            
            if use_joystick
                [~, joy_button] = mat_joy(0);
            elseif use_mouse
                [~,~,button] = GetMouse(theWindow);
            end
            [~,~,keyCode] = KbCheck;
            
            if use_mouse
                if button(1), break, end
            elseif use_joystick
                if joy_button(1), break, end
            end
            
            if keyCode(KbName('q'))==1
                abort_man;
            end
        end
    end
    
    % EXPLAIN
    prompt_n = strcmp(rating_types.alltypes, exp_scale.inst{i});
    while (1) % space
        draw_scale(exp_scale.inst{i}); % draw scale
        DrawFormattedText(theWindow, prompt_ex{1}, 'center', 100, orange, [], [], [], 1.2);
        DrawFormattedText(theWindow, rating_types.prompts{prompt_n}, 'center', 150, white, [], [], [], 1.2);
        Screen('Flip', theWindow);
        
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('space'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_man;
        end
    end
    
    if use_mouse
        get_overallratings(exp_scale.inst{i}, [], rating_types, [], [], 'explain_scale', prompt_ex{2}, 'mouse')
    elseif use_joystick
        get_overallratings(exp_scale.inst{i}, [], rating_types, [], [], 'explain_scale', prompt_ex{2}, 'joystick')
    end
    
    % Move to next
    if i < numel(exp_scale.inst)
        while (1) % space
            DrawFormattedText(theWindow, prompt_ex{3}, 'center', 100, orange, [], [], [], 1.2);
            if prompt_n == 1
                DrawFormattedText(theWindow, prompt_ex{6}, 'center', 150, orange, [], [], [], 1.2);
            end
            Screen('Flip', theWindow);
            
            if use_joystick
                [~, joy_button] = mat_joy(0);
            elseif use_mouse
                [~,~,button] = GetMouse(theWindow);
            end
            [~,~,keyCode] = KbCheck;
            
            if use_mouse
                if button(1), break, end
            elseif use_joystick
                if joy_button(1), break, end
            end
            
            if keyCode(KbName('q'))==1
                abort_man;
            end
            
        end
    else
        while (1) % space
            DrawFormattedText(theWindow, prompt_ex{7}, 'center', 100, orange, [], [], [], 1.2);
            DrawFormattedText(theWindow, prompt_ex{8}, 'center', 150, orange, [], [], [], 1.2);
            
            if strncmp(exp_scale.inst{i}, 'cont_', 5)
                DrawFormattedText(theWindow, prompt_ex{6}, 'center', 300, orange, [], [], [], 1.2);
            end
            
            Screen('Flip', theWindow);
            
            if use_joystick
                [~, joy_button] = mat_joy(0);
            elseif use_mouse
                [~,~,button] = GetMouse(theWindow);
            end
            [~,~,keyCode] = KbCheck;
            
            if use_mouse
                if button(1), break, end
            elseif use_joystick
                if joy_button(1), break, end
            end
            
            if keyCode(KbName('q'))==1
                abort_man;
            end
            
        end
    end
end

end


function prompt_ex = prompt_setup

% prompt = prompt_setup

%% Instructions
prompt_ex{1} = double('척도 연습: 실험자가 어떻게 반응 척도를 사용할 지에 대해 설명할 것입니다 (실험자, 스페이스를 눌러주세요).');
prompt_ex{2} = double('척도 연습: 반응 척도의 사용을 연습해 보세요 (좌우이동). 연습을 마치신 후에는 버튼을 누르시면 됩니다.');
prompt_ex{3} = double('잘 하셨습니다! 다음 화면으로 가시려면 버튼을 눌러주세요.');

%% some additional instructions
prompt_ex{4} = double('안녕하세요. 실험을 곧 시작하도록 하겠습니다. 먼저 반응 척도를 연습하는 것부터 해보겠습니다.');
prompt_ex{5} = double('준비가 되셨으면 버튼을 눌러주세요.');
prompt_ex{6} = double('연습을 할 때는 버튼을 누르셨지만 실제 실험에서 연속반응을 보고할 시에는 버튼을 누르실 필요가 없습니다.');
prompt_ex{7} = double('잘 하셨습니다! 이제 연습을 마치고 실제 실험에 들어가도록 하겠습니다.');
prompt_ex{8} = double('준비가 되셨으면 버튼을 눌러주세요.');

end