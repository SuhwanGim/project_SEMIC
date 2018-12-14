function ready = checkStatus(ip,port)
    %Checks pathway system status by polling every second
    ready = 0;
    starttime = GetSecs;
    while ~ready
        % instead of WaitSecs(0.5);
        if GetSecs - starttime >= 0.5
            break;
        end
        resp = main(ip,port,0); %get system status
        systemState = resp{4}; testState = resp{5};            
        if strcmp(systemState, 'Pathway State: TEST') && strcmp(testState,'Test State: RUNNING')
            ready = 1;
        end
    end    
end

