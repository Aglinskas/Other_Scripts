clear all
loadMR
size(subBetaArray)
% Random effects
clear keep
w_t = 1:10;
w_rois = [1 2 3 4 7 8 9 10 11 12 13 14 15 16 17 18 19 20]
for ss = 1:size(subBetaArray,3)
    keep.task(:,:,ss) = corr(subBetaArray(w_rois,w_t,ss));
    keep.roi(:,:,ss) = corr(subBetaArray(w_rois,w_t,ss)');
end

this.matrix = keep.roi
roi.indeces = [ 1     2     3     4     7     8     9    10    11    12    13    14    15    16    17    18    19    20]
this.labels = {master_coords_labels{roi.indeces}}
this.dim_to_permute = 3
%%
perm_ind = 1

subs = randi(size(this.matrix,this.dim_to_permute),1,size(this.matrix,this.dim_to_permute));
newVec = get_triu(mean(this.matrix(:,:,subs),3))
Z = linkage(1-newVec,'ward');
dendrogram(Z)
%%
clear atlas;
atlas.Z = Z;
temp.d = size(this.matrix,1) + 1 : size(this.matrix,1) + length(Z);
atlas.Z(:,4) = deal(temp.d);
atlas.atlas = cell(length(Z),2);

        for c = [1 2]
        for r = 1:length(atlas.Z)
if atlas.Z(r,c) < atlas.Z(1,4)
atlas.atlas{r,c} = atlas.Z(r,c)
else
r_temp = r
    while atlas.Z(r_temp,c) < atlas.Z(1,4) == 0
        for c = [1 2]
    r_temp = find(atlas.Z(:,4) == atlas.Z(r_temp,c))    
    atlas.atlas{r,c} = [atlas.atlas{r,c} atlas.Z(r_temp,[1 2])]
        end
    end
end     
        end
        end
    %%
%[atlas([1:size(this.matrix,1)],[1])] = deal([1:size(this.matrix,1)])
%[atlas([1:size(this.matrix,1)],[2])] = deal([1:size(this.matrix,1)])
%[atlas([1:size(this.matrix,1)],[3])] = deal(0)
%% Re-use code
clear clust_list
n_rois = length(this.labels)
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