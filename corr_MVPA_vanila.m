load('/Users/aidasaglinskas/Desktop/voxel_data.mat')
%% Similarity between the tasks
cmat = [];
mat = vx.voxel_data;
for run_ind = 1:5
for t1 = 1:12
for t2 = 1:12
for r = 1:21
for s_ind = 1:20
cmat(t1,t2,r,s_ind,run_ind) = corr(mat{r,t1,s_ind,run_ind}',mat{r,t2,s_ind,run_ind}');
end
end
end
end
end
%% Similarity between ROIs
c = cmat;
rcmat = [];
t_inds = 1:10;
for run_ind = 1:5
for s_ind = 1:20
    clc;disp(sprintf('%d/%d %d/%d',run_ind,5,s_ind,20))
for i = 1:21
for j = 1:21
rcmat(i,j,s_ind,run_ind) = corr(get_triu(c(t_inds,t_inds,i,s_ind,run_ind))',get_triu(c(t_inds,t_inds,j,s_ind,run_ind))');
end
end
end
end
%%
rcmat = mean(mean(rcmat,3),4);
Z = linkage(1-get_triu(rcmat),'ward');
f = figure(1)
[h x perm] = dendrogram(Z,'labels',vx.r_labels,'orientation','left')
make_pretty_dend(f,h)

m = figure(2)
add_numbers_to_mat(rcmat(perm,perm),vx.r_labels(perm))

m.CurrentAxes.CLim = [min(get_triu(rcmat)) max(get_triu(rcmat))]