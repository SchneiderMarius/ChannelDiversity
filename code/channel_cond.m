function  [chanval,channame] = channel_cond(neuron_orig,delete_chan)

regions={'axonh','soma','GCL','adendIML','adendMML','adendOML'};

if iscell(neuron_orig)
    
    counter=1;
    for f=1:numel(regions)-3
        chan = fieldnames(neuron_orig{1}.mech{1}.(regions{f}));

        for ff=1:numel(chan)
            if any(contains(fieldnames(neuron_orig{1}.mech{1}.(regions{f}).(chan{ff})),'bar'))
                chanparam=fieldnames(neuron_orig{1}.mech{1}.(regions{f}).(chan{ff}));

                for fff=1:sum(contains(fieldnames(neuron_orig{1}.mech{1}.(regions{f}).(chan{ff})),'bar'))
                    id2=find(contains(fieldnames(neuron_orig{1}.mech{1}.(regions{f}).(chan{ff})),'bar'));
                    par = chanparam{id2(fff)} ;  
                    chanval(counter,1)= neuron_orig{1}.mech{1}.(regions{f}).(chan{ff}).(par);
                    channame{counter,1} = chan{ff};
                    channame{counter,2} = regions{f};
                    channame{counter,3} = par;
                    counter=counter+1;
                    clear par
                end
                clear  chanparam
            end
        end
        clear chan 
    end    
    
    for mainC = 1 : numel(neuron_orig)
        for f=1:size(channame,1)    
            chanval(f,mainC) =  neuron_orig{mainC}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3});
        end
    end
    del = find(chanval(:,1)==0);
    
elseif isstruct(neuron_orig)
    counter=1;
    for f=1:numel(regions)-3
        chan = fieldnames(neuron_orig.mech{1}.(regions{f}));

        for ff=1:numel(chan)
            if any(contains(fieldnames(neuron_orig.mech{1}.(regions{f}).(chan{ff})),'bar'))
                chanparam=fieldnames(neuron_orig.mech{1}.(regions{f}).(chan{ff}));

                for fff=1:sum(contains(fieldnames(neuron_orig.mech{1}.(regions{f}).(chan{ff})),'bar'))
                    id2=find(contains(fieldnames(neuron_orig.mech{1}.(regions{f}).(chan{ff})),'bar'));
                    par = chanparam{id2(fff)} ;  
                    chanval(counter,1)= neuron_orig.mech{1}.(regions{f}).(chan{ff}).(par);
                    channame{counter,1} = chan{ff};
                    channame{counter,2} = regions{f};
                    channame{counter,3} = par;
                    counter=counter+1;
                    clear par
                end
                clear  chanparam
            end
        end
        clear chan
    end
    del = find(chanval==0);
end


if iscell(delete_chan)
    for counter2 = 1 : numel(delete_chan)
        del = [del; find(strcmp(delete_chan{counter2},channame(:,1)))];
    end
elseif ischar(delete_chan)
    del = [del; find(strcmp(delete_chan,channame(:,1)))];
end

channame(del,:) = [];
chanval(del,:) = [];
% dend_id=find(strcmp(channame(:,2),'GCL'));
% chan_dend=channame(dend_id,:);

end
