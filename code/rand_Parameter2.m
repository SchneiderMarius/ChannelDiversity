function [neuron, chanvalue, channame] = rand_Parameter(neuron_orig,boarder,num_sim,chan_del,change_base)

regions={'axonh','soma','GCL','adendIML','adendMML','adendOML'};

[chanvalue, channame] = channel_cond(neuron_orig, chan_del);

dend_id=find(strcmp(channame(:,2),'GCL'));
chan_dend=channame(dend_id,:);


for counter = 1 : num_sim
    neuron{counter} = neuron_orig;

    for f=1:size(channame,1)    
        neuron{counter}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})...
            =  neuron{counter}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3}) + (neuron{counter}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})*(rand*diff(boarder)+boarder(1)));
    end
    
    for f=4:numel(regions)
        for ff=1:size(chan_dend,1)
             neuron{counter}.mech{1}.(regions{f}).(chan_dend{ff,1}) = neuron{counter}.mech{1}.(chan_dend{ff,2}).(chan_dend{ff,1});
        end
    end 
    
    if change_base
        neuron_orig = neuron{counter};
    end
end

[chanvalue, channame] = channel_cond(neuron, chan_del);

end