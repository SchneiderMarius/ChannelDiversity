function Currentscapes(currents_dir,channels,voltVec,timeVec)
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
    [~, APt] = findpeaks(voltVec,timeVec,'MinPeakHeight',1,'MinPeakDistance',2);       

    xlim([APt(2)-5 APt(3)+10]) 
    x1 = APt(2)+diff([max(timeVec/(diff(timeVec([1 end]))/ (diff([APt(2) APt(3)])/time_fac))) diff([APt(2) APt(3)])])/2;
    p5(1) = plot(timeVec/(diff(timeVec([1 end]))/ (diff([APt(2) APt(3)])/time_fac))+x1 ...
         ,fac_voltheigh2*(100/fac_cont+log(500)) +(-voltVec(1) +voltVec)/fac_volt2,'k');

    [~,id1] = min(abs(timeVec-(APt(2)-5)));
    [~,id2] = min(abs(timeVec-(APt(3)+10)));
    
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
end