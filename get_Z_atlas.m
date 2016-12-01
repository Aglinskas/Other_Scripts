function Z_atlas = get_Z_atlas(Z,n_items)
% get_Z_atlas(Z,n_items)
% Converts Z indexes to sum of individual points
%
%
Z_atlas = nan(length(Z),2);
Z_atlas = num2cell(Z_atlas);
Z(:,4) = n_items + 1 : n_items+length(Z);
% simple cases
for r = 1:length(Z)
for c = [1 2]
    if Z(r,c) <= n_items;%length(mat); 
    Z_atlas{r,c} = Z(r,c);
    end
end
end

%1 complex and 1 simplecomplex 1
for r = 1:length(Z)
for c = [1 2]
% if don't need to go back (both cols single ROIs)
if sum([Z(find(Z(:,4) == Z(r,c)),[1 2])] <= n_items) == 2
Z_atlas{r,c} = Z(find(Z(:,4) == Z(r,c)),[1 2]);
end
end
end


for r = 1:length(Z)
for c = [1 2]
if sum([Z(find(Z(:,4) == Z(r,c)),[1 2])] <= n_items) == 1
if any(isnan([Z_atlas{find(Z(:,4) == Z(r,c)),:}])) == 0
Z_atlas{r,c} = [Z_atlas{find(Z(:,4) == Z(r,c)),:}]; 
end
end
end
end
% Give up check if they're filled in atlas already, hope for the best;
for r = 1:length(Z);
for c = [1 2];
    if isnan(Z_atlas{r,c});
a = Z_atlas(find(Z(:,4) == Z(r,c)),[1 2]);
if any(isnan([a{:}])) == 0;
Z_atlas{r,c} = [a{:}];
end
    end
end
end
%%

for i = 1:length(Z)
    Z_atlas{i,3} = Z(i,3);
end % end 