clear all
loadMR;
numclust = 0;
roi_or_task = 2;
n_perms = 100;
w_tasks = [1:10];
w_rois = 1:18;
dim_to_permute = 3;
h = figure(6);set(h, 'Visible', 'off');
algs = {'single'    'complete'    'average'    'weighted'    'centroid' 'median'    'ward'};
alg_ind = 7
disp(algs{alg_ind})
%
warning('off','stats:linkage:NotEuclideanMatrix');
bt_array = subBeta.array;
bt_array = bt_array - bt_array(:,11,:)%-repmat(bt_array(:,11,:),1,12); %face subtracted
bt_array = bt_array(w_rois,w_tasks,:);% % CC's trimmed 

bt_array = zscore(bt_array,[],2); % Task mean is 0
%bt_array = zscore(bt_array,[],1);% Mean of ROI is 0
bt_lbls = {subBeta.r_labels subBeta.t_labels};

mn = mean(bt_array,3);
figure(38);add_numbers_to_mat(mn,t_labels(1:10),r_labels)

disp(sprintf('Will permute across %d subjects',size(bt_array,dim_to_permute)));
bt_lbls{1} = bt_lbls{1}(w_rois);
bt_lbls{2} = bt_lbls{2}(w_tasks);
a = {[w_rois] [w_tasks] ':'};%bt_array(a{:})

noise = {}; %noise, when looking at ROIs, shuffle tasks, when tasks, shuffle ROIs
for i = 1:size(bt_array,dim_to_permute);
noise{2}(:,:,i) = bt_array(:,randperm(size(bt_array,2)),i);
noise{1}(:,:,i) = bt_array(randperm(size(bt_array,1)),:,i);
end

all_keeps = {};
all_noise = {};
for i = 1:size(bt_array,dim_to_permute);
a(dim_to_permute) = {i};
all_keeps{1}(i,:,:) = corr(bt_array(a{:})');
all_keeps{2}(i,:,:) = corr(bt_array(a{:}));
all_noise{1}(i,:,:) = corr(noise{1}(a{:})');
all_noise{2}(i,:,:) = corr(noise{2}(a{:}));
end
disp('all_keeps created')

this_mat = all_keeps{roi_or_task}%all_keeps{roi_or_task};
this_lbls = bt_lbls{roi_or_task};
%these_mats = {all_keeps{roi_or_task} all_noise{roi_or_task}};
these_mats = {all_keeps{roi_or_task} all_noise{roi_or_task}};
disp('all set up, ready to bootstrap');
            m = squeeze(mean(this_mat,1));
            newvec = get_triu(m);
            Z = linkage(1-newvec,algs{alg_ind});
            figure(1);
            subplot(1,2,1);
            [h x perm_ind] = dendrogram(Z,'labels',this_lbls,'orientation','left');
            subplot(1,2,2);
            ord = perm_ind(end:-1:1);
            add_numbers_to_mat(m(ord,ord),this_lbls(ord));
            drawnow;
            title({'Master Clustering' 'All subs'},'FontSize',20);
            t=figure;set(t,'visible','off');
            h;
%
tic;
subs = 1:size(bt_array,dim_to_permute);
fid_mat_all = [];
this_mat = [];
repvect = [1:10:n_perms];
for perm_ind = 1:n_perms;
    if ismember(perm_ind,repvect);disp(sprintf('%s percent complete',num2str(perm_ind / n_perms * 100)));end
for signal_or_noise = 1:2;
this_mat = these_mats{signal_or_noise};
%this_mat = 1-softmax(this_mat);
split_pool = [];
split_subs = [];
fid_mat_all(signal_or_noise,perm_ind,:,:) = zeros(size(this_mat,3),size(this_mat,3));

subpool = randperm(length(subs));

split_pool(:,1) = subpool(1:10);
split_pool(:,2) = subpool(11:20);



split_subs(:,1) = split_pool(randi(10,1,10),1);
split_subs(:,2) = split_pool(randi(10,1,10),2);


%xx = [];
for split_ind = 1:2;
perm_mat = this_mat(split_subs(:,split_ind),:,:);
perm_mat = squeeze(mean(perm_mat,1));
newVec = get_triu(perm_mat);
Z = linkage(1-newVec,algs{alg_ind});
Z_atlas = get_Z_atlas(Z,length(perm_mat));
h;
%[l x perm] = dendrogram(Z,numclust);
%xx(:,split_ind) = x;
end % ends split 

% add consensus
%l = nchoosek(1:size(this_mat,2),2);
for i = 1:length(Z_atlas);
% fid_mat_all(signal_or_noise,perm_ind,l(i,1),l(i,2)) = fid_mat_all(signal_or_noise,perm_ind,l(i,1),l(i,2)) + perm_mat(l(i,1),l(i,2));%[xx(l(i,1),1) == xx(l(i,2),1) && xx(l(i,1),2) == xx(l(i,2),2)]
% fid_mat_all(signal_or_noise,perm_ind,l(i,2),l(i,1)) = fid_mat_all(signal_or_noise,perm_ind,l(i,1),l(i,2));
fid_mat_all(signal_or_noise,perm_ind,Z_atlas{i,1},Z_atlas{i,2}) =  fid_mat_all(signal_or_noise,perm_ind,Z_atlas{i,1},Z_atlas{i,2}) + Z_atlas{i,3};
fid_mat_all(signal_or_noise,perm_ind,Z_atlas{i,2},Z_atlas{i,1}) = fid_mat_all(signal_or_noise,perm_ind,Z_atlas{i,2},Z_atlas{i,1})  + Z_atlas{i,3};
end

end
end
%fid_mat_all(signal_or_noise,perm_ind,1:size(this_mat,2),1:size(this_mat,2)) = 2;


% figure(3)
% subplot(1,2,1)
% histogram(c(:,1))
% subplot(1,2,2)
% histogram(c(:,2))
disp('done');
toc;
% Plot permutations
figure(3);
r = squeeze(mean(fid_mat_all(1,:,:,:),2));
%r = r ./ perm_ind;
r_s = r;
newVec = get_triu(r);
Z = linkage(newVec);
d1 = subplot(2,2,1);
[h x perm] = dendrogram(Z,'labels',this_lbls,'orientation','left');
[h(1:end).LineWidth] = deal(3)
ord = perm(end:-1:1);
ord_s = ord;
size(r);
m1 = subplot(2,2,2);
add_numbers_to_mat(r(ord,ord),this_lbls(ord));
title({'Permutation Clustering Signal' [num2str(perm_ind) ' Permutations']},'FontSize',20);


r = squeeze(mean(fid_mat_all(2,:,:,:),2));
%r = r ./ perm_ind;
newVec = get_triu(r);
Z = linkage(newVec);
d2 = subplot(2,2,3);
[h x perm] = dendrogram(Z,'labels',this_lbls,'orientation','left');
[h(1:end).LineWidth] = deal(3)
ord = perm(end:-1:1);
size(r);
m2 = subplot(2,2,4);
add_numbers_to_mat(r(ord,ord),this_lbls(ord));
title({'Permutation Clustering Noise' [num2str(perm_ind) ' Permutations']},'FontSize',20);
d1.FontSize = 14;
m1.FontSize = 14;
m1.FontWeight = 'bold';
d1.FontWeight = 'bold';


d2.FontSize = d1.FontSize
m2.FontSize   = m1.FontSize
m2.FontWeight = m1.FontWeight
d2.FontWeight = d1.FontWeight
% Schemaball
%
f = figure(4)
clf
sch_mat = [1 - r_s(ord_s,ord_s) ./ max(r_s(:))];
schemaball_play(this_lbls(ord_s),sch_mat,18)
%%
% figure(4)
% ofn = '/Users/aidasaglinskas/Desktop/test_folder/';
% export_fig([ofn datestr(datetime) '.pdf'])