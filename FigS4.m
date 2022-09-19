%% PLOT CORRELATION
clear all

Models = [5,8,15];
BKsubunit = 1;

saveDir = fullfile(pwd,'figures','FigS4')
if ~exist(saveDir,'dir')
    mkdir(saveDir)
end
    
font  = 'Arial';
fonts = 6;
tickl = 1.25;
lwidth = 0.5;
tickl  = 0.025;
marks = 6;
cmap = colormap;
cmap(end+1,:) = [1 1 1];
sz = [3.2,4.2;5.2,6;10.5,10]

for counter = 1 : numel(Models)
    load(fullfile(pwd,'code','data',sprintf('1_GCpopulation_%dchannels',Models(counter))));
   
    bk=find(contains(channame,'BK'));
    if BKsubunit==1
        channame{bk(1)}='BK1';%_{axonh}';
        channame{bk(2)}='BK2';%_{axonh}';
        channame{bk(3)}='BK1';%_{soma}';
        channame{bk(4)}='BK2';%_{soma}';
    else
       channame(bk([2,4]),:)=[];
       chanvalue(bk([2,4]),:)=[];      
    end

   chanvalue_valid = chanvalue(:,find(Fitness<2));
   
   [R P] = corrcoef(chanvalue_valid');
   P2 = P;
   P2(P2>0.01) = 1.1;

   for i = 1 : size(R,2)
       R(i,i) = 1.1; 
       channame_use{i} = sprintf('%s',channame{i,1});       
       %channame_use2{i} = sprintf('%s_{%s}',channame{i,1},channame{i,2});
       for ii = i : size(R,2)
            R(i,ii) = 1.1; 
            P2(i,ii) = 1.1;
       end
   end
   
   figure;
   imagesc(R);
   colormap(cmap) ;
   h=colorbar('NorthOutside');
   set(h, 'ylim', [-1 1],'YTick',[-1:0.5:1],'TickDir','out','LineWidth',lwidth);
   xtickangle(-45);
   box off
   hold on
   for cnt1 = 1 : size(R,1)
       for cnt2 = 1 : cnt1
           if P(cnt1,cnt2)<0.01
              plot([cnt2-0.5 cnt2+0.5 cnt2+0.5 cnt2-0.5 cnt2-0.5],[cnt1+0.5 cnt1+0.5 cnt1-0.5 cnt1-0.5 cnt1+0.5],'r')
           end
       end
   end
   set(gca,'FontName',font,'Fontsize',fonts,'TickDir','out','YTick',1:size(R,2),'XTick',1:size(R,2),'XTicklabel',channame_use,'YTicklabel',channame_use,'Linewidth',lwidth,'Ticklength',[tickl tickl]);
  
   set(gcf, 'Units', 'centimeters', 'Position', [2,2,sz(counter,:)], 'Renderer', 'painters');
   print(gcf,fullfile(saveDir,sprintf('Fig3_Correlation_%d.pdf',Models(counter))),'-dpdf') % then print it
   close all    
   clear channame_use
end

set(gca,'FontName',font,'Fontsize',fonts,'TickDir','out','YTick',[-80:40:40],'XTick',[0:100:300],'Linewidth',lwidth,'Ticklength',[tickl tickl])    
% set(gcf, 'Units', 'centimeters', 'Position', [2,2,sz], 'Renderer', 'painters');
% print(gcf,fullfile(saveDir,sprintf('%d_base_Trace.jpg',Models(counter))),'-dpdf') % then print it
% close all      