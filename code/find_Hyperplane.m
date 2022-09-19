function [Triplet, mech_Triplet, A, Anum,fac,channame] = find_hyperplane(Model,minPoints,data_folder,save_folder)

regions={'axonh','soma','GCL','adendIML','adendMML','adendOML'};
font  = 'Arial';
fonts = 6;
tickl = 1.25;
lwidth = 0.5;
tickl  = 0.025;
marks = 6;
sz = [3.6,3.4]

if nargin<3
    save_folder = data_folder;   
    plot_folder =  fullfile(save_folder,'Hyperplanes');
    minPoints   = 1500;
end

if nargin<4
    save_folder = data_folder;   
    plot_folder =  fullfile(save_folder,'Hyperplanes');
end

if nargin<5
    plot_folder = fullfile(save_folder,'Hyperplanes');
end

show = 1;

load(fullfile(data_folder,sprintf('1_GCpopulation_%dchannels',Model)))

id2_all = find(Fitness<2);
[val(:), id(:)]=sort(max(max(Matrix_rel(:,:,id2_all))));
id=id2_all(id);
Beast1=id(1:30);
chanmag = mean(chanvalue')';
chanmag = fix(log10(chanmag));

for i=1:length(chanmag)
    if chanmag(i)==0
        chanmag(i)=100;
    elseif chanmag(i)==-1
        chanmag(i)=1000;
    elseif chanmag(i)==-2
        chanmag(i)=10000;      
    elseif chanmag(i)==-3
        chanmag(i)=100000;
    elseif chanmag(i)==-4
        chanmag(i)=1000000; 
    elseif chanmag(i)==-5
        chanmag(i)=10000000; 
    elseif chanmag(i)==-6
        chanmag(i)=100000000; 
    end
end

%     figure
%     plot(chanvalue(1,Beast1),chanvalue(3,Beast1),'.')

for chan1=1:length(channame)
    for chan2=chan1+1:length(channame)
        if chan1~=chan2
            for n1=1:length(Beast1)
                for n2=n1+1:length(Beast1)
                    if n2~=n1 && (round(chanvalue(chan1,Beast1([n1]))'*chanmag(chan1))/chanmag(chan1) - round(chanvalue(chan1,Beast1([n2]))'*chanmag(chan1))/chanmag(chan1))>=0
                        f{n1,n2}=fit(chanvalue(chan1,Beast1([n1 n2]))'*1000,chanvalue(chan2,Beast1([n1 n2]))'*1000,'poly1');
            %             [V I]=find(round(f{n1,n2}(chanvalue(chan1,Beast1))*detail)/1000==round(chanvalue(chan2,Beast1)*1000)/1000);

                        I=find(round(f{n1,n2}(chanvalue(chan1,Beast1)*1000)*chanmag(chan2))/chanmag(chan2)-(round(chanvalue(chan2,Beast1)*1000*chanmag(chan2))/chanmag(chan2))'==0);
                        I(find(I==n1))=[];
                        I(find(I==n2))=[];


                        P3{chan1,chan2}{n1,n2}=I;
                        clear I

                        if ~isempty(P3{chan1,chan2}{n1,n2})
                            del=0;
                            for i=1:length(P3{chan1,chan2}{n1,n2})
                               del(i)=(round(chanvalue(chan1,Beast1([n1]))'*chanmag(chan1))/chanmag(chan1) - round(chanvalue(chan1,Beast1(P3{chan1,chan2}{n1,n2}(i)))'*chanmag(chan1))/chanmag(chan1))==0 ...
                                   | (round(chanvalue(chan1,Beast1([n2]))'*chanmag(chan1))/chanmag(chan1) - round(chanvalue(chan1,Beast1(P3{chan1,chan2}{n1,n2}(i)))'*chanmag(chan1))/chanmag(chan1))==0;

                            end
                            P3{chan1,chan2}{n1,n2}(find(del==1))=[];
                            if length(P3{chan1,chan2}{n1,n2})>1
                                    [errorvalue, chooseind]=find(min(f{n1,n2}(chanvalue(chan1,P3{chan1,chan2}{n1,n2}(:)))-(chanvalue(chan2,P3{chan1,chan2}{n1,n2}(:)))'));
                                    P3{chan1,chan2}{n1,n2}=P3{chan1,chan2}{n1,n2}(chooseind);
                            end

                            if show
                                if length(P3{chan1,chan2}{n1,n2})>1
                                    figure
                                    hold all
                                    h=plot(chanvalue(chan1,Beast1)*1000,chanvalue(chan2,Beast1)*1000,'.k','Markersize',6)
                                    h=plot(f{n1,n2})
                                    set(h, 'LineWidth',lwidth)
                                    xlim([min( chanvalue(chan1,Beast1)*1000)-0.1*abs(max(chanvalue(chan1,Beast1)*1000)-min(chanvalue(chan1,Beast1)*1000))   max( chanvalue(chan1,Beast1)*1000)+0.1*max(chanvalue(chan1,Beast1)*1000) ])
                                    ylim([min( chanvalue(chan2,Beast1)*1000)-0.1*abs(max(chanvalue(chan2,Beast1)*1000)-min(chanvalue(chan2,Beast1)*1000))     max( chanvalue(chan2,Beast1)*1000)+0.1*max(chanvalue(chan2,Beast1)*1000) ])

                                    xlabel(sprintf('g_{%s} [mS/cm^2]',channame{chan1}))
                                    ylabel(sprintf('g_{%s} [mS/cm^2]',channame{chan2}))
                                    set(gca,'FontName',font,'Fontsize',fonts,'TickDir','out','Linewidth',lwidth,'Ticklength',[tickl tickl])                                    
                                    legend off
                                    box off
                                    set(gcf, 'Units', 'centimeters', 'Position', [2,2,sz], 'Renderer', 'painters');
                                    print(gcf,fullfile(plot_folder,sprintf('Subspace_%d_%s_%s_%d_%d.pdf',Model,channame{chan1,1},channame{chan2,1},n1,n2)),'-dpdf') % then print it
                                    close all                                    
                                    
%                                     savefig(fullfile(plot_folder,sprintf('Subspace_%s_%s_%s_%d_%d',Model,channame{chan1,1},channame{chan2,1},n1,n2)))
%                                     saveas(h,fullfile(plot_folder,sprintf('Subspace_%s_%s_%s_%d_%d',Model,channame{chan1,1},channame{chan2,1},n1,n2)),'jpg')
%                                     close all
                                else

                                    figure
                                    hold all
                                    plot(chanvalue(chan1,Beast1)*1000,chanvalue(chan2,Beast1)*1000,'.k','Markersize',6)
                                    h=plot(f{n1,n2})
                                    set(h, 'LineWidth',lwidth)
                                    xlim([min( chanvalue(chan1,Beast1)*1000)-0.1*abs(max(chanvalue(chan1,Beast1)*1000)-min(chanvalue(chan1,Beast1)*1000))   max( chanvalue(chan1,Beast1)*1000)+0.1*max(chanvalue(chan1,Beast1)*1000) ])
                                    ylim([min( chanvalue(chan2,Beast1)*1000)-0.1*abs(max(chanvalue(chan2,Beast1)*1000)-min(chanvalue(chan2,Beast1)*1000))     max( chanvalue(chan2,Beast1)*1000)+0.1*max(chanvalue(chan2,Beast1)*1000) ])
                                    xlabel(sprintf('g_{%s} [mS/cm^2]',channame{chan1}))
                                    ylabel(sprintf('g_{%s} [mS/cm^2]',channame{chan2}))
                                    set(gca,'FontName',font,'Fontsize',fonts,'TickDir','out','Linewidth',lwidth,'Ticklength',[tickl tickl])                                    
                                    legend off
                                    box off
                                    set(gcf, 'Units', 'centimeters', 'Position', [2,2,sz], 'Renderer', 'painters');
                                    print(gcf,fullfile(plot_folder,sprintf('Subspace_%d_%s_%s_%d_%d.pdf',Model,channame{chan1,1},channame{chan2,1},n1,n2)),'-dpdf') % then print it
                                    close all 
%                                     
%                                     savefig(fullfile(plot_folder,sprintf('Subspace_%s_%s_%s_%d_%d',Model,channame{chan1,1},channame{chan2,1},n1,n2)))
%                                     saveas(h,fullfile(plot_folder,sprintf('Subspace_%s_%s_%s_%d_%d',Model,channame{chan1,1},channame{chan2,1},n1,n2)),'jpg')
%                                     close all
                                end
                            end

                        end

                    end
                end
            end
            numtriple(chan1,chan2)=length(find(~cellfun(@isempty,P3{chan1,chan2})));
        end

    end
end

%%

fac.a1=-1.6:0.04:2.5;
fac.a2=-1.6:0.04:2.5;

for i=1:length(fac.a2)
    Parsu(i,:)=fac.a1+fac.a2(i);
end

fac.a3=1-Parsu;

for chan1=1:length(channame)
    for chan2=chan1+1:length(channame)

        [I1 I2]=find(cellfun(@isempty,P3{chan1,chan2})==0);

        if ~isempty(I1)
            for i=1:length(I1)
    %             if chan P3{chan1,chan2}{I1(i), I2(i)}
                    Triplet{chan1,chan2}{i}=chanvalue(:,Beast1([I1(i), I2(i), P3{chan1,chan2}{I1(i), I2(i)}]));  
                    mech_Triplet{chan1,chan2}{i}=mechs(Beast1([I1(i), I2(i), P3{chan1,chan2}{I1(i), I2(i)}]));
    %             end
                A{chan1,chan2}{i}(1:length(fac.a2),1:length(fac.a1))=0;
                for n=1:length(fac.a2)
                    for b=1:length(fac.a1)

                        A{chan1,chan2}{i}(n,b)= sum(Triplet{chan1,chan2}{i}(:,1)*fac.a1(b)+Triplet{chan1,chan2}{i}(:,2)*fac.a2(n) +Triplet{chan1,chan2}{i}(:,3)*fac.a3(n,b)<0  );
                    end
                end
                Anum{chan1,chan2}(i)=sum((A{chan1,chan2}{i}(:)==0));
            end


              check=find(Anum{chan1,chan2}>minPoints);

              Triplet{chan1,chan2}=Triplet{chan1,chan2}(find(Anum{chan1,chan2}>minPoints));
              mech_Triplet{chan1,chan2}=mech_Triplet{chan1,chan2}(find(Anum{chan1,chan2}>minPoints));
              A{chan1,chan2}=A{chan1,chan2}(find(Anum{chan1,chan2}>minPoints)); 
              Anum{chan1,chan2}=Anum{chan1,chan2}(find(Anum{chan1,chan2}>minPoints));
              for z=1:length(check)
                  P3_new{chan1,chan2}(z,:)=[I1(check(z)) I2(check(z)) P3{chan1,chan2}{I1(check(z)),I2(check(z))}];
              end
        end

        if ~isempty(I1) && ~isempty(check) && size(P3_new{chan1,chan2},1)>1
            P3_sort=sort(P3_new{chan1,chan2},2);
            [C,ia]= unique(P3_sort,'rows');   
            Triplet{chan1,chan2} = Triplet{chan1,chan2}(ia);
            mech_Triplet{chan1,chan2} = mech_Triplet{chan1,chan2}(ia);
            A{chan1,chan2} = A{chan1,chan2}(ia);
            Anum{chan1,chan2} = Anum{chan1,chan2}(ia);
            P3_new{chan1,chan2} = P3_new{chan1,chan2}(ia,:);
        end  
    end
end

%     if exist('P3_new','var')       
%         save(fullfile(save_folder,'Factors_Hyperplane'),'fac.a1','fac.a2','fac.a3');
%         save(fullfile(save_folder,sprintf('Triplet_model_%s',Model)),'Triplet','mech_Triplet','A','Anum')
%         save(fullfile(save_folder,sprintf('Triplet_model_%s',Model)),'Triplet','mech_Triplet','A','Anum','P3','f','Beast1','chanvalue','P3_new')
%     end
%    clear Triplet mech_Triplet A Anum P3 P3_new Beast1 id2_all P3_new f val id
% end
