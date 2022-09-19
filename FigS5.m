clear all
saveDir = fullfile(cd,'figures','FigS5')

if ~exist(saveDir,'dir')
   mkdir(saveDir) 
end
cd 'code'

n=40;
b1 = linspace(1,8,n)./ 255;  %// Blue from 0 to 1
b2 = linspace(17,180,n)./ 255;  %// Blue from 0 to 1
b3 = linspace(181,238,n)./ 255;  %// Blue from 0 to 1

g1 = linspace(0.4660,0,n/4);
g2 = linspace(0.6740,0.5,n/4);
g3 = linspace(0.1880,0,n/4); 

o1 = linspace(0.9290,1,n/4);
o2 = linspace(0.6940,1,n/4);
o3 = linspace(0.1250,1,n/4);
rgb_sea=flip(squeeze([[b1,g1,o1]',[b2,g2,o2]',[b3,g3,o3]']))

sz1 = [4.5 3]
sz2 = [3.5 3]
        
font  = 'Arial';
fonts = 6;
tickl = 1.25;
lwidth = 0.5;
tickl  = 0.025;
marks = 6;
x_width = 3.45 ; y_width = 3;

Model = [5,8,15];

dat = dir(fullfile('data','FigS5','Hyperplane*'))
id = 1;
for cnt1 = 1 : length(dat)
    if ~contains(dat(cnt1).name,'Perc')
        dat_use(id) =  dat(cnt1);
        id = id + 1;
    end
end

params.channum = 15;
[neuron_orig, tree, ~,~] = Init_GC_mature(params);
        
for cnt1 = 7 : length(dat_use)
    
    id = 1;     
    for cnt2 = 1 : length(dat)
       if contains(dat(cnt2).name,dat_use(cnt1).name(1:end-4)) 
            dat_sub(id) = dat(cnt2);
            id = id + 1;
       end
    end
   %if length(dat) 
   
   if length(dat_sub)==5
       
   for cnt2 = 1 : length(dat_sub)
        load(fullfile(dat_sub(cnt2).folder,dat_sub(cnt2).name));
        
        nneuron = [];
        for cnt3 = 1 : length(mech)
            nneuron{cnt3} = neuron_orig;
            nneuron{cnt3}.mech{1} = mech{cnt3};
        end
        [chanvalue, channame] = channel_cond(nneuron, 'Kir21');

        out = cellfun(@(x) find(x == length(Fitness_Pareto)),A_new,'un',0);
        idx = cellfun('isempty',out);
        [y1,y2] = find(~idx);
       
        y3 = str2num(dat_use(cnt1).name(end-4:end-4));
        y0 = strsplit(dat_use(cnt1).name,'_');
        y0 = y0{2};
        y0 = str2num(erase( y0 , 'chan' ));
        y0 = find(y0==Model);
        
        id=find(anyzero==0);

        Land=zeros(1,101*101);
        Parameter1=zeros(1,101*101);
        Parameter2=zeros(1,101*101);
        
        Land(id)=Fitness_Pareto;
        Parameter1(id)=chanvalue(y1,:);
        Parameter2(id)=chanvalue(y2,:);

        % figure
        LandMatrix = vec2mat(Land,size(anyzero,1));
        Parameter1Matrix = vec2mat(Parameter1,size(anyzero,1));
        Parameter2Matrix = vec2mat(Parameter2,size(anyzero,1)); 
                
        RefMap=zeros(1,101*101);        
        if cnt2 ==1
             for i=1:3
                %new
                I(i) = find(ismember(chanvalue',Triplet{y0}{y1,y2}{y3}(:,i)','rows'));
                RefMap(id(I(i))) = 1;
%                 LandMatrix(id(I(i)))
                % original
%                 I(i)=find(Triplet{y0}{y1,y2}{y3}(1,i)==chanvalue(1,:))
%                 [Ind1(i), Ind2(i)]=find(LandMatrix==Fitness_Pareto(I(i)))
             end
             RefMatrix = vec2mat(RefMap,size(anyzero,1));
             [Ind1 Ind2] = find(RefMatrix==1);               
        end
     
        
        %
        [I1 I2]=find(anyzero(:,:)==0);
        xlimin=min(I1);
        ylimin=min(I2);
        xlimax=max(I1);
        ylimax=max(I2);
        
        figure
        f1=imagesc(LandMatrix)
        colormap(rgb_sea)
        %colorbar
        box off
        hold all
        plot(Ind2,Ind1,'r.','Markersize',6);
        axis off
        xlim([xlimin-5 xlimax+5]);
        ylim([ylimin-5 ylimax+5]);
        caxis([0 6]);

        if cnt2 ==1
            h = colorbar;
            set(gcf, 'Units', 'centimeters', 'Position', [2,2,sz1], 'Renderer', 'painters');
            set(h,'YTick',[0:2:6],'Tickdir','out','Ticklength',[tickl tickl],'FontName',font,'Fontsize',fonts,'linewidth',lwidth)
            ylabel(h, 'Fitness')
        else
            %h = colorbar('off');
            set(gcf, 'Units', 'centimeters', 'Position', [2,2,sz2], 'Renderer', 'painters');            
        end
        print(gcf,fullfile(saveDir,sprintf('%s.pdf',dat_sub(cnt2).name(1:end-4))),'-dpdf') % then print it
        close all       
   end
   
   end
end
