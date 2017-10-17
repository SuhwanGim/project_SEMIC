close all;
clear;


% exp = {'overall_avoidance_semicircular'};
% scriptdir = '/Users/cocoan/Dropbox/github/cocoan_experiment_master/task_functions';
% ts = generate_ts_semic(1, 'semicircular');
% cps_main(ts, 'fmri', 'explain_scale', exp, 'scriptdir', scriptdir, 'biopac', 'test'); %data = ?

%% Semicircular session 2: RUN1 - social + pain + continusous ratings

ts = generate_ts_semic(1, 'semicircular');
data = SEMIC_MAIN(ts, 'test', 'scriptdir', pwd);

%% Semicircular session 2: RUN2 - social + pain + continusous ratings

ts = generate_ts_semic(2, 'semicircular');
data = SEMIC_MAIN(ts, 'test', 'scriptdir', pwd);

%% Semicircular session 2: RUN3 - social + pain + continusous ratings

ts = generate_ts_semic(3, 'semicircular');
data = SEMIC_MAIN(ts, 'test', 'scriptdir', pwd);