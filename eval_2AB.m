%% Create Population of different GC models
%%2-fold range 
%%evaluate statistics
clear all
cd 'C:\Users\Marius Schneider\Desktop\Schneider2020_final\code';

Seed = rng('shuffle');

%GC-Models with different numbers of channels
Models = [15, 8 ,5];

% size of random sample
sample_size = 20000;

%range of random sample (-100% to +100% Channeldensity)
sample_range = 2;

%dont sample Kir21 - density validated by Beining et. al 2017
sample_not = 'Kir21';

for cnt1 = 1 : numel(Models)

    params.channum = Models(cnt1);
    [neuron_orig, tree, ~,~] = Init_GC_mature(params);
    
    [chanvalue, channame] = channel_cond(neuron_orig, sample_not);
    neuron{1} = neuron_orig;
       
    [neuron(2:sample_size+1), chanvalue(:,2:sample_size+1), channame] = randomize_Conductance(neuron_orig,2,sample_size);   

    %evaluate random Models
    [volt,timeVec,mechs] = IClamp_Mongiat(neuron,tree);
    [Matrix, Matrix_rel, Fitness] = Fitness_Mongiat(volt,timeVec,params);
    
    %statistcs of good models in rand. sample
    statistic(cnt1) = (sum(Fitness<2)-1)/sample_size*100;   

    del = find(Fitness>3);
    for counter=numel(del)
        mechs{del(counter)} = [];
        volt{del(counter)}  = [];
    end    
    save(fullfile(pwd,'data',sprintf('1_GCpopulation_%dchannels',Models(cnt1))),'chanvalue','volt','timeVec','Matrix','Matrix_rel','Fitness','channame','mechs');
end

save(fullfile(pwd,'data','1_PopSamp_statistic_twofold'),'statistic','Models','Seed');
