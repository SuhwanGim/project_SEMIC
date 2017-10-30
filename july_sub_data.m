function subject_data = sub_data(subj, rating_type, sess_n, modality, datdir)


if strcmp(modality, 'beh')
    load(fullfile(datdir, sprintf('s00%d_beh_%s_sess%d.mat',subj, rating_type, sess_n))); 
elseif strcmp(modality, 'fmri')
    load(fullfile(datdir, sprintf('s00%d_fmri_%s_sess%d.mat',subj, rating_type, sess_n+1))); 
end

trial_n = 1; 
% subject_data = zeros(54,4);

switch sess_n
    case 1
        
        for i = 1
            
            for j = 1:18
                
                if strcmp(rating_type, 'lin')
                    
                    subject_data.intensity(trial_n,1) = str2double(data.dat{i}{j}.intensity(3));
                    subject_data.ratings(trial_n,1) = data.dat{i}{j}.overall_avoidance_rating;
                    
                elseif strcmp(rating_type, 'semic')
                    subject_data.intensity(trial_n,1) = str2double(data.dat{i}{j}.intensity(3));
                    subject_data.ratings(trial_n,1) = data.dat{i}{j}.overall_avoidance_semicircular_rating_r_theta(:,2);
                end
                
                trial_n = trial_n +1;
            end
            
        end
        
        
    case 2
        
        for i = 1:3
            
            for j = 1:18
                
                if strcmp(rating_type, 'lin')
                    
                    subject_data.intensity(trial_n,1) = str2double(data.dat{i}{j}.intensity(3));
                    subject_data.cue_mean(trial_n,1) = mean(data.dat{i}{j}.cue_x);
                    subject_data.cue_std(trial_n,1) = std(data.dat{i}{j}.cue_x);
                    subject_data.ratings(trial_n,1) = data.dat{i}{j}.overall_avoidance_rating;
                    
                elseif strcmp(rating_type, 'semic')
                    
                    subject_data.intensity(trial_n,1) = str2double(data.dat{i}{j}.intensity(3));
                    subject_data.cue_mean(trial_n,1) = mean(data.dat{i}{j}.cue_theta);
                    subject_data.cue_std(trial_n,1) = std(data.dat{i}{j}.cue_theta);
                    subject_data.ratings(trial_n,1) = data.dat{i}{j}.overall_avoidance_semicircular_rating_r_theta(:,2);
                    
                end
                
                trial_n = trial_n +1;
            end
            
        end
end




end


% intersubject mean