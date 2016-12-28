function null = boot_func_get_null_distribution(noise,nruns,numClust,nperms)
%function null = boot_func_get_null_distribution(noise,nruns,this.numClust)
%this.numClust = 3
%nperms = 100;
%nruns = 3
this.numClust = numClust;
%noise = rand(size(subBeta.array));
%% Setup
loadMR
for i = 1:nruns
disp(sprintf('Estimating null distribution: run %d/%d',i,nruns))
loadMR
%size(subBeta.array)
%clear keep
subBeta.goodinds = [1:18];
warning('off','stats:linkage:NotEuclideanMatrix')
w_t = 1:10;
w_rois = subBeta.goodinds;
for ss = 1:size(subBeta.array,3)
    keep.task(:,:,ss) = corr(subBeta.array(w_rois,w_t,ss));
    keep.roi(:,:,ss) = corr(subBeta.array(w_rois,w_t,ss)');
    keepnoise.task(:,:,ss) = corr(noise(w_rois,w_t,ss));
    keepnoise.roi(:,:,ss) = corr(noise(w_rois,w_t,ss)');
end
choose.m = {keep.task keep.roi};
choose.l = {{subBeta.t_labels{w_t}} {subBeta.r_labels{w_rois}}};
choose.choice = 2;%
this.matrix = choose.m{choose.choice};
this.labels = choose.l{choose.choice};
this.dim_to_permute = 3;
this.fidelity_matrix = zeros(size(mean(this.matrix,this.dim_to_permute)));
% Split Half
set(0,'DefaultFigureVisible','off');
for perm_ind = 1:nperms
   % disp(sprintf('Permutation %d/%d',perm_ind,nperms))
subs.allsubs = 1:size(this.matrix,this.dim_to_permute);
subs.myGround = randi(size(this.matrix,this.dim_to_permute),1,10);
%subs.myRand = subs.allsubs(ismember(subs.allsubs,subs.myGround) == 0); %~10
subs.myRand = datasample(subs.allsubs(ismember(subs.allsubs,subs.myGround) == 0),10);

% Ground Clustering 
newVec = get_triu(mean(keepnoise.roi(:,:,subs.myGround),3));
%newVec = get_triu(mean(this.matrix(:,:,subs.myGround),3));
Z = linkage(1-newVec,'ward');
[h x.ground] = dendrogram(Z,this.numClust);
%permclustering
%newVec = get_triu(mean(this.matrix(:,:,subs.myRand),3)); %REAL
newVec = get_triu(mean(keepnoise.roi(:,:,subs.myRand),3)); %RAND
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
%% plot running average
try 
    keep_fmat;
catch 
    keep_fmat(1,:,:) = this.fidelity_matrix;
end
lk = size(keep_fmat,1);
keep_fmat(i,:,:) = this.fidelity_matrix;
mkeep_fmat = squeeze(mean(keep_fmat,1));
figure(8)
add_numbers_to_mat(mkeep_fmat,r_labels)
title({'Running Average of Fidelity Matrix' sprintf('Run %d',i)})
%%
% FINAL ORDERING AND PLOTTING
set(0,'DefaultFigureVisible','off');
newVec = get_triu(this.fidelity_matrix);
Z = linkage(1-newVec,'complete');
d = figure(13);
[h x.final] = dendrogram(Z);
x.final_ord = str2num(d.CurrentAxes.XTickLabel)
set(0,'DefaultFigureVisible','on')
%
figure(9);
clf;
subplot(1,2,1);
fmat = this.fidelity_matrix(x.final_ord,x.final_ord) ./perm_ind * 100;
%subplot(1,2,1)
add_numbers_to_mat(fmat,{this.labels{x.final_ord}})
%%
title(['Clustering Probability' ['i = ' num2str(i)]])
subplot(1,2,2)
%hist(get_triu(this.fidelity_matrix))
hist(get_triu(fmat))
null.fmat = fmat;

try 
this.chance;
catch
this.chance = []
end
l = size(this.chance,1) + 1;
this.chance(l,:) = get_triu(fmat)';
drawnow
%disp(['RUN ' num2str(i)])
end
%%
figure(9);
clf 
subplot(1,2,1)
hist(this.chance(:))
ttl = {'noise distribution' sprintf('%d runs',i) sprintf('%d permutations each',nperms)};
title(ttl)
subplot(1,2,2)
%hist(zscore(this.chance(:)))
null.vect = this.chance(:);
null.mean = mean(null.vect);
null.std = std(null.vect);
%subplot(1,3,3)
null.z = (null.vect - null.mean) / null.std;
hist(null.z)
title('Noise Z dist')
%save('/Users/aidasaglinskas/Desktop/10k_wrkspc.mat')

%save('/Users/aidasaglinskas/Desktop/10k_vars.mat','this_noise')

