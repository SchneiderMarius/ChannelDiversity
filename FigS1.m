clear all

exp=load(fullfile(pwd,'ExpData','Mongiat_BaCl_CClamp'));       

spikeThresh=-10;
duration=200;
exp_iclamp=exp.data{2}-12.1;
rate=exp.rate;

%%
id = [11,19] ;

saveDir = fullfile(pwd,'figures','FigS1')
if ~exist(saveDir,'dir')
    mkdir(saveDir)
end

font  = 'Arial';
fonts = 6;
tickl = 1.25;
lwidth = 0.5;
tickl  = 0.025;
marks = 6;
sz = [3.4,3]


for i=1:8
    figure
    hold all
    set(gcf, 'Position',  [300, 300, 800, 600])
    Trace{i}=plot([1/rate:1/rate:350],exp_iclamp(:,i,id(1)),'Linewidth',lwidth,'Color',[0.5 0.5 0.5])
    Trace{i}=plot([1/rate:1/rate:350],exp_iclamp(:,i,id(2)),'Linewidth',lwidth,'Color','k')
    xlabel('Time [ms]')
    ylabel('Voltage [mV]')
    set(gca,'FontName',font,'Fontsize',fonts,'TickDir','out','YTick',[-80:40:40],'XTick',[0:100:300],'Linewidth',lwidth,'Ticklength',[tickl tickl])
    xlim([0 350])
    ylim([-90 70])
%     saveas(Trace{i},fullfile(pwd,'figures','raw',sprintf('FigS1_1_Mongiat_trace_%d.jpg',i)),'jpg')
%     savefig(fullfile(pwd,'figures','raw',sprintf('FigS1_1_Mongiat_Trace_%d.fig',i)))
%     saveas(Trace{i},fullfile(pwd,'figures','raw',sprintf('FigS1_1_Mongiat_Trace_%d.pdf',i)),'pdf')
%     close all
    
    set(gcf, 'Units', 'centimeters', 'Position', [2,2,sz], 'Renderer', 'painters');
    print(gcf,fullfile(saveDir,sprintf('FigS1_1_Mongiat_trace_%d.pdf',i)),'-dpdf') % then print it
    close all
end

%%
%single Trace

for t=1:8
    figure
    hold all
    set(gcf, 'Position',  [300, 300, 800, 600])
    Trace{t}=plot([1/rate:1/rate:350],exp_iclamp(:,t,id(2)),'Linewidth',lwidth,'Color','k')
    xlabel('Time [ms]')
    ylabel('Voltage [mV]')
    set(gca,'FontName',font,'Fontsize',fonts,'TickDir','out','YTick',[-80:40:40],'XTick',[0:100:300],'Linewidth',lwidth,'Ticklength',[tickl tickl])

    xlim([0 350])
    ylim([-90 70])
%     saveas(Trace{t},fullfile(pwd,'figures','raw',sprintf('FigS1_2_single_Mongiat_trace_%d.jpg',t)),'jpg')
%     savefig(fullfile(pwd,'figures','raw',sprintf('FigS1_2_single_Mongiat_trace_%d.fig',t)))
%     saveas(Trace{t},fullfile(pwd,'figures','raw',sprintf('FigS1_2_single_Mongiat_trace_%d.pdf',t)),'pdf')
%     close all
    set(gcf, 'Units', 'centimeters', 'Position', [2,2,sz], 'Renderer', 'painters');
    print(gcf,fullfile(saveDir,sprintf('FigS1_2_single_Mongiat_trace_%d.pdf',t)),'-dpdf') % then print it
    close all    
end

%% FI - plot with std

sz = [3.5,3]

x = exp.csteps;
mFI = mean (squeeze((sum(diff(exp_iclamp > spikeThresh,1,1) == -1,1))));
stdFI = std (squeeze((sum(diff(exp_iclamp > spikeThresh,1,1) == -1,1))));
mFI = mFI(1:numel(x))/ duration * 1000;
stdFI= stdFI(1:numel(x))/ duration * 1000;

figure
hold on
p = patch ([x (fliplr (x))], [(mFI + stdFI) (fliplr (mFI - stdFI))],[0.7 0.7 0.7],'edgecolor','none' );
p = plot (x, mFI, 'k','Linewidth',lwidth);
set(gca,'FontName',font,'Fontsize',fonts,'TickDir','out','Linewidth',lwidth,'Ticklength',[tickl tickl])
xlabel('current step [pA]')
ylabel('frequency [Hz]')
xlim([0 120])
ylim([0 40])
% set(gcf, 'Position',  [500   400   560   450])
% saveas(p,fullfile(pwd,'figures','raw','FigS1_2b_FI_Curve.jpg'),'jpg')
% savefig(fullfile(pwd,'figures','raw','FigS1_2b_FI_Curve.fig'))
% saveas(p,fullfile(pwd,'figures','raw','FigS1_2b_FI_Curve.pdf'),'pdf')
set(gcf, 'Units', 'centimeters', 'Position', [2,2,sz], 'Renderer', 'painters');
print(gcf,fullfile(saveDir,'FigS1_2b_FI_Curve.pdf'),'-dpdf') % then print it
close all    


%% dV -plot
%Exp 

ff=[4 7 8];
ff=[7];

ostruct.amp = [90]/1000;
ostruct.dataset = 3
ostruct.duration = 200;
ostruct.spikeThresh = -10;
checkthis = 90;
ostruct.amp = [90]/1000;
cstepsSpiking = exp.csteps/1000;

[exp_iclamp,cstepsSpiking,rate] = load_ephys(ostruct.dataset,'CClamp');

dfilt = diff(exp_iclamp,1,1);
ind = ismember(cstepsSpiking,ostruct.amp);
exp_iclampCut = exp_iclamp(:,:,ind);
cstepsSpikingCut = cstepsSpiking(ind);
dfiltCut = dfilt(:,:,ind);
p = zeros(size(exp_iclampCut,2),1);
%col = colorme(size(exp_iclampCut,2),'-grk');

%1.AP -each trees
for f=1:size(exp_iclampCut,2)
    figure
    hold all
    this = exp_iclampCut(2:end,f,1);
    ind = find(dfiltCut(:,f,1)>7,1,'first') + 5*rate;  % find first spike
    dt = (diff(1/rate:1/rate:size(exp_iclampCut,1)/rate,1))';
   	g5 = plot(this(1:ind),dfiltCut(1:ind,f,1)./dt(1:ind),'LineWidth',lwidth,'Color','k','LineStyle','-');%exp_iclamp(:,f,s)))  % mark first spike red
    ylabel('Voltage change [mV/ms]')
    xlabel('Membrane voltage [mV]')
    set(gcf,'units','points','position',[10,10,500,430]) 
    set(gcf, 'Position',  [500   400   560   450])
    xlim([-80 80])
    set(gca,'FontName',font,'Fontsize',fonts,'XTick',-80:40:80,'YTick',0:400:800,'Linewidth',lwidth, 'TickDir', 'out','Ticklength',[tickl tickl])   
    ylim([-150 800])
%     saveas(g5,fullfile(pwd,'figures','raw',sprintf('FigS1_2c_dV-first_Exp_tree_%d.jpg',f)),'jpg')
%     savefig(fullfile(pwd,'figures','raw',sprintf('FigS1_2c_dV-first_Exp_tree_%d.fig',f)))
%     saveas(g5,fullfile(pwd,'figures','raw',sprintf('FigS1_2c_dV-first_Exp_tree_%d.pdf',i)),'pdf')
    set(gcf, 'Units', 'centimeters', 'Position', [2,2,sz], 'Renderer', 'painters');
    print(gcf,fullfile(saveDir,sprintf('FigS1_2c_dV-first_Exp_tree_%d.pdf',i)),'-dpdf') % then print it
    close all       
end

 %   set(gca,'FontName',font,'Fontsize',fonts,'TickDir','out','YTick',[-80:40:40],'XTick',[0:100:300],'Linewidth',lwidth,'Ticklength',[tickl tickl])


%%1.AP -all trees
figure
hold all
set(gcf, 'Position',  [500   400   560   450])

for f=1:size(exp_iclampCut,2)
    this = exp_iclampCut(2:end,f,1);
    ind = find(dfiltCut(:,f,1)>7,1,'first') + 5*rate;  % find first spike
    dt = (diff(1/rate:1/rate:size(exp_iclampCut,1)/rate,1))';
   	g5 = plot(this(1:ind),dfiltCut(1:ind,f,1)./dt(1:ind),'LineWidth',lwidth,'Color','k','LineStyle','-');%exp_iclamp(:,f,s)))  % mark first spike red
    ylabel('Voltage change [mV/ms]')
    xlabel('Membrane voltage [mV]')
    set(gcf,'units','points','position',[10,10,500,430])       
    xlim([-80 80])
    set(gca,'FontName',font,'Fontsize',fonts,'XTick',-80:40:80,'YTick',0:400:800,'Linewidth',lwidth, 'TickDir', 'out','Ticklength',[tickl tickl])
    ylim([-150 800])
end

% saveas(g5,fullfile(pwd,'figures','raw','FigS1_2c_dV-first_Exp_all_tree.jpg'),'jpg')
% savefig(fullfile(pwd,'figures','raw','FigS1_2c_dV-first_Exp_all_tree.fig'))
% saveas(g5,fullfile(pwd,'figures','raw','FigS1_2c_dV-first_Exp_all_tree.pdf'),'pdf')
% close all

set(gcf, 'Units', 'centimeters', 'Position', [2,2,sz], 'Renderer', 'painters');
print(gcf,fullfile(saveDir,'FigS1_2c_dV-first_Exp_all_tree.pdf'),'-dpdf') % then print it
close all       

%% IV - plot

holding_voltage = -80 - 12.1; % mV, LJP corrected
ostruct.subtract_hv = 1; % boolean subtract holding voltage current

exp=load(fullfile('ExpData','Mongiat_BaCl_VClamp'));       

thisdata = exp.data{2};
rate = exp.rate;
tvec = 1/rate:1/rate:size(thisdata,1)/rate;
Rin2 = zeros(size(thisdata,2),1);
cap2 = Rin2;
Rin = Rin2;
cap = Rin2;
vsteps = (-130:5:-40) - 12.1; %LJP corrected

for t = 1:size(thisdata,2)
    d = thisdata(:,t,vsteps==holding_voltage(1)+10);
    is = mean(d(tvec>190&tvec<204));
    i0 = mean(d(tvec<104));
    Rin2(t) = (10)/(is-i0)*1000;  % Rin (in MOhm) mV/pA
    x = tvec(d < is & tvec' > 100);
    y = d(d < is & tvec' > 100)-is;
    y = y(x<=x(1)+50);  % voltage step length of original capacitance measurement was only 50 ms hence cut vector thereafter
    x = x(x<=x(1)+50);
    cap2(t) = trapz(x,y)/(-10); % calculate capacitance as integral (charge) divided by amplitude of voltage step

    d = thisdata(:,t,vsteps==holding_voltage(1)-10);
    is = mean(d(tvec>190&tvec<204));
    i0 = mean(d(tvec<104));
    Rin(t) = (-10)/(is-i0)*1000;  % Rin (in MOhm) mV/pA
    x = tvec(d < is & tvec' > 100);
    y = d(d < is & tvec' > 100)-is;
    y = y(x<=x(1)+50);  % voltage step length of original capacitance measurement was only 50 ms hence cut vector thereafter
    x = x(x<=x(1)+50);
    cap(t) = trapz(x,y)/(-10); % calculate capacitance as integral (charge) divided by amplitude of voltage step
end 
fprintf('Mean Rin in Exp(@%gmV) is %g +- %g MOhm (s.e.m., -10mV)\n',holding_voltage(1)-10,mean(Rin),std(Rin)/sqrt(numel(Rin)))
fprintf('Mean Rin in Exp(@%gmV) is %g +- %g MOhm (s.e.m., +10mV)\n',holding_voltage(1)+10,mean(Rin2),std(Rin2)/sqrt(numel(Rin2)))
fprintf('\nMean capacitance in Exp(@%gmV) is %g +- %g pF (s.e.m. -10mV)',holding_voltage(1)-10,mean(cap),std(cap)/sqrt(numel(cap)))
fprintf('\nMean capacitance in Exp(@%gmV) is %g +- %g pF (s.e.m. +10mV)\n',holding_voltage(1)+10,mean(cap2),std(cap2)/sqrt(numel(cap2)))

if exist('delind','var')
    meas_curr = squeeze(mean(thisdata(194*rate+1:204*rate+1,setdiff(1:size(thisdata,2),delind),:),1));
    basl = squeeze(mean(thisdata(94*rate+1:104*rate+1,setdiff(1:size(thisdata,2),delind),:),1));
else
    meas_curr = squeeze(mean(thisdata(194*rate+1:204*rate+1,:,:),1));
    basl = squeeze(mean(thisdata(94*rate+1:104*rate+1,:,:),1));
end

if ostruct.subtract_hv
    meas_curr = meas_curr - basl;
end

gKirReal = zeros(size(meas_curr,1),1);
Kirind_Mongiat = vsteps <= -122.1;
otherind_Mongiat = vsteps >= -82.1 & vsteps <= -62.1;
for t = 1:size(meas_curr,1)
    tmp = polyfit(vsteps(Kirind_Mongiat),meas_curr(t,Kirind_Mongiat),1) - polyfit(vsteps(otherind_Mongiat),meas_curr(t,otherind_Mongiat),1) ;
    gKirReal(t) = tmp(1);
end

mIV = mean(meas_curr,1);
stdIV = std (meas_curr,1);

figure
hold on
set(gcf, 'Position',  [500   400   560   450])
hp = patch ([vsteps (fliplr (vsteps))], [(mIV + stdIV) (fliplr (mIV - stdIV))], [0 0 0]);
set (hp, 'facealpha', 0.2, 'edgecolor', 'none')
hp = plot (vsteps, mIV,'Color',[0 0 0],'LineWidth',lwidth,'LineStyle','-')
set(gca,'FontName',font,'Fontsize',fonts,'TickDir', 'out','Ytick',[-400:200:0],'linewidth',lwidth,'Ticklength',[tickl tickl])
ylabel('Current [pA]')
xlim([-140 -60])
ylim([-400 150])
xlabel('Holding Voltage [mV]')
% saveas(hp,fullfile(pwd,'figures','raw','FigS1_2d_IV_Curve.jpg'),'jpg')
% savefig(fullfile(pwd,'figures','raw','FigS1_2d_IV_Curvee.fig'))
% saveas(hp,fullfile(pwd,'figures','raw','FigS1_2d_IV_Curve.pdf'),'pdf')
% close all
set(gcf, 'Units', 'centimeters', 'Position', [2,2,sz], 'Renderer', 'painters');
print(gcf,fullfile(saveDir,'FigS1_2d_IV_Curve.pdf'),'-dpdf') % then print it
close all   

