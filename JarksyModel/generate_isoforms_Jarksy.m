function [neuron,channame,chanvalue] = generate_isoforms_2(neuron_orig,tree,channels,num,compile)

neuron = neuron_orig;


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




for counter = 1 : size(channame,1)
    S = dir('s*.*');
    
    inputFiles = dir(fullfile(pwd,'lib_mech',sprintf('%s*.mod',channame{counter,1})));
    filename = struct2cell(inputFiles);
%     fileNames = { filename{1} };
    
    
    if contains(channame(counter,2),'extra')
            neuron.mech{1}.(channame{counter,1}).(channame{counter,3})...
                =  neuron.mech{1}.(channame{counter,1}).(channame{counter,3})/(num+1);        
    else
            neuron.mech{1}.(channame{counter,2}).(channame{counter,1}).(channame{counter,3})...
                =  neuron.mech{1}.(channame{counter,2}).(channame{counter,1}).(channame{counter,3})/(num+1);
    end
    
    
    
    
%     neuron.mech{1}.(channame{counter,2}).(channame{counter,1}).(channame{counter,3}) = ...
%         neuron.mech{1}.(channame{counter,2}).(channame{counter,1}).(channame{counter,3})/(num+1);
%     
    for counter1 = 1 : num
      if compile == 1
          
            outputBaseFileName = sprintf('%s_%d.mod', filename{1}(1:end-4),counter1);
           if ~isfile(fullfile(pwd,'mods', outputBaseFileName))

                outputFullFileName = fullfile(pwd,'lib_mech', outputBaseFileName);
                inputFullFileName = fullfile(pwd,'lib_mech', filename{1});   
                copyfile( inputFullFileName, outputFullFileName);
                fid = fopen(outputFullFileName,'rt') ;
                X = fread(fid) ;
                fclose(fid) ;
                X = char(X.') ;
                % replace string S1 with string S2
                Y = strrep(X, channame{counter,1}, sprintf('%s_%d', filename{1}(1:end-4),counter1)) ;
                fid2 = fopen(outputFullFileName,'wt') ;
                fwrite(fid2,Y) ;
                fclose (fid2) ;
           end
      end
        %neuron.mech{1}.(channame{counter,2}).(sprintf('%s_%d', inputFiles.name(1:end-4),counter1))   
        %sprintf('%s_%d', inputFiles.name(1:end-4),counter1)
        
        % CHANGE !!!
%         neuron.mech{1}.(channame{counter,2}) = setfield(neuron.mech{1}.(channame{counter,2}),sprintf('%s_%d', filename{1}(1:end-4),counter1),neuron.mech{1}.(channame{counter,2}).(channame{counter,1}));
    
    if contains(channame(counter,2),'extra')
%             neuron.mech{1} = setfield(neuron.mech{1},sprintf('%s_%d', channame{counter,1},counter1),neuron.mech{1}.(channame{counter,1}));
            neuron.mech{1} = setfield(neuron.mech{1},sprintf('%s_%d',  filename{1}(1:end-4),counter1),neuron.mech{1}.(channame{counter,1}));
    else
%             neuron.mech{1}.(channame{counter,2}) = setfield(neuron.mech{1}.(channame{counter,2}),sprintf('%s_%d', channame{counter,1},counter1),neuron.mech{1}.(channame{counter,2}).(channame{counter,1}));
            neuron.mech{1}.(channame{counter,2}) = setfield(neuron.mech{1}.(channame{counter,2}),sprintf('%s_%d', filename{1}(1:end-4),counter1),neuron.mech{1}.(channame{counter,2}).(channame{counter,1}));

    end        
        
        
%         if strcmp(channame{counter,2},regions(3))
%             for counter2 = 4 : numel(regions)
%                 neuron.mech{1}.(regions{counter2}) = ...
%                 setfield(neuron.mech{1}.(channame{counter,2}),sprintf('%s_%d', filename{1}(1:end-4),counter1),neuron.mech{1}.(channame{counter,2}).(channame{counter,1}));
%             end
%         end
    end
end


if compile == 1
    [out, origminterf,tree] = t2n(neuron,tree,'-m')
end

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



use = [];
del = 1:size(channame,1)';
if strcmp(channels,'all')
     del = find(chanval==0);    
%     del = [find(chanval==0); find(strcmp('Kir21',channame(:,1)))];
elseif strcmp(channels,'nona8st')
     del = [find(chanval==0); find(strcmp('Kir21',channame(:,1))); find(strcmp('na8st',channame(:,1)))];
elseif ischar(channels) && ~ strcmp(channels,'nona8st')
     use = find(strcmp(channame(:,1),channels));
     del(use) = [];     
%      del=[find(chanval==0); del];
else   
    for counter = 1:numel(channels)
        use = [use ;find(strcmp(channame(:,1),channels(counter)))];
    end
    del(use) = [];
    del=[find(chanval==0); del];
end


channame(del,:) = [];
chanvalue(del,:) = [];


end