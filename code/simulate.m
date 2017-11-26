function final_time = simulate(config_file)
% run this to start the simulation
close all
addpath('bin','c')

if nargin==0
    config_file='data/config_test.conf';
end

fprintf('Load config file...\n');
config = loadConfig(config_file);

data = initialize(config);

data.time = 0;
fprintf('Start simulation...\n');

while (data.time < data.duration)
    tstart=tic;
    data = chooseExit(data);
    data = addDesiredForce(data);
    data = addWallForce(data);
    data = addAgentRepulsiveForce(data);
    data = addExitForce(data);
    data = applyForcesAndMove(data);
    
    % do the plotting
    set(0,'CurrentFigure',data.figure_floors);
    for floor=1:data.floor_count
        plotFloor(data, floor);
    end
    
    % save frame
    if data.save_frames == 1
        saveFrame(data)
    end

    if (data.time + data.dt > data.duration)
        data.dt = data.duration - data.time;
        data.time = data.duration;
    else
        data.time = data.time + data.dt;
    end
    
    if data.agents_exited == data.total_agent_count
        fprintf('All agents are now saved (or are they?). Time: %.2f sec\n', data.time);
        fprintf('Total Agents: %i\n', data.total_agent_count);
        break;
    end
    
    telapsed = toc(tstart);
    pause(max(data.dt - telapsed, 0.01));
    fprintf('Frame %i done (took %.3fs; %.3fs out of %.3gs simulated).\n', data.frame, telapsed, data.time, data.duration);
    data.frame = data.frame + 1;
end

final_time = data.time;

fprintf('Simulation done.\n');

