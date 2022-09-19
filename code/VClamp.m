function [currVec,steadyStateCurrVec] = VClamp(neuron,tree,vstepsModel,dur,holding_voltage)
% This function performs one or multiple voltage steps (in the squared
% pulse format, i.e. voltage step is surrounded by step to the baseline
% potential) in the cells given by "tree" and "neuron" and saves the 
% results in a mat file named according to neuron.experiment for later analysis.
%
% INPUTS
% neuron            t2n neuron structure with already defined mechanisms
% tree              tree cell array with morphologies
% vstepsModel       vector with voltages [mV] that will be held
% dur               duration time period of voltage step [ms]. Can be a 1x3
%                   vector which then includes the pre and post step 
%                   duration at which the cell is held at the holding 
%                   potential, or a scalar with only the step duration and 
%                   pre/post being set to 100 ms
% holding_voltage   potential [mV] at which cell is held before and after 
%                   the voltage step
% targetfolder_data destination of temporary results file
%
% OUTPUTS
% currVec           cell array of vectors containing the simulation time 
%                   vector and the measured current during the simulation 
%                   for each cell (first dim) and voltage step (second dim)
% out               the direct output structure of t2n, necessary for some
%                   other t2n functions
% 
% *****************************************************************************************************
% * This function is part of the T2N software package.                                                *
% * Copyright 2016, 2017 Marcel Beining <marcel.beining@gmail.com>                                    *
% *****************************************************************************************************


if ~exist('holding_voltage','var')
    holding_voltage = -80;
end
if numel(holding_voltage) < 2
    holding_voltage = repmat(holding_voltage,1,2);
end
if ~exist('dur','var')
    dur = [100 100 100];
elseif numel(dur) == 1
    dur = [100 dur 100];
end

elecnode = 1;

% neuron.params.tstop = sum(dur);


% nneuron = cell(numel(vstepsModel),1);
% nneuron{1} = neuron;

for n=1:numel(neuron)
    if n<=size(neuron,2)
        for s = 1:numel(vstepsModel)
                amp = cat(2,holding_voltage(1), vstepsModel(s), holding_voltage(2));
                neuronn{s+(n-1)*numel(vstepsModel)} = neuron{n};
                neuronn{s+(n-1)*numel(vstepsModel)}.params.tstop = sum(dur);

            for t = 1:numel(tree)
                neuronn{s+(n-1)*numel(vstepsModel)}.pp{t}.SEClamp = struct('node',elecnode,'rs',15,'dur', dur,'amp', amp);
                neuronn{s+(n-1)*numel(vstepsModel)}.record{t}.SEClamp = struct('record','i','node',elecnode);
            end    
        end
    end
end 


% for s = 1:numel(vstepsModel)
%     amp = cat(2,holding_voltage(1), vstepsModel(s), holding_voltage(2));
%     for t = 1:numel(tree)
%         nneuron{s}.pp{t}.SEClamp = struct('node',elecnode,'rs',15,'dur', dur,'amp', amp);
%         if s == 1
%             nneuron{s}.record{t}.SEClamp = struct('record','i','node',elecnode);
%         end
%     end
% end
neuronn = t2n_as(1,neuronn);
out = t2n(neuronn,tree,'-q-w');
if any(cellfun(@(x) x.error,out(cellfun(@(x) isfield(x,'error'),out))))
    return
end

for s = 1:numel(neuron)
    for t = 1:numel(vstepsModel)
        steadyStateCurrVec(t,s) =  mean(out{(s-1)*numel(vstepsModel)+t}.record{1}.SEClamp.i{1}(find(out{s}.t>=dur(1)+dur(2)*0.9,1,'first'):find(out{(s-1)*numel(vstepsModel)+t}.t<sum(dur(1:2)),1,'last')) *1000); % get steady state voltage (electrode current at 90-100% of step duration)
        currVec{t,s} =  [out{(s-1)*numel(vstepsModel)+t}.t';out{(s-1)*numel(vstepsModel)+t}.record{1}.SEClamp.i{1}' *1000];
%         voltVec{s}{t} = out{(s-1)*numel(vstepsModel)+t}.record{1}.cell.v{1} ;
%         timeVec= out{(s-1)*numel(ostruct.amp)+t}.t;        
    end
%     mechs{s}=neuron{s}.mech{1};
end

% for s = 1:numel(vstepsModel)
%     for t = 1:numel(tree)
%         steadyStateCurrVec(s,t) =  mean(out{s}.record{t}.SEClamp.i{1}(find(out{s}.t>=dur(1)+dur(2)*0.9,1,'first'):find(out{s}.t<sum(dur(1:2)),1,'last')) *1000); % get steady state voltage (electrode current at 90-100% of step duration)
%         currVec{t,s} =  [out{s}.t';out{s}.record{t}.SEClamp.i{1}' *1000];
%     end
% end
% if nargout == 0
%     save(fullfile(targetfolder_data,sprintf('Exp_VoltSteps_%s.mat',neuron.experiment)),'dur','mholding_current','neuron','holding_voltage','steadyStateCurrVec','currVec','vstepsModel','tree')
% end