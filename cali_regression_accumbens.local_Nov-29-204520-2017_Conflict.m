function [new_deg]=cali_regression (deg,rating,varargin)
%%
%
% 1) input data to regression line
% 2) calculating
% 3) where the skin site?
% 4) 너무 낮은 온도나 높은 온도면 제한을 걸어줘야함
% 5) residual 계산을해줘야함

%For example
% input: deg=[41,44,47], rating=[30,40,80]
% output: new_deg = [40.5 44 46.5] %low, mid, and high

%%
% .75-> 1.0
%               .74 -> 0.5
% .25-> .5
%               .24 -> 0.0
% a=[44.34 43.11 45.57 43.89 43.75 43.77 44.77 45.13 46.1 ];
% b=[44.5 43 45.5 44 43.5 44 45 45 46];
% aa=a.*2;

% bb=round(aa)./2;

x=deg;
y=rating;
P=polyfit(x,y,1); %regression

% %for visualization
% plot(x,y,'o-') % real data
% plot(x,y,'o-',x,P(1).*x+P(2)); % fit line



v_rating=[20 50 70]; % low, mid, and high


for i=1:3
    %v_rating=P(1).*new_deg+P(2);
    non_corrected_degree=(v_rating(i)-P(2))./P(1);
    x2_non_corrected_degree=non_corrected_degree.*2;
    new_deg(i)=round(x2_non_corrected_degree)./2;
end