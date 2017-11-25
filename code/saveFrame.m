function saveFrame(data)
%SAVEFRAME save frame

if mod(data.frame,data.FramesInSec) == 0
    
    saveas(data.figure_floors,sprintf('frames/%s/%s_%04i_%.3f.eps', ...
           data.frame_basename,data.frame_basename,data.frame,data.time),'epsc');
    videoFrame = getframe(data.figure_floors);
    writeVideo(data.video,videoFrame);

    if data.agents_exited == data.total_agent_count
        close(data.video);
    end

end