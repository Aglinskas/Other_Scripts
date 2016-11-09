loadMR
all_subs = [1:20];

for this_sub = 1:20;
    subBeta.array(:,:,this_sub) = zscore(subBeta.array(:,:,this_sub),[],2);
for t1 = 1:12;
for t2 = 1:12;

other_subs = all_subs(all_subs ~= this_sub);
this_beta = subBeta.array(:,t1,this_sub);
other_beta = mean(subBeta.array(:,t2,other_subs),3);

%this_beta = zscore(this_beta,[],2);
%other_beta = zscore(other_beta,[],2);

c = corr(this_beta,other_beta);
all_c(t1,t2,this_sub) = c;
end
end
end
%
OutPerm = [6    10     2     9     8     1     5     3     4     7]
f = figure(9)
m = subplot(1,2,1)
trim_mat = 1:10
mat = mean(all_c,3);
mat = mat(OutPerm,OutPerm)
mat=triu(mat)+tril(mat)';
mat=mat/2;

add_numbers_to_mat(mat(trim_mat,trim_mat),t_labels(OutPerm))
m.FontSize = 16
m.FontWeight = 'bold'
title('Cor with ')
d = subplot(1,2,2)
newVec = get_triu(mat(trim_mat,trim_mat));
Z = linkage(1-newVec,'ward')
[h x] = dendrogram(Z,'labels',t_labels(trim_mat),'orientation','left')
[h(1:end).LineWidth] = deal(5)

d.FontSize = 16
d.FontWeight = 'bold'


