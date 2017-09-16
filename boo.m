% Dendrograms
loadMR;
roi_or_task = 2;
mat = aBeta.fmat;
mat = zscore(mat,[],2)
% R null
mat_rs = [];
mat_ts = [];
for r = 1:size(mat,1)
for s = 1:size(mat,3)
mat_rs(r,:,s) = mat(r,Shuffle(1:size(mat,2)),s);
end
end
% T null
null_mat = {};
for t = 1:size(mat,2)
for s = 1:size(mat,3)
mat_ts(:,t,s) = mat(Shuffle(1:size(mat,1)),t,s);
end
end
null_mat = {mat_rs mat_ts};
null_mat = null_mat{roi_or_task};
%
albls = {aBeta.r_lbls aBeta.t_lbls(1:10)};
%Dendrogram
cmat = [];
ncmat = [];
for i = 1:20
if roi_or_task == 1
cmat(:,:,i) = corr(mat(:,:,i)');% rois
ncmat(:,:,i) = corr(null_mat(:,:,i)');% rois
elseif roi_or_task == 2
cmat(:,:,i) = corr(mat(:,:,i));% task
ncmat(:,:,i) = corr(null_mat(:,:,i));% rois
end
end
acmat = mean(cmat,3);
newVec = get_triu(acmat);
Z = linkage(1-newVec,'ward');
this_lbls =albls{cellfun(@length,albls) == size(acmat,1)};
d = figure(3)
[h x perm] = dendrogram(Z,'labels',this_lbls);
[h(1:end).LineWidth] = deal(3);
d.CurrentAxes.XTickLabelRotation = 45;
d.CurrentAxes.FontSize = 12;
d.CurrentAxes.FontWeight = 'bold'
box off
{'Regional' 'Task'};title([ans{roi_or_task} ' Similarity'],'FontSize',20)
d.CurrentAxes.YAxis.Label.String = 'Dissimilarity'
tr = 1
d.Color = [tr tr tr]
d.CurrentAxes.Color = [tr tr tr];
%Add colour 
if roi_or_task == 1
c_inds = [1 2 2 1 2 1 2 3 1 1 2 1 3 1 2 3 1 1];
c = {[1 0 0] [0 1 0] [.5 0 1]}
thick_inds = [19 20];

[h(1:length(c_inds)).Color] = deal(c{c_inds})
[h(thick_inds).LineWidth] = deal(h(1).LineWidth*2);

elseif roi_or_task == 2
%     ticklabels = get(gca,'XTickLabel');
%     ticklabels_new = cell(size(ticklabels));
%     ccc = { 'green' 'green' 'red' 'red' 'magenta' 'magenta' 'blue' 'cyan' 'blue' 'cyan'}
%     for i = 1:length(ticklabels)
%         cc = ccc{i};
%     ticklabels_new{i} = ['\' sprintf('color{%s} ',num2str(cc))  ticklabels{i}]
%     end
%     set(gca, 'XTickLabel', ticklabels_new);
%     thick_inds = [8 9];
%     [h(thick_inds).LineWidth] = deal(h(1).LineWidth*2);
thick_inds = [8 9]
[h(thick_inds).LineWidth] = deal(h(1).LineWidth*2);
end
% New Bootstrapp

% albls
% cmat
% this_lbls
all_mat = [];
for data_or_null = 1:2;
    {'data' 'null'};
    disp(sprintf('Running %s %d/2',ans{data_or_null},data_or_null))
for obs_iter = 1:20;
    disp(sprintf('Observation %d/20',obs_iter))
perm_struct = [];
dist = [];
subjpool = [];
perm_struct.params.nclust = [3 3];
perm_struct.params.nperms = 1000;
perm_struct.params.nsubs = 10;
perm_struct.permMat = zeros(perm_struct.params.nperms,size(cmat,1),size(cmat,1));
warning('off','stats:linkage:NotEuclideanMatrix') % Expecto Patronum those pesky warnings
for iter_ind = 1:perm_struct.params.nperms
    if ismember(iter_ind,0:perm_struct.params.nperms/10:perm_struct.params.nperms);disp(sprintf('%d/%d',iter_ind/perm_struct.params.nperms * 100,100));end
    
subjpool(1,:) = randi(size(cmat,3),1,perm_struct.params.nsubs);
subjpool(2,:) = randi(size(cmat,3),1,perm_struct.params.nsubs);


% subjpool(1,:) = 1:20;
% subjpool(2,:) = 1:20;

    perm_struct.commonSubs(iter_ind) = sum(ismember(subjpool(1,:),subjpool(2,:)));
    perm_struct.poolCor(iter_ind) = corr(subjpool(1,:)',subjpool(2,:)');
    dist(1,:) = 1-get_triu(mean(cmat(:,:,subjpool(1,:)),3));
    wh_mat = {cmat ncmat};
    dist(2,:) = 1-get_triu(mean(wh_mat{data_or_null}(:,:,subjpool(2,:)),3));
    
[h x1 perm1] = dendrogram(linkage(dist(1,:),'ward'),perm_struct.params.nclust(roi_or_task));
[h x2 perm2] = dendrogram(linkage(dist(2,:),'ward'),perm_struct.params.nclust(roi_or_task));

tmat = zeros(size(cmat,1),size(cmat,1));
for i = 1:size(cmat,1)
r = (x1==x1(i)) & (x2==x2(i));
tmat(find(r),find(r)) = tmat(find(r),find(r))+1;
tmat(tmat>0)=1;
end
perm_struct.permMat(iter_ind,:,:) = tmat;


end % ends boot_iterations
all_mat(data_or_null,obs_iter,:,:) = squeeze(mean(perm_struct.permMat,1));
end % ends observ_iter
end % ends data null
% Plot
figure(1)
clf
perm_struct.meanMat = squeeze(mean(perm_struct.permMat,1));
[h x perm] = dendrogram(linkage(1-get_triu(perm_struct.meanMat)))
ord = perm(end:-1:1);
add_numbers_to_mat(perm_struct.meanMat(ord,ord),this_lbls(ord))
figure(2)
clf
disp('Done')
%%
C{1} = [ 7     8    11    12    13    14    15    16    20    21];
C{2} = [3     4     9    10];
C{3} = [1     2     5     6    17    18    19];
for d_t = 1:2
for ob = 1:20
for cc = 1:3
k(d_t,ob,cc) = mean(get_triu(squeeze(all_mat(d_t,ob,C{cc},C{cc}))));
end
end
end
%%

wm = squeeze(mean(all_mat(1,:,:,:),2));
add_numbers_to_mat(wm,this_lbls)
dendrogram(linkage(1-get_triu(wm)),'labels',this_lbls,'orientation','left')
%%
all_mat(1)


[H,P,CI,STATS] = ttest(k(1,:,3)',k(2,:,3)')

a = [];
a = all_mat(1,:,:,:) - all_mat(2,:,:,:);
a = squeeze(mean(a,2));

[h x perm] = dendrogram(linkage(1-get_triu(a),'ward'));
ord = perm(end:-1:1);

clf;add_numbers_to_mat(a(ord,ord),this_lbls(ord))




figure
clf;schemaball_play(this_lbls(ord),a(ord,ord))
clf;schemaball(this_lbls(ord),perm_struct.meanMat(ord,ord))