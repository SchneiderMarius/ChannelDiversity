function[neuron, tree, channame,chanvalue] = Init_GC_mature(params,sample_not)
    
    if nargin<2
       sample_not = ''; 
    end

    if isfield(params,'channum')
        mech = load(fullfile(pwd,'data',sprintf('GC_%dchannels',params.channum)));
    else
        mech = load(fullfile(pwd,'data','GC_15channels'));
    end

    ostruct = struct('plot','auto','show',3,'legend',0,'marker','o','sem',1,'FontSize',10,'FontType','Arial','barwidth',0.3,'figurewidth',8,'figureheight',5,'LineWidth',1,'grid',0,'priority','plot','ticklength',0.015);  % some options that are used when something is plotted
    ostruct.usecol = 1;  % 0 = pseudorandom colors for each simulated cell in graph, 1 = green or blue grading


    % change biophysical model here
    ostruct.vmodel = 1; % 0 = passive model, > 0 = active model, everything else (e.g. NaN) = old AH99 model %1. Beining 2.Marius
    ostruct.changeAHion = 0;  % only important when using the AH99 model. Boolean to decide if standard AH99 ion reversal potentials are used (0) or if they are adjusted to the experiments (1)

    % change morphologies here
    ostruct.usemorph = 1;  % 1 = all SH07, 2= synth mouseMat, 3= synth mouseYoung 4= Beining (2016) AAV rat, 5 = synth ratOld 6= synth ratYoung 7 = Claiborne,
    ostruct.newborn = 0;  % 0 = adult GC model, 1 = young abGC model
    ostruct.cut=1;      %0=original Tree 1=Axon cut 2=Axonh cut
    ostruct.alltree=0;

    % more parameters
    ostruct.reducecells = 0;  % reduce number of cells for faster simulation (e.g. for testing)
    ostruct.scalespines = 1;  % scaling of g_pas and cm to implicitly model spines. is ignored in AH99 model, as this is already taken into account in the biophys model!
    ostruct.adjustloads = 0;  % the Hay et al 2013 implementation of adjust dendritic loads to reduce variability between cells (not used in publication)
    ostruct.noise = 0;       % add noise to the membrane voltage by injecting gaussian noise current to the soma (not working with variable dt / cvode)

    % do not change from here
    if ostruct.usemorph >= 4
        ostruct.ratadjust = 1;  % adjust Kir channel in rats
    else
        ostruct.ratadjust = 0;
    end

    %*****************************
    if ostruct.newborn
        ostruct.scalespines = 0.3 * ostruct.scalespines;  % means g_pas and cm are only scaled by 30% of the original spine densities due to reduced spine density in young abGCs
    end
    if ~exist(fullfile(pwd,'GC_initModel.m'),'file')
        error('It seems your current folder is not the GC model folder. Please change it')
    end
    % if ~exist(targetfolder_data,'file')
    %     mkdir(targetfolder_data)
    % end
    % if ~exist(targetfolder_results,'file')
    %     mkdir(targetfolder_results)
    % end
    [tree,neuron,treename] = GC_initModel(ostruct);  % initialize the model by loading the morphologies and setting the biophysical parameters
    if ostruct.newborn
        %     % this is the good FI,deep fAHP one...
        %     ostruct.channelblock = {'Kir21','Kv42','na8st','BK','Cav13','Kv21'};%,'Kv21','Kv42','Kv14','Kv34','na8st','Cav13'};%'Cav22'};     %{'Kv42','Kir21','Kv14','Kv34','pas','Kv21','na8st','Kv723'};%,'na8st','Kv723','na8st','Kv21'};%'except','Kir21'};%{'Kir','Kv42','HCN'};%'Kir','Kv42','Kv14','HCN'}; % Kir , SK etc
        %     ostruct.blockamount = [73,50,25,60,50,75];%68 kir %,100,80,80,50,55,100];%  Kv42 50 Kv21 70
        %      ostruct.specify = {'','','','','',''};

        %      % this is the used version
        oldexpname = neuron.experiment;
        neuron = t2n_blockchannel(neuron,{'Kir21','Kv42','na8st','BK','Cav13','Kv21','Kv723','BK'},[73,50,25,40,50,50,50,100],[],{'','','','gakbar','','','','gabkbar'});
        neuron.experiment = strcat(oldexpname,'_newborn');
        disp('young abGC version')
    end
    
    neuron.mech = mech.mech;
    neuron.experiment=sprintf('GC_%dchannels',params.channum);
    [chanvalue,channame] = channel_cond(neuron,sample_not);
end