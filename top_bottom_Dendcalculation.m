which_rois = [1,4,17,7]
size(keep)

rFFA_lFFA = keep(:,1,4)
%%
top = 1-[keep(:,1,7) keep(:,17) keep(:,4,7) keep(:,4,17)]
bottom = 1-[keep(:,1,4) keep(:,7,17)]

vals=[mean(top') -  mean(bottom') ]'
mean(vals)./(std(vals)/20^.5)

%%
cd /Volumes/Aidas_HDD/MRI_data/
loadMR
size(submats)
subvect
which_rois_to_cor = 2:20
{roi_names{which_rois_to_cor}}'
singmat = squeeze(mean(all_roicormats(subvect,which_rois_to_cor,which_rois_to_cor),1));
size(singmat)
%


lbls = {roi_names{which_rois_to_cor}}';
clear newVec
cc=0;
for ii=1:length(singmat)
for jj=ii+1:length(singmat)
cc=cc+1;
newVec(cc)=singmat(ii,jj);
end
end
Z = linkage(newVec,'ward')
figure(6);
dendrogram(Z,'labels',lbls,'Orientation','left')
figure(7);
dendrogram(Z,'Orientation','left')
%% Figure out the clusters
lbls
n_rois = length(which_rois_to_cor);
clust_list = Z(:,[1 2]);
clust_list = [clust_list [20 : size(Z,1) + 19]']

%% Build clust atlas
clust_atlas = {}
to_deal = [1:max(clust_list(:))]';
to_deal = num2cell(to_deal);
[clust_atlas{1:max(clust_list(:)),1}] = deal(to_deal{:})
[clust_atlas{1:n_rois,2}] = deal(to_deal{1:n_rois})
%% Make clust_atlas
for c = 37 %n_rois+1:max(clust_list(:))
    c_prime = c;
    found = 0
    rois_in_clust = []
    
  %
  % add code here to check if there's prev entry in the list; 
  % if both comb rois are in the previous list; concatenate them isntead 
  %
  %% finish this after ice cream ?\_(?)_/?
  clust_list(find(clust_list(:,3) == c),[1 2])
  if sum(ismember(cell2mat({clust_atlas{1:c,1}}'), clust_list(find(clust_list(:,3) == c),[1 2]))) == 2
  
      rr = clust_list(find(clust_list(:,3) == c),[1 2]);
      clust_atlas{c_prime,2} = [clust_atlas{rr,2}];
      found = 1;
  end
%   
%   clust_atlas{c_prime,1} = c_prime;
%    clust_atlas{c_prime,2} = rois_in_clust
  %%
  
while found == 0
clust_list(find(clust_list(:,3) == c),[1 2])
rois_in_clust = [rois_in_clust clust_list(find(clust_list(:,3) == c),[1 2])]
if rois_in_clust <= n_rois
    found = 1;
elseif rois_in_clust(1) > n_rois
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
   clust_atlas{c_prime,2} = rois_in_clust
end
 end
end
%%



