%% eval F-I and I-V (seperate)
clear all

cd 'code'

data_folder = fullfile(pwd,'data');
Models = [15, 8 ,5];

[exp_iclamp,cstepsSpiking] = load_ephys(3,'CClamp');
[exp_vclamp,vsteps,rate] = load_ephys(3,'VClamp');

params.channum = Models(1);
[neuron_orig, tree, ~] = Init_GC_mature(params);

for counter=1:numel(Models)

    data = load(fullfile(data_folder,sprintf('1_GCpopulation_%dchannels',Models(counter))));
    id   = find(data.Fitness<2);
    
    for cnt1 = 1 : length(id)
        neuron{cnt1} = neuron_orig;
        neuron{cnt1}.mech{1} = data.mechs{id(cnt1)};
    end
    
    [currVec,steadyStateCurrVec] = VClamp(neuron,tree,vsteps,[105 100 105],-80);
    [voltVec,timeVec,numspikes]=FI(neuron,tree,cstepsSpiking*1000);
    [voltVec_dV,timeVec_dV,numspikes_dV]=dV(neuron,tree,90)
     
    save(fullfile(data_folder,sprintf('FigS3_Pipeline_%d.mat',Models(counter))),'currVec','steadyStateCurrVec','voltVec','timeVec','numspikes','voltVec_dV','timeVec_dV','numspikes_dV','cstepsSpiking','vsteps'); 
    clear currVec steadyStateCurrVec voltVec timeVec numspikes voltVec_dV timeVec_dV numspikes_dV
end
