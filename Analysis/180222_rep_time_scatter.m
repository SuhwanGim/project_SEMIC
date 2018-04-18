
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



%% check 


runN = 2;
trialN = 18;
x=zeros(trialN,runN);
for j=1:runN
    for i=1:trialN
        x(i,j)=data.dat{1, j}{1, i}.duration_heat_trigger;
        if x(i,j)>2
            idx = data.dat{1, j}{1, i}.ts(6);
            disp(['Run:' num2str(j) ' Trial:' num2str(i) 'Cue type:' idx]);
        end
    end
end
disp(data.datafile);


