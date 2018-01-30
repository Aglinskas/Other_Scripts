figure(4)
add_numbers_to_mat(acmat,this_lbls)
Z = linkage(1-get_triu(acmat),'ward');
nclust = 5;
[h x perm] = dendrogram(Z)
this_lbls(x==1)
%% make_model  
model = zeros(size(acmat));
w = [];
a = [];
%x = [ 1     2     3     3     1     5     4     4     2     5]';
for i = unique(x)'
for s = 1:size(cmat,3)
    %model(find(x==i),find(x==i)) = 1    
    w(s,i) = mean(get_triu(cmat(find(x==i),find(x==i),s)));
    a(s,i) = mean(mean(cmat(find(x==i),find(x~=i),s)));
end
end


m = (mean(cmat,3) ./ std(cmat,[],3)) .^2
add_numbers_to_mat(m(perm,perm),this_lbls(perm))


model_evidence1 = mean(w,2) - mean(a,2);
[H,P,CI,STATS] = ttest(w,a);
STATS.H = H
STATS.P = P