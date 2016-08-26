function uniquepairs = get_unique_pairs(x)

a = 1:x;
b = 1:x;
%%
pairs = {}
for i = 1:length(a)
    for j = 1:length(b)
        pairs{end + 1} = [a(i) b(j)];
    end
end
pairs = pairs'
pairs = cell2mat(pairs)
%%
%%
%arrayfun(@(x) eq(pairs(1),pairs(2)),pairs)
%% get unique pairs
uniquepairs = unique(sort(pairs,2), 'rows')
%% Delete 1&1, 2&2 etc
uniquepairs = uniquepairs(eq(uniquepairs(:,1),uniquepairs(:,2)) == 0,:)
%return uniquepairs
%%
end