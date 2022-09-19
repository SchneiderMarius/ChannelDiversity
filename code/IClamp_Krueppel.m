function [Pareto, Matrix_rel, Matrix, voltVec,timeVec] = IClamp_Krueppel(neuron_orig, tree)

load(fullfile(pwd,'expdata','Exp_bAPproperties'));

% soma distance of test points from  Krueppel 2011 - Fig. 1 
dendist = [40 130];

for t = 1 : numel(tree)
    % select dendrite to test bAP
    id = 14;
    
    T = find(T_tree(tree{1}));
    eucl = eucl_tree(tree{1});
    dend = [];
    if eucl(T(id))>130
       dend = T(id); 
    end
    
    ipar = ipar_tree(tree{1});
    dend = ipar(dend,:);
    dend(dend==0) = []; nodes = [];
    for cnt = 1 : length(dendist)
        nodes(cnt) = dend(find(round(eucl(dend)) ==dendist(cnt),1));
    end
    nodes = [1 nodes];   
end

params.celsius = 33;  % temperature
ostruct.amp = [1700]/1000;  % standard current steps 0-90 pA
ostruct.duration = 2.5;  %2.25 ms current buzz
ostruct.spikeThresh = -10;  % std spike thresh of -10 mV
ostruct.delay = 30;

for n=1:numel(neuron_orig)
    neuron{n} = t2n_Q10pas(neuron_orig{n},params.celsius);
    neuron{n}.params.v_init = -85.4;
    neuron{n}.params.accuracy = 1; % improve AIS segment number for more accurate simulation
    neuron{n}.delay = 30;                
    neuron{n}.params.tstop =350; %350;    %55.5+ostruct.delay+ostruct.duration;
    neuron{n}.params.nseg = 1;
    for t=1:numel(tree)
        neuron{n}.APCount{t} = [1,ostruct.spikeThresh];
    end
    neuron{n}.params.dt=0.025;
    neuron{n}.params.cvode=0;
    neuron{n}.params.nseg = 1; %'Each 20';
    neuron{n}.params.prerun = 200;%200;    
end

hstep(:) = t2n_findCurr_fast(neuron,tree,-85.4,[],'-q');

for n=1:numel(neuron)
    if n<=size(neuron,2)
        for s = 1:numel(ostruct.amp)
                neuronn{s+(n-1)*numel(ostruct.amp)} = neuron{n};
            for t = 1:numel(tree)
                neuronn{s+(n-1)*numel(ostruct.amp)}.pp{t}.IClamp = struct('node',1,'times',[-200,ostruct.delay, ostruct.delay+ostruct.duration],'amp', [hstep(t,n) hstep(t,n)+ostruct.amp(s) hstep(t,n)]); %n,del,dur,amp
                neuronn{s+(n-1)*numel(ostruct.amp)}.record{t}.cell = struct('node',nodes,'record','v');
            end    
        end
    end
end

out = t2n(neuronn,tree,'-q'); % run simulations

numspikes = zeros(numel(tree),numel(ostruct.amp));
voltVec = cell(numel(tree),numel(neuron_orig));

for s = 1:numel(neuron)
        timeVec = out{s}.t;
        voltVec{s} = zeros(length(out{s}.t),numel(nodes));

        for cnt = 1 : length(nodes)
            %     subplot(3,1,cnt)
            voltVec{s}(:,cnt) = out{s}.record{1}.cell.v{nodes(cnt)};
            if cnt==1
               [v, id(cnt)] = max(voltVec{s}(:,cnt));
                Apt = timeVec(id);
            elseif cnt==2
                [val id(cnt)] = max(voltVec{s}(:,cnt));        
                Matrix(1,s) = max(voltVec{s}(:,cnt))-min(voltVec{s}(:,cnt));
                Matrix(3,s)= timeVec(id(2))-timeVec(id(1));      
            elseif cnt==3
                [val id(cnt)] = max(voltVec{s}(:,cnt));
                Matrix(2,s) = max(voltVec{s}(:,cnt))- min(voltVec{s}(:,cnt)) ;
                Matrix(4,s) = timeVec(id(3))-timeVec(id(1));
            end
        end
    Matrix_rel(:,s) = abs(Matrix(:,s)-Matrixexp)./Matrixexp_std;

end
    
Pareto = max(Matrix_rel);

end