%%
clear all

data_folder = fullfile(pwd,'code','data')
saveDir = fullfile(pwd,'figures','FigS3');

Models = [15, 8 ,5];

font  = 'Arial';
fonts = 6;
tickl = 1.25;
lwidth = 0.5;
tickl  = 0.025;
marks = 6;
sz = [3.5,3]


if ~exist(saveDir,'dir')
    mkdir(saveDir)
end    
[exp_iclamp,cstepsSpiking] = load_ephys(3,'CClamp');
[exp_vclamp,vsteps,rate] = load_ephys(3,'VClamp');
    
for counter=1:numel(Models)
     load(fullfile(data_folder,sprintf('FigS3_Pipeline_%d.mat',Models(counter))));
    
    % Trace
    figure
    hold all
    g3=plot(timeVec,voltVec{find(cstepsSpiking*1000==90)},'Color','k','Linewidth',lwidth)
    xlabel('Time [ms]')
    ylabel('Voltage [mV]')
    ylim([-90 80])
    xlim([0 350])   
    set(gcf, 'Position',  [680, 558, 340, 190])   
    set(gca,'FontName',font,'Fontsize',fonts,'TickDir','out','YTick',[-80:40:40],'XTick',[0:100:300],'Linewidth',lwidth,'Ticklength',[tickl tickl])
    set(gcf, 'Units', 'centimeters', 'Position', [2,2,sz], 'Renderer', 'painters');
    print(gcf,fullfile(saveDir,sprintf('%d_base_Trace.pdf',Models(counter))),'-dpdf') % then print it
    close all



    % F-I Plot
    figure
    hold all
    x = cstepsSpiking*1000;
    mFI = mean (squeeze((sum(diff(exp_iclamp > -10,1,1) == -1,1))));
    stdFI = std (squeeze((sum(diff(exp_iclamp > -10,1,1) == -1,1))));
    mFI = mFI(1:numel(x));
    stdFI= stdFI(1:numel(x));
    g4 = patch ([x (fliplr (x))], [(mFI + 2*stdFI) (fliplr (mFI - stdFI))],[0.8 0.8 0.8],'edgecolor','none' );
    g4 = plot(cstepsSpiking*1000,numspikes(:,1),'Color','k','Linewidth',lwidth)
    xlabel('Current step [pA]')
    ylabel('Number of APs')
    ylim([0 10])
    xlim([0 120])    
%     set(gcf, 'Position',  [680, 558, 200, 140]) 
    set(gca,'FontName',font,'Fontsize',fonts,'TickDir','out','YTick',[0:2:8],'XTick',[0:50:100],'Linewidth',lwidth,'Ticklength',[tickl tickl])
    set(gcf, 'Units', 'centimeters', 'Position', [2,2,sz], 'Renderer', 'painters');
    print(gcf,fullfile(saveDir,sprintf('%d_base_FI.pdf',Models(counter))),'-dpdf') % then print it
    close all    

%     saveas(g4,fullfile(plot_folder,sprintf('%s_base_FI.pdf',names{counter})),'jpg')
%     savefig(fullfile(plot_folder,sprintf('%s_base_FI.fig',names{counter})))
%     saveas(g4,fullfile(plot_folder,sprintf('%s_base_FI.pdf',names{counter})),'pdf')    
%     close all

    
    % I-V Plot  
    tvec = 1/rate:1/rate:size(exp_vclamp,1)/rate;
    meas_curr = squeeze(mean(exp_vclamp(194*rate+1:204*rate+1,:,:),1));
    basl = squeeze(mean(exp_vclamp(94*rate+1:104*rate+1,:,:),1));
    meas_curr = meas_curr - basl;
    mIV = mean(meas_curr,1);
    stdIV = std (meas_curr,1);
    figure
    hold all
    g1 = patch ([vsteps (fliplr (vsteps))], [(mIV + 2*stdIV) (fliplr (mIV - 2*stdIV))],[0.8 0.8 0.8],'edgecolor','none' );
    set(gca,'Linewidth',1.5)
    g1 = plot(vsteps,steadyStateCurrVec,'Linewidth',lwidth,'Color','k')
    xlim([-140 -60])
    ylim([-400 120])
    xlabel('Holding voltage [mV]')
    ylabel('Current [pA]') 
    set(gca,'FontName',font,'Fontsize',fonts,'TickDir','out','YTick',[-400 -200 0],'XTick',[-140:20:-60],'Linewidth',lwidth,'Ticklength',[tickl tickl])
    set(gcf, 'Units', 'centimeters', 'Position', [2,2,sz], 'Renderer', 'painters');
    print(gcf,fullfile(saveDir,sprintf('%d_base_IV.pdf',Models(counter))),'-dpdf') % then print it
    close all    

    %dV plot
    thisv = squeeze(voltVec_dV{1}{1});
    maxdv = max(diff(thisv,1,1))/0.025;
    ind = find(voltVec_dV{1}{1}>0,1,'first');  % find first AP
    thist = squeeze(timeVec_dV);
     if isempty(ind)
        ind =1;
        linstyl = '-';
    else
        ind = find(thist >= thist(ind)+5,1,'first'); % first spike should be finished within ~6ms
        linstyl = ':';
     end
    ff=figure
    hold all
    g6 = plot(thisv(2:ind),diff(thisv(1:ind),1,1)./0.025,'LineWidth',lwidth,'Color','k','LineStyle','--');
    g6 = plot(thisv(ind+1:end),diff(thisv(ind:end),1,1)./0.025,'LineWidth',lwidth,'Color','k','LineStyle','-');
    ylabel('Voltage change [mV/ms]')
    xlabel('Voltage [mV]')
    xlim([-80 80])
    ylim([-150 800])
    box off
    set(gca,'FontName',font,'Fontsize',fonts,'TickDir','out','XTick',-80:40:80,'YTick',0:400:800,'Linewidth',lwidth,'Ticklength',[tickl tickl])
    set(gcf, 'Units', 'centimeters', 'Position', [2,2,sz], 'Renderer', 'painters');
    print(gcf,fullfile(saveDir,sprintf('%d_base_dV.pdf',Models(counter))),'-dpdf') % then print it
    close all    

end





