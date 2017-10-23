function checkRunning(ip,port)
    %Checks pathway system status by polling every second
    ready = 0;
    while ~ready
        WaitSecs(1); %change the function and seconds
        resp = main(ip,port,0); %get system status
        systemState = resp{4}; testState = resp{5};            
        if strcmp(systemState, 'Pathway State: READY') && strcmp(testState,'Test State: RUNNING')
            break;
            %ready = 1;
        end
    end    
end