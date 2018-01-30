loadMR;clc
mat = aBeta.wmat;
albls = {aBeta.r_lbls aBeta.t_lbls(1:10)};
drop_inds = [9 10 13 14  19 20 1 2]
mat(drop_inds,:,:) = [];
albls{1}(drop_inds) = [];
% make null mats
null_mats = {mat permute(mat,[2 1 3])};
for r_t = 1:2
for s_ind = 1:size(mat,3)
null_mats{r_t}(:,:,s_ind) = null_mats{r_t}(:,Shuffle(1:size(null_mats{r_t}(:,:,s_ind),2)),s_ind);
end
end
null_mats{2} = permute(null_mats{2},[2 1 3]);
% Make cmats
rcmat = [];tcmat = [];acmat = {};rcmat_null = [];tcmat_null = [];
for i = 1:size(mat,3)
rcmat(:,:,i) = corr(mat(:,:,i)');  
tcmat(:,:,i) = corr(mat(:,:,i));   
rcmat_null(:,:,i) = corr(null_mats{2}(:,:,i)');
tcmat_null(:,:,i) = corr(null_mats{1}(:,:,i));
end
acmat = {rcmat tcmat};
ancmat = {rcmat_null tcmat_null};
% permute
r_t = 1; % which dim to permute
mat = acmat{r_t}; % take the mat 
this_lbls = albls{r_t}; % and the labels 

    % Average Clustering
    warning('off','stats:linkage:NotEuclideanMatrix');
    figure(1);clf;
    Z = linkage(1-get_triu(mean(mat,3)),'ward');
    [h perm_struct.ground_x perm] = dendrogram(Z,3);
    dendrogram(Z,'labels',this_lbls,'orientation','left');
    title('ground truth clustering','fontsize',20);
    
perm_struct.mat = acmat{r_t};
perm_struct.lbls = albls{r_t};
perm_struct.nperms = 100;
[3 3];perm_struct.nclust = ans(r_t); % how many clusters to excpect;
perm_struct = func_lastBoot_bootmat(perm_struct);
f = figure(2)
perm_struct.meanClust = mean(perm_struct.clustmat,3);
fm = perm_struct.meanClust;
ord = perm_struct.final_ord;
lbls = perm_struct.lbls
add_numbers_to_mat(fm(ord,ord),lbls(ord))
%%
perm_struct.mat = ancmat{r_t};
disp('estimating null')
noise = [];
for i = 1:20
 disp(sprintf('%d/%d',i,20))   
noise_struct = func_lastBoot_bootmat(perm_struct);
noise(:,:,i) = noise_struct.meanClust;
end
disp('null estimated')
%% Stats
for i = unique(perm_struct.ground_x)'
inds = find(perm_struct.ground_x == i);
disp(['Cluster ' num2str(i)])
%disp(perm_struct.lbls(inds))
within = mean(get_triu(perm_struct.meanClust(inds,inds)));
n = arrayfun(@(x) mean(get_triu(noise(inds,inds,x))),1:20);
p = 1 - sum(within >= n) / length(n);
disp(['P value ' num2str(p)])
end
%find(perm_struct.ground_x == 2)
%%

m = perm_struct.meanClust;
add_numbers_to_mat(m(ord,ord),lbls(ord))
%%
lbls = albls{r_t};
lbls = strrep(lbls,'.mat','');
lbls = strrep(lbls,'Angular','AG');
figure(3);clf
schemaball_play(lbls(ord),m(ord,ord),10)
fast_save_fig_png
