function exp_scale(scale)

% explane scale (overall and continuous)
% MESSAGE FOR EACH RUN

global theWindow W H; % window property
global white red orange bgcolor; % color
global window_rect prompt_ex lb rb tb bb scale_H promptW promptH; % rating scale
global lb1 rb1 lb2 rb2;
global fontsize anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd anchor_lms anchor_lms_y anchor_lms_x; % anchors


 
Screen(theWindow,'FillRect',bgcolor, window_rect);


switch scale
    case 'predict'
        msg = double('이 척도가 화면에 나타나면\n "이번 자극이 최대 얼마나 아플까요?"에 대해 보고를 해 주시면 되겠습니다.');
        % display
        Screen('TextSize', theWindow, 28);
        DrawFormattedText(theWindow, msg, 'center', 1/5*H, white, [], [], [], 1);
        draw_scale('cont_predict_semicircular');
        Screen('Flip', theWindow);
        while (1)
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('s'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment;
            end
        end
        Screen('TextSize', theWindow, 28);
        msg = double('그러면 지금부터 연습을 시작하겠습니다.\n 척도가 화면에 뜨면 바로 움직여 주세요.');
        DrawFormattedText(theWindow, msg, 'center', 'center', white, [], [], [], 1);
        Screen('Flip', theWindow);
        WaitSecs(5);
        rnd=randperm(5,1);
        WaitSecs(rnd);
        start_while = GetSecs;
        
        cir_center = [(lb1+rb1)/2 H*3/4+100];
        SetMouse(cir_center(1), cir_center(2)); % set mouse at the center
        while GetSecs-start_while < 10
            [x,y,~]=GetMouse(theWindow);
            radius = (rb1-lb1)/2; % radius
            theta = atan2(cir_center(2)-y,x-cir_center(1));
            % current euclidean distance
            curr_r = sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2);
            % current angle (0 - 180 deg)
            curr_theta = rad2deg(-theta+pi);
            % For control a mouse cursor:
            % send to diameter of semi-circle
            if y > cir_center(2)%%bb
                y = cir_center(2); %%bb;
                SetMouse(x,y);
            end
            % send to arc of semi-circle
            if sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2) > radius
                x = radius*cos(theta)+cir_center(1);
                y = cir_center(2)-radius*sin(theta);
                SetMouse(x,y);
            end
            draw_scale('cont_predict_semicircular');
            Screen('DrawDots', theWindow, [x y], 15, orange, [0 0], 1);
            Screen('Flip', theWindow);
        end
        
        
        
end

end

