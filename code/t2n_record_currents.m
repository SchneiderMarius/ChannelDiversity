function [data] = t2n_record_currents(tree,neuron,ions)

%%
%Einheiten: Current [mA/cm^2] * Surf [um^2] = [10*-3 / 10^-4] *[10^-12] A
% = [10^-11] A = 10^-2 nA = 10 pA

regions = tree{1}.rnames;
surface_tree = surf_tree(tree{1});

%n = 1;

channel = [];
for counter = 1 : numel(regions)
    % check for channels in Model
    channel = [channel; fieldnames(neuron.mech{1}.(regions{counter})) ]  
end

channel = unique(channel);
channel_tag = cell(length(channel),1);

for counter = 1 : numel(channel)
    
    % find corresponding nodes for each channel
    nodes{counter} = [];
    for counter2 = 1 : numel(regions)
        if any(strcmp(channel(counter),  fieldnames(neuron.mech{1}.(regions{counter2})))) 
           nodes{counter} =  [nodes{counter}; find(find(strcmp(tree{1}.rnames,regions{counter2}))==tree{1}.R)];
        end
    end
    nodes{counter} = sort(nodes{counter});
    %ion specific tag
    for counter2 = 1 : numel(ions)
        if ~isempty(strfind(channel{counter},ions{counter2}))
            channel_tag{counter,1} = sprintf('i%s_%s',lower(ions{counter2}),channel{counter});
        end
    end
    
    %ion-unspecific channels (e.g. pas)
    if isempty(channel_tag{counter})
       channel_tag{counter,1} = sprintf('i_%s',channel{counter});
    end
end

nodes2 = [1,nodes]


      

% scan different Models
timeVec = [];
voltVec = [];

neuron.params.dt=0.05; 
neuron.params.nseg = 'Each 1'
neuron.params.accuracy=1;
hstep = t2n_findCurr(neuron,tree,-80,[],'-q-d');
ostruct.duration = 200;  
neuron.params.tstop = 250+ostruct.duration;
ostruct.delay = 55.5;
ostruct.amp = 90/1000;  
neuron.pp{1}.IClamp = struct('node',1,'times',[-100,ostruct.delay,ostruct.delay+ostruct.duration],'amp', [hstep(1) hstep(1)+ostruct.amp hstep(1)]);
neuron.record{1}.cell = struct('node',[1,nodes],'record',['v',channel_tag']);
out = t2n(neuron,tree,'-q-d-w'); % run simulations

timeVec = out.t;
voltVec = out.record{1}.cell.v{1};

% translate Neuron segmentetion to trees structure and calc surface
for counter2=1:numel(nodes{find(strcmp(channel,'pas'))})
    current_pas(:,counter2) = out.record{1}.cell.(channel_tag{find(strcmp(channel,'pas'))}){nodes{find(strcmp(channel,'pas'))}(counter2)};%*surface_tree(nodes{counter2}(counter3));  % {chans{1,2}{1}(i)};
end

[Au,ia,ic] = unique(current_pas', 'rows', 'stable');

for counter2 = 1 : numel(ia)
    nodes_surf(counter2) = sum(surface_tree(find(ic==counter2)));
end

current_out = [];
current_in = [];
channel_in = [];
channel_out = [];
current_out_rel = [];
current_in_rel = [];
%read out currents and multiply with surface of nodes & divide into outward and inward current 
for counter2 = 1 : numel(channel)
    n = 1;
    for counter3=1:numel(nodes{counter2})
        if any(nodes{counter2}(counter3)==ia)
            current_vec{counter2}(:,n) = out.record{1}.cell.(channel_tag{counter2}){nodes{counter2}(counter3)}*nodes_surf(find(nodes{counter2}(counter3)==ia));                
            n=n+1;
        end
    end
    current_total(:,counter2) = sum(current_vec{counter2},2);

   if any(any(current_total(:,counter2)<0))
      current_in = [current_in, current_total(:,counter2)];
      channel_in = [channel_in,channel(counter2)];           
   end
   current_in(current_in > 0) = 0;

   if any(any(current_total(:,counter2)>0))
      current_out = [current_out, current_total(:,counter2)];
      channel_out = [channel_out,channel(counter2)];
   end
   current_out(current_out < 0) = 0;
end
current_in_total = sum(current_in,2);
current_out_total = sum(current_out,2);
current_out_rel = current_out ./ sum(current_out,2)  *100 ;
current_in_rel  = - current_in ./ sum(current_in,2)  *100 ;


data.current_out = current_out;
data.current_in = current_in;
data.current_out_rel = current_out_rel;
data.current_in_rel = current_in_rel;
data.channel_out = channel_out;
data.channel_in = channel_in;
data.voltVec = voltVec;
data.timeVec = timeVec;
data.current_total = current_total;

%save('123', 'current_out','current_in','current_out_rel','current_in_rel','channel_out','channel_in','voltVec','timeVec')


id  = find(strcmp(data.channel_in,'na8st'));
ATP = sum(data.current_in(id))*(1/3)*(10^-9)*(6.242*10^18);




end