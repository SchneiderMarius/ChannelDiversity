function [mech_end,volt_general, Pareto_end, Matrix_rel_hist] = gradient_walk_Jarsky(neuron_orig,tree,start_step,chan_del, flagboarder)
%[mech_hist, Matrix_rel_hist, chanvalue_hist, channame,volt_general,Pareto_totalhist,Pareto_hist,Matrix_rel_longhist,imp_steps]


imp_steps=0;
step=start_step;
factor=[-step, step];

%after 10 steps without performace/Fitness increase -> stop
% flagboarder=10;
%%
% factor=[-0.75,-0.5,-0.25,-0.1,-0.05,0.05,0.1,0.25,0.5,1,2,4];

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


neuron_way=neuron_orig;
neuron{1}=neuron_orig;    
[volt,timeVec,mechs,~] = Parameter_Test_Jarsky_CClamp(neuron,tree,0.1);

[Matrix,Matrix_rel,Fitness] = Fitness_Jarsky(volt,timeVec);
%_hist-> HISTORY OF GRADIENT WALK!!!!
mech_hist{1}=mechs{1};
Matrix_rel_hist=Matrix_rel;
Matrix_general=Matrix_rel;
Matrix_rel_longhist=Matrix_rel;
volt_general = volt;

counter=0;
flag_count=0;
%increase in radnomization 
increase = [-0.1 0.1];
boarder = [1 1];


while flag_count <= flagboarder && max(max(Matrix_general))>2
    counter=counter+1;
	clear neuron
    
	for f=1:size(channame,1)
          %gehe alle factoren durch in einem Kanal 

        if contains(channame(f,2),'extra')
            for ff=1:numel(factor) 
                neuron{ff+numel(factor)*(f-1)}=neuron_orig;
                neuron{ff+numel(factor)*(f-1)}.mech{1}.(channame{f,1}).(channame{f,3})...
                    =  neuron_orig.mech{1}.(channame{f,1}).(channame{f,3}) + (neuron_orig.mech{1}.(channame{f,1}).(channame{f,3})*factor(ff));  
            end        
        else 
            for ff=1:numel(factor) 
                neuron{ff+numel(factor)*(f-1)}=neuron_orig;
                neuron{ff+numel(factor)*(f-1)}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})...
                    =  neuron_orig.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3}) + (neuron_orig.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})*factor(ff));  
            end
        end 
    end
       
	[volt,timeVec,mechs,~] = Parameter_Test_Jarsky_CClamp_fast(neuron,tree,0.1);
	[Matrix,Matrix_rel,Fitness] = Fitness_Jarsky(volt,timeVec,10,'01');  
      
      
      %% apply all changes which improve performance  (test whether all changes together perform better)
      id_imp = find(max(max(Matrix_rel))< max(max(Matrix_general)) );
      if numel(id_imp)>1
          nneuron{1}=neuron_orig;
          for f=1:size(channame,1)
              
              if contains(channame(f,2),'extra')
                for ff=1:numel(factor)
                    if any((ff+numel(factor)*(f-1))==id_imp)
                        nneuron{1}.mech{1}.(channame{f,1}).(channame{f,3})...
                        =  neuron_orig.mech{1}.(channame{f,1}).(channame{f,3}) + (neuron_orig.mech{1}.(channame{f,1}).(channame{f,3})*factor(ff));  
                    end
                end          

              else
                for ff=1:numel(factor)
                    if any((ff+numel(factor)*(f-1))==id_imp)
                        nneuron{1}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})...
                        =  neuron_orig.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3}) + (neuron_orig.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})*factor(ff));  
                    end
                end                  
              end

          end
          [volt_imp,timeVec,mechs(end+1),~] = Parameter_Test_Jarsky_CClamp_fast(nneuron,tree,0.1);
          [Matrix(:,:,end+1),Matrix_rel(:,:,end+1),Fitness(:,:,end+1)] = Fitness_Jarsky(volt_imp,timeVec,10,'01');  
          volt(end+1)=volt_imp;
          neuron(end+1) = nneuron;  
      end
      
      
      idhist=find( min(max(max(Matrix_rel(:,:,:))))==max(max(Matrix_rel(:,:,:))),1 );
      Matrix_rel_longhist(:,:,end+1) = Matrix_rel(:,:,idhist);
      
      
      %%
      if min(max(max(Matrix_rel(:,:,:)))) < max(max(Matrix_general(:,:,:))) && abs(min(max(max(Matrix_rel(:,:,:))))-max(max(Matrix_general(:,:,:)))) > 0.05
           id=find( min(max(max(Matrix_rel(:,:,:))))==max(max(Matrix_rel(:,:,:))),1);
           Matrix_rel_hist(:,:,end+1) = Matrix_rel(:,:,id);
           mech_hist(end+1) = neuron{id}.mech(1);
           Matrix_general = Matrix_rel(:,:,id);
           volt_general = volt(id);
           neuron_orig = neuron{id};
           flag_count = 0;
           max(max(Matrix_general))
           imp_steps=imp_steps+1; 
      elseif (min(max(max(Matrix_rel(:,:,:)))) >= max(max(Matrix_general(:,:,:)))  || abs(min(max(max(Matrix_rel(:,:,:))))-max(max(Matrix_general(:,:,:)))) < 0.05)     && max(max(Matrix_general(:,:,:)))<2.5
            step = step-(step/2);
            factor = [-step, step];
            flag_count = flag_count+1;
      elseif (min(max(max(Matrix_rel(:,:,:)))) >= max(max(Matrix_general(:,:,:))) || abs(min(max(max(Matrix_rel(:,:,:))))-max(max(Matrix_general(:,:,:)))) < 0.05) && max(max(Matrix_general(:,:,:)))>2.5
            step = step+(step/2);
            factor = [-step, step];     
            if factor(1)<=-1
               fac_temp = factor(2); 
               clear factor
               factor = fac_temp + (step/2);
            end
            flag_count = flag_count+1;
      end  

%       if flag_count==flagboarder && max(max(Matrix_general))>2
%            boarder=boarder+increase;
%            if boarder(1)==0 || boarder(1)<0
%               boarder=[0 boarder(2)+increase(2)];                    
%            end
%            [neuron_samp, ~, ~]=rand_Parameter(neuron_orig,boarder);
%            neuron_orig=neuron_samp{1};
%        end
end 
flag_count = 0;
step=start_step;
factor=[-step, step];
% IMPROVE
while flag_count <= flagboarder/2 && factor(1)>-1 && max(max(Matrix_general))<2
    counter=counter+1;
    clear neuron
       for f=1:size(channame,1)
           %gehe alle factoren durch in einem Kanal 

           if contains(channame(f,2),'extra')
               for ff=1:numel(factor) 
                    neuron{ff+numel(factor)*(f-1)}=neuron_orig;
                    neuron{ff+numel(factor)*(f-1)}.mech{1}.(channame{f,1}).(channame{f,3})...
                        =  neuron_orig.mech{1}.(channame{f,1}).(channame{f,3}) + (neuron_orig.mech{1}.(channame{f,1}).(channame{f,3})*factor(ff));  
               end 
           else
               for ff=1:numel(factor) 
                    neuron{ff+numel(factor)*(f-1)}=neuron_orig;
                    neuron{ff+numel(factor)*(f-1)}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})...
                        =  neuron_orig.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3}) + (neuron_orig.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})*factor(ff));  
               end
           end
           

       end
       
      [volt,timeVec,mechs,~] = Parameter_Test_Jarsky_CClamp(neuron,tree,0.1);
      [Matrix,Matrix_rel,Fitness] = Fitness_Jarsky(volt,timeVec);  
      
      
      %% apply all changes which improve performance  (test whether all changes together perform better)
      id_imp = find(max(max(Matrix_rel))< max(max(Matrix_general)) );
      if numel(id_imp)>1
          nneuron{1}=neuron_orig;
          for f=1:size(channame,1)
             if contains(channame(f,2),'extra')
                for ff=1:numel(factor)
                   if any((ff+numel(factor)*(f-1))==id_imp)
                        nneuron{1}.mech{1}.(channame{f,1}).(channame{f,3})...
                            =  neuron_orig.mech{1}.(channame{f,1}).(channame{f,3}) + (neuron_orig.mech{1}.(channame{f,1}).(channame{f,3})*factor(ff));  
                   end
                end             
             else
                for ff=1:numel(factor)
                   if any((ff+numel(factor)*(f-1))==id_imp)
                        nneuron{1}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})...
                            =  neuron_orig.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3}) + (neuron_orig.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})*factor(ff));  
                   end
                end                                  
             end

          end
          [volt_imp,timeVec,mechs(end+1),~] = Parameter_Test_Jarsky_CClamp(nneuron,tree,0.1);
          [Matrix(:,:,end+1),Matrix_rel(:,:,end+1),Fitness(:,:,end+1)] = Fitness_Jarsky(volt_imp,timeVec);  
          volt(end+1)=volt_imp;
          neuron(end+1) = nneuron;  
      end
      
      
      idhist=find( min(max(max(Matrix_rel(:,:,:))))==max(max(Matrix_rel(:,:,:))),1 );
      Matrix_rel_longhist(:,:,end+1) = Matrix_rel(:,:,idhist);
      
      
      %%
      if min(max(max(Matrix_rel(:,:,:)))) < max(max(Matrix_general(:,:,:))) && abs(min(max(max(Matrix_rel(:,:,:))))-max(max(Matrix_general(:,:,:)))) > 0.05
           id=find( min(max(max(Matrix_rel(:,:,:))))==max(max(Matrix_rel(:,:,:))),1);
           Matrix_rel_hist(:,:,end+1) = Matrix_rel(:,:,id);
           mech_hist(end+1) = neuron{id}.mech(1);
           Matrix_general = Matrix_rel(:,:,id);
           volt_general = volt(id);
           neuron_orig = neuron{id};
           flag_count = 0;
           max(max(Matrix_general))
           imp_steps=imp_steps+1; 
      elseif (min(max(max(Matrix_rel(:,:,:)))) >= max(max(Matrix_general(:,:,:)))  || abs(min(max(max(Matrix_rel(:,:,:))))-max(max(Matrix_general(:,:,:)))) < 0.05)     && max(max(Matrix_general(:,:,:)))<2.5
            step = step-(step/2);
            factor = [-step, step];
            flag_count = flag_count+1;
      elseif (min(max(max(Matrix_rel(:,:,:)))) >= max(max(Matrix_general(:,:,:))) || abs(min(max(max(Matrix_rel(:,:,:))))-max(max(Matrix_general(:,:,:)))) < 0.05) && max(max(Matrix_general(:,:,:)))>2.5
            step = step+(step/2);
            factor = [-step, step]; 
            flag_count = flag_count+1;

      end  
end 


%%
Pareto_hist(:) = max(max(Matrix_rel_hist));
Pareto_totalhist(:) = max(max(Matrix_rel_longhist));

for counter=1:numel(mech_hist) 
   for f=1:size(channame,1)
        if contains(channame(f,2),'extra')
           chanvalue_hist{f,counter} = mech_hist{counter}.(channame{f,1}).(channame{f,3});
            if numel(mech_hist{counter}.(channame{f,1}).(channame{f,3}))==1
                chanvalue_hist2(f,counter) = mech_hist{counter}.(channame{f,1}).(channame{f,3});
            else
                chanvalue_hist2(f,counter) = mech_hist{counter}.(channame{f,1}).(channame{f,3})(find(mech_hist{counter}.(channame{f,1}).(channame{f,3})>0,1));
            end
        else
            chanvalue_hist{f,counter} = mech_hist{counter}.(channame{f,2}).(channame{f,1}).(channame{f,3});
            if numel(mech_hist{counter}.(channame{f,2}).(channame{f,1}).(channame{f,3}))==1
                chanvalue_hist2(f,counter) = mech_hist{counter}.(channame{f,2}).(channame{f,1}).(channame{f,3});
            else
                chanvalue_hist2(f,counter) = mech_hist{counter}.(channame{f,2}).(channame{f,1}).(channame{f,3})(find(mech_hist{counter}.(channame{f,2}).(channame{f,1}).(channame{f,3})>0,1));
            end
        end       
   end      
end

mech_end = mech_hist{1}(end);
Pareto_end = max(max(Matrix_rel_hist(:,:,end)));
