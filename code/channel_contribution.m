function [currents_dir,currents_reldir,channels,voltVec,timeVec] = channel_contribution(neuron_orig,tree,params)

channels={};
channels{1,1}='v';
channels{1,2}=1;
regions = tree{1}.rnames;
surface = surf_tree(tree{1});

for counter1 = 1 : numel(regions)    
    x= fieldnames(neuron_orig.mech{1}.(regions{counter1})); 
    for counter2 = 1: numel(fieldnames(neuron_orig.mech{1}.(regions{counter1})))
        xx=fieldnames(neuron_orig.mech{1}.(regions{counter1}).(x{counter2}));
        if any(contains(xx,'bar'))
            gid = find(contains(xx,'bar'),1);
            if neuron_orig.mech{1}.(regions{counter1}).(x{counter2}).(xx{gid})>0
               flag = 1;
            else
               flag = 0;
            end
        else
            flag = 1;
        end
        
        if flag==1
            if any(contains(channels(:,1),x{counter2}))
                channels{find(contains(channels(:,1),x{counter2})),2} = ...
                    [channels{find(contains(channels(:,1),x{counter2})),2};find(find(strcmp(tree{1}.rnames,regions{counter1}))==tree{1}.R)];
            else
                if strcmp('pas',x{counter2}) || strcmp('HCN',x{counter2})
                    channels{end+1,1} = sprintf('i_%s',x{counter2});
                elseif contains(x{counter2},'K')
                    channels{end+1,1} = sprintf('ik_%s',x{counter2});
                elseif contains(x{counter2},'C')
                    channels{end+1,1} = sprintf('ica_%s',x{counter2});
                elseif contains(x{counter2},'na')
                    channels{end+1,1} = sprintf('ina_%s',x{counter2});
                end
                channels{find(contains(channels(:,1),x{counter2})),2} =...
                    find(find(strcmp(tree{1}.rnames,regions{counter1}))==tree{1}.R);
            end
        end
    end
end

neuron = neuron_orig;
neuron.params.dt=0.05; 
neuron.params.nseg = 1;

hstep = t2n_findCurr(neuron,tree,-80,[],'-q-d');
ostruct.duration = 200;
neuron.params.tstop = 150+ostruct.duration;
ostruct.delay = 55.5;  % standard current steps 0-90 pA
ostruct.amp = 90/1000;  % standard current steps 0-90 pA
neuron.pp{1}.IClamp = struct('node',1,'times',[-100,ostruct.delay,ostruct.delay+ostruct.duration],'amp', [hstep(1) hstep(1)+ostruct.amp hstep(1)]); %n,del,dur,amp
neuron.record{1}.cell = struct('node',channels(:,2),'record',channels(:,1));
out = t2n(neuron,tree,'-q-d'); % run simulations

timeVec = out.t;
voltVec = out.record{1}.cell.v{1};
channels(1,:)=[]; 
%         currents(:,counter1) = zeros(numel(out.t),1);    
currents_dir{1} = zeros(numel(out.t),size(channels,1));
currents_dir{2} = zeros(numel(out.t),size(channels,1));   

for counter1 = 1 : size(channels,1)
    for counter2 = 1 : numel(channels{counter1,2})
        currents_seg{counter1}(:,counter2) = ...
            out.record{1}.cell.(channels{counter1,1}){channels{counter1,2}(counter2)} * surface(channels{counter1,2}(counter2));         
    end
    currents(:,counter1) = sum(currents_seg{counter1},2);
    currents_dir{1}(find(currents(:,counter1)>0),counter1) = currents(find(currents(:,counter1)>0),counter1);
    currents_dir{2}(find(currents(:,counter1)<0),counter1) = currents(find(currents(:,counter1)<0),counter1);
end

if params.plot==1
    
%     bg = {'w','k'};
%     c = distinguishable_colors(size(channels,1),bg);
    c = color_config(channels);

    fac_cont = 15;
    fac_volt = 20;
    fac_voltheigh = 1.1;
    fac_volt2 = 30;
    fac_voltheigh2 = 1.4;
    time_fac = 1.6;
    set(gca,'DefaultLineLineWidth',0.5)
    current_axis=[5 50 500];
    
    
    sum_currents{1} = zeros(length(timeVec),1);
    sum_currents{2} = zeros(length(timeVec),1);
    currents_reldir{1} = currents_dir{1}./sum(currents_dir{1},2).*100;
    currents_reldir{2} = -currents_dir{2}./sum(currents_dir{2},2).*100;

    figure
    hold all
    for counter2 = 1 : size(channels,1)
       pl = patch( [timeVec ; flip(timeVec)], [sum_currents{1}; flip(sum_currents{1}+currents_reldir{1}(:,counter2)/fac_cont) ],c(counter2,:),'LineStyle','none');
       pl = patch( [timeVec ; flip(timeVec)], [sum_currents{2}; flip(sum_currents{2}+currents_reldir{2}(:,counter2)/fac_cont) ],c(counter2,:),'LineStyle','none');
       sum_currents{1} = sum_currents{1} + currents_reldir{1}(:,counter2)/fac_cont;
       sum_currents{2} = sum_currents{2} + currents_reldir{2}(:,counter2)/fac_cont;
       p(counter2) = pl;

    end
    axis on;
%     legend(p, extractAfter(channels(:,1), '_'),'location','south','NumColumns',round((size(channels,1)+4)/3));
    
    legend(p, extractAfter(channels(:,1), '_'),'location','south');

    for counter3 = 1 : numel(current_axis)
        p2(counter3) = plot(timeVec, sum_currents{1}+log(current_axis(counter3)),':','Color',[0.5 0.5 0.5]);
        set(get(get(p2(counter3),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');   
        p3(counter3) = plot(timeVec, sum_currents{2}-log(current_axis(counter3)),':','Color',[0.5 0.5 0.5]);
        set(get(get(p3(counter3),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    end


    xout = sum(currents_dir{1},2);
    xout(xout<1) = 1;
    p4(1) = patch([timeVec;flip(timeVec)] , [ones(length(timeVec),1).*sum_currents{1}; flip(sum_currents{1}+log(xout))],'k' );
    xin = -sum(currents_dir{2},2);
    xin(xin<1) = 1;
    p4(2) = patch([timeVec;flip(timeVec)] , [ones(length(timeVec),1).*sum_currents{2}; flip(sum_currents{2}-log(xin))],'k' );
    p4(3) = plot(timeVec, fac_voltheigh*(100/fac_cont+log(500)) +(-voltVec(1) +voltVec)/fac_volt,'k','Linewidth',0.5);
    [Amp, APt] = findpeaks(voltVec,timeVec,'MinPeakHeight',1,'MinPeakDistance',2);
%         

    xlim([APt(2)-5 APt(3)+10]) 
    x1 = APt(2)+diff([max(timeVec/(diff(timeVec([1 end]))/ (diff([APt(2) APt(3)])/time_fac))) diff([APt(2) APt(3)])])/2;
    p5(1) = plot(timeVec/(diff(timeVec([1 end]))/ (diff([APt(2) APt(3)])/time_fac))+x1 ...
         ,fac_voltheigh2*(100/fac_cont+log(500)) +(-voltVec(1) +voltVec)/fac_volt2,'k');
    %Pfeile
    id1 = find(timeVec == (APt(2)-5));
    id2 = find(timeVec == (APt(3)+10));
    p5(2) = plot([timeVec(id1)   timeVec(id1)/(diff(timeVec([1 end]))/ (diff([APt(2) APt(3)])/time_fac))+x1]...
        ,[(fac_voltheigh*(100/fac_cont+log(500)) +(-voltVec(1) +voltVec(id1))/fac_volt)   (fac_voltheigh2*(100/fac_cont+log(500)) +(-voltVec(1) +voltVec(id1))/fac_volt2)],'--','Color',[0.5 0.5 0.5]);     

    p5(3) = plot([timeVec(id2)   timeVec(id2)/(diff(timeVec([1 end]))/ (diff([APt(2) APt(3)])/time_fac))+x1]...
        ,[(fac_voltheigh*(100/fac_cont+log(500)) +(-voltVec(1) +voltVec(id2))/fac_volt)   (fac_voltheigh2*(100/fac_cont+log(500)) +(-voltVec(1) +voltVec(id2))/fac_volt2)],'--','Color',[0.5 0.5 0.5]);     
    for counter3 = 1 : 3
        set(get(get(p4(counter3),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');         
        set(get(get(p5(counter3),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');         
    end


    set(gca,'YTick',[-100/fac_cont-log(500) -100/fac_cont-log(50) -100/fac_cont-log(5) 100/fac_cont+log(5) 100/fac_cont+log(50) 100/fac_cont+log(500) fac_voltheigh*(100/fac_cont+log(500))+20/fac_volt fac_voltheigh*(100/fac_cont+log(500))+100/fac_volt]);
    set(gca,'YTickLabel', char('-500','-50','-5','5','50','500','-60','20'),'Tickdir','out', 'FontName', 'Arial','fontsize',6);
    ymin = min([ones(length(timeVec),1).*sum_currents{2}; flip(sum_currents{2}-log(xin))])*1.05;
    ymax = max(fac_voltheigh2*(100/fac_cont+log(500)) +(-voltVec(1) +voltVec)/fac_volt2)*1.05;
    ylim([ymin ymax]);
    set(gcf, 'Units', 'centimeters', 'Position', [15,1.5,15,20], 'Renderer', 'painters');
    
    saveas(gcf,fullfile(params.folder,'figures','Fig1',sprintf('Fig1C_%dchannel_legend.svg',params.channum)),'svg');
    delete(legend);
    saveas(gcf,fullfile(params.folder,'figures','Fig1',sprintf('Fig1C_%dchannel.svg',params.channum)),'svg');

end


end