function [amp, Vrest] = t2n_findCurr(neuron,tree,desv,amp,options)
% This function finds the current necessary to keep the neurons defined in
% "neuron" and "tree" at a desired voltage or alternatively finds the
% spiking threshold.
% 
% INPUTS
% neuron            t2n neuron structure with already defined mechanisms (see documentation)
% tree              tree cell array with morphologies (see documentation)
% desv              desired voltage (mV) or 'spike' if spiking threshold is searched
% amp               (optional) starting values of the current amplitudes (one for each
%                   neuron defined in tree)
% options           (optional) options for starting T2N (see t2n)
%
% OUTPUTS
% amp               current amplitude for each neuron to reach the desired voltage/spike
% Vrest             resting potential of each cell
%
%
% *****************************************************************************************************
% * This function is part of the T2N software package.                                                *
% * Copyright 2016, 2017 Marcel Beining <marcel.beining@gmail.com>                                    *
% *****************************************************************************************************

if nargin < 5
    options = '-q-d';
end
if nargin < 5 || isempty(amp)
    amp = zeros(numel(neuron),1);
end
counterthresh = 20;
for n=1:length(neuron) 
    if ischar(desv) && strcmpi(desv,'Spike')
        e = 0.0005; %nA allowed difference to find spiking thresh
        neuron{n}.params.dt = 1;
        neuron{n}.params.tstop = 500;
    else
        e = 0.2; % mV allowed difference between target voltage and actual voltage
        neuron{n}.params.dt = 10;
        neuron{n}.params.tstop = 2000;
    end
    step = 0.05;

    neuron{n}.params.cvode = 0;

    ready = zeros(numel(neuron),1);
    maxamp = NaN(numel(neuron),2) ;
    minamp = NaN(numel(neuron),2) ;

    flag = false;
    ostep = zeros(numel(neuron),1);
    counter = 0;
    Vrest = NaN(numel(neuron),1);
    sflag = ones(numel(neuron),1);
    if isfield(neuron{n},'con')
        neuron{n} = rmfield(neuron{n},'con'); % delete all connections since this is not desired here
    end
    if isfield(neuron{n},'play')
        neuron{n} = rmfield(neuron{n},'play'); % delete all play vectors since this is not desired here
    end
    if isfield(neuron{n},'pp')
        neuron{n} = rmfield(neuron{n},'pp'); % delete all point processes since this is not desired here
    end
end
treeind = 1:numel(neuron);

while ~flag && counter <= counterthresh
    counter = counter +1;

    for n = 1:numel(neuron)
        if ~isfield(tree{1},'artificial')
            neuron{n}.record{1}.cell = struct('node',1,'record','v');%;recnode,'ik_Kir';recnode,'gka_ichan3';recnode,'i_pas'};
            neuron{n}.pp{1}.IClamp = struct('node',1,'del',0,'dur',2000,'amp', amp(treeind(n))); %n,del,dur,amp
            neuron{n}.APCount{1} = [1,-20];
        else
            ready(treeind(n)) = true;
        end
    end
    [out] = t2n(neuron,tree,options);

    for n = 1:numel(neuron)
        if ~isfield(tree{1},'artificial')
            
            thisv = out{n}.record{1}.cell.v{1}(end);
            
            maxv = max(out{n}.record{1}.cell.v{1});
            if maxv > -40 || ~isempty(out{n}.APCtimes{1}{1})  % spike
                maxamp(treeind(n),:) = [amp(treeind(n)) maxv];
                if ischar(desv) && strcmpi(desv,'Spike')
                    if isnan(minamp(treeind(n)))
                        ostep(treeind(n)) = -step;
                        amp(treeind(n)) = amp(treeind(n)) + ostep(treeind(n));
                    elseif abs(minamp(treeind(n),1)-maxamp(treeind(n),1)) < e
                        ready(treeind(n)) = true;
                        if all(ready)
                            flag = true;
                        end
                    else
                        amp(treeind(n)) = (maxamp(treeind(n),1)-minamp(treeind(n),1))/2 + minamp(treeind(n),1);
                    end
%                     fprintf('Reached Spike of spike\n');
                else
                    if counter == 1 || sflag(treeind(n))
                        amp(treeind(n)) = amp(treeind(n)) - step;
                    else
                        ostep(treeind(n)) = ostep(treeind(n)) / 2;
                        amp(treeind(n)) = amp(treeind(n)) - ostep(treeind(n));
                    end
%                     fprintf('Reached Voltage: Spike\n');
                end
                continue
                
            end
            if counter == 1
                Vrest(treeind(n)) = mean(thisv);
            end
            sflag(treeind(n)) = 0;
%              fprintf('Reached Voltage: %2.1f, ',out.record{t}.cell.v{1}(end));
            if ischar(desv) && strcmpi(desv,'Spike')
                if isnan(maxamp(treeind(n))) || isnan(minamp(treeind(n)))
                    if isnan(minamp(treeind(n)))
                        minamp(treeind(n),:) = [amp(treeind(n)) thisv];
                    end
                    ostep(treeind(n)) = +step;
                    amp(treeind(n)) = amp(treeind(n)) + ostep(treeind(n));
                elseif maxamp(treeind(n),2) > -40 && abs(minamp(treeind(n),1)-maxamp(treeind(n))) < e
                    ready(treeind(n)) = true;
                    if all(ready)
                        flag = true;
                    end
                else
                    minamp(treeind(n),:) = [amp(treeind(n)) thisv];
                    amp(treeind(n)) = (maxamp(treeind(n))-minamp(treeind(n)))/2 + minamp(treeind(n));
                end
                
            else
               
                if abs(thisv - desv) <= e
                    ready(treeind(n)) = true;
                    if all(ready)
                        flag = true;
                    end
                else
                    if isnan(maxamp(treeind(n))) || isnan(minamp(treeind(n)))
                        if desv < thisv
                            maxamp(treeind(n),:) = [amp(treeind(n)) thisv];
                        else
                            minamp(treeind(n),:) = [amp(treeind(n)) thisv];
                        end
                        if isnan(maxamp(treeind(n))) || isnan(minamp(treeind(n)))
                            ostep(treeind(n)) = sign(desv-thisv)*step;
                            amp(treeind(n)) = amp(treeind(n)) + ostep(treeind(n));
                        else
                            amp(treeind(n)) = (maxamp(treeind(n),1)-minamp(treeind(n),1))/2 + minamp(treeind(n),1);
                            
                        end
                    else
                        if desv < thisv
                            maxamp(treeind(n),:) = [amp(treeind(n)) thisv];
                        else
                            minamp(treeind(n),:) = [amp(treeind(n)) thisv];
                            
                        end
                        amp(treeind(n)) = (maxamp(treeind(n))-minamp(treeind(n)))/2 + minamp(treeind(n));
                    end
                end
            end
        end
%         if ischar(desv) && strcmpi(desv,'Spike')
%             fprintf(' of spike\n');
%         else
% %             fprintf(' of target voltage %g mV\n',desv);
%         end
    end
    
    [~,~,ib] = intersect(find(ready),treeind);
%     neuron{n}.mech(ib) = [];
%     neuron{n}.record(ib) = [];
%     neuron{n}.pp(ib) = [];
%     neuron{n}.APCount(ib) = [];
    treeind(ib) = [];
    neuron(ib) = [];

end
if counter > counterthresh
%     warndlg('Not all target voltages could be reached! Check!')
end
