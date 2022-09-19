function [neuron, chanvalue, channame] =  mech_config(neuron,params)

if nargin<1
   params.folder = '' 
end

%select data file with mech configuration

regions = fieldnames(mech{1});


for cnt1 = 1 : numel(regions)
    reg_chan = fieldnames(mech{1}.(regions{cnt1}))
    
    for cnt2 = 1 : numel(reg_chan)
        parnames = fieldnames(mech{1}.(regions{cnt1}).(reg_chan{cnt2}));
        
        if any(contains(parnames,'bar'))
            id = find(contains(parnames,'gbar') |contains(parnames,'bar'));
            
            if length(id)>1
                for cnt3 = 1 : length(id)
                    if mech{1}.(regions{cnt1}).(reg_chan{cnt2}).(parnames{id(cnt3)})==0
                        mech{1}.(regions{cnt1}) = rmfield(mech{1}.(regions{cnt1}),reg_chan{cnt2});
                    end
                end
            elseif mech{1}.(regions{cnt1}).(reg_chan{cnt2}).(parnames{id})==0
                mech{1}.(regions{cnt1}) = rmfield(mech{1}.(regions{cnt1}),reg_chan{cnt2});
            end
        end
    end
end

end
