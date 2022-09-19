function [neuron, chanvalue, channame]=rand_Parameter(neuron_orig,boarder,num_sim,chan_del,ChangeInit)

rng('shuffle');

regions={'axonh','soma','GCL','adendIML','adendMML','adendOML'};
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
%                chanval_surf(counter,1) = chanval(counter,1) *surfcomp(f)
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

if nargin<4
    del=[find(chanval==0); find(strcmp('Kir21',channame(:,1)))];
else
    del=[find(chanval==0); find(strcmp('Kir21',channame(:,1))); find(strcmp(chan_del,channame(:,1)))];
end
channame(del,:) = [];
chanval(del,:) = [];
dend_id=find(strcmp(channame(:,2),'GCL'));
chan_dend=channame(dend_id,:);

% same sample range for all channels
if any(size(boarder)==1)
    for counter=1:num_sim
        neuron{counter}=neuron_orig;

        for f=1:size(channame,1)    
%             neuron{counter}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})...
%                 =  neuron{counter}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3}) + (neuron{counter}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})*(rand*diff(boarder)+boarder(1)));
            neuron{counter}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})...
                =  neuron{counter}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})*(rand*diff(boarder)+boarder(1));
        end

        for f=4:numel(regions)
            for ff=1:size(chan_dend,1)
                 neuron{counter}.mech{1}.(regions{f}).(chan_dend{ff,1}) = neuron{counter}.mech{1}.(chan_dend{ff,2}).(chan_dend{ff,1});
            end
        end 

        if ChangeInit==1
            neuron_orig=neuron{counter};
        end
    end
%change range for each channel
else ~any(size(boarder)==1)
    for counter=1:num_sim
        neuron{counter}=neuron_orig;

        for f=1:size(channame,1)    
%            neuron{counter}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})...
%                =  neuron{counter}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3}) + (neuron{counter}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})*(rand*diff(boarder(f,:))+boarder(f,1)));
            neuron{counter}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})...
                =  (neuron{counter}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})*(rand*diff(boarder(f,:))+boarder(f,1)));       
        end

        for f=4:numel(regions)
            for ff=1:size(chan_dend,1)
                 neuron{counter}.mech{1}.(regions{f}).(chan_dend{ff,1}) = neuron{counter}.mech{1}.(chan_dend{ff,2}).(chan_dend{ff,1});
            end
        end 

        if ChangeInit==1
            neuron_orig=neuron{counter};
        end
    end    
end
%%

clear channame chanval
regions={'axonh','soma','GCL','adendIML','adendMML','adendOML'};
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
%                chanval_surf(counter,1) = chanval(counter,1) *surfcomp(f)
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

del=[find(chanval==0); find(strcmp('Kir21',channame(:,1)))];

channame(del,:) = [];
chanval(del,:) = [];

for n=1:numel(neuron) 
   for f=1:size(channame,1)
       chanvalue(f,n)=neuron{n}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3});
   end      
end

end