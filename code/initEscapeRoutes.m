function data = initEscapeRoutes(data)
%INITESCAPEROUTES Summary of this function goes here
%   Detailed explanation goes here

for i=1:data.floor_count

    boundary_data = zeros(size(data.floor(i).img_wall));
    boundary_data(data.floor(i).img_wall) =  1;
    boundary_data(data.floor(i).img_stairs_down) = -1;
    
    data.floor(i).img_dir_x = {};
    data.floor(i).img_dir_y = {};
    for j = 1 : length(data.floor(i).img_exit)
        temp = boundary_data;
        temp(data.floor(i).img_exit{j}) = -1;
        exit_dist = fastSweeping(temp) * data.meter_per_pixel;
        [data.floor(i).img_dir_x{end+1}, data.floor(i).img_dir_y{end+1}] = ...
            getNormalizedGradient(temp, -exit_dist);
    end
end

