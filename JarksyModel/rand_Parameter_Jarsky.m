function [neuron, chanvalue, chanval, channame] = rand_Parameter_Jarsky(neuron_orig,tree,boarder,num_sim,chan_del,change_base)

%rng('shuffle');

regions ={};
for counter = 1 : numel(tree{1}.rnames)
    if any(contains(fieldnames(neuron_orig.mech{1}),tree{1}.rnames{counter}))
        regions = [regions tree{1}.rnames{counter}];
    end
end
regions = [regions 'all' 'range'];
counter=1;

%1. range.nax
%2. range.kad
%3. kap.gkabar

for f= 1 : numel(regions)
    chan = fieldnames(neuron_orig.mech{1}.(regions{f}));

    for ff=1:numel(chan)
        if any(contains(fieldnames(neuron_orig.mech{1}.(regions{f}).(chan{ff})),'bar'))
            chanparam=fieldnames(neuron_orig.mech{1}.(regions{f}).(chan{ff}));
            
            for fff=1:sum(contains(fieldnames(neuron_orig.mech{1}.(regions{f}).(chan{ff})),'bar'))
                id2 = find(contains(fieldnames(neuron_orig.mech{1}.(regions{f}).(chan{ff})),'bar'));
                par = chanparam{id2(fff)} ;  
                if numel(neuron_orig.mech{1}.(regions{f}).(chan{ff}).(par))==1
                    chanval(counter,1) = neuron_orig.mech{1}.(regions{f}).(chan{ff}).(par);
                else
                    chanval(counter,1) = neuron_orig.mech{1}.(regions{f}).(chan{ff}).(par)(find(neuron_orig.mech{1}.(regions{f}).(chan{ff}).(par)>0,1));
                end

                chanvalue{counter,1} = neuron_orig.mech{1}.(regions{f}).(chan{ff}).(par);
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

if nargin<5
%     del = [find(chanval==0); find(strcmp('Kir21',channame(:,1)))];
else
%     del = [find(chanval==0); find(strcmp('Kir21',channame(:,1))); find(strcmp(chan_del,channame(:,1)))];
    del = find(strcmp(chan_del,channame(:,1)));
end
channame(del,:) = [];
chanval(del,:) = [];
% dend_id = find(strcmp(channame(:,2),'GCL'));
% chan_dend = channame(dend_id,:);

% Suche Mechanisms ohne region
chan = fieldnames(neuron_orig.mech{1});
for counter = 1 : numel(fieldnames(neuron_orig.mech{1}))
    if ~any(contains(channame(:,2),chan{counter})) %~any(contains(tree{1}.rnames,chan{counter}))
        id = find(contains(fieldnames(neuron_orig.mech{1}.(chan{counter})),'bar'));
        chanparam = fieldnames(neuron_orig.mech{1}.(chan{counter}));
        channame = [channame; [{chan{counter}}, {'extra'}, {chanparam{id}}]];
        chanvalue{size(chanvalue,1)+1,1} = neuron_orig.mech{1}.(chan{counter}).(chanparam{id});
        chanval(size(chanval,1)+1,1) = neuron_orig.mech{1}.(chan{counter}).(chanparam{id})(find(neuron_orig.mech{1}.(chan{counter}).(chanparam{id})>0,1));
        
    end
end


for counter=1:num_sim
    neuron{counter} = neuron_orig;

    for f=1:size(channame,1)
        if contains(channame(f,2),'extra')
            neuron{counter}.mech{1}.(channame{f,1}).(channame{f,3})...
                =  neuron{counter}.mech{1}.(channame{f,1}).(channame{f,3}) + (neuron{counter}.mech{1}.(channame{f,1}).(channame{f,3})*(rand*diff(boarder)+boarder(1)));        
        else
            neuron{counter}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})...
                =  neuron{counter}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3}) + (neuron{counter}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})*(rand*diff(boarder)+boarder(1)));
        end
    end
    
    if change_base
        neuron_orig=neuron{counter};
    end
end


%%

regions ={};
for counter = 1 : numel(tree{1}.rnames)
    if any(contains(fieldnames(neuron_orig.mech{1}),tree{1}.rnames{counter}))
        regions = [regions tree{1}.rnames{counter}];
    end
end
regions = [regions 'all' 'range'];
counter=1;

%1. range.nax
%2. range.kad
%3. kap.gkabar

for f= 1 : numel(regions)
    chan = fieldnames(neuron_orig.mech{1}.(regions{f}));

    for ff=1:numel(chan)
        if any(contains(fieldnames(neuron_orig.mech{1}.(regions{f}).(chan{ff})),'bar'))
            chanparam=fieldnames(neuron_orig.mech{1}.(regions{f}).(chan{ff}));
            
            for fff=1:sum(contains(fieldnames(neuron_orig.mech{1}.(regions{f}).(chan{ff})),'bar'))
                id2 = find(contains(fieldnames(neuron_orig.mech{1}.(regions{f}).(chan{ff})),'bar'));
                par = chanparam{id2(fff)} ;  
                if numel(neuron_orig.mech{1}.(regions{f}).(chan{ff}).(par))==1
                    chanval(counter,1) = neuron_orig.mech{1}.(regions{f}).(chan{ff}).(par);
                else
                    chanval(counter,1) = neuron_orig.mech{1}.(regions{f}).(chan{ff}).(par)(find(neuron_orig.mech{1}.(regions{f}).(chan{ff}).(par)>0,1));
                end

                chanvalue{counter,1} = neuron_orig.mech{1}.(regions{f}).(chan{ff}).(par);
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

if nargin<5
%     del = [find(chanval==0); find(strcmp('Kir21',channame(:,1)))];
else
%     del = [find(chanval==0); find(strcmp('Kir21',channame(:,1))); find(strcmp(chan_del,channame(:,1)))];
    del = find(strcmp(chan_del,channame(:,1)));
end
channame(del,:) = [];
chanval(del,:) = [];
% dend_id = find(strcmp(channame(:,2),'GCL'));
% chan_dend = channame(dend_id,:);

% Suche Mechanisms ohne region
chan = fieldnames(neuron_orig.mech{1});
for counter = 1 : numel(fieldnames(neuron_orig.mech{1}))
    if ~any(contains(channame(:,2),chan{counter})) %~any(contains(tree{1}.rnames,chan{counter}))
        id = find(contains(fieldnames(neuron_orig.mech{1}.(chan{counter})),'bar'));
        chanparam = fieldnames(neuron_orig.mech{1}.(chan{counter}));
        channame = [channame; [{chan{counter}}, {'extra'}, {chanparam{id}}]];
        chanvalue{size(chanvalue,1)+1,1} = neuron_orig.mech{1}.(chan{counter}).(chanparam{id});
        chanval(size(chanval,1)+1,1) = neuron_orig.mech{1}.(chan{counter}).(chanparam{id})(find(neuron_orig.mech{1}.(chan{counter}).(chanparam{id})>0,1));
    end
end

% del=[find(chanval==0); find(strcmp('Kir21',channame(:,1)))];
% 
% channame(del,:) = [];
% chanval(del,:) = [];

% for n=1:numel(neuron) 
%    for f=1:size(channame,1)
%        chanvalue(f,n)=neuron{n}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3});
%    end      
% end

for counter=1:numel(neuron) 

    for f=1:size(channame,1)
        if contains(channame(f,2),'extra')
           chanvalue{f,counter} = neuron{counter}.mech{1}.(channame{f,1}).(channame{f,3});
            if numel(neuron_orig.mech{1}.(channame{f,1}).(channame{f,3}))==1
                chanval(f,counter) = neuron_orig.mech{1}.(channame{f,1}).(channame{f,3});
            else
                chanval(f,counter) = neuron_orig.mech{1}.(channame{f,1}).(channame{f,3})(find(neuron_orig.mech{1}.(channame{f,1}).(channame{f,3})>0,1));
            end
        else
            chanvalue{f,counter} = neuron{counter}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3});
            if numel(neuron_orig.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3}))==1
                chanval(f,counter) = neuron_orig.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3});
            else
                chanval(f,counter) = neuron_orig.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})(find(neuron_orig.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})>0,1));
            end
        end
    end
end


end