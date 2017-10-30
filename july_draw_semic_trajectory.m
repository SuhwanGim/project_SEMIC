function h = draw_semic_trajectory(subj, rating_type, sess_n, modality, colors, plottype, datdir)

if strcmp(modality, 'beh')
    load(fullfile(datdir, sprintf('s00%d_beh_%s_sess%d.mat',subj, rating_type, sess_n))); 
elseif strcmp(modality, 'fmri')
    load(fullfile(datdir, sprintf('s00%d_fmri_%s_sess%d.mat',subj, rating_type, sess_n+1))); 
end

switch plottype
    case 'semic_xy'
        for i = 1:3
            for j = 1:18
                h = plot(data.dat{i}{j}.overall_avoidance_semicircular_cont_rating_xy(:,1), data.dat{i}{j}.overall_avoidance_semicircular_cont_rating_xy(:,2), 'color', colors, 'linewidth', .3);
                hold on;
            end
        end
        
        set(gca, 'xlim', [-1 1], 'ylim', [0 1]);
    case 'semic_x'
        for i = 1:3
            for j = 1:18
                h = plot(data.dat{i}{j}.overall_avoidance_semicircular_cont_rating_xy(:,1), 'color', colors, 'linewidth', .3);
                hold on;
            end
        end
        
%         set(gca, 'xlim', [-1 1], 'ylim', [0 1]);
        
    case 'semic_y'
        for i = 1:3
            for j = 1:18
                h = plot(data.dat{i}{j}.overall_avoidance_semicircular_cont_rating_xy(:,2), 'color', colors, 'linewidth', .3);
                hold on;
            end
        end
        
%         set(gca, 'xlim', [-1 1], 'ylim', [0 1]);
    case 'semic_theta'
        for i = 1:3
            for j = 1:18
                h = plot(data.dat{i}{j}.overall_avoidance_semicircular_cont_rating_r_theta(:,2), 'color', colors, 'linewidth', .3);
                hold on;
            end
        end
        set(gca, 'ylim', [0 1]);
    case 'linear_x'
        for i = 1:3
            for j = 1:18
                h = plot(data.dat{i}{j}.overall_avoidance_cont_rating, 'color', colors, 'linewidth', .5);
                hold on;
            end
        end
        set(gca, 'ylim', [0 1]);
end

end