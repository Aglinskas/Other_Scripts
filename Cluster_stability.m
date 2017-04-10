clear all
loadMR;
numclust = 3;
roi_or_task = 2;
n_perms = 100;
w_tasks = [1:10];
w_rois = 1:18;
dim_to_permute = 3;
h = figure(6);set(h, 'Visible', 'off');
%
warning('off','stats:linkage:NotEuclideanMatrix');
bt_array = subBeta.array;
bt_array = bt_array-repmat(bt_array(:,11,:),1,12); %face subtracted
bt_array = bt_array(w_rois,w_tasks,:);% % CC's trimmed 
%if roi_or_task == 1
%bt_array = zscore(bt_array,[],2); % Task mean is 0
%elseif roi_or_task == 2
%bt_array = zscore(bt_array,[],1);% Mean of ROI is 0
%end


bt_lbls = {subBeta.r_labels subBeta.t_labels};

mn = mean(bt_array,3);
mf = figure(38);add_numbers_to_mat(mn,t_labels(1:10),r_labels)
mf.CurrentAxes.FontSize = 14
mf.CurrentAxes.FontWeight = 'bold'
mf.CurrentAxes.XTickLabelRotation =  25

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
these_mats = {all_noise{roi_or_task} all_noise{roi_or_task}};
disp('all set up, ready to bootstrap');
            m = squeeze(mean(this_mat,1));
            newvec = get_triu(m);
            Z = linkage(1-newvec,'ward');
            mb = figure(1);
            d = subplot(1,2,1);
            [h x perm_ind] = dendrogram(Z,'labels',this_lbls,'orientation','left');
            [h(1:end).LineWidth] = deal(3)
            d.FontSize = 13
            d.FontWeight = 'bold'
            mm = subplot(1,2,2);
            ord = perm_ind(end:-1:1);
            add_numbers_to_mat(m(ord,ord),this_lbls(ord));
            mm.FontSize = 13
            mm.FontWeight = 'bold'
            mm.XTickLabelRotation = 45
            drawnow;
            title({'Master Clustering' 'All subs'},'FontSize',20);
            t=figure;set(t,'visible','off');
            h;
            
ofn = '/Users/aidasaglinskas/Desktop/lol_betas/';
saveas(mf,[ofn datestr(datetime)],'png')
saveas(mb,[ofn datestr(datetime)],'png')
%% Task Cluster Stability
this_mat;
% ^ this_mat is [20 by 10 by 10] correlation matrix;
sort_mat = this_mat(:,ord,ord);
% ^ sort the matrix so it looks like it is on the dendrogram; 
% 1:5 becomes the first cluster, 6:10

inds_a = [1:4]%[1:2:10]%[1:5]; % first cluster tasks (null:[1:2:10])
inds_b = [5:10]%[2:2:10]%[6:10]; % second cluster tasks (null:[2:2:10])

%inds_a = [1:5];
%inds_b = [6:10];

within_a = [];
within_b = [];
across = [];
for i = 1:20; % loop through subjects
within_a(i,1) = mean(get_triu(squeeze(sort_mat(i,inds_a,inds_a)))');
within_b(i,1) = mean(get_triu(squeeze(sort_mat(i,inds_b,inds_b)))');
% get means of the upper triangle for within
across(i,1) = mean(mean((squeeze(sort_mat(i,inds_a,inds_b)))'));
% across square values, mean to a single number per subject
end
[H,P,CI,STATS] = ttest(mean([within_a within_b],2),across);
disp(sprintf('T: %s',num2str(STATS.tstat)))
disp(sprintf('p: %s',num2str(P)))
%^ttest mean of within_a and within_b against across
%%
% figure(2)
% add_numbers_to_mat(squeeze(mean(sort_mat)))

%Y = inconsistent(Z,1)
%% ROI stability 
this_mat;
% ^ this_mat is [20 by 10 by 10] correlation matrix;
sort_mat = this_mat(:,ord,ord);
% ^ sort the matrix so it looks like it is on the dendrogram; 
s = Shuffle(1:18) % Shuffle to get random clusters
%inds_a = s(1:6)% % random clusters
%inds_b = s(7:12)%
%inds_c = s(13:18)%

inds_a = [1:4] %amy-Fp
inds_b = [5:10] % DMN
inds_c = [11:18] % core -att

within_a = []; %amy 
within_b = []; %
within_c = [];
across_a_b = [];
across_a_c = [];
across_b_c = [];
for i = 1:20; % loop through subjects
within_a(i,1) = mean(get_triu(squeeze(sort_mat(i,inds_a,inds_a)))');
within_b(i,1) = mean(get_triu(squeeze(sort_mat(i,inds_b,inds_b)))');
within_c(i,1) = mean(get_triu(squeeze(sort_mat(i,inds_c,inds_c)))');

across_a_b(i,1) = mean(mean(squeeze(sort_mat(i,inds_a,inds_b)))');
across_a_c(i,1) = mean(mean(squeeze(sort_mat(i,inds_a,inds_c)))');
across_b_c(i,1) = mean(mean(squeeze(sort_mat(i,inds_b,inds_c)))');
end
[H,P,CI,STATS] = ttest(mean([within_a within_b within_c],2),mean([across_a_b across_a_c across_b_c],2));

disp(sprintf('T: %s',num2str(STATS.tstat)))
disp(sprintf('p: %s',num2str(P)))
%%
[H,P,CI,STATS] = ttest(across_a_b,across_b_c);
STATS.tstat
P
%%












