function [voltVec, timeVec,mechs] = IClamp_Mongiat(neuron_orig, tree)

neuron=neuron_orig;

ostruct.duration = 200;  % standard duration 200 ms

ostruct.numAP = 0;
ostruct.spikeThresh = -10;  % std spike thresh of -10 mV
ostruct.amp = [50,90]/1000;  % standard current steps 0-90 pA
ostruct.delay = 55.5;  % standard current steps 0-90 pA


for n=1:numel(neuron)
    if n<=size(neuron,2)
    neuron{n}.params.tstop =350; %350;    %55.5+ostruct.delay+ostruct.duration;
    neuron{n}.params.nseg = 1;
    for t=1:numel(tree)
        neuron{n}.APCount{t} = [1,ostruct.spikeThresh];
    end
    neuron{n}.params.dt=0.05;
    neuron{n}.params.cvode=0;
    neuron{n}.params.nseg = 'Each 20';
    neuron{n}.params.prerun=200;    
    end
end

hstep(:) = t2n_findCurr_fast(neuron,tree,-80,[],'-q');

for n=1:numel(neuron)
    if n<=size(neuron,2)
        for s = 1:numel(ostruct.amp)
                neuronn{s+(n-1)*numel(ostruct.amp)} = neuron{n};
            for t = 1:numel(tree)
                neuronn{s+(n-1)*numel(ostruct.amp)}.pp{t}.IClamp = struct('node',1,'times',[-100,ostruct.delay,ostruct.delay+ostruct.duration],'amp', [hstep(t,n) hstep(t,n)+ostruct.amp(s) hstep(t,n)]); %n,del,dur,amp
                neuronn{s+(n-1)*numel(ostruct.amp)}.record{t}.cell = struct('node',1,'record','v');
            end    
        end
    end
end

out = t2n(neuronn,tree,'-q'); % run simulations

numspikes = zeros(numel(tree),numel(ostruct.amp));
voltVec = cell(numel(tree),numel(neuron_orig));
timeVec = voltVec;

for s = 1:numel(neuron)
    for t = 1:numel(ostruct.amp)
        voltVec{s}{t} = out{(s-1)*numel(ostruct.amp)+t}.record{1}.cell.v{1} ;
        timeVec = out{(s-1)*numel(ostruct.amp)+t}.t;        
    end
    mechs{s}=neuron{s}.mech{1};
end

end