function data = addDesiredForce(data)
%ADDDESIREDFORCE add 'desired' force contribution (towards nearest exit or
%staircase)

for fi = 1:data.floor_count
    pos = [arrayfun(@(a) a.p(1), data.floor(fi).agents);
       arrayfun(@(a) a.p(2), data.floor(fi).agents)];
   tree = createRangeTree(pos);

    for ai=1:length(data.floor(fi).agents)
        
        % get agent's data
        p = data.floor(fi).agents(ai).p;
        m = data.floor(fi).agents(ai).m;
        v0 = data.floor(fi).agents(ai).v0;
        v = data.floor(fi).agents(ai).v;
        exit = data.floor(fi).agents(ai).exit;
        exitC = data.floor(fi).img_exitC{exit};
        
        % get direction towards nearest exit
%         ex = lerp2(data.floor(fi).img_dir_x{exit}, p(1), p(2));
%         ey = lerp2(data.floor(fi).img_dir_y{exit}, p(1), p(2));
%         e = [ex ey];
        e = (exitC - p) * data.meter_per_pixel;
        e = e / norm(e);
        
        r_max = data.p_radius / data.meter_per_pixel;
        idx = rangeQuery(tree, p(1) - r_max, p(1) + r_max, ...
                               p(2) - r_max, p(2) + r_max)';
        v_avg = 0;
        for aj = idx
            if ai ~= aj
                v_avg = v_avg + data.floor(fi).agents(aj).v;
            end
        end
        if length(idx) > 1
            v_avg = v_avg / (length(idx)-1);
        end
        u0 = (1-data.p)*v0*e + data.p*v_avg;
        
        % get force
        Fi = m * (u0 - v)/data.tau;
        
        % add force
        data.floor(fi).agents(ai).f = data.floor(fi).agents(ai).f + Fi;
    end
end

