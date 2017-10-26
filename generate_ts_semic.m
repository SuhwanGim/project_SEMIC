function ts = generate_ts_semic(session_n, varargin)

% [ts, exp] = generate_ts_semic
%
% Session 1 (3 runs, 5 cue means x 3 cue sd x 3 thermode ramp-up = 45 trials x 3 runs = 135 trials): cue + pain + continuous rating 
% Three ramp-up settings of thermode (2, 4, and 6 seconds) is manipulated by CHEPS Program 
%
% ts = generate_ts_semic(1, 'semicircular)

semicircular = false;
rng('shuffle');

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'semicircular'}
                semicircular = true;
            %case {'linear'}
            %    semicircular = false;
            case {'data'}
                data = varargin{i+1};
        end
    end
end

% 3(2,4,6sec) x 15 other combination
% Strafied randomization [1 2 3] [2 3 1] ....
for i = 1:15 
         program(i*3-2:i*3) = randperm(3) + 99;
end
      
switch session_n
   
    case 1
        S3{1} = repmat({'TP'}, 45, 1);
        % S3{2} = transpose(program);%program
        S3{3} = repmat({'0010'}, 45, 1);%duration? 
        S3{4} = repmat({'cont_int'}, 45, 1);
        S3{5} = repmat({'3'}, 45, 1);%pre-rating jitter
        S3{6} = repmat({'5', '11'; '7', '9'; '9', '7'; '11', '5'}, 5, 1); %inter-trial jitter

        if exist('data', 'var')
            for trial_i = 1:numel(data.dat{1})
                if semicircular
                    rating_lv{str2double(data.dat{1}{trial_i}.intensity(end))}(end+1) = data.dat{1}{trial_i}.overall_avoidance_semicircular_rating_r_theta(:,2);
                else
                    rating_lv{str2double(data.dat{1}{trial_i}.intensity(end))}(end+1) = data.dat{1}{trial_i}.overall_avoidance_rating;
                end
            end
        else
            warning('There is no data file. It will use a fake data.');
            rating_lv{1} = .2;
            rating_lv{2} = .35;
            rating_lv{3} = .5;
        end
        
        ref_mean = cellfun(@mean, rating_lv)';
        ref_bounds = [ref_mean - mean(diff(ref_mean)) ref_mean + mean(diff(ref_mean))]; % column 1: lower bound, column 2: upper bound
        
        std=[.03 .05 .12 .14];
        
        for i = 1:3
            temp_bounds(i,:) = linspace(ref_bounds(i,1), ref_bounds(i,2), 3);
            [A,B] = meshgrid(temp_bounds(i,:), std);
            temp_pair = reshape(cat(2, A', B'), [], 2);
            ref(6*i-5:6*i, :) = temp_pair([randperm(6,3) randperm(6,3)+6],:);
        end
        
        for ii = 1:size(ref,1)
            S3{7}{ii,1} = [S3{2}(ii) {'draw_social_cue', [ref(ii,1), ref(ii,2)+(rand/30-(1/30)/2), 20]}]; % add a little randomness
        end
        
        
        
        trial_n = 45;
        
        for k = 1:numel(S3) %Number of session? 
            for run_i = 1:3 %Number of run? 
                temp = S3{k}(randperm(trial_n),:);
                switch k
                    case {1, 3, 5}
                        for j = 1:trial_n
                            ts{run_i}{j}(k) = temp(j);
                        end
                    case 4
                        for j = 1:trial_n
                            ts{run_i}{j}(4) = {temp(j)};
                        end
                    case 6
                        for j = 1:trial_n
                            ts{run_i}{j}(6) = temp(j,1);
                            ts{run_i}{j}(7) = temp(j,2);
                        end
                    case 7
                        for j = 1:trial_n
                            ts{run_i}{j}(2) = temp{j}(1);
                            ts{run_i}{j}{8} = temp{j}(2:3);
                        end
                end
            end
        end
        S3{2} = transpose(program);%program
end