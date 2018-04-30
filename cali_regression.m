function cali_regression (degree, rating, th, NumOfTr)
%%
% This function calibrate heat perception for each individuals.There are
% two steps in this function. First fit the regression line usgin least
% squre manner until last trial. Second, find well-fitted skin sites and
% export on command line.
% =======================================================================
% 1. INPUT VARIALBE
%  1) th = 'N'th of trial 2) deg = level of heat (thermode) 3) rating =
%  subject score for heat-stimulation 4) NumOftr = Total number of trial
% 2. For example input: deg=41; rating=30; output: [40.5 44 46.5] %low,
% mid, and high
%========================================================================
% ONE IMPORTANT NOTIFICATION : This function include some Statistical and
% Machine learning Toolbox functions. IF YOUR MATLAB DON'T INCLUDE IT, THIS
% FUNCTION WILL DO NOT WORK FUNCTIONALLY.
%
% by. Suhwan Gim (roseno.9@daum.net) 
% 2018.03.19 
%
% see also glmfit % glmval %
% LinearModel.Residuals.Raw: sum of squared errors polyfit: in a
% least-squares sense % polyval

%% SETUP: variable
global reg;
std_rating=[30 50 70]; % low, mid, and high %from L. Atlas et al. (2010)
final_rating=[30 40 50 60 70];

%% SETUP: Correting input data 
% For example, a boundary score of semi-sircular rating is between 0 to 100
% . However, there are some cases exceeding this boundry such due to the
% program error. Therefore, we should correct this rating score into the
% between 0 to 100.

if (150>= rating) && (rating > 100) % if 100<rating<=150
    rating = 100;
elseif (200>= rating) && (rating > 150) % if 150<rating<=200
    rating = 0;
else % if 0<=rating<100 
    %do nothing
end

%% SETUP: Input data
reg.stim_degree(th)=degree;
reg.stim_rating(th)=rating; %0 to 100

%% START:
% 1) fit the regression line with least square manner and 2) save the new degree based on fitted regression line

if th>2 % Trial 3~: fit the regression line (least square manner)
    P=polyfit(reg.stim_degree,reg.stim_rating,1); % (x,y, dimension) regression
    for i=1:3 % Trial 4~
        non_corrected_degree=(std_rating(i)-P(2))./P(1); 
        % std_rating(i) = P(1).*non_corrected_degree.^2 + P(2).*non_corrected_degree + P(3)
        % fzero(@(x)f1(x)-std_rating(i),50);
        % f1 = @(x) P(1).*x.^2+P(2).*x+P(3);
        % non_corrected_    degree = fzero(@(x)f1(x)-std_rating(i),50);
        reg.cur_heat_LMH(th+1,i)=unit_integer(non_corrected_degree); % see subfunction
    end
else
    reg.cur_heat_LMH(th,:)=0; % this is only for avoiding NaN % Don't use until 3rd trial
end
% 3) calculate the size of residuals
if th == NumOfTr
    reg.sum_residuals(reg.skin_site) = 0;
    reg.total_fit = fitlm(reg.stim_degree,reg.stim_rating,'linear');
    for ii=1:th
        reg.sum_residuals(reg.skin_site(ii)) = reg.sum_residuals(reg.skin_site(ii)) + abs(reg.total_fit.Residuals.Raw(ii));
    end
    
    ForCAL = reg.sum_residuals; %for a calculation
    for iii=1:3 % To find three lowest value and index
        [~, min_dim] = min(ForCAL);
        ForCAL(min_dim) = 999; % mark a lowest number repeatly
    end
    reg.studySkinSite = find(ForCAL==999); %input marked numbers
    
    for iiii=1:numel(final_rating)
        nc_final_degree = (final_rating(iiii)-P(2))./P(1);
        reg.FinalLMH_5Level(iiii) = unit_integer(nc_final_degree);
    end
else
    %do nothing
end

end


%======================SUB_FUNCTION=======================================
function c_number=unit_integer(uc_number)
%For example

% Input=[44.34 43.11 45.57 43.89 43.75 43.77 44.77 45.13 46.1 ];
% Output=[44.4000 43.2000 45.6000 43.8000 43.8000 43.8000 44.8000 45.2000
% 46.2000];

uc_number=uc_number.*5;
c_number=round(uc_number)./5;

% limit the degree
c_number(c_number > 49.2) = 49.2;
c_number(c_number < 39) = 39;
end

