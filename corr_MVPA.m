loadMR
%%
vx.voxel_data = vx.f_voxel_data;
pairs = nchoosek(1:12,2);
mat = [];
cmat = [];
tic;
mat_all.pairs = pairs;
mat_all.r_labels = vx.r_labels;
mat_all.list_r = vx.list_r;
mat_all.t_labels = vx.t_labels;
for r_ind = 1:21;
disp([num2str(r_ind) '/' num2str(21)])
toc
for task1_ind = 1:2
for task2_ind = 1:2
for pair_ind = 1:length(pairs)
tasks = pairs(pair_ind,:);
for s_ind = 1:size(vx.voxel_data,3)
for run1_ind = 1:5
for run2_ind = 1:5
v1 = vx.voxel_data{r_ind,tasks(task1_ind),s_ind,run1_ind}';
v2 = vx.voxel_data{r_ind,tasks(task2_ind),s_ind,run2_ind}';
c = corr(v1,v2);
row_index = (task1_ind-1)*5+run1_ind;
col_index = (task2_ind-1)*5+run2_ind;
mat(row_index,col_index,s_ind) = c;
%mat_all(row_index,col_index,tasks(task1_ind),tasks(task2_ind),r_ind,s_ind) = c;
mat_all.mat(row_index,col_index,pair_ind,r_ind,s_ind) = c;
end
end
% keep tabs
pl = 0;
if pl
imagesc(mat_all(:,:,tasks(task1_ind),tasks(task2_ind),r_ind,s_ind));
ttl = {[vx.t_labels{tasks(task1_ind)} '-' vx.t_labels{tasks(task2_ind)}] vx.r_labels{r_ind} ['Sub: ' num2str(s_ind)]};
title(ttl,'fontsize',20);
drawnow
end
end
end
end
end
end
%% Compute shit
for i = 1:20 
t1_within(i) = mean(get_triu(mat(1:5,1:5,i)));
t2_within(i) = mean(get_triu(mat(6:10,6:10,i)));
temp = mat(1:5,6:10,i);
across_diag_inds = [1 7 13 19 25];
other_inds = find(~ismember(1:25,across_diag_inds));
across_diag(i) = mean(temp(across_diag_inds));
across_offdiag(i) = mean(temp(other_inds));
R = mean([t1_within t2_within],2) - across_offdiag';
end
cmat(tasks(1),tasks(2),r_ind,:) = R;
cmat(tasks(2),tasks(1),r_ind,:) = R;
end
end
vx.f_run_cor = mat_all;
vx.f_cmat = cmat;
vx.mat_all_descrp = 'mat_all(row_index,col_index,task1,task2,r_ind,s_ind)'
save('/Users/aidasaglinskas/Desktop/WcorrMVPA.mat')
%%

r_ninds = [19 20 15 16 13 14 9 10 1 2]
r_inds = find(~ismember(1:21,r_ninds))
%vx.r_labels(r_inds)
cmat = vx.w_cmat(1:10,1:10,r_inds,:)
ttl = 'Word Data';
mat = cmat;
mat = mat;
cormat = [];
pairs = nchoosek(1:size(cmat,3),2);
for s_ind = 1:20
for pair_ind = 1:length(pairs)
v1 = get_triu(mat(:,:,pairs(pair_ind,1),s_ind))';
v2 = get_triu(mat(:,:,pairs(pair_ind,2),s_ind))';
cormat(pairs(pair_ind,1),pairs(pair_ind,2),s_ind) = corr(v1,v2);
cormat(pairs(pair_ind,2),pairs(pair_ind,1),s_ind) = cormat(pairs(pair_ind,1),pairs(pair_ind,2),s_ind);
%cormat(pairs(pair_ind,1),pairs(pair_ind,1),s_ind) = 1;
%cormat(pairs(pair_ind,2),pairs(pair_ind,2),s_ind) = 1;
end
end
disp('done')
ccmat = mean(cormat,3);
lbls = vx.r_labels;
Z = linkage(1-get_triu(ccmat),'ward');
d = figure(1)
[h x perm] = dendrogram(Z,'labels',vx.r_labels(r_inds),'orientation','left')
perm = perm(end:-1:1)
make_pretty_dend(d,h)
title(ttl,'FontSize',20);
figure(2);add_numbers_to_mat(ccmat(perm,perm),lbls(r_inds(perm)))
%%
r_ind = 17;
m = mean(cmat(:,:,r_ind,:),4)
figure(4)
add_numbers_to_mat(m,vx.t_labels(1:10))

