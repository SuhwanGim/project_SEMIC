% SEMIC_2018.05.19
% Analysis maindata 

% Trial sequences
% ts{runNbr}:
% [run_Number, trial_Number, ITI, Delay, Delay2, cue_settings, cue_mean, cue_var, stim_level, program, overall_unpl_Q_cond, overall_unpl_Q_txt];
%% Settings
clear;
basedir = pwd;
cali_dir='/Users/WIWIFH/Dropbox/github/SEMIC_CODE_COCOAN/CALI_SEMIC_data/'; % cali_data dir
main_dir='/Users/WIWIFH/Dropbox/github/SEMIC_CODE_COCOAN/Main_SEMIC_data/'; % main_data dir
filename = '*.mat';
filelist = dir([main_dir filename]);
cali_filelist = dir([cali_dir filename]);

%load([cali_dir filelist(i).name]);

%% SETUP: Each parameter
col1 = [];
col2 = [0.9922    0.6824    0.3804];
trial_number = 18;
%% Preprocessing task data (combinataion matrix)
% Trial combination within one participatns 
% 2(Two cues) x 4(Low: LV1 to LV4  / High LV2 to LV5)

% title([ts{1,i}(j,6) ts{1,i}(j,9)]);
for i=1:length(filelist) %number of participants
    load([main_dir filelist(i).name]);
    for j=1:length(ts) %number of runs
        load([cali_dir 'Calib_' data.subject '.mat']);
        for k=1:length(data.dat{j})
            %comb.mat.subID = 'sub_semic000';
            comb_mat.projID = data.subject;
            comb_mat.version = data.version;
            comb_mat.description = [data.subject ': same codition data without no time consideration'];
            comb_mat.time = datestr(clock, 0);
            
            % calibration data
            comb_mat.data.calib.stim_degree = reg.stim_degree;
            comb_mat.data.calib.stim_rating = reg.stim_rating;
            comb_mat.data.calib.fit = reg.total_fit;
            comb_mat.data.calib.Final_5Level = reg.FinalLMH_5Level;
            comb_mat.data.calib.skin_order = reg.skinSite_rs;
            comb_mat.data.calib.skin_residuals = reg.sum_residuals;
            
            % cue and continuous data
            comb_mat.data.cont{j}{k}.run_number = ts{1,j}{k,1};
            comb_mat.data.cont{j}{k}.trial_number = ts{1,j}{k,2};
            comb_mat.data.cont{j}{k}.cue_type = ts{1,j}{k,6};
            if ts{1,j}{k,6} ~= "NO"
                comb_mat.data.cont{j}{k}.cue_theta = data.dat{j}{k}.cue_theta;
            end
            comb_mat.data.cont{j}{k}.stim_level = ts{1,j}{k,9};
            comb_mat.data.cont{j}{k}.overall_unpl_Q_cond = ts{1,j}{k,11};
            
            comb_mat.data.cont{j}{k}.con_xy = data.dat{j}{k}.con_xy;
            comb_mat.data.cont{j}{k}.con_time_fromstart = data.dat{j}{k}.con_time_fromstart;
            comb_mat.data.cont{j}{k}.con_r_theta = data.dat{j}{k}.con_r_theta;
 
            %comb_mat.data.ovrerall
            %comb_mat.data.?
          
        end
    end
    %save
    temp_p{i} = comb_mat;
end

disp(temp_p);
%% plot each combination
% 11 types(low - LV 1 to 4 / High LV1 to 4 / No cue LV 1 to 3)
% 

%Data
subj_i=1; 
semic_data=temp_p{subj_i};
idx_low=1;idx_high = 1;idx_no= 1;
low_xy = []; high_xy = []; no_xy = []; temp = [];
for i=1:length(semic_data.data.cont)
    for j=1:length(semic_data.data.cont{i})
        if semic_data.data.cont{i}{j}.cue_type == "LOW"
            
            low_xy{idx_low} = semic_data.data.cont{i}{j}.con_xy;
            %normalization? or Degree
            %
            %normA = A - min(A(:));
            %normA = normA ./ max(normA(:)); % *
            %
            
            % normalize function only works after Matlab 2018a versions.
            %
%             temp = semic_data.data.cont{i}{j}.con_xy(1:870,:); 
%             norm_temp(:,1) = normalize(temp(:,1),'range',[-1 1]); %x
%             norm_temp(:,2) = normalize(temp(:,2),'range',[0 1]); %y
            temp = semic_data.data.cont{i}{j}.con_xy(1:870,:); 
            norm_temp(:,1) = temp(:,1) - min(temp(:,1)); % x
            norm_temp(:,2) = temp(:,2) - min(temp(:,2)); % y
            
            norm_temp(:,1) = norm_temp(:,1) ./ max(norm_temp(:,1));
            %re-normalization only x to [-1 1] from [0 1]
            range = 2; %1 - (-1)
            norm_temp(:,1) = norm_temp(:,1) * range + (-1); 
            
            norm_temp(:,2) = norm_temp(:,2) ./ max(norm_temp(:,2));
            
            
            %range2 = y - x; a = (a * range2) + x
            
            if idx_low == 1
                sum_low_xy = norm_temp;
            else
                sum_low_xy = norm_temp + sum_low_xy;
            end
            
            
            idx_low = length(low_xy)+1;
            
        elseif semic_data.data.cont{i}{j}.cue_type == "HIGH"
             
            high_xy{idx_high} = semic_data.data.cont{i}{j}.con_xy;
            %normalization? or Degree
            %
            %normA = A - min(A(:));
            %normA = normA ./ max(normA(:)); % *
            %
            
            % normalize function only works after Matlab 2018a versions.
            %
%             temp = semic_data.data.cont{i}{j}.con_xy(1:870,:); 
%             norm_temp(:,1) = normalize(temp(:,1),'range',[-1 1]); %x
%             norm_temp(:,2) = normalize(temp(:,2),'range',[0 1]); %y
            temp = semic_data.data.cont{i}{j}.con_xy(1:870,:); 
            norm_temp(:,1) = temp(:,1) - min(temp(:,1)); % x
            norm_temp(:,2) = temp(:,2) - min(temp(:,2)); % y
            
            norm_temp(:,1) = norm_temp(:,1) ./ max(norm_temp(:,1));
            %re-normalization only x to [-1 1] from [0 1]
            range = 2; %1 - (-1)
            norm_temp(:,1) = norm_temp(:,1) * range + (-1); 
            
            norm_temp(:,2) = norm_temp(:,2) ./ max(norm_temp(:,2));
            
            
            %range2 = y - x; a = (a * range2) + x
            
            if idx_high == 1
                sum_high_xy = norm_temp;
            else
                sum_high_xy = norm_temp + sum_high_xy;
            end
            
            
            idx_high = length(high_xy)+1;
            
        elseif semic_data.data.cont{i}{j}.cue_type == "NO"
           
            no_xy{idx_no} = semic_data.data.cont{i}{j}.con_xy;
            %normalization? or Degree
            %
            %normA = A - min(A(:));
            %normA = normA ./ max(normA(:)); % *
            %
            
            % normalize function only works after Matlab 2018a versions.
            %
%             temp = semic_data.data.cont{i}{j}.con_xy(1:870,:); 
%             norm_temp(:,1) = normalize(temp(:,1),'range',[-1 1]); %x
%             norm_temp(:,2) = normalize(temp(:,2),'range',[0 1]); %y
            temp = semic_data.data.cont{i}{j}.con_xy(1:870,:); 
            norm_temp(:,1) = temp(:,1) - min(temp(:,1)); % x
            norm_temp(:,2) = temp(:,2) - min(temp(:,2)); % y
            
            norm_temp(:,1) = norm_temp(:,1) ./ max(norm_temp(:,1));
            %re-normalization only x to [-1 1] from [0 1]
            range = 2; %1 - (-1)
            norm_temp(:,1) = norm_temp(:,1) * range + (-1); 
            
            norm_temp(:,2) = norm_temp(:,2) ./ max(norm_temp(:,2));
            
            
            %range2 = y - x; a = (a * range2) + x
            
            if idx_no == 1
                sum_no_xy = norm_temp;
            else
                sum_no_xy = norm_temp + sum_no_xy;
            end
            
            
            idx_no = length(no_xy)+1;
                   
        end
    end
end

% for i=length(sum_low_xy)
%     
%     plot(sum_low_xy(:,1), sum_low_xy(:,2), 'linewidth', .3);
%     axis([-1 1 0 1]);
% end



%% plot (without consideration stimulus levels)

mean_sum_low_xy = sum_low_xy./length(low_xy);
mean_sum_high_xy = sum_high_xy./length(high_xy);
mean_sum_no_xy = sum_no_xy./length(no_xy);
subplot(3,1,1);
plot(mean_sum_low_xy(:,1), mean_sum_low_xy(:,2)); axis([-1 1 0 1]); title([semic_data.projID ' -Cue type: Low']); 
subplot(3,1,2);
plot(mean_sum_high_xy(:,1), mean_sum_high_xy(:,2)); axis([-1 1 0 1]); title([semic_data.projID ' -Cue type: High']); 
subplot(3,1,3);
plot(mean_sum_no_xy(:,1), mean_sum_no_xy(:,2)); axis([-1 1 0 1]); title([semic_data.projID ' -Cue type: No']); 

 %.*length(low_xy)
%% Overall
%% Physio
%%

%Plot
for i = 1:6 % number of runs
    % comb_mat

    for j = 1:trial_number % number of trials

        h = plot(data.dat{1,i}{1,j}.con_xy(:,1), data.dat{i}{j}.con_xy(:,2), 'color', col2, 'linewidth', .3);
        title(['Run:' num2str(i)]);
        axis([-1 1 0 1]);
        hold on;
    end
    
    subplot(4,2,i); 
    
end

%%
[x,y]=ginput(2); %start and endof arrow
       AX=axis(gca); %can use this to get all the current axes
       Xrange=AX(2)-AX(1);
       Yrange=AX(4)-AX(3);       
       X=(x-AX(1))/Xrange +AX(1)/Xrange;
       Y=(y-AX(3))/Yrange +AX(3)/Yrange;
         annotation('textarrow', X, Y,'String' , 'LegendText','Fontsize',12);

         
