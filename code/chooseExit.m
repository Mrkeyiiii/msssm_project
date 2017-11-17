function data = chooseExit(data)
%CHOOSEEXIT choose exit for each agent

for fi = 1:data.floor_count

    for ai=1:length(data.floor(fi).agents)
        
        % get agent's data
        p = data.floor(fi).agents(ai).p;
        exit = data.floor(fi).agents(ai).exit;
        e = data.floor(fi).agents(ai).e;
        
        % choose exit
        deUik = zeros(length(data.floor(fi).img_exit),1);
        diUik = zeros(length(data.floor(fi).img_exit),1);
        for k = 1 : length(data.floor(fi).img_exit)
            deUik(k) = exp(data.kw * data.W);
            nik = data.floor(fi).img_exitC{k} - p;
            dik = norm(nik);
            nik = nik / dik;
            phi = acos(dot(nik,e));
            if phi < pi/2 + pi/2*(1-data.E)
                dphi = 1;
            else
                dphi = 0;
            end
            diUik(k) = exp(-data.l * dik * data.E) * dphi;
        end
        Uik = deUik * (1-data.E) + diUik * data.E;
        [Ubest,kbest] = max(Uik);
        if exit == 0
            exit = kbest;
        else
            Ucurr = Uik(exit);
            if Ubest >= Ucurr*(data.g+1)
                exit = kbest;
            end
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
