loadMR
%%
size(MVPA_results)
clust{1} = [ 4     3    14    13     6     5    12    11];
clust{2} = [18    17    16    15     2     1];
clust{3} = [10     9     8     7];
clust{4} = [1:18]

w_s = [1:20]
w_t = [1:10]
clust_ID = 4
%%
% clear a b
% a = mean(MVPA_results(:,:,w_t,w_t),4)
% for sub = 1:20
%     b(sub,:,:) = corr(squeeze(a(sub,:,:)));
% end
%%
matrix  = 
%size(matrix)
labels = {tasks{w_t}}'%{masks_name{clust{clust_ID}}}'

mat = figure(8);
add_numbers_to_mat(matrix,labels);
mat.CurrentAxes.FontSize = 25;

dend = figure(9);
newVec = get_triu(1-matrix);
Z = linkage(newVec,'ward');
[h x] = dendrogram(Z,'labels',labels,'orientation','left');
[h(1:end).LineWidth] = deal(3);
dend.CurrentAxes.FontSize = 25;













