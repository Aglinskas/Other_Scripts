a = [1 2 3]
b = [1 2 3]
%%
pairs = {}
for i = 1:length(a)
    for j = 1:length(b)
        pairs{end + 1} = [a(i) b(j)];
    end
end
pairs = pairs'
%%
uniquepairs = unique(sort(cell2mat(pairs),2), 'rows')

%%
cell2mat(pairs)