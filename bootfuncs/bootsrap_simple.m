%% Setup
clear all
loadMR
size(subBeta.array)
clear keep
noise = rand(size(subBeta.array));
subBeta.goodinds = [1:18]
warning('off','stats:linkage:NotEuclideanMatrix')
%%
w_t = 1:10;
%w_rois = [ 2     4     8    10    14    15    17    19    20];
w_rois = subBeta.goodinds
%subBetaArray = noise ;
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
this.numClust = 3
nperms = 1000;
this.fidelity_matrix = zeros(size(mean(this.matrix,this.dim_to_permute)));
% Split Half
set(0,'DefaultFigureVisible','off')
for perm_ind = 1:nperms
    disp(sprintf('Permutation %d/%d',perm_ind,nperms))
subs.allsubs = 1:size(this.matrix,this.dim_to_permute);
subs.myGround = randi(size(this.matrix,this.dim_to_permute),1,20);
%subs.myRand = subs.allsubs(ismember(subs.allsubs,subs.myGround) == 0); %~10
%subs.myRand = datasample(subs.allsubs(ismember(subs.allsubs,subs.myGround) == 0),10);

% Ground Clustering 
newVec = get_triu(mean(keepnoise.roi(:,:,subs.myGround),3));
%newVec = get_triu(mean(this.matrix(:,:,subs.myGround),3));
Z = linkage(1-newVec,'ward');
[h x.ground] = dendrogram(Z,this.numClust);
%
%

for c = 1:this.numClust
    this.fidelity_matrix(find(x.ground == c),find(x.ground == c)) = this.fidelity_matrix(find(x.ground == c),find(x.ground == c)) + 1;
end
end
%%
%% FINAL ORDERING AND PLOTTING
set(0,'DefaultFigureVisible','off')
newVec = get_triu(this.fidelity_matrix ./ perm_ind);
Z = linkage(1-newVec,'complete');
d = figure(13)
[h x.final] = dendrogram(Z);
x.final_ord = str2num(d.CurrentAxes.XTickLabel)
set(0,'DefaultFigureVisible','on')
%%
figure(9)
clf
subplot(1,2,1)
fmat = this.fidelity_matrix(x.final_ord,x.final_ord) ./perm_ind * 100;
%fmat = fmat - 100 / this.numClust;
%fmat(fmat<0) = 0;
%subplot(1,2,1)
add_numbers_to_mat(fmat,{this.labels{x.final_ord}})
title('Probability above chance')
    %randi([1 this.numClust],nperms,1);
    subplot(1,2,2)
load('/Users/aidasaglinskas/Desktop/null_params.mat');
zmat = (fmat - noise_mean) / noise_std;
add_numbers_to_mat(zmat,{this.labels{x.final_ord}})
title('Z matrix')