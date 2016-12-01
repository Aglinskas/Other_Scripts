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
nperms = 100;
this.fidelity_matrix = zeros(size(mean(this.matrix,this.dim_to_permute)));
% Split Half
set(0,'DefaultFigureVisible','off')
for perm_ind = 1:nperms
    disp(sprintf('Permutation %d/%d',perm_ind,nperms))
subs.allsubs = 1:size(this.matrix,this.dim_to_permute);
subs.myGround = randi(size(this.matrix,this.dim_to_permute),1,10);
%subs.myRand = subs.allsubs(ismember(subs.allsubs,subs.myGround) == 0); %~10
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
%%
figure(9)
clf
%subplot(1,2,1)
fmat = this.fidelity_matrix(x.final_ord,x.final_ord) ./perm_ind * 100;
%fmat = fmat - 100 / this.numClust;
%fmat(fmat<0) = 0;
%subplot(1,2,1)
add_numbers_to_mat(fmat,{this.labels{x.final_ord}})
title('Probability above chance')
%%
load('/Users/aidasaglinskas/Desktop/10k_vars.mat')
this_noise.chance

null =this_noise.chance(:); 
%size(this_noise.chance(:),1)
for r = 1:18
for c = 1:18
pmat(r,c) = length(find(null >= fmat(r,c))) / length(null);
end
end
add_numbers_to_mat(pmat,{this.labels{x.final_ord}})
%% Schemaball(s)
% sch =  figure(10)
% clf
% schemaball({this.labels{x.final_ord}},this.fidelity_matrix(x.final_ord,x.final_ord) ./perm_ind)
% sch.CurrentAxes.LineWidth = 5
% figure(11)
% clf
% White_schema({this.labels{x.final_ord}},(this.fidelity_matrix(x.final_ord,x.final_ord) ./perm_ind * 100) > 1)
% set(0,'DefaultFigureVisible','on')
% %% Chi mat
% chi_mat = ones(size(this.fidelity_matrix))
% for r = 1:size(this.fidelity_matrix);
%     for c = 1:size(this.fidelity_matrix);
% %if this.fidelity_matrix(r,c) > nperms / this.numClust
% rv = [ones(nperms/2,1);zeros(nperms/2,1)];
% v = [ones(this.fidelity_matrix(r,c),1);zeros(nperms - this.fidelity_matrix(r,c),1)];
% %[h,p,st] = chi2gof(v);
% v(v==3) = 0;
% rv(rv==3) = 0;
% %[tbl,chi2stat,pval] = crosstab(v,rv);
% [h,p,st] = chi2gof(v,'expected',[nperms-nperms/this.numClust nperms/this.numClust]);
% chi_mat(r,c) = p;
% end
%     end
% %end
% figure(1)
% clf
% %subplot(1,2,2)
% add_numbers_to_mat(chi_mat(x.final_ord,x.final_ord),{this.labels{x.final_ord}})