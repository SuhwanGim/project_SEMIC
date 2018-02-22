
% repetition time in while-loop

%within one trial

for i=1:numel(data.dat{1,1})
    scatter(1:numel(diff(data.dat{1, 1}{1, i}.con_time_fromstart)),diff(data.dat{1, 1}{1, i}.con_time_fromstart));
    mean(diff(data.dat{1, 1}{1, 1}.con_time_fromstart))
    hold on;
end


%%

mot.dat{1, 1}{1, 1}.while_start_timestamp
