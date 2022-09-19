function [neuron, chanvalue, channame]=connect_Parameter(neuron_orig,mech,mech2,stepnum)



regions={'axonh','soma','GCL','adendIML','adendMML','adendOML'};
counter=1;

for f=1:numel(regions)-3
    chan = fieldnames(mech{1}.(regions{f}));

    for ff=1:numel(chan)
        if any(contains(fieldnames(mech{1}.(regions{f}).(chan{ff})),'bar'))
            chanparam=fieldnames(mech{1}.(regions{f}).(chan{ff}));
            
            for fff=1:sum(contains(fieldnames(mech{1}.(regions{f}).(chan{ff})),'bar'))
                id2=find(contains(fieldnames(mech{1}.(regions{f}).(chan{ff})),'bar'));
                par = chanparam{id2(fff)} ;  
                chanval(counter,1)= mech{1}.(regions{f}).(chan{ff}).(par);
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
dend_id=find(strcmp(channame(:,2),'GCL'));
chan_dend=channame(dend_id,:);


for f=1:size(channame,1)   
   mechstep(f) = (mech2{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})-mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3}))/stepnum;
    
end

for counter = 1 : stepnum-1
    mechout{counter}=mech;

    for f=1:size(channame,1)    
        mechout{counter}{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})...
            = mechout{counter}{1}.(channame{f,2}).(channame{f,1}).(channame{f,3}) +  mechstep(f)*counter;
    end
  
    
    for f=4:numel(regions)
        for ff=1:size(chan_dend,1)
             mechout{counter}{1}.(regions{f}).(chan_dend{ff,1}) = mechout{counter}{1}.(chan_dend{ff,2}).(chan_dend{ff,1});
        end
    end 
end


%%

clear channame chanval
regions={'axonh','soma','GCL','adendIML','adendMML','adendOML'};
counter=1;


for f=1:numel(regions)-3
    chan = fieldnames(mech{1}.(regions{f}));

    for ff=1:numel(chan)
        if any(contains(fieldnames(mech{1}.(regions{f}).(chan{ff})),'bar'))
            chanparam=fieldnames(mech{1}.(regions{f}).(chan{ff}));
            
            for fff=1:sum(contains(fieldnames(mech{1}.(regions{f}).(chan{ff})),'bar'))
                id2=find(contains(fieldnames(mech{1}.(regions{f}).(chan{ff})),'bar'));
                par = chanparam{id2(fff)} ;  
                chanval(counter,1)= mech{1}.(regions{f}).(chan{ff}).(par);
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

for n=1:numel(mechout)
   neuron{n} = neuron_orig;
   neuron{n}.mech = mechout{n};
   for f=1:size(channame,1)
       chanvalue(f,n)=mechout{n}{1}.(channame{f,2}).(channame{f,1}).(channame{f,3});
   end      
end

end