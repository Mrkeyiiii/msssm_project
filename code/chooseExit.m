function data = chooseExit(data)
%CHOOSEEXIT choose exit for each agent

for fi = 1:data.floor_count

    r = zeros(length(data.floor(fi).img_exit),1);
    for k = 1 : length(data.floor(fi).img_exit)
        exitC = data.floor(fi).img_exitC{k};
        dk = zeros(length(data.floor(fi).agents),1);
        for ai = 1 : length(data.floor(fi).agents)
            p = data.floor(fi).agents(ai).p;
            exit = data.floor(fi).agents(ai).exit;
            if exit == k || exit == 0
                dk(ai) = norm((exitC-p)*data.meter_per_pixel);
            end
        end
        dk = sort(dk);
        dk(dk==0) = [];
        if ~isempty(dk)
            if dk(1) < 2
                for i = 2 : length(dk)
                    if dk(i)-dk(i-1) >= data.r_max+data.r_min/2
                        r(k) = dk(i-1);
                        break
                    end
                end
            end
        end
    end
    rmax = max(r);
    if rmax == 0
        rmax = 1;
    end
    data.floor(fi).img_exitR = r;
        
    for ai=1:length(data.floor(fi).agents)
        
        % get agent's data
        p = data.floor(fi).agents(ai).p;
        exit = data.floor(fi).agents(ai).exit;
        e = data.floor(fi).agents(ai).e;
        
        % choose exit
        deUik = zeros(length(data.floor(fi).img_exit),1);
        diUik = zeros(length(data.floor(fi).img_exit),1);

        for k = 1 : length(data.floor(fi).img_exit)
            deUik(k) = 0*exp(data.kw * data.W);
            nik = (data.floor(fi).img_exitC{k} - p) * data.meter_per_pixel;
            dik = norm(nik);
            nik = nik / dik;
            phi = acos(dot(nik,e));
            if dik > r(k)
                dik = dik - r(k);
            else
                dik = 0;
            end
            if phi <= pi/2 + pi/2*(1-data.E)
                dphi = 1;
            else
                dphi = 0;
            end
            diUik(k) = exp(-data.l * dik * data.E) * ...
                       (1-data.alpha*data.E*(r(k)/rmax)^data.beta) * dphi;
        end
        Uik = deUik * (1-data.E) + diUik * data.E;
        [Ubest,kbest] = max(Uik);
        if exit == 0
            if max(Uik) == 0
                data.floor(fi).agents(ai).e = [0 0];
                continue
            end
            exit = kbest;
        else
            Ucurr = Uik(exit);
            if Ubest >= Ucurr * (data.g+1)
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
