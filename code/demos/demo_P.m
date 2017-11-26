close all ; clear ; clc
cd('..')

trialNum = 10;
pValues = 0 : 1 : 9;
tResults = zeros(trialNum,length(pValues));
configFile = 'data/config_demo_P.conf';
configText = fileread(configFile);

for p = pValues
    configName = ['data/config_demo_P-0.' num2str(p) '.conf'];
    configTextNew = strrep(configText,'X',num2str(p));
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