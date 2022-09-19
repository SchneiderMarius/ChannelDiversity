clear all

[~, neuron_orig, ostruct,tree, treeModel] = Init_GC_mature;

trees = tree{4}
clear tree
tree{1} = trees;
clear trees

data_folder = 'C:\Users\Marius\Desktop\Masterthesis\Schneider_Paper\data'
save_folder = 'C:\Users\Marius\Desktop\Masterthesis\Schneider_Paper\FigS5'

regions={'axonh','soma','GCL','adendIML','adendMML','adendOML'};


Model = {'7','13','13_EqualDist'}
Model = {'7','13'}

% Percentage=[0];

minPoints = 1000;


%%
clear all
cd code
data_folder = fullfile(cd,'data')
save_folder = fullfile(data_folder,'FigS5')
if ~exist(save_folder,'dir')
   mkdir(save_folder) 
end
Model = [5,8,15];
regions={'axonh','soma','GCL','adendIML','adendMML','adendOML'};
load(fullfile(cd,'data','Factors-Hyperplane_newdata'));
minPoints = 1500;
Percentage=[0.1,0.05,0,-0.05,-0.1];

for z=1:length(Model)
    params.channum = Model(z);
    [neuron_orig, tree, ~,~] = Init_GC_mature(params);
    [Triplet{z}, mech_Triplet{z}, A{z}, Anum{z},fac{z},channame{z}] = find_Hyperplane(Model(z),minPoints,data_folder,save_folder)
end

%search for hyperplanes that exist in all models
params.channum = Model(1);
[neuron_orig, tree, ~,~] = Init_GC_mature(params);


for z=3:length(Model)
    params.channum = Model(z);
    [neuron_orig, tree, ~,~] = Init_GC_mature(params);    
    
    sum(~cellfun(@isempty, Triplet{z}))
    %     load(sprintf('Triplet_model_%s_newdata',Model{z}));
    
    nneuron = neuron_orig;
    nneuron.mech{1} = mech_Triplet{z}{find(~cellfun(@isempty, mech_Triplet{z}),1)}{1}{1};  
    
    [chanvalue, channame] = channel_cond(nneuron, 'Kir21');
    
    chandel=find(chanvalue(:,1)==0);
    chanvalue(chandel,:)=[];
    channame(chandel,:)=[];    
    dend_id=find(strcmp(channame(:,2),'GCL'));
    chan_dend=channame(dend_id,:);

    for y1 = 1 : size(Triplet{z},1)
        for y2 = y1 + 1 : size(Triplet{z},2)
                
            for counter = 1 : numel(Percentage)
                boarder = length(Triplet{z}{y1,y2});
                if boarder > 2
                   boarder = 2; 
                end
                
                for y3 = 1 : boarder
                   for n=1:length(fac{z}.a2)
                %randomize conductances of channels with max-condition*(but no min)
                       for b=1:length(fac{z}.a1)
                            neuron{(n-1)*length(fac{z}.a1)+b}=nneuron;
                            Fac(n,b)=fac{z}.a3(n,b)+fac{z}.a1(b)+fac{z}.a2(n);
                            anyzero(n,b)=0;
                            for f = 1 : size(channame,1) 
                                neuron{(n-1)*length(fac{z}.a1)+b}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})...
                                    = mech_Triplet{z}{y1,y2}{y3}{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})*fac{z}.a1(b) + mech_Triplet{z}{y1,y2}{y3}{2}.(channame{f,2}).(channame{f,1}).(channame{f,3})*fac{z}.a2(n) + mech_Triplet{z}{y1,y2}{y3}{3}.(channame{f,2}).(channame{f,1}).(channame{f,3})*fac{z}.a3(n,b);
                                anyzero(n,b) = anyzero(n,b)+(neuron{(n-1)*length(fac{z}.a1)+b}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})<0);
                            end
                            for f=4:numel(regions)
                                for ff=1:size(chan_dend,1)
                                     neuron{(n-1)*length(fac{z}.a1)+b}.mech{1}.(regions{f}).(chan_dend{ff,1}) = neuron{(n-1)*length(fac{z}.a1)+b}.mech{1}.(chan_dend{ff,2}).(chan_dend{ff,1});
                                end
                            end                       
                        end
                   end
                   [chanvalue, channame] = channel_cond(neuron, 'Kir21');
                    chanstd=std(chanvalue')';
                      %%  
                   for n=1:length(fac{z}.a2)
                        for b=1:length(fac{z}.a1)
                            neuron{(n-1)*length(fac{z}.a1)+b} = nneuron;
                            Fac(n,b)=fac{z}.a3(n,b)+fac{z}.a1(b)+fac{z}.a2(n);
                            anyzero(n,b)=0;
                            for f = 1 : size(channame,1) 
                                neuron{(n-1)*length(fac{z}.a1)+b}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})...
                                    = mech_Triplet{z}{y1,y2}{y3}{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})*fac{z}.a1(b) + mech_Triplet{z}{y1,y2}{y3}{2}.(channame{f,2}).(channame{f,1}).(channame{f,3})*fac{z}.a2(n) + mech_Triplet{z}{y1,y2}{y3}{3}.(channame{f,2}).(channame{f,1}).(channame{f,3})*fac{z}.a3(n,b) + Percentage(counter)*chanstd(f,1);
                                anyzero(n,b) = anyzero(n,b)+(neuron{(n-1)*length(fac{z}.a1)+b}.mech{1}.(channame{f,2}).(channame{f,1}).(channame{f,3})<0);
                            end
                            for f=4:numel(regions)
                                for ff=1:size(chan_dend,1)
                                     neuron{(n-1)*length(fac{z}.a1)+b}.mech{1}.(regions{f}).(chan_dend{ff,1}) = neuron{(n-1)*length(fac{z}.a1)+b}.mech{1}.(chan_dend{ff,2}).(chan_dend{ff,1});
                                end
                            end                                 
                        end
                   end

                   anyzero=anyzero';
                   A_new{y1,y2}(y3)=sum(anyzero(:)==0);
                   neuron(find(anyzero(:)>0))=[];   

                   [voltVec,timeVec,mech]=IClamp_Mongiat(neuron,tree);
                   [Matrix,Matrix_rel,Fitness_Pareto]= Fitness_Mongiat(voltVec,timeVec);

                    if Percentage(counter) == 0
                        save(fullfile(save_folder,sprintf('Hyperplane_%dchan_Triplet_%s_%s_%d.mat',Model(z),channame{y1,1},channame{y2,1},y3)),'mech','Matrix','Model','Matrix_rel','mech_Triplet','anyzero','Triplet','Fitness_Pareto','Percentage','A_new');
                    else
                        save(fullfile(save_folder,sprintf('Hyperplane_%dchan_Triplet_%s_%s_%d_Perc%.2f.mat',Model(z),channame{y1,1},channame{y2,1},y3,Percentage(counter))),'mech','Matrix','Model','Matrix_rel','mech_Triplet','anyzero','Triplet','Fitness_Pareto','Percentage','A_new');
                    end
                    clear voltVec Matrix timeVec mech numspikes Fitness chan_norm chan_rel chanvalue mech Matrix Matrixshort_rel Matrix_rel Matrix_Model Par5090_2 Par5090_3 Fitness anyzero neuron Fitness_Pareto
                end
            end
        end
    end
end

%%
%%

cpu=32;

trees=tree{4}
clear tree
tree{1}=trees;
dVthresh = 15;
clear neuron
neuron_orig.params.cvode=0;

regions={'axonh','soma','GCL','adendIML','adendMML','adendOML'}

channels{1,1}={'na8st','Kv11','Kv14','Kv34','Kv723','Cav22','Cav12','Cav13','Cav32','BK','BK','SK2'}
channels{2,1}={'gbar','gkbar','gkbar','gkbar','gkbar','gbar','gbar','gbar','gbar','gabkbar','gakbar','gkbar'}
channels{3,1}={2,5,5,5,5,2,2,2,2,2,10,2}

channels{1,2}={'na8st','Kv21','Cav22','Cav12','Cav13','Cav32','BK','BK','SK2'}
channels{2,2}={'gbar','gkbar','gbar','gbar','gbar','gbar','gabkbar','gakbar','gkbar'}
channels{3,2}={2,5,2,2,2,2,2,10,2}

channels{1,3}={'Kv42','Cav22','Cav12','Cav13','Cav32','SK2'}
channels{2,3}={'gkbar','gbar','gbar','gbar','gbar','gkbar'}
channels{3,3}={5,2,2,2,2,10}



current=[1 3];
clear neuron
%%
neuron_orig2=neuron_orig;

%41 66
load('Factors-Hyperplane_newdata')
Model={'3chan','10chan'}

Percentage=[0.1,0.05,-0.05,-0.1];


%%
for n=1:1%numel(neuron)
    for f=1:3%numel(regions)
        if f==1
            num=0;
        else
            num=num+numel(channels{1,f-1});
        end
        for i=1:numel(channels{1,f})
            chanvalue(num+i,n)= mech_Triplet{1,4}{1}{n}.(regions{f}).(channels{1,f}{i}).(channels{2,f}{i});
            chanModel{num+i,1}= sprintf('%s_{%s}',channels{1,f}{i},regions{f});
        end
    end
end
 chandel=find(chanvalue(:,1)==0);
 chanvalue(chandel,:)=[]
 chanModel(chandel,:)=[]
% 
%  for i=1:3
%     I(i)=find(Triplet{1,2}{1}(1,i)==chanvalue(1,:))
%  end
%  chanvalue(:,I)
% 
%  
%  
%  neuron=neuron(I)
%  
% for i=1:3
%    figure
%    hold all
%    plot(timeVec{1}{1},voltVec{i}{1})
%    plot(timeVec{1}{1},voltVec{i}{2})
%    
% end
%  
%%
n=40

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

%%
y1=2
y2=3
y3=1
Model{1}='Triplet_model_simple';
z=1;
id=find(A{y1,y2}{y3}==0)

Land=zeros(1,101*101)
Parameter1=zeros(1,101*101)
Parameter2=zeros(1,101*101)

% Fitness(find(any(any(Matrixshort_rel(:,:,:)>5)>0)))=6;

% Fitness(end)=[]

% Fitness(find(isnan(Fitness)))=[];
% for i=1:length(mech)
% if any(Matrixshort_rel(:,:,i)>10)
%     Fitness(i)=Fitness(i)+3
% end
% end
Land(id)=Fitness
Parameter1(id)=chanvalue(y1,:)
Parameter2(id)=chanvalue(y2,:)


% figure
LandMatrix = vec2mat(Land,size(anyzero,1))
Parameter1Matrix = vec2mat(Parameter1,size(anyzero,1))
Parameter2Matrix = vec2mat(Parameter2,size(anyzero,1))

% mech_Triplet{1}()
%
 for i=1:3
    I(i)=find(Triplet{y1,y2}{y3}(1,i)==chanvalue(1,:))
 
    [Ind1(i), Ind2(i)]=find(LandMatrix==Fitness(I(i)))
 end
 
%
[I1 I2]=find(anyzero(:,:)==0);
xlimin=min(I1)
ylimin=min(I2)
xlimax=max(I1)
ylimax=max(I2)

figure
f1=imagesc(LandMatrix)
colormap(rgb_sea)
colorbar
box off
hold all
plot(Ind2,Ind1,'r.','Markersize',13)
axis off
xlim([xlimin-5 xlimax+5])
ylim([ylimin-5 ylimax+5])
caxis([0 6])
h = colorbar;
ylabel(h, 'Fitness')
set(gca, 'Fontsize',13)
saveas(f1,sprintf('Hyperplane_%s_Triplet_%s_%s_%d.jpg',Model{z},chanModel{y1,1},chanModel{y2,1},y3),'jpg')
save(sprintf('Hyperplane_%s_Triplet_%s_%s_%d.fig',Model{z},chanModel{y1,1},chanModel{y2,1},y3))
%%
sprintf('%.2f',-5)