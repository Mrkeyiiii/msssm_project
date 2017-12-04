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
            density = 1 / ((pi/2) * dk(1)*dk(1));
            if density < data.rho_congestion
                r(k) = 0;
            else
                for i = 2:length(dk)
                    density = i / ((pi/2) * dk(i)*dk(i));
                    if density < data.rho_congestion
                        r(k) = dk(i-1);
                        break;
                    end
                    if i == length(dk)
                        r(k) = dk(i);
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
        isAlone = data.floor(fi).agents(ai).isAlone;
        
        % choose exit
        diUik = zeros(length(data.floor(fi).img_exit),1);
        for k = 1 : length(data.floor(fi).img_exit)
            % nik = (data.floor(fi).img_exitC{k} - p) * data.meter_per_pixel;
            % dik = norm(nik);
            % nik = nik / dik;
            % phi = acos(nik*e');

            dik = lerp2(data.floor(fi).exit_dist{k}, p(1), p(2));
            d_x = lerp2(data.floor(fi).img_dir_x{k}, p(1), p(2));
            d_y = lerp2(data.floor(fi).img_dir_y{k}, p(1), p(2));
            nik = [d_x d_y];
            phi = acos(nik*e');
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
                       (1-data.alpha*(r(k)/rmax)^data.beta) * dphi;
        end
        Uik = diUik;
        [Ubest,kbest] = max(Uik);
        if exit == 0
            if max(Uik) == 0
                if isAlone == 1
                    e = 2*pi*rand();
                    data.floor(fi).agents(ai).e = [cos(e) sin(e)];
                else
                    data.floor(fi).agents(ai).e = [0 0];
                end
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
        ex = lerp2(data.floor(fi).img_dir_x{exit}, p(1), p(2));
        ey = lerp2(data.floor(fi).img_dir_y{exit}, p(1), p(2));
        e = [ex ey];

        %e = (exitC - p) * data.meter_per_pixel;
        %e = e / norm(e);
        
        % update direction
        data.floor(fi).agents(ai).e = e;
        
    end
end
