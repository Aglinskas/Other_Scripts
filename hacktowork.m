%% Load up, and define singmat
loadMR
masks_name = master_coords_labels
masks_name = cellfun(@(x) strrep(x,'_','-'),masks_name,'UniformOutput',0)
which_rois_to_cor = [1:length(masks_name)]
roi_names = masks_name;
lbls = {roi_names{which_rois_to_cor}}'
size(subBetaArray)
%% Create Keep
clear keep
which_subs = [1:8 9 10:20]
reducedBetaArray=(subBetaArray(which_rois_to_cor,1:10,which_subs));%subBetaArray(ROI,TASK,SUB)
for subj=1:size(reducedBetaArray,3)
   keep(subj,:,:)= corr(squeeze(reducedBetaArray(:,:,subj))','type', 'Pearson'); %the transpose is important reducedBetaArray(:,:,subj))'); 
end
%keep = keep(:,:,[1:8 10:20])
singmat = squeeze(mean(keep,1));

%%% feed roicormat instead of keep 
% a = all_roicormats(:,which_rois_to_cor,which_rois_to_cor);
% singmat = squeeze(mean(a,1));

% % % Create Region correlation matrix
% % % Should have an nroi by nroi array of correlations; 
% % % size(subBetaArray)
% % % 
% % % for sub = 1:size(subBetaArray,3)
% % % end
% % % To do it with MVPA decoding
% % % size(singmat)
% % % 
% % % corr(mean(subBetaArray(which_rois_to_cor,[1:10],:)))
% % % 
% % % singmat = squeeze(mean(all_roicormats(subvect,which_rois_to_cor,which_rois_to_cor),1));
% % % singmat = corr(mean(subBetaArray(which_rois_to_cor,[1:10],:),3)')
% % % keep = keep(:,which_rois_to_cor,which_rois_to_cor)
% % % 
% % % Keep has to be already define as the size that you want
%
%%
clear Task_Cor_Mat
%y = [1:12 15 18] % which rois
y = 1:18 % ROIS
tt = 1
subBetaArray = subBetaArray(:,:,:); % reduce subjects
%subBetaArray = subBetaArray(:,1:10,:);
for subject = 1:size(subBetaArray,3); % loop subjects
    for r = 1:size(subBetaArray,2); % loop task
        for c = 1:size(subBetaArray,2); % loop task
Task_Cor_Mat(subject,r,c) = corr(subBetaArray(y,r,subject),subBetaArray(y,c,subject),'type', 'Spearman');
        end
    end
end
squeeze(mean(Task_Cor_Mat,1))
%
keep = Task_Cor_Mat;
singmat = squeeze(mean(Task_Cor_Mat,1))
lbls = tasks(1:12)
which_rois_to_cor = 1:size(keep,2);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear newVec
cc=0;
for ii=1:length(singmat)
for jj=ii+1:length(singmat)
cc=cc+1;
newVec(cc)=singmat(ii,jj);
end
end
Z = linkage(1-newVec,'ward'); % one minus newvec is importnat
wanna_plot = 1; if wanna_plot == 1
dend_labeled = figure(6);
dendrogram(Z,'labels',lbls,'Orientation','left')
%dend_num = figure(7);
%dendrogram(Z,'Orientation','left');
end
%%% Figure out the clusters
%lbls
clear clust_list
n_rois = length(which_rois_to_cor);
clust_list = Z(:,[1 2]);
clust_list = [clust_list [n_rois + 1 : size(Z,1) + n_rois]'];
%Build clust atlas
clust_atlas = {};
to_deal = [1:max(clust_list(:))]';
to_deal = num2cell(to_deal);
[clust_atlas{1:max(clust_list(:)),1}] = deal(to_deal{:})
[clust_atlas{1:n_rois,2}] = deal(to_deal{1:n_rois})
% Make clust_atlas
for c =  n_rois+1:max(clust_list(:))
    c_prime = c; % indices, assemble! :D
    found = 0
    rois_in_clust = []
% if complex clust has already been worked out, just concatenate them
  clust_list(find(clust_list(:,3) == c),[1 2])
  if sum(ismember(cell2mat({clust_atlas{1:c,1}}'), clust_list(find(clust_list(:,3) == c),[1 2]))) == 2
      rr = clust_list(find(clust_list(:,3) == c),[1 2]);
      clust_atlas{c_prime,2} = [clust_atlas{rr,2}];
      found = 1;
  end
  % % 
  %% If not, work it out
while found == 0
clust_list(find(clust_list(:,3) == c),[1 2])
rois_in_clust = [rois_in_clust clust_list(find(clust_list(:,3) == c),[1 2])]
if rois_in_clust <= n_rois % if it's a cluster of a single ROI, it's just the ROI
    found = 1;
elseif rois_in_clust(1) > n_rois % if it's more than a single ROI, work it out
    c = rois_in_clust(1)
    % if it checks the first number and loops back the rois_in_clust(1))
    % is left huge and crashes the loop
    rois_in_clust(rois_in_clust == rois_in_clust(1)) = []
elseif rois_in_clust(2) > n_rois
    c = rois_in_clust(2)
    %rois_in_clust(2) = []
    rois_in_clust(rois_in_clust == rois_in_clust(2)) = []
end
if found == 1
   clust_atlas{c_prime,1} = c_prime;
   clust_atlas{c_prime,2} = rois_in_clust;
end
 end
end
%%% CLUSTERS TO COMPARE
%clust_pair = [37 36]
all_possible_clusters = []
all_possible_clusters = nchoosek(n_rois+1:max(clust_list(:))',2);
%all_possible_clusters = [27 19]
for c_perm_ind = 1:size(all_possible_clusters,1);

%     if c_perm_ind == 4
%         break 
%     end
    clust_pair = all_possible_clusters(c_perm_ind,:);

rois_to_comp{1} = clust_atlas{clust_pair(1),2}; %cell?
rois_to_comp{2} = clust_atlas{clust_pair(2),2};
% Withing cluster
within_clust_betas = [];
for r2c = 1:2
within_clust_pairs = nchoosek(rois_to_comp{r2c},2);
for r = 1: size(within_clust_pairs,1);
   within_clust_betas = [within_clust_betas keep(:,within_clust_pairs(r,1),within_clust_pairs(r,2))];
end
end
%within_clust_pairs
size(within_clust_betas)
% Between cluster
betweeen_clust_pairs = [0 0];
for bc1 = 1:length(rois_to_comp{1});
    for bc2 = 1:length(rois_to_comp{2});
    betweeen_clust_pairs = [betweeen_clust_pairs;rois_to_comp{1}(bc1) rois_to_comp{2}(bc2)];
    end
end
betweeen_clust_pairs(1,:) = [];

betweeen_clust_betas = [];
for r = 1: size(betweeen_clust_pairs,1)
   betweeen_clust_betas = [betweeen_clust_betas keep(:,betweeen_clust_pairs(r,1),betweeen_clust_pairs(r,2))];
end
betweeen_clust_pairs;
    
size(betweeen_clust_betas)
% Calculation
% top = 1-[keep(:,1,7) keep(:,1,17) keep(:,4,7) keep(:,4,17)]
% bottom = 1-[keep(:,1,4) keep(:,7,17)]
% 
% vals=[mean(top') -  mean(bottom') ]'
% mean(vals)./(std(vals)/20^.5)
% [H,P,CI,STATS] = ttest(vals)

% top = 1-betweeen_clust_betas;
% bottom = 1-within_clust_betas;

top = betweeen_clust_betas;
bottom = within_clust_betas;

vals= [(1-nanmean(top')) -  (1-nanmean(bottom'))]';
%[H,P,CI,STATS] = ttest(vals,0,'alpha',0.05 / size(all_possible_clusters,1));
[H,P,CI,STATS] = ttest(vals);
STATS
P

all_possible_clusters(c_perm_ind,3) = STATS.tstat;
%all_possible_clusters(c_perm_ind,3) = vals;
all_possible_clusters(c_perm_ind,4) = P;
all_possible_clusters(c_perm_ind,5) = H;

if max(betweeen_clust_betas(:)==1);
    all_possible_clusters(c_perm_ind,[3,4])=-666;
end
end
%all_possible_clusters = sortrows(all_possible_clusters,-3);
%keep(subject,roi,roi)
%% Epiloque
roi_pair = [24 25]

cind = find(all_possible_clusters(:,1) == roi_pair(2) & all_possible_clusters(:,2) == roi_pair(1));
if isempty(cind)
   cind = find(all_possible_clusters(:,1) == roi_pair(1) & all_possible_clusters(:,2) == roi_pair(2));end
all_possible_clusters(cind,:)
  


% cluster_table = {}
% wh_p = 153
% 
% 
% tt = {clust_atlas{all_possible_clusters(wh_p,[1 2]),2}}
% cluster_table{1,1} = {lbls{tt{1}}}
% cluster_table{1,2} = {lbls{tt{2}}}