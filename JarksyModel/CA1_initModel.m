%%
function [tree, neuron_orig] = CA1_initModel(num_tree,conv_tree);  % initialize the model by loading the morphologies and setting the biophysical parameters

%num_tree : Anzahl an Morphs
%conv_tree: 1 = transform to hoc

t2n_initModelfolders     (pwd);
tstop                    = 1100;%40000;
dt                       = 0.05;


neuron.params            = [];
neuron.params.celsius    = 35;
neuron.params.v_init     = -70;
neuron.params.prerun     = 200;
neuron.params.tstop      = tstop;
neuron.params.dt         = dt;
neuron.params.nseg       = 'd_lambda';

%% Load morphology
[tree, treeFilename, treepath] = load_tree ( ...
    './Morphos/hPCs_Jarsky.mtr');
tname                    = 'Jarsky_model';
neuron.params.exchfolder = 't2nexchange_Jarsky_model';
% to de-group the morphologies (if necessary), and have the different tree
% structures in the cell array 'tree':
if isstruct              (tree)
    tree                 = {tree};
elseif iscell            (tree{1})
    tree                 = tree{1};
end

if num_tree==1
    trees = tree{1}
    clear tree
    tree{1} = trees
    clear trees
end
% %% Divide the tree morphology (if it hasn't been divided before)
% for t                    = 1 : numel (tree)
%     % option j jarsky?, axon include axon
%     disp                (t)
%     tree{t}.R            = tree{t}.R * 0 + 2;
%     tree{t}.R (1)        = 1;
%     tree{t}.rnames       = {'soma', 'dendrite'};
%     tree{t}              = CA1pyramidalcell_sort_Jmodel_len (tree{t}, '-j');
% end

%% Convert the tree into NEURON

if conv_tree==1
    for t                    = 1 : numel (tree)
    if ~all (cellfun (@(x) isfield (x, 'NID'), tree)) || ...
            ~all (cellfun (@(x) exist (fullfile ( ...
            pwd, 'morphos', 'hocs', [x.NID, '.hoc']), 'file'), ...
            tree))
        answer           = questdlg ( ...
            ['Caution!', ...
            ' Not all of your trees have been transformed for NEURON yet!', ...
            ' Transforming now..'], ...
            'Transform tree', 'OK', 'Cancel', 'OK');
        % If I want to convert my tree into hoc, sort them first, and
        % then do it:
        if strcmp        (answer, 'OK')
            tree{t}      = sort_tree      (tree{t}, '-LO');
            % Tanslation of morphologies into hoc file:
            tree         = t2n_writeTrees (tree, ...
                tname, fullfile (treepath, treeFilename));
        end
    end
end
end
%% Add passive parameters
cm                       = 0.75;  % Membrane capacitance (uF/cm2)
Ra                       = 200;   % Cytoplasmic resistivity (ohm*cm)
Rm                       = 40000; % Membrane resistance (ohm/cm2) (uniform)
gpas                     = 1;
e_pas                    = -66;
cm_axonmyel              = 0.04;
Rm_axonnode              = 50;
for t                    = 1 : numel (tree)
    % do not scale spines:
    neuron.mech{t}.all.pas = struct ( ...
        'cm',                  cm,  ...
        'Ra',                  Ra,  ...
        'g',                   gpas / Rm,  ...
        'e',                   e_pas);
end

%% Add active mechanisms
% To get the regions that should be ranged:
% taken the regions from tree 1 because all of them have the same region
% definition:
treeregions              = tree{1}.rnames;
noregions                = ...
    {'soma', 'basal', 'hill', 'iseg', 'myelin', 'node'};
x                        = false (size (treeregions));
for r                    = 1 : numel (noregions)
    % <-- Flag the ones that noregions{r} matches:
    x                    = x | ...
        ~cellfun (@isempty, strfind (treeregions, noregions{r}));
end
treeregions (x)          = []; % <-- Delete all the flagged lines at once
% ********** Na conductance (gNabar)
nainfo.gbar              = 0.040;               % in S/cm2
nainfo.gnode             = 30.0;                % in S/cm2
nainfo.region            = treeregions;
% ********** Delayed rectifier K+ conducatnce (gKdr)
gkdr                     = 0.040;               % in S/cm2 (uniform)
% ********** A-type K+ channel proximal (gAKp) and distal (gAKd)
kainfo.gka               = 0.048;               % in S/cm2
kainfo.gka_ax            = kainfo.gka * 0.2;    % in S/cm2
kainfo.ek                = -77;
kainfo.region            = treeregions;
for t                    = 1 : numel (tree)
    % Distribution pf the channels that depend on path distance
    vec_gNa{t}           = range_conductanceNa (nainfo, tree{t}, ...
        '-wE'); % some option determining excitability
    vec_gKa{t}           = range_conductanceKa (kainfo, tree{t});
    neuron.mech{t}.range.nax = struct ( ...
        'gbar',                vec_gNa{t});
    neuron.mech{t}.all.nax = struct ( ...
        'gbar',                nainfo.gbar, ...
        'ena',                 55);
    neuron.mech{t}.all.kdr = struct ( ...
        'gkdrbar', gkdr, ...
        'ek',                  -77);
    neuron.mech{t}.kap   = struct ( ...
        'gkabar',              vec_gKa{t}.proximal);
    neuron.mech{t}.all.kap = struct ( ...
        'gkabar',              kainfo.gka, ...
        'ek',                  -77);
    neuron.mech{t}.range.kad = struct ( ...
        'gkabar',              vec_gKa{t}.distal);
    neuron.mech{t}.proxAp.kad = struct ( ...
        'gkabar',              kainfo.gka, ...
        'ek',                  -77);
    neuron.mech{t}.middleAp.kad = struct ( ...
        'gkabar',              kainfo.gka, ...
        'ek',                  -77);
    neuron.mech{t}.distalAp.kad = struct ( ...
        'gkabar',              kainfo.gka, ...
        'ek',                  -77);
    neuron.mech{t}.tuft.kad = struct ( ...
        'gkabar',              kainfo.gka, ...
        'ek',                  -77);
end
neuron_orig              = neuron;
end
