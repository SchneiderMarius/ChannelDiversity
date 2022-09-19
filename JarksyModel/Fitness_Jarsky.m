function [Matrix,Matrix_rel,Pareto]= Fitness_Jarsky(volt,timeVec)



dVthresh = 15;
ap = -10; % minimum AP amplitude threshold for detection [mV]

load(fullfile(pwd,'Data','FitnessMatrix'));    
    

for counter00=1:length(volt)

%     if any(uu==1)
%         [exp_iclamp,cstepsSpiking,rate] = load_ephys(3,'CClamp');
%         for i=1:length(currstep)
%             s1(i)=find(cstepsSpiking == currstep(i));
%         end
%     end

%     if exist('props','var')
%         Matrix(1,1:numel(currstep))=mean(props.Rin);
%         Matrixstd(1,1:numel(currstep))=std(props.Rin);
%         Matrix(2,1:numel(currstep))=mean(props.cm);
%         Matrixstd(2,1:numel(currstep))=std(props.cm)   ; 
%     end


    props.APt = cell(length(volt{counter00}),size(volt{counter00}{1},2));



    % props.APt = cell(2,max([size(exp_iclamp,2),size(sim1.voltVec,1)]));

    props.APiv = props.APt; props.APit = props.APt; props.APwidth = props.APt; props.APind = props.APt; props.APamp = props.APt;props.APampabs = props.APt;props.APISI = props.APt;props.fAHP = props.APt;props.fAHPabs = props.APt;props.APdeact = props.APt;
    props.APic = cell(numel(1),1);props.maxDV = props.APt;

    for u=1:length(volt{1})

    %             if isempty(s1)
    %                 continue
    %             else
        thisv = volt{counter00}{u};
        thist=timeVec;
%         thist = repmat((1/rate:1/rate:size(thisv,1)/rate)',1,size(thisv,2));
%         thisv = interp1(thist(:,1),thisv,thist(1,1):newrate:thist(end,1));
%         thist = repmat((thist(1,1):newrate:thist(end,1))',1,size(thisv,2));
%         spikdetect = squeeze(any(exp_iclamp > -30,1));
%         csteps = cstepsSpiking;
%         [~,props.APic{u}] = find(spikdetect == 1 & cumsum(spikdetect,2) == 1);
%         props.APic{u} = csteps(props.APic{u})*1000;
        thisdv = diff(thisv,1,1)./diff(thist,1,1);
    %     props.thisv=thisv;
    %     props.thist=thist;
    %     props.thisdv=thisdv;
        for t = 1:size(thisv,2)
            flag = false;
            flag2 = false;
            [props.APampabs{u,t},props.APt{u,t}] = findpeaks(thisv(:,t),thist(:,t),'MinPeakHeight',ap,'MinPeakDistance',2); % spikes need to be 2 ms apart at least
            [~,~,props.APind{u,t}] = intersect(props.APt{u,t},thist(:,t));
            props.APt{u,t} = thist(props.APind{u,t});
            props.APISI{u,t} = diff(props.APt{u,t});
    %         [~,props.APt50{u,t}] = findpeaks(exp_iclamp(:,t,find(cstepsSpiking == steps(1))),1/rate:1/rate:350,'MinPeakHeight',ap,'MinPeakDistance',2);
            count = 1;
            for n = 1 : numel(thisdv(:,t))  % go through voltage trace
    %             if  numel(props.APind{u,t}) >= count && thisdv(n,t) > 0 && (numel(props.maxDV{u,t}) < count || props.maxDV{u,t}(count) < thisdv(n,t))  % get time and value and voltage level of maximum voltage change
    %                 props.maxDV{u,t}(count) = thisdv(n,t);
    %                 props.APiv2{u,t}(count) = thisv(n,t);
    %                 props.APit2{u,t}(count) = thist(n);
    %             end
    %             
    %             if numel(props.maxDV{u,t}) == count && n > props.APind{u,t}(count) && ~flag2 && thisdv(n,t)<0 && thisv(n,t) <= props.APiv2{u,t}(count)
    %                 props.APwidth2{t}(count) = thist(n) - props.APit2{u,t}(count);  % AP width at level of fast rising phase
    %                 flag2 = true;
    %             end

                if ~flag && thisdv(n,t) >= dVthresh && numel(props.APt{u,t})>=count && (3 > props.APt{u,t}(count)-thist(n)) %thisdv(n,t) >= dv_base(t)+2*stddv_base(t) %&&
                    props.APit{u,t}(count) = thist(n);
                    props.APiv{u,t}(count) = thisv(n,t);
                    flag = true;
                elseif flag && thisv(n,t) <= props.APiv{u,t}(count) % spike is over

                    props.APamp{u,t}(count) = props.APampabs{u,t}(count) - props.APiv{u,t}(count);
                    props.APwidth{u,t}(count) = thist(props.APind{u,t}(count)+find(thisv(props.APind{u,t}(count)+1:end,t) <= props.APiv{u,t}(count)+props.APamp{u,t}(count)/2,1,'first'),t)-thist(find(thisv(1:props.APind{u,t}(count),t) <= props.APiv{u,t}(count)+props.APamp{u,t}(count)/2,1,'last'),t);  %width at half amplitude (as Brenner 2005)
                    if props.APt{u,t}(count) < 255.5 - 5  % security zone of 5 ms not to measure props.fAHP in spikes at end of stimulation
                        if numel(props.APt{u,t}) <= count
                            tlim = 255.5;         % set window to search for props.fAHP, 255 is end of stimulation
                        else
                            tlim = min(255.5,props.APt{u,t}(count+1));
                        end
                        ind = find(thist(:,t) >= props.APt{u,t}(count) & thist(:,t) <= tlim); % get time window between spike max and next spike
    %                     [props.fAHPabs{u,t}(count), ind2] = min(thisv(ind,t));  % find minimum in V in that window
    %                     figure;plot(thist(:,t),thisv(:,t)),hold all;plot(thist(ind,t),thisv(ind,t))
                        [y,x] = findpeaks(-thisv(ind,t),thist(ind,t),'MinPeakDistance',1.5);
                        tim = x(find(diff(y,1)<0,1,'first'));
                        if isempty(tim)
                            [~,tim] = max(y);
                            tim = x(tim);
                        end
                        if isempty(tim)
                            props.APdeact{u,t}(count) = NaN;
                            props.fAHP{u,t}(count) = NaN;
                            props.fAHPabs{u,t}(count) = NaN;
                        else
                            props.fAHPabs{u,t}(count) = thisv(thist(:,t)==tim,t);
                            if tim - props.APt{u,t}(count) > 5 %(thist(ind(ind2),t) - props.APt{u,t}(count)) > 5 % if time from spike to fAHP is longer than 5ms then it is propably no fAHP
                                props.APdeact{u,t}(count) = NaN;
                                [~,ind2] = min(diff(thisv(ind,t),1,1));  % find minimum of derivative
                                ind2 = ind(ind2-1+find(diff(thisv(ind(ind2:end),t),1,1)> -0.005,1,'first'));  %attempt to rescue fAHP calculation..check were derivative negative steepness is over
                                if (isempty(ind2) && thist(ind(end)) == 255.5) || thist(ind2,t) - props.APt{u,t}(count) > 5
                                    props.fAHP{u,t}(count) = NaN;
                                    props.fAHPabs{u,t}(count) = NaN;
                                else
                                    props.fAHPabs{u,t}(count) = thisv(ind2,t);
                                    props.fAHP{u,t}(count) = props.APiv{u,t}(count)-props.fAHPabs{u,t}(count);
%                                     display('fAHP rescued')
                                end
                            else
                                props.fAHP{u,t}(count) = props.APiv{u,t}(count)-props.fAHPabs{u,t}(count);

                                thist2 = thist(ind(thist(ind,t)==tim):end,t);
                                thist2 = thist2(1:find(thist2(1)+5 <= thist2,1,'first')); % nur bis +5ms

                                thisv2 = thisv(ind(thist(ind,t)==tim):ind(thist(ind,t)==tim)+numel(thist2)-1,t);

                                lthisv2 = log(thisv2(end)-thisv2);
                                imagind = find(imag(lthisv2)~=0 | isinf(lthisv2),1,'first')-1;
                                %                     min(imagind,find(thist2-thist(ind(ind2)-3)
                                if imagind < 4
                                    props.APdeact{u,t}(count) = NaN;
                                else
                                    [p,~] = polyfit(thist2(1:imagind)-thist(ind(thist(ind,t)==tim)) , lthisv2(1:imagind),1);
                                    props.APdeact{u,t}(count) = -1/p(1);
                                end
                            end
                        end
                    end
                    flag = false;
                    flag2 = false;
                    count = count + 1;
                end
            end
    %         switch uu(u)
    %             case 1
    %                 col = [0 0 0];
    %             case 2
    %                 if isfield(sim1.tree{t},'col')
    %                     col = sim1.tree{t}.col{1};
    %                 else
    %                     col = [1 0 0];
    %                 end
    %         end

        end
                
        
        Matrix(3,u,counter00)=mean(cellfun(@numel,props.APind(u,:)));

        idx = ~cellfun('isempty',props.APiv(u,:));
        Matrix(4,u,counter00)= mean(cellfun(@(v)v(1),props.APiv(u,idx)));
%         Matrixstd(4,u,counter00)= std(cellfun(@(v)v(1),props.APiv(u,idx)));
 
        Matrix(13,u,counter00)=mean(setdiff(cell2mat(props.APiv(u,:)),cellfun(@(v)v(1),props.APiv(u,idx))));

        idx = ~cellfun('isempty',props.APt(u,:));
        Matrix(5,u,counter00)= mean(cellfun(@(v)v(1),props.APt(u,idx)));
%         Matrixstd(5,u,counter00)= std(cellfun(@(v)v(1),props.APt(u,idx)));

        idx = ~cellfun('isempty',props.APISI(u,:));
        Matrix(6,u,counter00)= mean(cellfun(@(v)v(1),props.APISI(u,idx)));
%         Matrixstd(6,u,counter00)= std(cellfun(@(v)v(1),props.APISI(u,idx)));


        idx = cellfun(@length,props.APISI(u,:))>2;
        Matrix(7,u,counter00)= mean(1-cellfun(@(v)v(1),props.APISI(u,idx))./cellfun(@(v)v(end),props.APISI(u,idx)));
        
        if idx==0
            Matrix(7,u,counter00)= 0;
        end
        
%         Matrixstd(7,u,counter00)= std(1-cellfun(@(v)v(1),props.APISI(u,idx))./cellfun(@(v)v(end),props.APISI(u,idx)));

        idx = ~cellfun('isempty',props.APamp(u,:));
        Matrix(8,u,counter00)= mean(cellfun(@(v)v(1),props.APamp(u,idx)));
%         Matrixstd(8,u,counter00)= std(cellfun(@(v)v(1),props.APamp(u,idx)));
        Matrix(14,u,counter00)=mean(setdiff(cell2mat(props.APamp(u,:)),cellfun(@(v)v(1),props.APamp(u,idx))));

        idx = ~cellfun('isempty',props.fAHP(u,:));
        Matrix(9,u,counter00)= mean(cellfun(@(v)v(1),props.fAHP(u,idx)));
%         Matrixstd(9,u,counter00)= std(cellfun(@(v)v(1),props.fAHP(u,idx)));

        idx = ~cellfun('isempty',props.fAHPabs(u,:));
        Matrix(10,u,counter00)= mean(cellfun(@(v)v(1),props.fAHPabs(u,idx)));
%         Matrixstd(10,u,counter00)= std(cellfun(@(v)v(1),props.fAHPabs(u,idx)));

        idx = ~cellfun('isempty',props.APwidth(u,:));
        Matrix(11,u,counter00)= mean(cellfun(@(v)v(1),props.APwidth(u,idx)));
%         Matrixstd(11,u,counter00)= std(cellfun(@(v)v(1),props.APwidth(u,idx)));
%         temp_width=cell2mat(props.APwidth(u,:));
%         Matrix(15,u,counter00) = mean(temp_width(2:end));

        idx = ~cellfun('isempty',props.APt(u,:));
        Matrix(12,u,counter00)= mean(cellfun(@(v)v(end),props.APt(u,idx)));
    end
    clear props
end

Matrix(isnan(Matrix))=0;


ind0=[2:12];
ind1=[4,5,12:12];
ind2=[5];

[i0_1]=find(Matrix(3,:,:)==0);
[i1]=find(Matrix(3,:,:)==1);
[i2_1]=find(Matrix(3,:,:)==2);
% Matrixexp = Matrix
% Matrixexp_std = Matrix*0.2
% save(fullfile(pwd,'Data','Matrix_20perc'),'Matrixexp','Matrixexp_std')
Matrix_rel = abs(Matrix(3:end,:,:)-Matrixexp(3:end,:))./abs(Matrixexp_std(3:end,:));
Matrix_rel(ind0,i0_1)=0;
Matrix_rel(ind1,i1)=0;
Matrix_rel(ind2,i2_1)=0;

% da keine adaptation (sonst Nan da durch 0 geteilt)
Matrix(7,:,:) = [];
Matrix_rel(5,:,:) = [];

Pareto(:)=max(max(Matrix_rel));


