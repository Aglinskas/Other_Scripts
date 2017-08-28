%function func_runPlots2(aBeta)

%close all
%loadMR
clc
%close all
loadMR
a = get(0,'Children');for i = 1:length(a); clf(a(i));end
warning('off')
set(0, 'DefaultFigureVisible', 'on');
mats = {aBeta.fmat aBeta.trim.mat};
albls = {{aBeta.r_lbls aBeta.t_lbls(1:10)} {aBeta.trim.r_lbls aBeta.trim.t_lbls}};
analysis_name = '' % for expprt
for big_small = 1:2
    big_small_str = {'Full' 'Tiny'};
    mat = mats{big_small};
    lbls = albls{big_small};
    
% Mean Beta Array
    mat_zscored = zscore(mat,[],2);
    avg_mat = mean(mat_zscored,3);
    [2 3];avg_mat_fig = figure(ans(big_small));
add_numbers_to_mat(avg_mat,lbls{1},lbls{2});
    ttl = {'Average Beta Zscored' [big_small_str{big_small} ' Array']};
    fig_make_pretty(avg_mat_fig,ttl);
% T value array
tmat = [];
for r = 1:size(mat,1)
for t = 1:size(mat,2)
   this_vec = squeeze(mat(r,t,:));
   other_vec = squeeze(mean(mat(r,find(~ismember(1:size(mat,2),t)),:),2));
   [H,P,CI,STATS] = ttest(this_vec,other_vec);
   tmat(r,t) = STATS.tstat;
end
end
[4 5]; tmat_fig = figure(ans(big_small));
%tmat_fig = figure
add_numbers_to_mat(tmat,lbls{1},lbls{2});
fig_make_pretty(tmat_fig,{'Tmatrix'});
%% Dendrograms
for r_t = 1:2 % ROI Task
r_t_str = {'ROI' 'TASKS'};
r_t_mats = {permute(mat,[2 1 3]) mat};
%r_t_mats{1} = zscore(r_t_mats{1},[],1);
%r_t_mats{2} = zscore(r_t_mats{2},[],2);
r_t_mat = r_t_mats{r_t};
r_t_mat = zscore(r_t_mat,[],2); disp('Zscored')
%r_t_mat = zscore(r_t_mat,[],1);

cmat = [];
for i = 1:size(r_t_mat,3);
    cmat(:,:,i) = corr(r_t_mat(:,:,i));
end
avg_cmat = mean(cmat,3);
this_lbls = lbls{cellfun(@length,lbls) == size(cmat,1)};
dist = get_triu(1-avg_cmat);
%dist = pdist(1-avg_cmat);

Z = linkage(dist,'ward');
{[6 7] [8 9]};
dend = figure(ans{big_small}(r_t));
%dend = figure
subplot(1,2,2);
[h x perm] = dendrogram(Z,'labels',this_lbls,'orientation','left');
ord = perm(end:-1:1);
ttl = [big_small_str{big_small}  ' ' r_t_str{r_t} ' Dend'];
fig_make_pretty(dend,ttl);
subplot(1,2,1);
add_numbers_to_mat(avg_cmat(ord,ord),this_lbls(ord));
ttl = [big_small_str{big_small}  ' ' r_t_str{r_t} ' Cmat'];
%dend.Position = [3          77        1278         627];
fig_make_pretty(dend,ttl);
[h(1:end).LineWidth] = deal(3);


% Bootsrapping
perm_params.n_iters = 100;
perm_params.n_subs_to_sample = 10;
perm_params.n_clust = [3 3]; % ROI & TASK
perm_struct = struct;
temp_fig = figure(666);
temp_fig.Visible = 'off';
disp('Permuting')
for perm_ind = 1:perm_params.n_iters
repvec = 0:perm_params.n_iters / 10:perm_params.n_iters;
if ismember(perm_ind,repvec)
    perc = [perm_ind / perm_params.n_iters * 100];
   disp([num2str(perc)  '% Done']);
end
    
perm_cmat = cmat(:,:,randi(size(cmat,3),1,perm_params.n_subs_to_sample));
dist = 1-get_triu(mean(perm_cmat,3));
Z = linkage(dist,'ward');
Z_atlas = get_Z_atlas(Z,length(Z)+1);

perm_struct.dist_Mat(perm_ind,:,:) = zeros(size(perm_cmat,1),size(perm_cmat,1));
% Distance Matrix
for i = 1:size(Z_atlas,1) 
    perm_struct.dist_Mat(perm_ind,Z_atlas{i,1},Z_atlas{i,2}) = perm_struct.dist_Mat(perm_ind,Z_atlas{i,1},Z_atlas{i,2}) + Z_atlas{i,3};
    perm_struct.dist_Mat(perm_ind,Z_atlas{i,2},Z_atlas{i,1}) = perm_struct.dist_Mat(perm_ind,Z_atlas{i,2},Z_atlas{i,1}) + Z_atlas{i,3};
end

perm_struct.clust_Mat(perm_ind,:,:) = zeros(size(perm_cmat,1),size(perm_cmat,1));
[h x perm] = dendrogram(Z,perm_params.n_clust(r_t));
for i = unique(x)';
perm_struct.clust_Mat(perm_ind,find(x==i),find(x==i)) = perm_struct.clust_Mat(perm_ind,find(x==i),find(x==i))+1;
end
end % ends perm

%{[11 12] [13 14]};figure(ans{big_small}(r_t));
dendMat = squeeze(mean(perm_struct.clust_Mat,1));
distMat = squeeze(mean(perm_struct.dist_Mat,1));
%bmats = {distMat dendMat};


{[10 11] [12 13]};
m = figure(ans{big_small}(r_t));
subplot(2,2,2)
[h x perm] = dendrogram(linkage(get_triu(distMat)),'labels',this_lbls,'orientation','left');
ord = perm(end:-1:1)
m = subplot(2,2,1)
add_numbers_to_mat(distMat(ord,ord),this_lbls(ord))
subplot(2,2,4)
[h x perm] = dendrogram(linkage(1-get_triu(dendMat),'ward'),'labels',this_lbls,'orientation','left');
ord = perm(end:-1:1)
m = subplot(2,2,3)
add_numbers_to_mat(dendMat(ord,ord),this_lbls(ord))
end % ends r_t
end % ends big small
disp('All Plotted')
drawnow
pause(3)
ofn_dir = '/Users/aidasaglinskas/Desktop/Figures/'
exp_figs = 0;
if exp_figs
disp('Saving Figs')
ofn_nm = ['RunBeta ' ': ' analysis_name datestr(datetime) ];
mkdir(fullfile(ofn_dir,ofn_nm));
a = get(0,'Children');
[Y I] = sort([a.Number]);
a = a(I);
for i = 1:length(a)
saveas(a(i),fullfile(ofn_dir,ofn_nm,[datestr(datetime) '.png']),'png')
end
disp('exported')
end

%end