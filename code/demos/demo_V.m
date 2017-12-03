close all ; clear ; clc
cd('..')

trialNum = 10;
v0Values = 135 : 10 : 225;
tResults = zeros(trialNum,length(v0Values));
configFile = 'data/config_demo_v0.conf';
configText = fileread(configFile);

for v0 = v0Values
configName = ['data/config_demo_v0-' num2str(v0/100) '.conf'];
configTextNew = strrep(configText,'X',num2str(v0/100)); %search for X and replace it
fileID = fopen(configName,'w');                     %write premission
fprintf(fileID,configTextNew);
fclose(fileID);                                     %overwriting the config.file
end

for trial = 1 : trialNum
s = rng('shuffle','twister');
for pInd = 1 : length(v0Values) %1-10
v0 = v0Values(pInd);
configName = ['data/config_demo_v0-' num2str(v0/100) '.conf'];
rng(s)
tResults(trial,pInd) = simulate(configName);
close
end
end                                 %generating random factor and make sure
%that everytime we have the same random


for v0 = v0Values
configName = ['data/config_demo_v0-' num2str(v0/100) '.conf'];
delete(configName)
end

figure()
plot(v0Values/10,mean(tResults),'-ko')
grid
xlim([v0Values(1)/10 v0Values(end)/10])
xlabel('Desired velocity $v0$','interpreter','latex')
ylabel('Evacuation time (s)','interpreter','latex')
if exist('plots','dir') ~= 7
mkdir('plots')
end
saveas(gcf,'../plots/demo_v0.eps')
