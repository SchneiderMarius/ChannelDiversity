saveDir = fullfile(cd,'code','data');
cd JarkyModel

iso_num = [2:2:20];
samplesize = 200;
boarder = [-0.75 0.75];
big_steps = 0.1;
small_steps = 0.05;
num_fit = 5;
[tree, neuron_orig] = CA1_initModel(1,0); 

for counter = 2 : numel(iso_num)
    [neuron_iso{counter},channame{counter},chanvalue{counter}] = generate_isoforms_Jarksy(neuron_orig,tree,'all',iso_num(counter),0);
    [neuron_samp{counter}, chanvalue{counter}, ~, channame{counter}] = rand_Parameter_Jarsky(neuron_iso{counter},tree,boarder,samplesize,[],0);
    [volt{counter},timeVec,mechs,~]  = Parameter_Test_Jarsky_CClamp(neuron_samp{counter},tree,0.1);
    [Matrix{counter},Matrix_rel{counter},Pareto(counter,:)] = Fitness_Jarsky(volt{counter},timeVec);
    
    [B I] = sort(Pareto(counter,:));
    [C,ia,ic] = unique(B);
    I_use = I(ia(1:num_fit));
    
    for counter2 = 1 : numel(I_use)
        [mechs_fit{counter,counter2}, volt_fit{counter,counter2}, Pareto_fit(counter,counter2), Matrix_rel_hist{counter,counter2}]...
            = gradient_walk_Jarsky(neuron_samp{counter}{I_use(counter2)},tree,small_steps,[],6);      
        sprintf('Counter1: %d/%d, Counter2: %d/%d',counter,numel(iso_num),counter2,num_fit)
    end
end
save(fullfile(pwd,'Data','Isoform_fits'),'iso_num','mechs_fit','volt_fit','Pareto_fit','Matrix_rel_hist','Matrix','Matrix_rel','Pareto','neuron_samp','volt')

%%
clear all 

data = load(fullfile(pwd,'Data','Isoform_fits'));
[tree, neuron_orig] = CA1_initModel(1,0);  % initialize the model by loading the morphologies and setting the biophysical parameters
boarder = [-1 1];
samplesize = 1000;
iso_num = [0,data.iso_num]

for counter = 1 : numel(iso_num)
    if counter == 1
        [neuron_samp{counter,1}, chanvalue{counter,1}, ~, channame{counter,1}] = rand_Parameter_Jarsky(neuron_orig,tree,boarder,samplesize,[],0);
        [volt{counter,1},timeVec,~,~]  = Parameter_Test_Jarsky_CClamp(neuron_samp{counter,1},tree,0.1);
        [Matrix{counter,1},Matrix_rel{counter,1},Pareto{counter,1}] = Fitness_Jarsky(volt{counter,1},timeVec,10,'01');
        statistic_mean(counter) = sum(Pareto{counter,1}<2)/samplesize;
        statistic_best(counter) = sum(Pareto{counter,1}<2)/samplesize;
    else 
        for counter2 = 1 : size(data.mechs_fit,2)
            if ~isempty(data.mechs_fit{counter-1,counter2})
                clear neuron_samp
                neuron = neuron_orig;
                neuron.mech{1} = data.mechs_fit{counter-1 , counter2};
                [neuron_samp{counter,counter2}, chanvalue{counter,counter2}, ~, channame{counter,counter2}] = rand_Parameter_Jarsky(neuron,tree,boarder,samplesize,[],0);
                [volt{counter,counter2},timeVec,~,~]  = Parameter_Test_Jarsky_CClamp(neuron_samp{counter,counter2},tree,0.1);
                [Matrix{counter,counter2},Matrix_rel{counter,counter2},Pareto{counter,counter2}] = Fitness_Jarsky(volt{counter,counter2},timeVec);
                stats(counter,counter2) = sum(Pareto{counter,counter2}<2)/samplesize;
            end
        end
        statistic_mean(counter) = mean(stats(counter,stats(counter,:)>0));
        statistic_max(counter) = max(stats(counter,:));
    end
    save(fullfile(saveDir,'4C_JarkyIsoforms_statistic'),'statistic_mean','statistic_max','stats','Matrix','Matrix_rel','Pareto','chanvalue','channame','iso_num')
end
