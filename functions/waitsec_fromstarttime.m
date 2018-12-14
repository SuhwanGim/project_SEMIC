function waitsec_fromstarttime(starttime, duration)
% Using this function instead of WaitSecs()
% function waitsec_fromstarttime(starttime, duration)

while true
    if GetSecs - starttime >= duration
        break;
    end
end

end