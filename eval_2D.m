%% Random Walks - test perturbation stability of Models
clear all
cd 'C:\Users\Marius Schneider\Desktop\Schneider2020_final\code';

Seed = rng('shuffle');
Models = [15, 8 ,5];

runs = 2000;
max_iteration = 250;

%boarder of sampling (range of Percentage in which zou sample)
boarder=[-0.05,0.05];

keep = {'na8st',[]};
samp_size = 16;

for cnt1 = 1 : length(keep)
    
    for cnt2 = 1 : numel(Models)
        
        params.channum = Models(cnt2);
        [neuron_orig2, tree, ~] = Init_GC_mature(params);

        for cnt3 = 1 : runs

            neuron_orig=neuron_orig2;      
            Fitness{cnt3,cnt2} = [];

            for cnt4 =1 : max_iteration
                [neuron, chanval, channame] = rand_Parameter(neuron_orig,boarder,samp_size,keep{cnt1},1);
                [volt,timeVec,mechs] = IClamp_Mongiat(neuron,tree);
                [Matrix_sim, Matrix_rel_sim, Fitness_sim] = Fitness_Mongiat(volt,timeVec,params);     
                Fitness{cnt3,cnt2}(length(Fitness{cnt3})+1:length(Fitness{cnt3})+length(Fitness_sim)) = Fitness_sim;
                neuron_orig=neuron{length(neuron)};

                if any(Fitness_sim > 2)
                    num_step(cnt2,cnt3) = samp_size*(cnt4-1)+find(max(Fitness{cnt3,cnt2})>2,1);
                    clear neuron
                    if mod(cnt3,10)==0
                        if cnt1==1
                            save(fullfile(pwd,'data',sprintf('3_RandWalk_valid_%dchannels_nona8st',Models(cnt2))),'num_step','Fitness','runs','Seed');                          
                        elseif cnt1==2
                            save(fullfile(pwd,'data',sprintf('3_RandWalk_valid_%dchannels',Models(cnt2))),'num_step','Fitness','runs','Seed');
                        end
                    end
                    break;
                end        
            end
        end
        
        if cnt1==1
             save(fullfile(pwd,'data',sprintf('3_RandWalk_valid_%dchannels_nona8st',Models(cnt2))),'num_step','Fitness','runs','Seed','Models');                          
        elseif cnt1==2
             save(fullfile(pwd,'data',sprintf('3_RandWalk_valid_%dchannels',Models(cnt2))),'num_step','Fitness','runs','Seed','Models');
        end
    end
    % save statistics
    if cnt1==1
         save(fullfile(pwd,'data',sprintf('3_RandWalk_valid_statistic_nona8st')),'num_step','Fitness','Models','runs','Seed');                          
    elseif cnt1==2
         save(fullfile(pwd,'data',sprintf('3_RandWalk_valid_statistic')),'num_step','Fitness','Models','runs','Seed');
    end 
end
