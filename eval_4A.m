clear all
cd code
folder = fullfile(cd,'data')

params.channum = 5;
[neuron_orig, tree, ~,~] = Init_GC_mature(params);
neuron_orig.params.cvode=0;
rng('shuffle');

%%
samp_size = 200;
Mod(1,:) = [1:18];
Mod(2,:) = [1:18];

for counter0=1:size(Mod,2)
    % change 2021
    %load(fullfile(folder,sprintf('Stoch_sample200_%dBK_%dCav22',Mod(1,counter0),Mod(2,counter0))))
    base=load(fullfile(folder,'Fig3AB',sprintf('Scan_newchan_timeconstant_%dBK_%dCav22_best',Mod(1,counter0),Mod(2,counter0))));

    for counter11 = 1 : 2%numel(base.mech_best)    
        tic
        neuron_orig.mech{1}=base.mech_best{counter11};
        [neuron, chanvalue{counter11}, channame] = randomize_Conductance(neuron_orig,2,samp_size);
        [volt{counter11},timeVec,mechs{counter11}]=IClamp_Mongiat(neuron,tree);
        [Matrix{counter11},Matrix_rel{counter11},Fitness(counter11,:)] = Fitness_Mongiat(volt{counter11},timeVec);     
        statistic(counter0,counter11)=sum(Fitness(counter11,:)<2)/samp_size;
        toc
    end
    save(fullfile(folder,'Fig3AB',sprintf('Stoch_sample200_%dBK_%dCav22',counter0-1,counter0-1)),'chanvalue','channame','mechs','volt','timeVec','Matrix','Matrix_rel','Pareto_sample');
    clear chanvalue channame mechs volt timeVec Matrix Matrix_rel Fitness Pareto_sample
end
save(fullfile(folder,'Fig3A_Stoch_sample200_statistcs'),'statistic','Mod')


% Set up fittype and options.
ft = fittype( 'a/(1+exp(-b*(x+c)))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.1798 0.4841 -4.393];

for top=1:6
    figure
    hold all
    for counter=1:19
       [temp ind{counter}]= sort(statistic(counter,:),2,'descend')
       statistc_best{top}(counter,1:top) = sort(statistic(counter,ind{counter}(1:top)));
       p=plot( ones(top)*(counter-1)*2,statistc_best{top}(counter,1:top)*100,'.k','Markersize',20)
    end
     [fitresult{top}, gof{top}] = fit( [0:18]'*2, mean(statistc_best{top},2)*100, ft, opts );

    p=plot(fitresult{top})
    p(1).MarkerSize = 20;

    xlabel('Number of added channels')
    ylabel('Percentage of valid models')
    xlim([0 39])
    set(gca,'Fontsize',20,'Linewidth',1.5,'Tickdir','out')
    saveas(p,fullfile(folder,'plots',sprintf('Fig5_expanddiv_statistics_sample_%d.pdf',top)),'pdf')
    saveas(p,fullfile(folder,'plots',sprintf('Fig5_expanddiv_statistics_%d.jpg',top)),'jpg')
    savefig(fullfile(folder,'plots',sprintf('Fig5_expanddiv_statistics_%d.fig',top)))
    close all
end

%% PLOT expanddiv & exoanddiv_nona8st

folder = 'C:\Users\Marius Schneider\Desktop\Masterthesis\Masterthesis_data\3_Results\3_5_increase_diversity\data'

data=load(fullfile(folder,'Stoch_sample200_statistcs'))
datanona8st=load(fullfile(folder,'stochastic_sample100_statistcs_nona8st'))


ft = fittype( 'a/(1+exp(-b*(x+c)))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.1798 0.4841 -4.393];

steps= [4:4:24];

for top=1:6
    figure
    hold all
    
    for counter=1:size(datanona8st.statistic,1)
       [temp ind]= sort(datanona8st.statistic(counter,:),2,'descend')
       statistc_best_no{top}(counter,1:top) = sort(datanona8st.statistic(counter,ind(1:top)));
       p=plot( steps(counter),statistc_best_no{top}(counter,1:top)*100,'.b','Markersize',20)
    end
    
    for counter=1:size(data.statistic,1)
       [temp ind]= sort(data.statistic(counter,:),2,'descend')
       statistc_best{top}(counter,1:top) = sort(data.statistic(counter,ind(1:top)));
       p=plot( ones(top)*(counter-1)*2,statistc_best{top}(counter,1:top)*100,'.k','Markersize',20)
    end
    
    [fitresult{top}, gof{top}] = fit( [0:18]'*2, mean(statistc_best{top},2)*100, ft, opts );
    [fitresult_no{top}, gof_no{top}] = fit( [[4:4:24],1)-1]'*2, mean(statistc_best_no{top},2)*100, ft, opts );

    p=plot(fitresult{top})
    p=plot(fitresult_no{top})

    p(1).MarkerSize = 20;

    xlabel('Number of added channels')
    ylabel('Percentage of valid models')
    xlim([0 39])
    set(gca,'Fontsize',20,'Linewidth',1.5,'Tickdir','out')
%     saveas(p,fullfile(folder,'plots',sprintf('Fig5_expanddiv_statistics_sample_%d.pdf',top)),'pdf')
%     saveas(p,fullfile(folder,'plots',sprintf('Fig5_expanddiv_statistics_%d.jpg',top)),'jpg')
%     savefig(fullfile(folder,'plots',sprintf('Fig5_expanddiv_statistics_%d.fig',top)))
%     close all
end