%% Setup
clear all
loadMR
size(subBetaArray)
clear keep
w_t = 1:10;
w_rois = [1 2 3 4 7 8 9 10 11 12 13 14 15 16 17 18 19 20];

%noise = rand(size(subBetaArray));
%subBetaArray = noise;

for ss = 1:size(subBetaArray,3)
    keep.task(:,:,ss) = corr(subBetaArray(w_rois,w_t,ss));
    keep.roi(:,:,ss) = corr(subBetaArray(w_rois,w_t,ss)');
end
this.matrix = keep.roi
this.labels = {master_coords_labels{w_rois}}
this.dim_to_permute = 3
this.numClust = 3
this.fidelity_matrix = zeros(size(mean(this.matrix,this.dim_to_permute)));
% Split Half
nperms = 100;
set(0,'DefaultFigureVisible','off')
for perm_ind = 1:nperms
    disp(sprintf('Permutation %d/%d',perm_ind,nperms))
subs.allsubs = 1:size(this.matrix,this.dim_to_permute);
subs.myGround = randi(size(this.matrix,this.dim_to_permute),1,10);
subs.myRand = subs.allsubs(ismember(subs.allsubs,subs.myGround) == 0);
% Ground Clustering 
newVec = get_triu(mean(this.matrix(:,:,subs.myGround),3));
Z = linkage(1-newVec,'ward');
[h x.ground] = dendrogram(Z,this.numClust);

newVec = get_triu(mean(this.matrix(:,:,subs.myRand),3));
Z = linkage(1-newVec,'ward');
[h x.perm] = dendrogram(Z,this.numClust);
%
pairs = nchoosek(1:length(this.labels),2);
for p_ind = 1:length(pairs)
roi_pair = pairs(p_ind,:);
fid_score = x.ground(roi_pair(1)) == x.ground(roi_pair(2)) && x.perm(roi_pair(1)) == x.perm(roi_pair(2));
this.fidelity_matrix(roi_pair(1),roi_pair(2)) = this.fidelity_matrix(roi_pair(1),roi_pair(2)) + fid_score;

% mirror
this.fidelity_matrix(roi_pair(2),roi_pair(1)) = this.fidelity_matrix(roi_pair(1),roi_pair(2));
end
end
%
set(0,'DefaultFigureVisible','off')
newVec = get_triu(this.fidelity_matrix);
Z = linkage(1-newVec,'complete');
d = figure(9)
[h x.final] = dendrogram(Z);
x.final_ord = str2num(d.CurrentAxes.XTickLabel)
set(0,'DefaultFigureVisible','on')
figure(9)
add_numbers_to_mat(this.fidelity_matrix(x.final_ord,x.final_ord) ./perm_ind * 100,{this.labels{x.final_ord}})

