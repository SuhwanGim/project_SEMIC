function draw_scale(scale)

% DRAWRING SCALES
% draw_scale(scale)

global theWindow W H; % window property
global white red orange bgcolor; % color
global window_rect prompt_ex lb rb tb bb scale_H promptW promptH; % rating scale
global lb1 rb1 lb2 rb2;
global fontsize anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd anchor_lms anchor_lms_y anchor_lms_x; % anchors

switch scale
    case 'line'
        xy = [lb lb lb rb rb rb; H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawText','Not',lb-50,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
        Screen(theWindow,'DrawText','Worst',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
        % Screen('Flip', theWindow);
    case 'overall_int'
        %xy = [lb lb lb rb rb rb; H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        % added middle line
        xy = [lb lb lb (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 rb rb rb; ...
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawText','0 kg/cm^2',lb-60,anchor_y,255);
        Screen(theWindow,'DrawText',' ',lb-50,anchor_y2,255);
        Screen(theWindow,'DrawText','10 kg/cm^2',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText',' ',rb-50,anchor_y2,255);
        % Screen('Flip', theWindow);
    case 'overall_avoidance'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen('TextSize', theWindow, 28); % fonsize for anchors
        Screen(theWindow,'DrawText',double('전혀'),lb-35,anchor_y,255);
        Screen(theWindow,'DrawText',double('최대'),rb,anchor_y,255);
        Screen('TextSize', theWindow, fontsize); % fonsize for anchors
        % Screen('Flip', theWindow);
    case 'overall_unpleasant'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen(theWindow,'DrawText','Not',lb-50,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
        Screen(theWindow,'DrawText','Worst',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
    case 'lms'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen(theWindow,'DrawText','Not',lb-100,anchor_y-20,255);
        Screen(theWindow,'DrawText','at all',lb-100,anchor_y2-20,255);
        Screen(theWindow,'DrawText','Worst',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
        for i = 1:5
            Screen('DrawLine', theWindow, 0, anchor(i), H/2+scale_H, anchor(i), H/2, 2);
        end
        Screen(theWindow,'DrawText','barely',anchor(1)-30,anchor_y+scale_H/2.5,255);
        Screen(theWindow,'DrawText','detectable',anchor(1)-30,anchor_y2+scale_H/2.5,255);
        Screen(theWindow,'DrawText','weak',anchor(2)-10,anchor_y,255);
        Screen(theWindow,'DrawText','moderate',anchor(3),anchor_y,255);
        Screen(theWindow,'DrawText','strong',anchor(4),anchor_y,255);
        Screen(theWindow,'DrawText','very',anchor(5),anchor_y,255);
        Screen(theWindow,'DrawText','strong',anchor(5),anchor_y2,255);
        % Screen('Flip', theWindow);
    case 'cont_int'
        xy = [lb H/6+scale_H; rb H/6+scale_H; rb H/6];
        Screen(theWindow, 'FillPoly', orange, xy);
        Screen(theWindow,'DrawText','Not',lb-50,H/6+10+scale_H,255);
        Screen(theWindow,'DrawText','at all',lb-50,H/6+10+scale_H+25,255);
        Screen(theWindow,'DrawText','Strongest',rb-50,H/6+10+scale_H,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,H/6+10+scale_H+25,255);
        % Screen('Flip', theWindow);
    case 'cont_avoidance'
        xy = [lb H/6+scale_H; rb H/6+scale_H; rb H/6];
        Screen(theWindow, 'FillPoly', orange, xy);
        Screen(theWindow,'DrawText','Not',lb-35,H/6+10+scale_H,255);
        Screen(theWindow,'DrawText','at all',lb-35,H/6+10+scale_H+25,255);
        Screen(theWindow,'DrawText','Most',rb,H/6+10+scale_H,255);
        Screen(theWindow,'DrawText',' ',rb,H/6+10+scale_H+25,255);
        %     case 'overall_int'
        %         xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        %         Screen(theWindow, 'FillPoly', 255, xy);
        %         Screen(theWindow,'DrawText','Not',lb-50,anchor_y,255);
        %         Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
        %         Screen(theWindow,'DrawText','Strongest',rb-50,anchor_y,255);
        %         Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
    case 'overall_aversive_ornot'
        lb2 = W/3;
        rb2 = (W*2)/3;
        lb3 = lb2+((rb2-lb2).*0.4);
        rb3 = rb2-((rb2-lb2).*0.4);
        xy = [lb2 lb2 lb2 lb3 lb3 lb3;
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        xy2 = [rb2 rb2 rb2 rb3 rb3 rb3;
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawLines', xy2, 5, 255);
        Screen(theWindow,'DrawText','YES',lb2+50,H/2-scale_H/2,255);
        Screen(theWindow,'DrawText','NO',rb3+50,H/2-scale_H/2,255);
    case 'overall_pain_ornot'
        lb2 = W/3;
        rb2 = (W*2)/3;
        lb3 = lb2+((rb2-lb2).*0.4);
        rb3 = rb2-((rb2-lb2).*0.4);
        xy = [lb2 lb2 lb2 lb3 lb3 lb3;
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        xy2 = [rb2 rb2 rb2 rb3 rb3 rb3;
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawLines', xy2, 5, 255);
        Screen(theWindow,'DrawText','YES',lb2+50,H/2-scale_H/2,255);
        Screen(theWindow,'DrawText','NO',rb3+50,H/2-scale_H/2,255);
    case 'overall_boredness'
        %xy = [lb lb lb rb rb rb; H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        % added middle line
        xy = [lb lb lb rb rb rb; ...
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawText','Not bored',lb-40,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-40,anchor_y2,255);
        Screen(theWindow,'DrawText','Extremely',rb-35,anchor_y,255);
        Screen(theWindow,'DrawText','Bored',rb-35,anchor_y2,255);
        % Screen('Flip', theWindow);
    case 'overall_alertness'
        %xy = [lb lb lb rb rb rb; H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        % added middle line
        xy = [lb lb lb (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 rb rb rb; ...
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawText','Extremely',lb-35,anchor_y,255);
        Screen(theWindow,'DrawText','sleepy',lb-35,anchor_y2,255);
        
        Screen(theWindow,'DrawText','Neutral',(lb+rb)/2-35,anchor_y,255);
        
        Screen(theWindow,'DrawText','Extremely',rb-35,anchor_y,255);
        Screen(theWindow,'DrawText','alert',rb-35,anchor_y2,255);
        % Screen('Flip', theWindow);
    case 'overall_relaxed'
        xy = [lb lb lb rb rb rb; ...
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawText','Least',lb-40,anchor_y,255);
        Screen(theWindow,'DrawText','relaxed',lb-40,anchor_y2,255);
        Screen(theWindow,'DrawText','Most',rb-35,anchor_y,255);
        Screen(theWindow,'DrawText','relaxed',rb-35,anchor_y2,255);
    case 'overall_attention'
        xy = [lb lb lb rb rb rb; ...
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawText','Not',lb-40,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-40,anchor_y2,255);
        Screen(theWindow,'DrawText','Best',rb-35,anchor_y,255);
    case 'overall_resting_positive'
        %xy = [lb lb lb rb rb rb; H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        % added middle line
        xy = [lb lb lb (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 rb rb rb; ...
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawText','Strongly',lb-35,anchor_y,255);
        Screen(theWindow,'DrawText','agree',lb-35,anchor_y2,255);
        
        Screen(theWindow,'DrawText','Neutral',(lb+rb)/2-35,anchor_y,255);
        
        Screen(theWindow,'DrawText','Strongly',rb-35,anchor_y,255);
        Screen(theWindow,'DrawText','disagree',rb-35,anchor_y2,255);
        % Screen('Flip', theWindow);
    case 'overall_resting_negative'
        %xy = [lb lb lb rb rb rb; H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        % added middle line
        xy = [lb lb lb (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 rb rb rb; ...
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawText','Strongly',lb-35,anchor_y,255);
        Screen(theWindow,'DrawText','agree',lb-35,anchor_y2,255);
        
        Screen(theWindow,'DrawText','Neutral',(lb+rb)/2-35,anchor_y,255);
        
        Screen(theWindow,'DrawText','Strongly',rb-35,anchor_y,255);
        Screen(theWindow,'DrawText','disagree',rb-35,anchor_y2,255);
        % Screen('Flip', theWindow);
    case 'overall_resting_myself'
        %xy = [lb lb lb rb rb rb; H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        % added middle line
        xy = [lb lb lb (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 rb rb rb; ...
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawText','Strongly',lb-35,anchor_y,255);
        Screen(theWindow,'DrawText','agree',lb-35,anchor_y2,255);
        
        Screen(theWindow,'DrawText','Neutral',(lb+rb)/2-35,anchor_y,255);
        
        Screen(theWindow,'DrawText','Strongly',rb-35,anchor_y,255);
        Screen(theWindow,'DrawText','disagree',rb-35,anchor_y2,255);
        % Screen('Flip', theWindow);
    case 'overall_resting_others'
        %xy = [lb lb lb rb rb rb; H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        % added middle line
        xy = [lb lb lb (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 rb rb rb; ...
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawText','Strongly',lb-35,anchor_y,255);
        Screen(theWindow,'DrawText','agree',lb-35,anchor_y2,255);
        
        Screen(theWindow,'DrawText','Neutral',(lb+rb)/2-35,anchor_y,255);
        
        Screen(theWindow,'DrawText','Strongly',rb-35,anchor_y,255);
        Screen(theWindow,'DrawText','disagree',rb-35,anchor_y2,255);
        % Screen('Flip', theWindow);
    case 'overall_resting_imagery'
        %xy = [lb lb lb rb rb rb; H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        % added middle line
        xy = [lb lb lb (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 rb rb rb; ...
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawText','Strongly',lb-35,anchor_y,255);
        Screen(theWindow,'DrawText','agree',lb-35,anchor_y2,255);
        
        Screen(theWindow,'DrawText','Neutral',(lb+rb)/2-35,anchor_y,255);
        
        Screen(theWindow,'DrawText','Strongly',rb-35,anchor_y,255);
        Screen(theWindow,'DrawText','disagree',rb-35,anchor_y2,255);
        % Screen('Flip', theWindow);
    case 'overall_resting_present'
        %xy = [lb lb lb rb rb rb; H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        % added middle line
        xy = [lb lb lb (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 rb rb rb; ...
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawText','Strongly',lb-35,anchor_y,255);
        Screen(theWindow,'DrawText','agree',lb-35,anchor_y2,255);
        
        Screen(theWindow,'DrawText','Neutral',(lb+rb)/2-35,anchor_y,255);
        
        Screen(theWindow,'DrawText','Strongly',rb-35,anchor_y,255);
        Screen(theWindow,'DrawText','disagree',rb-35,anchor_y2,255);
        % Screen('Flip', theWindow);
    case 'overall_resting_past'
        %xy = [lb lb lb rb rb rb; H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        % added middle line
        xy = [lb lb lb (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 rb rb rb; ...
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawText','Strongly',lb-35,anchor_y,255);
        Screen(theWindow,'DrawText','agree',lb-35,anchor_y2,255);
        
        Screen(theWindow,'DrawText','Neutral',(lb+rb)/2-35,anchor_y,255);
        
        Screen(theWindow,'DrawText','Strongly',rb-35,anchor_y,255);
        Screen(theWindow,'DrawText','disagree',rb-35,anchor_y2,255);
        % Screen('Flip', theWindow);
    case 'overall_resting_future'
        %xy = [lb lb lb rb rb rb; H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        % added middle line
        xy = [lb lb lb (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 rb rb rb; ...
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawText','Strongly',lb-35,anchor_y,255);
        Screen(theWindow,'DrawText','agree',lb-35,anchor_y2,255);
        
        Screen(theWindow,'DrawText','Neutral',(lb+rb)/2-35,anchor_y,255);
        
        Screen(theWindow,'DrawText','Strongly',rb-35,anchor_y,255);
        Screen(theWindow,'DrawText','disagree',rb-35,anchor_y2,255);
        % Screen('Flip', theWindow);
    case 'overall_resting_bitter_int'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen(theWindow,'DrawText','Not',lb-50,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
        Screen(theWindow,'DrawText','Strongest',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
    case 'overall_resting_bitter_unp'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen(theWindow,'DrawText','Not',lb-50,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
        Screen(theWindow,'DrawText','Worst',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
    case 'overall_resting_capsai_int'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen(theWindow,'DrawText','Not',lb-50,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
        Screen(theWindow,'DrawText','Strongest',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
    case 'overall_resting_capsai_unp'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen(theWindow,'DrawText','Not',lb-50,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
        Screen(theWindow,'DrawText','Worst',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
    case 'overall_thermal_int'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen(theWindow,'DrawText','Not',lb-50,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
        Screen(theWindow,'DrawText','Strongest',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
    case 'overall_thermal_unp'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen(theWindow,'DrawText','Not',lb-50,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
        Screen(theWindow,'DrawText','Worst',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
    case 'overall_pressure_int'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen(theWindow,'DrawText','Not',lb-50,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
        Screen(theWindow,'DrawText','Strongest',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
    case 'overall_pressure_unp'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen(theWindow,'DrawText','Not',lb-50,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
        Screen(theWindow,'DrawText','Worst',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
    case 'overall_negvis_int'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen(theWindow,'DrawText','Not',lb-50,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
        Screen(theWindow,'DrawText','Strongest',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
    case 'overall_negvis_unp'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen(theWindow,'DrawText','Not',lb-50,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
        Screen(theWindow,'DrawText','Worst',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
    case 'overall_negaud_int'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen(theWindow,'DrawText','Not',lb-50,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
        Screen(theWindow,'DrawText','Strongest',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
    case 'overall_negaud_unp'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen(theWindow,'DrawText','Not',lb-50,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
        Screen(theWindow,'DrawText','Worst',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
    case 'overall_posvis_int'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen(theWindow,'DrawText','Not',lb-50,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
        Screen(theWindow,'DrawText','Strongest',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
    case 'overall_posvis_ple'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen(theWindow,'DrawText','Not',lb-50,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
        Screen(theWindow,'DrawText','Most',rb-50,anchor_y,255);
        Screen(theWindow,'DrawText','imaginable',rb-50,anchor_y2,255);
    case 'overall_comfortness'
        xy = [lb lb lb rb rb rb; ...
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawText','Not',lb-40,anchor_y,255);
        Screen(theWindow,'DrawText','at all',lb-40,anchor_y2,255);
        Screen(theWindow,'DrawText','Most',rb-35,anchor_y,255);
        Screen(theWindow,'DrawText',' ',rb-35,anchor_y2,255);
    case 'overall_mood'
        xy = [lb lb lb (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 (lb+rb)/2 rb rb rb; ...
            H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
        Screen(theWindow,'DrawLines', xy, 5, 255);
        Screen(theWindow,'DrawText','Negative',lb-35,anchor_y,255);
        Screen(theWindow,'DrawText','Neutral',(lb+rb)/2-35,anchor_y,255);
        Screen(theWindow,'DrawText','Positive',rb-35,anchor_y,255);
    case 'cont_avoidance_exp'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', orange, xy);
        Screen(theWindow,'DrawText','Not',lb-35,H/2+10+scale_H,255);
        Screen(theWindow,'DrawText','at all',lb-35,H/2+10+scale_H+25,255);
        Screen(theWindow,'DrawText','Most',rb,H/2+10+scale_H,255);
        Screen(theWindow,'DrawText',' ',rb,H/2+10+scale_H+25,255);
    case 'valance_selfrelevance'
        
        xcenter = (lb+rb)/2;
        ycenter = bb;
        xy = [lb xcenter xcenter xcenter rb xcenter xcenter xcenter;
            ycenter ycenter tb ycenter ycenter ycenter bb ycenter];
        
        Screen('TextSize', theWindow, 22);
        anchor_W = Screen(theWindow,'DrawText', double('나와 매우 관련'), 0, 0, bgcolor);
        
        Screen(theWindow, 'FillRect', bgcolor, window_rect); % reset
        
        Screen('DrawLines',theWindow, xy, 3, 255);
        Screen(theWindow,'DrawText', double('부정적'), anchor_xl, ycenter-10, 255);
        Screen(theWindow,'DrawText', double('긍정적'), anchor_xr, ycenter-10, 255);
        
        Screen(theWindow,'DrawText', double('나와 매우 관련'), xcenter-anchor_W/2, anchor_yu, 255);
        Screen(theWindow,'DrawText', double('나와 관련 없음'), xcenter-anchor_W/2, anchor_yd, 255);
        Screen('TextSize', theWindow, fontsize);
        
    case 'time'
        xcenter = (lb+rb)/2;
        ycenter = bb;
        
        xy = [lb lb lb xcenter xcenter xcenter xcenter rb rb rb; ...
            ycenter-scale_H/2 ycenter+scale_H/2 ycenter ycenter ycenter-scale_H/2 ycenter+scale_H/2 ycenter ...
            ycenter ycenter-scale_H/2 ycenter+scale_H/2];
        
        Screen('TextSize', theWindow, 22);
        anchor_W = Screen(theWindow,'DrawText', double('과거'), 0, 0, bgcolor);
        
        Screen(theWindow, 'FillRect', bgcolor, window_rect); % reset
        
        Screen(theWindow,'DrawLines', xy, 3, 255);
        Screen(theWindow,'DrawText', double('과거'), lb-anchor_W/2, ycenter-50, 255);
        Screen(theWindow,'DrawText', double('현재'), (lb+rb)/2-anchor_W/2, ycenter-50, 255);
        Screen(theWindow,'DrawText', double('미래'), rb-anchor_W/2, ycenter-50, 255);
        Screen('TextSize', theWindow, fontsize);
        
    case 'overall_avoidance_semicircular'
        xcenter = (lb+rb)/2;
        ycenter = bb;
        
        radius = (rb-lb)/2; % radius
        x = reshape(repmat(linspace(lb,rb,1000),2,1),1,2000); x([1 2000]) = [];
        xy = [x; bb - sqrt(radius.^2 - (x-xcenter).^2)];
        
        Screen('TextSize', theWindow, 28); % fonsize for anchors
        Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        anchor_W = Screen(theWindow,'DrawText', double('전혀'), 0, 0, bgcolor);
        anchor_W2 = Screen(theWindow,'DrawText', double('최대'), 0, 0, bgcolor);
        
        % Screen(theWindow, 'FillRect', bgcolor, window_rect); % reset
        
        Screen(theWindow,'DrawLines', xy, 3, 255);
        Screen(theWindow,'DrawText', double('전혀'), lb-anchor_W/2, ycenter+20, 255);
        Screen(theWindow,'DrawText', double('최대'), rb-anchor_W2/2, ycenter+20, 255);
        
        Screen('TextSize', theWindow, fontsize); % fonsize for instructions
        
    case 'overall_motor'
        xy = [lb H/2+scale_H; rb H/2+scale_H; rb H/2];
        Screen(theWindow, 'FillPoly', 255, xy);
        Screen('TextSize', theWindow, 28); % fonsize for anchors
        Screen(theWindow,'DrawText',double('전혀'),lb-35,anchor_y,255);
        Screen(theWindow,'DrawText',double('최대'),rb,anchor_y,255);
        Screen('TextSize', theWindow, fontsize); % fonsize for anchors
        % Screen('Flip', theWindow);
        
    case 'overall_motor_semicircular'
        xcenter = (lb+rb)/2;
        ycenter = bb;
        
        radius = (rb-lb)/2; % radius
        x = reshape(repmat(linspace(lb,rb,1000),2,1),1,2000); x([1 2000]) = [];
        xy = [x; bb - sqrt(radius.^2 - (x-xcenter).^2)];
        
        Screen('TextSize', theWindow, 28); % fonsize for anchors
        
        anchor_W = Screen(theWindow,'DrawText', double('전혀'), 0, 0, bgcolor);
        anchor_W2 = Screen(theWindow,'DrawText', double('최대'), 0, 0, bgcolor);
        
        % Screen(theWindow, 'FillRect', bgcolor, window_rect); % reset
        Screen(theWindow,'DrawLines', xy, 3, 255);
        
        Screen(theWindow,'DrawText', double('0'), lb-anchor_W/2, ycenter+20, 255);
        Screen(theWindow,'DrawText', double('180'), rb-anchor_W2/2, ycenter+20, 255);
        
        Screen('TextSize', theWindow, fontsize); % fonsize for instructions
        
        
    case 'explain_painful_semicircular'
        
        xcenter = (lb+rb)/2;
        ycenter = bb;
        
        radius = (rb-lb)/2; % radius
        x = reshape(repmat(linspace(lb,rb,1000),2,1),1,2000); x([1 2000]) = [];
        xy = [x; bb - sqrt(radius.^2 - (x-xcenter).^2)];
        
        Screen('TextSize', theWindow, 28); % fonsize for anchors
        
        anchor_W = Screen(theWindow,'DrawText', double('전혀'), 0, 0, bgcolor);
        anchor_W2 = Screen(theWindow,'DrawText', double('조금'), 0, 0, bgcolor);
        anchor_W3 = Screen(theWindow,'DrawText', double('보통'), 0, 0, bgcolor);
        anchor_W4 = Screen(theWindow,'DrawText', double('많이'), 0, 0, bgcolor);
        anchor_W5 = Screen(theWindow,'DrawText', double('매우많이'), 0, 0, bgcolor);
        anchor_W6 = Screen(theWindow,'DrawText', double('최대'), 0, 0, bgcolor);
        
        % Screen(theWindow, 'FillRect', bgcolor, window_rect); % reset
        Screen(theWindow,'DrawLines', xy, 3, 255);
        
        
        Screen(theWindow,'DrawText', double('1'), lb-anchor_W/2, ycenter, 255); %전혀
        Screen(theWindow,'DrawText', double('2'), anchor_lms_x(1), anchor_lms_y(1), 255);
        Screen(theWindow,'DrawText', double('3'), anchor_lms_x(2), anchor_lms_y(2), 255);
        Screen(theWindow,'DrawText', double('4'), anchor_lms_x(3), anchor_lms_y(3), 255);
        Screen(theWindow,'DrawText', double('5'), anchor_lms_x(4), anchor_lms_y(4), 255);
        Screen(theWindow,'DrawText', double('6'), rb-anchor_W6/2+40, ycenter, 255); %최대
        
        Screen('TextSize', theWindow, fontsize); % fonsize for instructions
        
        
    case 'cont_predict_semicircular' %For SEMIC project
        % For bigger rating scale, we use both new boundary [lb1 rb1]
        
        xcenter = (lb1+rb1)/2;
        ycenter = H*3/4+100;
        %ycenter = bb;
        
        
        %       radius = (rb1-lb1)/2; % radius
        %       x = reshape(repmat(linspace(lb1,rb1,1000),2,1),1,2000); x([1 2000]) = [];
        %       xy = [x; bb - sqrt(radius.^2 - (x-xcenter).^2)];
        skip_step = 4;
        end_step = 18; %even number
        start_step = 1;
        
        for j=start_step:(end_step/2) - skip_step
            i=j-start_step+1; % 1 to (end_step-start_step)
            lb_temp = j*W/end_step; rb_temp = (end_step-j)*W/end_step; %1*w/50, 49*W/50
            radius = (rb_temp-lb_temp)/2; % radius
            x_temp = reshape(repmat(linspace(lb_temp, rb_temp,1000),2,1),1,2000); x_temp([1 2000]) = [];
            y_temp = ycenter - sqrt(radius.^2 - (x_temp-xcenter).^2);
            x(:,i*1998-1997:i*1998) = x_temp;
            y(:,i*1998-1997:i*1998) = y_temp;
            %xy = [x; bb - sqrt(radius.^2 - (x-xcenter).^2)];
        end
        xy = [x; y];
        
        Screen('TextSize', theWindow, 24); % fonsize for anchors
        Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        anchor_W = Screen(theWindow,'DrawText', double('전혀'), 0, 0, bgcolor);
        anchor_W2 = Screen(theWindow,'DrawText', double('최대'), 0, 0, bgcolor);
        
        % Screen(theWindow, 'FillRect', bgcolor, window_rect); % reset
        
        Screen(theWindow,'DrawLines', xy, 2, [255 255 255 230]);
        Screen(theWindow,'DrawText', double('전혀'), x(1)-anchor_W/2, ycenter+20, 255); %lb1
        Screen(theWindow,'DrawText', double('최대'), max(x)-anchor_W2/2, ycenter+20, 255); %rb1
        
        Screen('TextSize', theWindow, fontsize); % fonsize for instructions
        
        
    case 'overall_predict_semicircular' %For SEMIC project
        % For bigger rating scale, we use both new boundary [lb1 rb1]
        
        xcenter = (lb1+rb1)/2;
        ycenter = H*3/4+100;
        %ycenter = bb;
        
        
        %       radius = (rb1-lb1)/2; % radius
        %       x = reshape(repmat(linspace(lb1,rb1,1000),2,1),1,2000); x([1 2000]) = [];
        %       xy = [x; bb - sqrt(radius.^2 - (x-xcenter).^2)];
        end_step = 18; %even number
        skip_step = 4;
        start_step = 5;
        
        for j=start_step:((end_step/2) - skip_step)
            i=j-start_step+1; % 1 to (end_step-start_step)
            lb_temp = j*W/end_step; rb_temp = (end_step-j)*W/end_step; %4*w/18, 14*W
            radius = (rb_temp-lb_temp)/2; % radius
            x_temp = reshape(repmat(linspace(lb_temp, rb_temp,1000),2,1),1,2000); x_temp([1 2000]) = [];
            y_temp = ycenter - sqrt(radius.^2 - (x_temp-xcenter).^2);
            x(:,i*1998-1997:i*1998) = x_temp;
            y(:,i*1998-1997:i*1998) = y_temp;
            %xy = [x; bb - sqrt(radius.^2 - (x-xcenter).^2)];
        end
        xy = [x; y];
        
        Screen('TextSize', theWindow, 24); % fonsize for anchors
        Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        anchor_W = Screen(theWindow,'DrawText', double('전혀'), 0, 0, bgcolor);
        anchor_W2 = Screen(theWindow,'DrawText', double('최대'), 0, 0, bgcolor);
        
        % Screen(theWindow, 'FillRect', bgcolor, window_rect); % reset
        
        Screen(theWindow,'DrawLines', xy, 2, [255 255 255 230]);
        Screen(theWindow,'DrawText', double('전혀'), x(1)-anchor_W/2, ycenter+20, 255); %lb1
        Screen(theWindow,'DrawText', double('최대'), max(x)-anchor_W2/2, ycenter+20, 255); %rb1
        
        Screen('TextSize', theWindow, fontsize); % fonsize for instructions
 
end

end