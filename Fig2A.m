
clear all
cd 'D:\Schneider2020_final_v2\code';
params.folder='D:\Schneider2020_final_v2\code';
Models = [15, 8 ,5];

font  = 'Arial';
fonts = 6;
tickl = 1.25;
lwidth = 0.5;
tickl  = 0.025;
marks = 6;
x_width = 3.45 ; y_width = 3;

c = {[27,158,119]/255;[217,95,2]/255;[117,112,179]/255};


region = {'axonh','soma',{'GCL','adendIML','adendMML','adendOML'}}

col = [0.7725,0.7725,0.7725];
%col2 = [[0, 0.4470, 0.7410];[0.8500, 0.3250, 0.0980];[0.9290, 0.6940, 0.1250];[0.4940, 0.1840, 0.5560]];

col2 = [[0, 0.4470, 0.7410];[202,0,32]/255;[0.9290, 0.6940, 0.1250];[0.4940, 0.1840, 0.5560]];

%col2 = [[166,206,227]/255;[0.8500, 0.3250, 0.0980];[0.9290, 0.6940, 0.1250];[0.4940, 0.1840, 0.5560]];
% select colors for 4 example traces & select id of traces (or plot randomModels)

for cnt1 = 1 : numel(Models)
    
    params.channum = Models(cnt1);
    [neuron_orig, tree, ~] = Init_GC_mature(params);
    surface = surf_tree(tree{1});

    Pop = load(fullfile(cd,'data',sprintf('1_GCpopulation_%dchannels',Models(cnt1))))
    
    for cnt2 = 1 : numel(region)
        NodeID{cnt2} = [];
        IDs = find(contains(tree{1}.rnames,region{cnt2}));
        for cnt3 = 1 : length(IDs)
            NodeID{cnt2} = [NodeID{cnt2}; find(IDs(cnt3)==tree{1}.R)];
        end
        surf(1,cnt2) = sum(surface(NodeID{cnt2}));
    end

    for cnt2=1:numel(region)
        chanID = contains(Pop.channame(:,2),region{cnt2});    
        chansurf(chanID,:) = Pop.chanvalue(chanID,:) * surf(1,cnt2);
    end
    
    chans = unique(Pop.channame(:,1));
    
    %sort channels for plotting
    order = {'na','Kv','Ca'};
    chansort={};
    for cnt2 = 1 : length(order)
        id = find(contains(chans,order{cnt2}));
        chansort = [chansort; chans(id)];
    end
    chansort  = [chansort; chans(find(~ismember(chans,chansort)))];
    for cnt2 = 1 : length(chansort)
        channelsurf(cnt2,:) = 0;
        id = find(contains(Pop.channame(:,1),chansort{cnt2}));
        channelsurf(cnt2,1:size(chansurf,2)) = sum(chansurf(id,:),1);
    end
    channelsurf_rel = channelsurf./channelsurf(:,1);
    chanrel_min = min(channelsurf_rel(:,Pop.Fitness<2),[],2);
    chanrel_max = max(channelsurf_rel(:,Pop.Fitness<2),[],2);    

    chanfit = channelsurf_rel(:,Pop.Fitness<2)'
	% mc:        Color of the bars indicating the mean. (default 'k'); set either [],'' or 'none' if the mean should not be plotted
    % medc:      Color of the bars indicating the median. (default 'r'); set either [],'' or 'none' if the mean should not be plotted
%'

    %,'edgecolor','none'
    [h,L,MX,MED,bw]=violin(chanfit,'facecolor',col,'mc',[],'medc',[])
    ylim([0 2])
    set(gca,'YTick',[0:1:2],'Xtick',[1:1:length(chansort)],'Ticklength',[tickl tickl], 'TickDir', 'out','XTicklabel',chansort,'FontName',font,'Fontsize',fonts,'linewidth',lwidth);
%     figure
%     hold all
%     set(gcf, 'Position',  [273, 336, 560, 503], 'Renderer', 'painters')
%     for i=1:size(channelsurf_rel,1)
%         g1 = plot([i, i],[chanrel_min(i) chanrel_max(i)],'Color',col,'Linewidth',lwidth)
%         g1 = plot([i-0.2, i+0.2],[chanrel_min(i) chanrel_min(i)],'Color',col,'Linewidth',lwidth)
%         g1 = plot([i-0.2  i+0.2],[chanrel_max(i) chanrel_max(i)],'Color',col,'Linewidth',lwidth)
%     end
    xtickangle(90);
    ylim([0 2.2]);
    xlim([0.5 length(chansort)+0.5]);
    ylabel('models / data')  ;  
    
    
    %select random ids
    validID = find(Pop.Fitness<2);
    ID = datasample(validID,4);    
    
    for i=1:numel(ID)
        hold all
        g1=plot([1:size(channelsurf_rel,1)],channelsurf_rel(:,ID(i))','.','Markersize',marks,'Color',col2(i,:))
    end
    
    
    set(gcf, 'Units', 'centimeters', 'Position', [2,2,3.2,3], 'Renderer', 'painters');
    print(gcf,fullfile(params.folder,'figures','Fig2',sprintf('Fig2A1_%dchannel_violin.pdf',Models(cnt1))),'-dpdf') % then print it
    close all

    figure
    for cnt2 = 1 : length(ID)
        subplot(2,2,cnt2)
        g1 = plot(Pop.timeVec,Pop.volt{ID(cnt2)}{2},'Color',col2(cnt2,:),'Linewidth',lwidth)
        box off
        if cnt2~=3
            axis off
        end
    end
    set(gcf, 'Units', 'centimeters', 'Position', [2,2,3.2,3], 'Renderer', 'painters');
    print(gcf,fullfile(params.folder,'figures','Fig2',sprintf('Fig2A2_%dchannel_violin.pdf',Models(cnt1))),'-dpdf') % then print it
    close all
end
