function data = chooseExit(data)
%CHOOSEEXIT choose exit for each agent

for fi = 1:data.floor_count

    for ai=1:length(data.floor(fi).agents)
        
        % get agent's data
        p = data.floor(fi).agents(ai).p;
        exit = data.floor(fi).agents(ai).exit;
        
        % choose exit
        if exit == 0
            exit = randi(length(data.floor(fi).img_exit));
        else
        end
        
        % update exit
        data.floor(fi).agents(ai).exit = exit;
        exitC = data.floor(fi).img_exitC{exit};
        
        % get direction towards exit
        e = (exitC - p) * data.meter_per_pixel;
        e = e / norm(e);
        
        % update direction
        data.floor(fi).agents(ai).e = e;
        
    end
end
