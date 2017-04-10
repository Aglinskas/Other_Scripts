clear all
loadMR;
numclust = 2;
roi_or_task = 2;
w_tasks = [1:10];
w_rois = 1:18;
dim_to_permute = 3;
h = figure(6);set(h, 'Visible', 'off');
%
warning('off','stats:linkage:NotEuclideanMatrix');
bt_array = subBeta.array;
bt_array = bt_array-repmat(bt_array(:,11,:),1,12); %face subtracted
bt_array = bt_array(w_rois,w_tasks,:);% % CC's trimmed 
%bt_array = zscore(bt_array,[],1);% For ROI
bt_array = zscore(bt_array,[],2); % for Task, 
bt_lbls = {subBeta.r_labels subBeta.t_labels};


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

this_mat = all_keeps{roi_or_task};
this_lbls = bt_lbls{roi_or_task};
these_mats = {all_keeps{roi_or_task} all_noise{roi_or_task}};
disp('all set up, ready to bootstrap');
            m = squeeze(mean(this_mat,1));
            newvec = get_triu(m);
            Z = linkage(1-newvec,'ward');
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
n_perms = 100;
repvect = [1:10:n_perms];
for perm_ind = 1:n_perms;
    if ismember(perm_ind,repvect);disp(sprintf('%s percent complete',num2str(perm_ind / n_perms * 100)));end
for signal_or_noise = 1:2;
this_mat = these_mats{signal_or_noise};
split_pool = [];
split_subs = [];
fid_mat_all(signal_or_noise,perm_ind,:,:) = zeros(size(this_mat,3),size(this_mat,3));
subpool = randperm(length(subs));
split_pool(:,1) = subpool(1:10);
split_pool(:,2) = subpool(11:20);

split_subs(:,1) = split_pool(randi(10,10,1),1);
split_subs(:,2) = split_pool(randi(10,10,1),2);

xx = [];
for split_ind = 1:2;
perm_mat = this_mat(split_subs(:,split_ind),:,:);
perm_mat = squeeze(mean(perm_mat,1));
newVec = get_triu(perm_mat);
Z = linkage(1-newVec,'ward');
h;
[l x perm] = dendrogram(Z,numclust);
xx(:,split_ind) = x;
end % ends split 

% add consensus
l = nchoosek(1:size(this_mat,2),2);
for i = 1:length(l);
fid_mat_all(signal_or_noise,perm_ind,l(i,1),l(i,2)) = fid_mat_all(signal_or_noise,perm_ind,l(i,1),l(i,2)) + [xx(l(i,1),1) == xx(l(i,2),1) && xx(l(i,1),2) == xx(l(i,2),2)];
fid_mat_all(signal_or_noise,perm_ind,l(i,2),l(i,1)) = fid_mat_all(signal_or_noise,perm_ind,l(i,1),l(i,2));
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
figure(2);
r = squeeze(sum(fid_mat_all(1,:,:,:),2));
r = r ./ perm_ind;
newVec = get_triu(r);
Z = linkage(1-newVec);
subplot(1,2,1);
[h x perm] = dendrogram(Z,'labels',this_lbls,'orientation','left');
ord = perm(end:-1:1);
size(r);
subplot(1,2,2);
add_numbers_to_mat(r(ord,ord),this_lbls(ord));
title({'Permutation Clustering' [num2str(perm_ind) ' Permutations']},'FontSize',20);



