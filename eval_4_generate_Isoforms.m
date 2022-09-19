clear all
cd code
folder = fullfile(cd,'data','Fig3AB');

% expand by max. 18 isoforms per channel
expansion = 21;
%%
old_chan={'BK','Cav22'};
old_chan_par={'base','hTau'};
regions={'axonh','soma','GCL','adendIML','adendMML','adendOML'};

%step_var = 1;
%stepsize = 0.05; %(10%)
%param_boarder=1;
samp_size = 500;
%runs=20;
%steps=zeros(1,runs);
factor=2;
rng('shuffle');


for ct0 = 2 : expansion

    params.channum = 5;
    [neuron_orig, tree, ~,~] = Init_GC_mature(params);
    neuron_orig2=neuron_orig;
       
    new_chan = [];
    for cnt1 = 2 : ct0
        new_chan{1}{cnt1-1} = sprintf('BK%d',cnt1);
        new_chan{2}{cnt1-1} = sprintf('Cav22%d',cnt1);
    end

    %add chans to neuron struct
    for f=1:numel(regions)-3
        for counter0=1:numel(old_chan)
            if any(contains(fieldnames(neuron_orig2.mech{1}.(regions{f})),old_chan{counter0}))

                chanparam=fieldnames(neuron_orig2.mech{1}.(regions{f}).(old_chan{counter0}));
                id=find(contains(fieldnames(neuron_orig2.mech{1}.(regions{f}).(old_chan{counter0})),'bar'));
                for i=1:numel(id)
                    neuron_orig2.mech{1}.(regions{f}).(old_chan{counter0}).(chanparam{id(i)}) = ...
                        neuron_orig2.mech{1}.(regions{f}).(old_chan{counter0}).(chanparam{id(i)}) / ( numel(new_chan{counter0}) +1);
                end
                for counter1=1:numel(new_chan{counter0})
    %                    [neuron_orig2.mech{1}.(regions{f}).(new_chan{counter0})] = neuron_orig2.mech{1}.(regions{f}).(old_chan{counter0});
                    neuron_orig2.mech{1}.(regions{f}).(new_chan{counter0}{counter1}) = neuron_orig2.mech{1}.(regions{f}).(old_chan{counter0});

                end
            end
        end
    end

    %add chans to dendrites of neuron struct
    for f=4:numel(regions)
        for counter0=1:numel(old_chan)
            if any(contains(fieldnames(neuron_orig2.mech{1}.(regions{f})),old_chan{counter0}))
               for counter1=1:numel(new_chan{counter0})
                    neuron_orig2.mech{1}.(regions{f}).(new_chan{counter0}{counter1}) = neuron_orig2.mech{1}.(regions{3}).(new_chan{counter0}{counter1});
               end
            end
        end
    end


    counter=1;
    for f=1:numel(regions)-3

        chan = fieldnames(neuron_orig2.mech{1}.(regions{f}));
    %    surfcomp(f)=sum(surf(find(find(strcmp(tree{1}.rnames,regions{f}))==tree{1}.R)));

        for ff=1:numel(chan)
            if any(contains(fieldnames(neuron_orig2.mech{1}.(regions{f}).(chan{ff})),'bar'));
                chanparam=fieldnames(neuron_orig2.mech{1}.(regions{f}).(chan{ff}));

                for fff=1:sum(contains(fieldnames(neuron_orig2.mech{1}.(regions{f}).(chan{ff})),'bar'))
                    id2=find(contains(fieldnames(neuron_orig2.mech{1}.(regions{f}).(chan{ff})),'bar'));
                    par = chanparam{id2(fff)} ;  
                    chanval(counter,1)= neuron_orig2.mech{1}.(regions{f}).(chan{ff}).(par);
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

    id=setdiff([1:size(chanval,1)],[find(strcmp(channame(:,1),'na8st'));find(strcmp(channame(:,1),'Kir21'))]);
    chanval_red=chanval(id,1);
    channame_red=channame(id,:);

    del=find(chanval_red==0);
    channame_red(del,:)=[];
    chanval_red(del,:)=[];

    dend_id=find(strcmp(channame_red(:,2),'GCL'));
    chan_dend=channame_red(dend_id,:);
    %boarder for chanvalues
    chanboarder=chanval_red*2;

    %% Settings
    %1 = stepsize is in range of -stepsize to stepsize (variable stepsize)   0 = fixed stepsize
    % step_var = 1;
    % %maximum stepsize
    % stepsize = 0.05; %(10%)
    % % 1 = Parameter have 2-fold limit range ; 0 = no limit for parameters
    % param_boarder=1;
    % cpu=32;
    % samp_size = 5000;
    % runs=20;
    % steps=zeros(1,runs);
    % factor=2;
    % rng('shuffle');
    %%
    neuron_orig=neuron_orig2;

    for b=1:samp_size
        neuron{b} = neuron_orig;
        for ff=1:length(old_chan)
            for f=1:length(new_chan{ff})
                neuron{b}.mech{1}.axonh.(new_chan{ff}{f}).(old_chan_par{ff}) = neuron{b}.mech{1}.axonh.(new_chan{ff}{f}).(old_chan_par{ff})*rand*factor;
            end
        end
        for f=1:size(channame_red,1)     
            if any(strcmp((channame_red{f,1}),new_chan{1})) && ~strcmp((channame_red{f,2}),'axonh')
                neuron{b}.mech{1}.(channame_red{f,2}).(channame_red{f,1}).(old_chan_par{1})...
                            = neuron{b}.mech{1}.axonh.(channame_red{f,1}).(old_chan_par{1});
            elseif any(strcmp((channame_red{f,1}),new_chan{2})) && ~strcmp((channame_red{f,2}),'axonh')
                neuron{b}.mech{1}.(channame_red{f,2}).(channame_red{f,1}).(old_chan_par{2})...
                            = neuron{b}.mech{1}.axonh.(channame_red{f,1}).(old_chan_par{2});
            end
            neuron{b}.mech{1}.(channame_red{f,2}).(channame_red{f,1}).(channame_red{f,3})...
                = neuron_orig.mech{1}.(channame_red{f,2}).(channame_red{f,1}).(channame_red{f,3})*rand*factor;
        end         
        for f=4:numel(regions) 
            for ff=1:size(chan_dend,1)
                neuron{b}.mech{1}.(regions{f}).(chan_dend{ff,1}) = neuron{b}.mech{1}.(chan_dend{ff,2}).(chan_dend{ff,1});
            end
        end   
    end

    [volt,timeVec,mechs]=IClamp_Mongiat(neuron,tree);
    [Matrix,Matrix_rel,Fitness]= Fitness_Mongiat(volt,timeVec);

    voltVec2=volt;     
    mech=mechs;
    Matrix_rel2=Matrix_rel;
    Fitness2=Fitness;

    chanvalue = [];
    for n=1:numel(mech) 
       for f=1:size(channame_red,1)
           chanvalue(f,n)=mech{n}.(channame_red{f,2}).(channame_red{f,1}).(channame_red{f,3});
       end      
    end

    [B,I] = sort(Fitness2);
    voltVec    = voltVec2(I(1:5));
    mech       = mech(I(1:5));
    Fitness    = Fitness2(I(1:5));
    Matrix_rel = Matrix_rel2(I(1:5));
    time       = timeVec(I(1:5));
    chanvalue  = chanvalue(:,I(1:5));

    save(fullfile(folder,sprintf('Scan_newchan_timeconstant_%d_Cav_%d_BK_best.mat',numel(new_chan{1}),numel(new_chan{2}))),'voltVec','time','mech','channame_red','chanvalue','Fitness','Matrix_rel');
end



%% Statistics von 3 chan Model und 3chan + 3Cav22 (6chan)  Model !!!

% name={'Scan_newchan_timeconstant_3_Cav_0_BK_10best','Scan_3chan_10best'};
% names={'3chan_3_Cav_0_BK','3chan'}
% 
% rng('shuffle');
% factor=2;
% neuron_orig.mech(2:8)=[];
% cpu=16;
% sampsize=200;
% 
% for counter0=1:numel(name)
%     load(name{counter0})
% 
%     dend_id=strcmp(channame(:,2),'GCL');
%     chan_dend=channame(dend_id,:);
%  
%    
%    for counter1=1:numel(mech_best)
%        neuron_orig.mech{1}=mech_best{counter1}
%        
%        for counter2=1:round(sampsize/cpu)
%            for b=1:cpu
%                 neuron{b} = neuron_orig;
%                 for f=1:size(channame,1)
%                     neuron{b}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})=neuron{b}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})*rand*factor;   
%                 end      
%                 %take GCL values for whole dendrite
%                 for f=4:numel(regions)
%                     for ff=1:size(chan_dend,1)
%                         neuron{b}.mech{1}.(regions{f}).(chan_dend{ff,1}).(chan_dend{ff,3}) = neuron{b}.mech{1}.(chan_dend{ff,2}).(chan_dend{ff,1}).(chan_dend{ff,3});
%                     end
%                 end
%             end
% 
%              [volt,timeVec,mechs,~]=Parameter_Test_Mongiat_CClamp_fast(neuron,tree);
%              [Matrix,Matrix_rel,Fitness]= Fitness_Mongiat_Bein_Model_new(volt,timeVec{1}{1});
% 
%              if counter2==1     
%                  voltVec2=volt;     
%                  mech=mechs;
%                  Matrix_rel2=Matrix_rel;
%                  Fitness2=Fitness;
%             else
%                  voltVec2(length(voltVec2)+1:length(voltVec2)+length(volt))=volt;     
%                  mech(length(mech)+1:length(mech)+length(neuron))=mechs;
%                  Matrix_rel2(:,:,size(Matrix_rel2,3)+1:size(Matrix_rel2,3)+size(Matrix_rel,3))=Matrix_rel;
%                  Fitness2(length(Fitness2)+1:length(Fitness2)+length(Fitness))=Fitness;
%             end
%             
%        end
%        id2 = find(any(any(Matrix_rel2(:,[1 2],:)>2))==0);
%        del=setdiff( [1:length(Fitness2) ], id2);
%        num_valid(counter0,counter1)=numel(id2);
%        perc_valid(counter0,counter1)=numel(id2)/length(Fitness2);
%        voltVec=voltVec2;
%        mechs=mech;
%        Matrix_rel=Matrix_rel2;
%        Fitness=Fitness2;
%        for nn=1:numel(del) 
%           voltVec{del(nn)}=[];  
%           mechs{del(nn)}=[];    
%        end
%     
%        save(sprintf('Sample_%d_%s',counter1,names{counter0}),'Matrix_rel','Fitness','mechs','voltVec');
%        save(sprintf('Sample_timeconstant_statistic'),'perc_valid','num_valid','names');
%        clear voltVec mechs Matrix_rel Fitness
%    end
% end
% 
% perc_mean=mean(perc_valid,2);
% save(sprintf('Sample_timeconstant_statistic'),'perc_valid','num_valid','names','perc_mean');
% 
% 
% find( min(max(max(Matrix_rel(:,:,:))))==max(max(Matrix_rel(:,:,:))))
% 
% Fitness(find( min(max(max(Matrix_rel(:,:,:))))==max(max(Matrix_rel(:,:,:)))) )
% Matrix_rel(:,:,find( min(max(max(Matrix_rel(:,:,:))))==max(max(Matrix_rel(:,:,:)))) )
% 
% mechs_best{length(voltVec_best)+1}=mechs{ find( min(max(max(Matrix_rel(:,:,:))))==max(max(Matrix_rel(:,:,:)))) }
% Fitness_best{length(voltVec_best)+1}=Fitness( find( min(max(max(Matrix_rel(:,:,:))))==max(max(Matrix_rel(:,:,:)))) )
% Matrix_rel_best(:,:,length(voltVec_best)+1)=Matrix_rel(:,:, find( min(max(max(Matrix_rel(:,:,:))))==max(max(Matrix_rel(:,:,:)))) )
% voltVec_best{length(voltVec_best)+1}=voltVec{ find( min(max(max(Matrix_rel(:,:,:))))==max(max(Matrix_rel(:,:,:)))) }
% save(fullfile(sprintf('Scan_newchan_timeconstant_3_Cav_0_BK_best2.mat')),'voltVec_best','mech_best','Fitness_best','Matrix_rel_best');
