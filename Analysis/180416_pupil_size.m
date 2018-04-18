%% Type help for help
help Edf2Mat


%% Converting the EDF File and saving it as a Matlab File
edf0 = Edf2Mat('M_010_1.EDF');

%% Plot the progress of the pupil size
ed = length(edf0.timeline);
converted = (edf0.Samples.time - edf0.Samples.time(1))/1000; %convert to seconds 
time = 1:(length(edf0.Samples.time));

figure();
plot(converted, edf0.Samples.pa(:, 1));  %Left eye

% hline=gline(mean(edf0.Samples.pa(:, 1)));
% set(hline, 'color', 'r');
%line(mean(edf0.Samples.pa(:, 1)));
% plot(edf0.Samples.pa(2, ed - 500:ed)); 