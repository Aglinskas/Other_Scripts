loadMR
% %% Without Replacement [Defunct]
% tic
nsubs = 20;
select_how_many = 15; % how many subjects to permute
subject_pool = nchoosek([1:nsubs],select_how_many);
%%

%%
rng(GetSecs)
rng
%% With replacement
clear subject_pool
nperms = 100000;
tic
for i = 1:nperms
rep =[[1:nperms/10:nperms]';[1:1000:nperms]'];
if ismember(i,rep)
    disp([num2str(i*100 / nperms) ' % done']);end
subject_pool(i,:) = randi([1 20],[1 20]);
end
toc
%%
tic
t_s = GetSecs;
clear Bootstrapedkeep
for s = 1:size(subject_pool,1)
subjects = subject_pool(s,:);
which_rois_to_cor = 1:size(subBetaArray,1);
clear reducedBetaArray keep
reducedBetaArray=(subBetaArray(which_rois_to_cor,1:10,subjects));%subBetaArray(ROI,TASK,SUB)
for subj=1:size(reducedBetaArray,3);
   keep(subj,:,:)= corr(squeeze(reducedBetaArray(:,:,subj))','type', 'Spearman'); %the transpose is important reducedBetaArray(:,:,subj))'); 
end
Bootstrapedkeep(s,:,:)= squeeze(mean(keep,1));
report_vect = [0:size(subject_pool,1) / 100 * 10:size(subject_pool,1)]';
report_vect  = [report_vect;[0:500:size(subject_pool,1)]'];
if ismember(s,report_vect)
    perc = (100 * s) / size(subject_pool,1);
  disp([num2str(perc) ' % complete, in ' num2str(GetSecs - t_s) ' Seconds'])
end
end
save(['/Users/aidas_el_cap/Desktop/BootstrapedKeep' num2str(nperms) '_perms_' datestr(datetime) '.mat'],'Bootstrapedkeep','subject_pool')
disp('done')
toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Scotts Code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Master clustering (Ground truth)
loadMR
lbls = masks_name;
singmat = squeeze(mean(keep,1));
newVec = get_triu(singmat);
numClust=3; %number of clusters we care about
Z = linkage(1-newVec,'ward'); % one minus newvec is importnat
r = figure(9);
[h x] = dendrogram(Z,numClust);
close(r);
% x holds the roi classification
% h dend handle
for ii=1:numClust
    friendSet{ii}=lbls(x==ii);
    disp(['Cluster ' num2str(ii)])
    disp(friendSet{ii})
end % collects regions that are in clusters
% Permutes the clusters
%%
warning('off','stats:linkage:NotEuclideanMatrix')
for perm=1:size(Bootstrapedkeep,1) %number of permutations
%Z = linkage(1-newVec+rand(size(newVec))/10,'ward'); % my code goes here
if ismember(perm,[1:size(Bootstrapedkeep,1)/10:size(Bootstrapedkeep,1)])
    perc = find([1:size(Bootstrapedkeep,1)/10:size(Bootstrapedkeep,1)] == perm) * 10;
    disp([num2str(perc) '% done'])
end
newVec = get_triu(squeeze(Bootstrapedkeep(perm,:,:)));
Z = linkage(1-newVec,'ward');

[h x]=dendrogram(Z,numClust);

all_ord(:,perm) = x;
for ii=1:numClust
    stillFriends{ii}=lbls(x==ii);
end
for ii=1:numClust
    scoreClust(ii,perm)=0;
for jj=1:numClust
    if any(strcmp(stillFriends{jj},friendSet{ii}{1}));
        break
    end
end
try
    if all(strcmp(sort(friendSet{ii}),sort(stillFriends{jj})));
        scoreClust(ii,perm)=1;
    end
end
end
end
mn = mean(scoreClust,2);
disp('All done')
for ii = 1:numClust
    disp(['Cluster ' num2str(ii)])
    disp(['Reliability ' num2str(mn(ii))])
    disp(friendSet{ii})
end
%% Manually Check Cluster replicability
edit check_cluster_repricability
%%
%11    12     5     6    13    14     3     4     1     2    15    16    17    18     7     8     9    10
clust = [ 1     2    15    16    17    18 ];
for ind = 1:size(all_ord,2)
score(ind) = all(all_ord(clust,ind) == all_ord(clust(1),ind));
end
perc = sum(score) / size(all_ord,2) * 100
that_clustering  = find(score == 1)';
diff_clust = find(score == 0)';
%%
perm = diff_clust(3)
%perm = that_clustering(1)
newVec = get_triu(squeeze(Bootstrapedkeep(perm,:,:)));
Z = linkage(1-newVec,'ward');
dend_labeled = figure(6);
dendrogram(Z,'labels',lbls,'Orientation','left')

