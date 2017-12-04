function cali_regression (degree, rating, th, varargin)
% Information
%
% th = 'N'th of trial
% deg = level of heat (thermode)
% rating = subject score for heat-stimulation
%
% 3) where the skin site?
% 4) 너무 낮은 온도나 높은 온도면 제한을 걸어줘야함
% 5) residual 계산을해줘야함

%For example
% input: deg=41; rating=30;
% output: new_deg = [40.5 44 46.5] %low, mid, and high
%=================================================================

% glmfit % glmval % LinearModel.Residuals.Raw: sum of squared errors
% polyfit: in a least-squares sense % polyval
%% SETUP: variable
global reg;
std_rating=[30 50 70]; % low, mid, and high %from L. Atlas et al. (2010)

%% SETUP: Input data
reg.stim_degree(th)=degree;
reg.stim_rating(th)=rating; %0 to 100

%% START:
% 1) fit the linear regression line with least square manner

if th>2 % Trial 3~: fit the regression line (least square manner)
    P=polyfit(reg.stim_degree,reg.stim_rating,1); % (x,y, dimension) regression   
    for i=1:3 % Trial 4~: 1) fit the regression line and 2) save the new degree based on fitted regression line
        %v_rating=P(1).*new_deg+P(2);
        non_corrected_degree=(std_rating(i)-P(2))./P(1);
        reg.cur_heat_LMH(th+1,i)=unit_integer(non_corrected_degree);
    end
else
    reg.cur_heat_LMH(th,:)=0; % this is only for avoiding NaN % Don't use until 3rd trial
    
    
    
    % %for visualization
    % plot(x,y,'o-') % real data
    % plot(x,y,'o-',x,P(1).*x+P(2)); % fit line
    
end

% 2) calculate the level of residual (sum of square)
if th == 24
    reg.sum_residuals(reg.skin_site) = 0;
    total_fit = fitlm(reg.stim_degree,reg.stim_rating);
    for ii=1:th
        reg.sum_residuals(reg.skin_site(ii)) = reg.sum_residuals(reg.skin_site(ii)) + total_fit.Residuals.Raw(ii);
    end
    ForCAL = reg.sum_residuals;
    for iii=1:3 % To find three lowest value and index
        [~, min_dim] = min(ForCAL);
        ForCAL(min_dim) = 999; % mark lowest number
    end
    reg.studySkinSite = find(ForCal==999);
else
    %do nothing
end

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

