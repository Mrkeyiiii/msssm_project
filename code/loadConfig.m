function config = loadConfig(config_file)
% load the configuration file
%
%  arguments:
%   config_file     string, which configuration file to load
%


% get the path from the config file -> to read the images
config_path = fileparts(config_file);
if strcmp(config_path, '') == 1
    config_path = '.';
end

fid = fopen(config_file);
input = textscan(fid, '%s=%s');
fclose(fid);

keynames = input{1};
values = input{2};

%convert numerical values from string to double
v = str2double(values);
idx = ~isnan(v);
values(idx) = num2cell(v(idx));

config = cell2struct(values, keynames);


% read the images
for i=1:config.floor_count
    
    %building structure
    file = config.(sprintf('floor_%d_build', i));
    file_name = [config_path '/' file];
    img_build = imread(file_name);
    
    % decode images
    config.floor(i).img_wall = (img_build(:, :, 1) ==   0 ...
                              & img_build(:, :, 2) ==   0 ...
                              & img_build(:, :, 3) ==   0);
                          
    config.floor(i).img_spawn = (img_build(:, :, 1) == 255 ...
                               & img_build(:, :, 2) ==   0 ...
                               & img_build(:, :, 3) == 255);
                           
    config.floor(i).img_exit{1} = (img_build(:, :, 1) ==   0 ...
                                 & img_build(:, :, 2) == 255 ...
                                 & img_build(:, :, 3) ==   0);
                             
    config.floor(i).img_exitC{1} = (img_build(:, :, 1) ==   0 ...
                                  & img_build(:, :, 2) == 200 ...
                                  & img_build(:, :, 3) ==   0);
    config.floor(i).img_exit{1} = config.floor(i).img_exit{1} ...
                                | config.floor(i).img_exitC{1};
    [exitC_x,exitC_y] = ind2sub(size(config.floor(i).img_exitC{1}),find(config.floor(i).img_exitC{1}==1));
    config.floor(i).img_exitC{1} = [exitC_x exitC_y];
                             
    config.floor(i).img_exit{2} = (img_build(:, :, 1) ==   0 ...
                                 & img_build(:, :, 2) == 255 ...
                                 & img_build(:, :, 3) == 255);
                             
    config.floor(i).img_exitC{2} = (img_build(:, :, 1) ==   0 ...
                                  & img_build(:, :, 2) == 200 ...
                                  & img_build(:, :, 3) == 200);
    config.floor(i).img_exit{2} = config.floor(i).img_exit{2} ...
                                | config.floor(i).img_exitC{2};
    [exitC_x,exitC_y] = ind2sub(size(config.floor(i).img_exitC{2}),find(config.floor(i).img_exitC{2}==1));
    config.floor(i).img_exitC{2} = [exitC_x exitC_y];
                          
    config.floor(i).img_stairs_up = (img_build(:, :, 1) == 255 ...
                                   & img_build(:, :, 2) ==   0 ...
                                   & img_build(:, :, 3) ==   0);
                               
    config.floor(i).img_stairs_down = (img_build(:, :, 1) ==   0 ...
                                     & img_build(:, :, 2) ==   0 ...
                                     & img_build(:, :, 3) == 255);
                                 
    %init the plot image here, because this won't change
    config.floor(i).img_plot = 6*config.floor(i).img_wall ...
        + 5*config.floor(i).img_stairs_up ...
        + 4*config.floor(i).img_stairs_down ...
        + 3*config.floor(i).img_exit{1} ...
        + 2*config.floor(i).img_exit{2} ...
        + 1*config.floor(i).img_spawn;
    config.color_map = [1 1 1; 0.9 0.9 0.9; 0 1 1; 0 1 0; 0.4 0.4 1; 1 0.4 0.4; 0 0 0];
end

