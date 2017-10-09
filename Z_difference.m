%function m = Z_difference(Z1,Z2)

% z1a = get_Z_atlas(Z1,size(Z1,1)+1);
% z2a = get_Z_atlas(Z2,size(Z1,1)+1);

z1a = get_Z_atlas(allZ{10},size(Z1,1)+1);
z2a = get_Z_atlas(allZ{1},size(Z1,1)+1);

a = z1a(:,[1 2]);
b = z2a(:,[1 2]);
c = [];
if length(a) ~= length(b);error(' different size dends');end
for i = 1:length(a)
tempa = [a{i,[1 2]}];
for j = 1:length(a)
tempb = [b{j,[1 2]}];

c(j,i) = mean(ismember(tempa,tempb));
end
end

m = mean(mean(c,1));
m = 1-m