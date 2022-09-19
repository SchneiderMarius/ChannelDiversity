function [new_tree,new_mech] = t2n_transform_mech(old_tree,old_mech,new_tree)


regions=old_tree.rnames
surface_tree=surf_tree(old_tree);
surface_newtree=sum(surf_tree(new_tree));

counter=1;
for f=1:numel(regions)

    chan = fieldnames(old_mech.(regions{f}));
    
    for ff=1:numel(chan)
        if any(contains(fieldnames(old_mech.(regions{f}).(chan{ff})),'bar'));
            chanparam=fieldnames(old_mech.(regions{f}).(chan{ff}));
            
            for fff=1:sum(contains(fieldnames(old_mech.(regions{f}).(chan{ff})),'bar'))
                id2=find(contains(fieldnames(old_mech.(regions{f}).(chan{ff})),'bar'));
                par = chanparam{id2(fff)} ;  
                chanval(counter,1)= old_mech.(regions{f}).(chan{ff}).(par);
                chanval_surf(counter,1)= old_mech.(regions{f}).(chan{ff}).(par)*sum(surface_tree(find(old_tree.R==find(strcmp(old_tree.rnames,regions{f})))));
%                chanval_surf(counter,1) = chanval(counter,1) *surfcomp(f)
                channame{counter,1} = chan{ff};
                channame{counter,2} = regions{f};
                channame{counter,3} = par;
                counter=counter+1;
                clear par
            end
            clear  chanparam
        elseif strcmp(chan{ff},'pas') && any(contains(fieldnames(old_mech.(regions{f}).(chan{ff})),'g'));
              chanparam=fieldnames(old_mech.(regions{f}).(chan{ff}));
            for fff=1:sum(contains(fieldnames(old_mech.(regions{f}).(chan{ff})),'g'))
                id2=find(contains(fieldnames(old_mech.(regions{f}).(chan{ff})),'g'));
                par = chanparam{id2(fff)} ;  
                chanval(counter,1)= old_mech.(regions{f}).(chan{ff}).(par);
                chanval_surf(counter,1)= old_mech.(regions{f}).(chan{ff}).(par)*sum(surface_tree(find(old_tree.R==find(strcmp(old_tree.rnames,regions{f})))));

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
clear counter id2

del=find(chanval==0);
chanval(del,:)=[];
chanval_surf(del,:)=[];
channame(del,:)=[];
chans=unique(channame(:,1));

counter=1;
for i=1:numel(chans)
    if strcmp(chans{i},'BK')
        id = find(strcmp(channame(:,1),chans{i}));
        chan_dens(counter,:) = sum(chanval_surf(id([1,3]),1));
        chan_dens_name(counter,:) = channame(id(1),[1,3]);
        counter=counter+1;
        chan_dens(counter,:) = sum(chanval_surf(id([2,4]),1));
        chan_dens_name(counter,:) = channame(id(2),[1,3]) ;
        counter=counter+1;
    else
        id = find(strcmp(channame(:,1),chans{i}));
        chan_dens(counter,:) = sum(chanval_surf(id,1));
        chan_dens_name(counter,:) = channame(id(1),[1,3]);
        counter=counter+1;
    end
end

regions_new=new_tree.rnames
new_mech=old_mech;

del_regions=regions;
del_regions(find(strcmp(del_regions,regions_new)))=[];

new_mech = rmfield(new_mech,del_regions);

for i=1:size(chan_dens_name,1)
    new_mech.(regions_new{1}).(chan_dens_name{i,1}).(chan_dens_name{i,2}) = chan_dens(i,1)/surface_newtree ;
end

















