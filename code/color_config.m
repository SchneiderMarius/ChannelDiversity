function c = color_config(channels)

load('Color_Configuration')

for cnt = 1 : length(channels)
    id = find(strcmp(chan,channels{cnt}));
    c(cnt,:) = col(id,:);    
end

end