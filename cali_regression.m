function cali_regression (degree, rating, th, varargin)
% Information
%
% th = 'N'th of trial
% deg = level of heat (thermode)
% rating = subject score for heat-stimulation
%
% 3) where the skin site?
% 4) �ʹ� ���� �µ��� ���� �µ��� ������ �ɾ������
% 5) residual ������������

%For example
% input: deg=41; rating=30;
% output: new_deg = [40.5 44 46.5] %low, mid, and high
%=================================================================

% glmfit
% glmval
% sse: sum squared error performance function --> Neural Network Toolbox
% LinearModel.SSE: sum of squared errors --> Stats and machine learning
%                                           Toolbox
% polyfit: in a least-squares sense
% polyval


%% SETUP: variable
global reg;
std_rating=[30 50 70]; % low, mid, and high %from L. Atlas et al. (2010)


%% SETUP: Input data
reg.stim_degree(th)=degree;
reg.stim_rating(th)=rating; %0 to 100

%% START:

if th>2
    P=polyfit(reg.stim_degree,reg.stim_rating,1); % (x,y, dimension) regression
    if th>4
        for i=1:3
            %v_rating=P(1).*new_deg+P(2);
            non_corrected_degree=(std_rating(i)-P(2))./P(1);
            reg.cur_heat_LMH(th,i)=unit_integer(non_corrected_degree);
        end
    else
        reg.cur_heat_LMH(th,:)=0;
    end
else
    %do nothing
end




% %for visualization
% plot(x,y,'o-') % real data
% plot(x,y,'o-',x,P(1).*x+P(2)); % fit line


end


%======================SUB_FUNCTION=======================================
function c_number=unit_integer(uc_number)
%For example
% 1) .75-> 1.0
%   1-1)        .74 -> 0.5
% 2).25-> .5
%   2-1)        .24 -> 0.0
%
% Input=[44.34 43.11 45.57 43.89 43.75 43.77 44.77 45.13 46.1 ];
% Output=[44.5 43 45.5 44 43.5 44 45 45 46];

uc_number=uc_number.*2;
c_number=round(uc_number)./2;

% limitation
c_number(c_number > 48) = 48;
c_number(c_number < 41) = 41;
end

