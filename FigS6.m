clear all

data_folder = fullfile(pwd,'code','data')
saveDir = fullfile(pwd,'figures','FigS6');
cd 'code';

params.folder='D:\Schneider2020_final_v2\code';
Models = {'comp_BK','comp_Cav22'};
region = {'axonh','soma',{'GCL','adendIML','adendMML','adendOML'}}

font  = 'Arial';
fonts = 6;
tickl = 1.25;
lwidth = 0.5;
tickl  = 0.025;
marks = 6;
x_width = 3.45 ; y_width = 3;
col = [0.7725,0.7725,0.7725];
col2 = [[0, 0.4470, 0.7410];[202,0,32]/255;[0.9290, 0.6940, 0.1250];[0.4940, 0.1840, 0.5560]];

for cnt1 = 2 : numel(Models)
    
    params.channum = 15;
    [neuron_orig, tree, ~] = Init_GC_mature(params);
    surface = surf_tree(tree{1});
    
    Pop_original = load(fullfile(cd,'data','1_GCpopulation_15channels'))
    Pop_original.mechs = [];
   
    Pop          = load(fullfile(cd,'data',sprintf('1_GCpopulation_14channels_%s',Models{cnt1})))
    Pop.mechs = [];
    
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
        
        chanID_original = contains(Pop_original.channame(:,2),region{cnt2});    
        chansurf_original(chanID_original,:) = Pop_original.chanvalue(chanID_original,:) * surf(1,cnt2);        
    end
    
    chans = unique(Pop.channame(:,1));
    chans_orig = unique(Pop_original.channame(:,1));
    
    %sort channels for plotting
    order = {'na','Kv','Ca'};
    chansort={}; chansort_original={};
    for cnt2 = 1 : length(order)
        id = find(contains(chans,order{cnt2}));
        chansort = [chansort; chans(id)];
        
        id_orig = find(contains(chans_orig,order{cnt2}));
        chansort_original = [chansort_original; chans_orig(id_orig)];        
    end
    
    chansort           = [chansort; chans(find(~ismember(chans,chansort)))];
    chansort_original  = [chansort_original; chans_orig(find(~ismember(chans_orig,chansort_original)))];
    
    for cnt2 = 1 : length(chansort)
        channelsurf(cnt2,:) = 0;
        id = find(contains(Pop.channame(:,1),chansort{cnt2}));
        channelsurf(cnt2,1:size(chansurf,2)) = sum(chansurf(id,:),1);
    end
    
    for cnt2 = 1 : length(chansort_original)
        channelsurf_original(cnt2,:) = 0;
        id = find(contains(Pop_original.channame(:,1),chansort_original{cnt2}));
        channelsurf_original(cnt2,1:size(chansurf_original,2)) = sum(chansurf_original(id,:),1);
    end    
    
    %new
    [C,ia] = setdiff(chansort_original,chansort)
    channelsurf_original(ia,:)=[];
    chansort_original(ia)=[];
    
    channelsurf_rel = channelsurf./channelsurf_original(:,1);
    chanrel_min = min(channelsurf_rel(:,Pop.Fitness<2),[],2);
    chanrel_max = max(channelsurf_rel(:,Pop.Fitness<2),[],2);    

    chanfit = channelsurf_rel(:,Pop.Fitness<2)';

    [h,L,MX,MED,bw]=violin(chanfit,'facecolor',col,'mc',[],'medc',[])
    set(gca,'Xtick',[1:1:length(chansort)],'Ticklength',[tickl tickl], 'TickDir', 'out','XTicklabel',chansort,'FontName',font,'Fontsize',fonts,'linewidth',lwidth);
    xtickangle(90);
    xlim([0.5 length(chansort)+0.5]);
    ylabel('models / data')  ;  
    %select random ids
    validID = find(Pop.Fitness<2);
    ID = datasample(validID,4);    
    
    for i=1:numel(ID)
        hold all
        g1=plot([1:size(channelsurf_rel,1)],channelsurf_rel(:,ID(i))','.','Markersize',marks,'Color',col2(i,:))
    end
    box off
    set(gcf, 'Units', 'centimeters', 'Position', [2,2,3.2,3], 'Renderer', 'painters');
    print(gcf,fullfile(saveDir,sprintf('FigS6_14channel_violin_%s.pdf',Models{cnt1})),'-dpdf') % then print it
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
    set(gcf, 'Units', 'centimeters', 'Position', [2,2,5.2,4], 'Renderer', 'painters');
    print(gcf,fullfile(saveDir,sprintf('FigS6_14channel_violin_%s_Trace.pdf',Models{cnt1})),'-dpdf') % then print it
    close all
end
