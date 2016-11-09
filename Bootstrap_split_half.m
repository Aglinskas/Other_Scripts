%% Setup
clear all
loadMR
size(subBeta.array)
clear keep
noise = rand(size(subBeta.array));

warning('off','stats:linkage:NotEuclideanMatrix')
%%
w_t = 1:10;
%w_rois = [ 2     4     8    10    14    15    17    19    20];
w_rois = subBeta.goodinds
%subBetaArray = noise ;
for ss = 1:size(subBeta.array,3)
    keep.task(:,:,ss) = corr(subBeta.array(w_rois,w_t,ss));
    keep.roi(:,:,ss) = corr(subBeta.array(w_rois,w_t,ss)');
    %keepnoise.task(:,:,ss) = corr(noise(w_rois,w_t,ss));
    %keepnoise.roi(:,:,ss) = corr(noise(w_rois,w_t,ss)');
end

choose.m = {keep.task keep.roi}
choose.l = {{subBeta.taskLabels{w_t}} {subBeta.RoiLabels{w_rois}}}
choose.choice = 2%

this.matrix = choose.m{choose.choice}
this.labels = choose.l{choose.choice}
this.dim_to_permute = 3
this.numClust = 3
this.fidelity_matrix = zeros(size(mean(this.matrix,this.dim_to_permute)));
% Split Half
nperms = 10000;
set(0,'DefaultFigureVisible','off')
for perm_ind = 1:nperms
    disp(sprintf('Permutation %d/%d',perm_ind,nperms))
subs.allsubs = 1:size(this.matrix,this.dim_to_permute);
subs.myGround = randi(size(this.matrix,this.dim_to_permute),1,10);
subs.myRand = subs.allsubs(ismember(subs.allsubs,subs.myGround) == 0);
% Ground Clustering 
% newVec = get_triu(mean(this.matrix(:,:,subs.myGround),3));
newVec = get_triu(mean(this.matrix(:,:,subs.myGround),3));
Z = linkage(1-newVec,'ward');
[h x.ground] = dendrogram(Z,this.numClust);

%permclustering
newVec = get_triu(mean(this.matrix(:,:,subs.myRand),3));
Z = linkage(1-newVec,'ward');
[h x.perm] = dendrogram(Z,this.numClust);
%
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
%
set(0,'DefaultFigureVisible','off')
newVec = get_triu(this.fidelity_matrix);
Z = linkage(1-newVec,'complete');
d = figure(9)
[h x.final] = dendrogram(Z);
x.final_ord = str2num(d.CurrentAxes.XTickLabel)
%set(0,'DefaultFigureVisible','on')
%%
figure(9)
add_numbers_to_mat(this.fidelity_matrix(x.final_ord,x.final_ord) ./perm_ind * 100,{this.labels{x.final_ord}})
sch =  figure(10)
schemaball({this.labels{x.final_ord}},this.fidelity_matrix(x.final_ord,x.final_ord) ./perm_ind)
sch.CurrentAxes.LineWidth = 5
figure(11)
clf
White_schema({this.labels{x.final_ord}},(this.fidelity_matrix(x.final_ord,x.final_ord) ./perm_ind * 100) > 1)
set(0,'DefaultFigureVisible','on')

%%
figure
imagesc(mean(this.matrix(x.final_ord,x.final_ord),3))

%%
%figure
a = this.fidelity_matrix(x.final_ord,x.final_ord);
%%
inds = [15:18];
mean(get_triu(a(inds,inds))' ./ perm_ind * 100)


