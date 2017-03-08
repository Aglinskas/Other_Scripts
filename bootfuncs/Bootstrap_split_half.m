%% Setup
clear all
loadMR
warning('off','stats:linkage:NotEuclideanMatrix')

% Noise == Permuted Subbeta;
noise = [];
for r = 1:18
for s = 1:20
rng(randi(100000))
noise(r,:,s) = subBeta.array(r,[randperm(10) 11 12],s);
end
end
subBeta.array = subBeta.array - subBeta.array(:,11,:);
%subBeta.array = zscore(subBeta.array,[],1)
subBeta.array = zscore(subBeta.array,[],2)
noise = noise - noise(:,11,:);
%noise = zscore(noise,[],1);
noise = zscore(noise,[],2);
%% Permute, noise 
null_runs = 10;
this.numClust = 3
nperms = 100;
%
w_t = 1:10;
subBeta.goodinds = [1:18]
w_rois = subBeta.goodinds;
clear keep
for ss = 1:size(subBeta.array,3)
    keep.task(:,:,ss) = corr(subBeta.array(w_rois,w_t,ss));
    keep.roi(:,:,ss) = corr(subBeta.array(w_rois,w_t,ss)');
    keepnoise.task(:,:,ss) = corr(noise(w_rois,w_t,ss));
    keepnoise.roi(:,:,ss) = corr(noise(w_rois,w_t,ss)');
end

choose.m = {keep.task keep.roi}
choose.l = {{subBeta.t_labels{w_t}} {subBeta.r_labels{w_rois}}}
choose.choice = 2%

this.matrix = choose.m{choose.choice}
this.labels = choose.l{choose.choice}
this.dim_to_permute = 3
this.fidelity_matrix = zeros(size(mean(this.matrix,this.dim_to_permute)));
% Split Half
set(0,'DefaultFigureVisible','off')
for perm_ind = 1:nperms
    disp(sprintf('Permutation %d/%d',perm_ind,nperms))
subs.allsubs = 1:size(this.matrix,this.dim_to_permute);
subs.myGround = randi(size(this.matrix,this.dim_to_permute),1,10);
subs.myRand = datasample(subs.allsubs(ismember(subs.allsubs,subs.myGround) == 0),10);

% Ground Clustering 
newVec = get_triu(mean(this.matrix(:,:,subs.myGround),3));
%newVec = get_triu(mean(this.matrix(:,:,subs.myGround),3));
Z = linkage(1-newVec,'ward');
[h x.ground] = dendrogram(Z,this.numClust);

%permclustering
%newVec = get_triu(mean(this.matrix(:,:,subs.myRand),3)); %REAL
newVec = get_triu(mean(this.matrix(:,:,subs.myRand),3)); %RAND
Z = linkage(1-newVec,'ward');
[h x.perm] = dendrogram(Z,this.numClust);
%
%%
pairs = nchoosek(1:length(this.labels),2);
for p_ind = 1:length(pairs)
roi_pair = pairs(p_ind,:);
%[x.ground x.perm]
fid_score = x.ground(roi_pair(1)) == x.ground(roi_pair(2)) && x.perm(roi_pair(1)) == x.perm(roi_pair(2));
this.fidelity_matrix(roi_pair(1),roi_pair(2)) = this.fidelity_matrix(roi_pair(1),roi_pair(2)) + fid_score;
% mirror
this.fidelity_matrix(roi_pair(2),roi_pair(1)) = this.fidelity_matrix(roi_pair(1),roi_pair(2));
end
end
%%
%% FINAL ORDERING AND PLOTTING
set(0,'DefaultFigureVisible','off')
newVec = get_triu(this.fidelity_matrix);
Z = linkage(1-newVec,'complete');
d = figure(13)
[h x.final] = dendrogram(Z);
x.final_ord = str2num(d.CurrentAxes.XTickLabel)
set(0,'DefaultFigureVisible','on')
%% compare to null
null = boot_func_get_null_distribution(noise,null_runs,this.numClust,nperms);

figure(9)
clf
subplot(1,2,1)
fmat = this.fidelity_matrix(x.final_ord,x.final_ord) ./perm_ind * 100;
imagesc(fmat)
add_numbers_to_mat(fmat,{this.labels{x.final_ord}})
title('Probability clustering probability');
% Pvalues 
for r = 1:size(fmat,1)
for c = 1:size(fmat,2)
pmat(r,c) = length(find(null.vect >= fmat(r,c))) / length(null.vect);
end
end
subplot(1,2,2)
add_numbers_to_mat(pmat,{this.labels{x.final_ord}});
title('pmatrix')