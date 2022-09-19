%% Random samle in different ranges
clear all

cd 'C:\Schneider2020_final\code';

Seed = rng('shuffle');

Models = [15, 8 ,5];
sample_size = 5000;
range = [0.1 : 0.1 : 1]';
range(:,2) = -range;

for cnt1 = 1 : numel(Models)
    params.channum = Models(cnt1);
    [neuron_orig, tree, ~] = Init_GC_mature(params);   
    for cnt2 = 1 : 7%size(range,1)   
        [neuron, chanvalue, channame] = rand_Parameter(neuron_orig,range(cnt2,:),sample_size,[],0);
        [volt,timeVec,mechs] = IClamp_Mongiat(neuron,tree);
        [Matrix, Matrix_rel, Fitness] = Fitness_Mongiat(volt,timeVec,params);
        statistic(cnt1,cnt2)  = sum(Fitness<2)/sample_size;    
    end
end

save(fullfile(pwd,'data',sprintf('2_Population_statistic_range')),'range','Models','statistic','Seed');

