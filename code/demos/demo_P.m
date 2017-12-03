close all ; clear ; clc
cd('..')

s = rng('shuffle','twister');
rng(s)
simulate('data/config_demo_P.conf');

trialNum = 10;
pValues = 0 : 1 : 9;
tResults = zeros(trialNum,length(pValues));
configFile = 'data/config_demo_P.conf';
configText = fileread(configFile);

for p = pValues
    configName = ['data/config_demo_P-0.' num2str(p) '.conf'];
    configTextNew = strrep(configText,'save_frames = 1','save_frames = 0');
    configTextNew = strrep(configTextNew,'p = 0.4',['p = 0.' num2str(p)]);
    fileID = fopen(configName,'w');
    fprintf(fileID,configTextNew);
    fclose(fileID);
end

for trial = 1 : trialNum
	s = rng('shuffle','twister');
    for pInd = 1 : length(pValues)
        p = pValues(pInd);
        configName = ['data/config_demo_P-0.' num2str(p) '.conf'];
        rng(s)
        tResults(trial,pInd) = simulate(configName);
        close
    end
end

for p = pValues
    configName = ['data/config_demo_P-0.' num2str(p) '.conf'];
    delete(configName)
end

figure()
plot(pValues/trialNum,mean(tResults),'-ko')
grid
xlim([pValues(1)/trialNum pValues(end)/trialNum])
xlabel('Panic level $p$','interpreter','latex')
ylabel('Evacuation time (s)','interpreter','latex')
if exist('plots','dir') ~= 7
    mkdir('plots')
end
saveas(gcf,'plots/demo_P.eps')