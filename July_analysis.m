%% directory setting
clear;
basedir = '/Users/clinpsywoo/Dropbox/projects/ongoing_projects/W_semic'; % computer setting
beh_datdir = fullfile(basedir, 'data', 'behavioral');
figdir = fullfile(basedir, 'figures');

% path
addpath(genpath(basedir));


%% read data

rating_types = {'lin', 'semic'};
modality = {'beh', 'beh', 'beh', 'beh', 'fmri'};

subj_i = [1:3 5:6];
for i = 1:5
    for rating_type_i = 1:2
        for sess_n = 1:2 
            eval(['data.sess' num2str(sess_n) '.' rating_types{rating_type_i} '{i} = sub_data(subj_i(i), rating_types{rating_type_i}, sess_n, modality{i}, beh_datdir);']);
        end
    end
end


%% individual mean per level

for subj_i = 1:numel(data.sess1.lin)
    
    for int_j = 1:3
        sess1_mrating_lin(subj_i,int_j) = mean(data.sess1.lin{subj_i}.ratings(data.sess1.lin{subj_i}.intensity==int_j));
        sess1_mrating_semic(subj_i,int_j) = mean(data.sess1.semic{subj_i}.ratings(data.sess1.semic{subj_i}.intensity==int_j));
    end
    
end

%% lineplot lin: session 1
x = (1:3)-.1; % x values
y = mean(sess1_mrating_lin);
e = ste(sess1_mrating_lin); % standard error of the mean

create_figure('sess1');
set(gcf, 'Position', [856   521   563   500]);
col = [0.8353    0.2431    0.3098];

h = errorbar(x, y, e, 'o', 'color', 'k', 'linewidth', 2, 'markersize', 10, 'markerfacecolor', col);
h.CapSize = 0;

hold on;

sepplot(x, y, .9, 'color', col, 'linewidth', 3);

for i = 1:3
    hold on; h = scatter(repmat(i,5,1)-.1, sess1_mrating_lin(:,i), 40, col, 'filled', 'MarkerFaceAlpha', .5);
end

set(gca, 'xlim', [.5 3.5], 'linewidth', 1.5, 'tickdir', 'out', 'ticklength', [.02 .02], 'fontsize', 20);

%% lineplot semic: session 1

hold on;
x = (1:3)+.1;
y = mean(sess1_mrating_semic);
e = ste(sess1_mrating_semic); % standard error of the mean

col2 = [0.9922    0.6824    0.3804];
markercol = col2-.2;

h = errorbar(x, y, e, 'o', 'color', 'k', 'linewidth', 2, 'markersize', 10, 'markerfacecolor', col2);
h.CapSize = 0;

hold on;

sepplot(x, y, .9, 'color', col2, 'linewidth', 3);

for i = 1:3
    hold on; h = scatter(repmat(i,5,1)+.1, sess1_mrating_semic(:,i), 40, col2, 'filled', 'MarkerFaceAlpha', .5);
end

set(gca, 'xlim', [.5 3.5], 'linewidth', 1.5, 'tickdir', 'out', 'ticklength', [.02 .02], 'fontsize', 20);

fig_name = fullfile(figdir, 'sess1_int_ratings.pdf');

pagesetup(gcf);
saveas(gcf, fig_name);

pagesetup(gcf);
saveas(gcf, fig_name);

%%

clf;
col =  [0.3765    0.2902    0.4824
    0.2157    0.3765    0.5725
    0.4667    0.5765    0.2353
    0.8941    0.4235    0.0392
    0.5843    0.2157    0.2078];

for int = 1:3
    subplot(1,3,int);
    for i = 1:5
        scatter(data.sess2.lin{i}.cue_mean(data.sess2.lin{i}.intensity==int), data.sess2.lin{i}.ratings(data.sess2.lin{i}.intensity==int), 40, col(i,:), 'filled', 'MarkerFaceAlpha', .7); 
        hold on;
        [~, ~, stats] = glmfit(data.sess2.lin{i}.cue_mean(data.sess2.lin{i}.intensity==int), data.sess2.lin{i}.ratings(data.sess2.lin{i}.intensity==int));
        h = refline(stats.beta(2),stats.beta(1));
        h.Color = col(i,:);
        h.LineWidth = 1.2;
    end
    set(gca, 'ylim', [0 1], 'xlim', [0 1]);
    xlabel('Social cue mean', 'fontsize', 15);
    ylabel('Pain ratings', 'fontsize', 15);
end

fig_name = fullfile(figdir, 'sess2_social_cue_ratings.pdf');

pagesetup(gcf);
saveas(gcf, fig_name);

pagesetup(gcf);
saveas(gcf, fig_name);

%% trajectory plot

rating_types = {'semic'};
modality = {'beh', 'beh', 'beh', 'beh', 'fmri'};

subj_i = [1:3 5:6];
for i = 1:5
    for rating_type_i = 1
        for sess_n = 2 
            h = draw_semic_trajectory(subj_i(i), rating_types{rating_type_i}, sess_n, modality{i}, col(i,:), beh_datdir);
        end
    end
end

set(gcf, 'position', [1000         912         897         426]);
axis off;
set(gcf, 'color', 'w');
hold on;

fig_name = fullfile(figdir, 'sess2_social_cue_trajectory_v1.pdf');

pagesetup(gcf);
saveas(gcf, fig_name);

pagesetup(gcf);
saveas(gcf, fig_name);

%% semic xy trajectory


rating_types = {'semic'};
modality = {'beh', 'beh', 'beh', 'beh', 'fmri'};
plottype = 'semic_xy';

subj_i = [1:3 5:6];
for i = 1:5
    for rating_type_i = 1
        for sess_n = 2 
            h = draw_semic_trajectory(subj_i(i), rating_types{rating_type_i}, sess_n, modality{i}, col(i,:), plottype, beh_datdir);
        end
    end
end

set(gcf, 'position', [1000         912         897         426]);
axis off;
set(gcf, 'color', 'w');
hold on;

%% semic theta trajectory
figure;
rating_types = {'semic'};
modality = {'beh', 'beh', 'beh', 'beh', 'fmri'};
plottype = 'semic_theta';

subj_i = [1:3 5:6];
for i = 1:5
    for rating_type_i = 1
        for sess_n = 2 
            if subj_i(i) == 6
                h = draw_semic_trajectory(subj_i(i), rating_types{rating_type_i}, sess_n, modality{i}, col(i,:), plottype, beh_datdir);
            end
        end
    end
end

set(gcf, 'position', [1000         912         897         426]);
axis off;
set(gcf, 'color', 'w');
hold on;

%% line x trajectory
clf;
rating_types = {'lin'};
modality = {'beh', 'beh', 'beh', 'beh', 'fmri'};
plottype = 'linear_x';

subj_i = [1:3 5:6];
for i = 1:5
    for rating_type_i = 1
        for sess_n = 2 
            h = draw_semic_trajectory(subj_i(i), rating_types{rating_type_i}, sess_n, modality{i}, col(i,:), plottype, beh_datdir);
        end
    end
end

set(gcf, 'position', [1000         912         897         426]);
axis off;
set(gcf, 'color', 'w');
hold on;


fig_name = fullfile(figdir, 'sess2_social_cue_linear_trajectory_v1.pdf');

pagesetup(gcf);
saveas(gcf, fig_name);

pagesetup(gcf);
saveas(gcf, fig_name);











%% fmri
%dat6
count = 1; subject_data = zeros(54,4);
%subj = 1; 
%sess = 1; 
%dir = sprintf('/Volumes/NO NAME/CNIR/data/ratings_data');

load('s006_fmri_semic_sess3_r123.mat'); 
for i = 1: 3
    for j = 1: 18
        
        %intensity (LV)
        %        trial_sequence{i}{j}{2}
        
        % cue mean, sd
        %trial_sequence{i}{j}{8}{2}(1:2)
        
        subject_data(count,:)= [str2double(trial_sequence{i}{j}{2}(3)), trial_sequence{i}{j}{8}{2}(1:2), data.dat{i}{j}.overall_avoidance_semicircular_rating_r_theta(2)];
        count = count +1;
    end
    
end

dat6_semic = subject_data; 



%%

%categorise intensity levels
% [Y,E] = discretize(dat1_lin(:,1),3,'categorical',{'L','M','H'});
[neword,origind] = sort(dat6_semic(:,1),'ascend');
s6_semic = dat6_semic(origind,:); 

% %categorise cue mean levels within each intensity
% %L
% [Y1,E] = discretize(s6_semic(1:18,2),3,'categorical',{'L','M','H'});
% %M
% [Y2,E] = discretize(s6_semic(19:36,2),3,'categorical',{'L','M','H'});
% %H
% [Y3,E] = discretize(s6_semic(37:54,2),3,'categorical',{'L','M','H'});
% 
% temp = [Y1;Y2;Y3]; 

%categorise cue std levels within each intensity
%L
[Y1,E] = discretize(s6_semic(1:18,3),4,'categorical',{'L','ML','HL','H'});
%M
[Y2,E] = discretize(s6_semic(19:36,3),4,'categorical',{'L','ML','HL','H'});
%H
[Y3,E] = discretize(s6_semic(37:54,3),4,'categorical',{'L','ML','HL','H'});

temp = [Y1;Y2;Y3]; 


%ratings in intensity level order 1: 1- 18, 2: 19 - 36, 3: 37 - 54
d = s6_semic(:,4);

figure;

subplot(311); 
h1 = scatter(Y1,d(1:18),'o'); title('Low');  
%title('ratings v intensity')
xlabel('cue mean')
ylabel('ratings')

subplot(312); 
h2 = scatter(Y2,d(19:36),'x');title('Med'); xlabel('cue mean')
ylabel('ratings')

subplot(313); 
h3 = scatter(Y3,d(37: 54), 'bo'); title('Hi'); xlabel('cue mean')
ylabel('ratings')







