function data = initialize(config)
% initialize the internal data from the config data
%
%  arguments:
%   config      data structure from loadConfig()
%
%  return:
%   data        data structure: all internal data used for the main loop
%
%               all internal data is stored in pixels NOT in meters


data = config;

%for convenience
data.pixel_per_meter = 1/data.meter_per_pixel;

if ~isfield(data, 'rho_congestion')
    data.rho_congestion = 0.75;
end

fprintf('Init escape routes...\n');
data = initEscapeRoutes(data);
fprintf('Init wall forces...\n');
data = initWallForces(data);
fprintf('Init agents...\n');
data = initAgents(data);

% maximum influence of agents on each other

data.r_influence = data.pixel_per_meter * ...
    fzero(@(r) data.A * exp((2*data.r_max-r)/data.B) - 1e-4, data.r_max);

fprintf('Init plots...\n');
%init the plots
%exit plot
% data.figure_exit=figure;
% hold on;
% axis([0 data.duration 0 data.total_agent_count]);
% title(sprintf('agents that reached the exit (total agents: %i)', data.total_agent_count));

%floors plot
data.figure_floors=figure;
data.figure_floors_subplots_w = data.floor_count;
data.figure_floors_subplots_h = 1;
for i=1:config.floor_count
%     data.floor(i).agents_on_floor_plot = subplot(data.figure_floors_subplots_h, data.figure_floors_subplots_w ...
%     , data.floor_count - i+1 + data.figure_floors_subplots_w);
    data.floor(i).building_plot = subplot(data.figure_floors_subplots_h, data.figure_floors_subplots_w ...
    , data.floor_count - i+1);
end

%frames
data.frame = 0;
if data.save_frames == 1
    if exist('frames','dir') ~= 7
        mkdir('frames')
    end
    if exist(['frames/' data.frame_basename],'dir') == 7
        rmdir(['frames/' data.frame_basename],'s')
    end
    mkdir(['frames/' data.frame_basename])
    data.video = VideoWriter(['frames/' data.frame_basename '/' data.frame_basename],'MPEG-4');
    data.video.Quality = 100;
    data.video.FrameRate = 25;
    data.dt = min(0.04,data.dt);
    data.FramesInSec = ceil(1 / (data.video.FrameRate * data.dt));
    data.dt = 1 / (data.FramesInSec * data.video.FrameRate);
    open(data.video);
end

