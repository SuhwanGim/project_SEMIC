
% repetition time in while-loop

%within one trial

for i=1:numel(data.dat{1,1})
    scatter(1:numel(diff(data.dat{1, 1}{1, i}.con_time_fromstart)),diff(data.dat{1, 1}{1, i}.con_time_fromstart));
    disp(mean(diff(data.dat{1, 1}{1, i}.con_time_fromstart)))
    hold on;
end


%% overall rating


for i=1:numel(data.dat{1,1})
    
    %scatter(1:numel(diff(data.dat{1, 1}{1, i}.ovr_time_fromstart)),diff(data.dat{1, 1}{1, i}.ovr_time_fromstart));
    %mean(diff(data.dat{1, 1}{1, i}.con_time_fromstart))
    if data.dat{1, 1}{1, i}.ts(6) =="NO"
        %do nothing
    else
        disp(data.dat{1, 1}{1, i}.cue_end_timestamp - data.dat{1, 1}{1, i}.ITI_endtimestamp)
    end
    %disp(data.dat{1, 1}{1, i}.overallRating_end_timestamp_end-data.dat{1, 1}{1, i}.overall_rating_time_stamp)
    %hold on;
end





