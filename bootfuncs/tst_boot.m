clear all
close all
loadMR
load('/Users/aidasaglinskas/Desktop/counter.mat')
analysis_name = masks_name{counter};
%% Parameters to specify
% load('/Users/aidasaglinskas/Desktop/dendroPerSub.mat')
% dendroPerSub(:,rows2exclude,:)=[];
% dendroPerSub(:,:,rows2exclude)=[];
size(MVPA_results)
clust{1} = [ 4     3    14    13     6     5    12    11];
clust{2} = [18    17    16    15     2     1];
clust{3} = [10     9     8     7];
clust{4} = [1:18]

w_s = [1:20]
w_t = [1:10]
%%
clust_ID = 4
%matrix  = squeeze(mean(MVPA_results(w_s,clust{clust_ID},w_t,w_t),2));
matrix  = squeeze(mean(MVPA_results(w_s,clust{clust_ID},w_t,w_t),2));
%mean(MVPA_results,4)
size(matrix)
%matrix = corr(matrix');
size(matrix)
labels = {tasks{w_t}}'%{masks_name{clust{clust_ID}}}'


%task_inds = [1:12;13:24]%[1:12]%[1:12;13:24]
%task_inds = task_inds(:)
%roi_inds = 1:18

% Default: [1 2 15 16 17 18]
% Core-frontal: [11 12 5 6 3 4 13 14]
% Hipp-FP: [9 10 7 8]
matrix_to_permute = matrix; % Takes Matrix(subject,row,colum)
dim_to_permute = 1;
%load('/Users/aidasaglinskas/Desktop/label.mat')
%label(rows2exclude)=[];
labels_for_the_matrix = labels %labels for the matrix
%repmat({'No lbl'},1,1138)
specify_model = 0
part_of_iteration = 0; % is this part of it?
threhold = 25; % only for iterations;
numClust=3; %number of clusters we care about
nperms = 10000; %how many permutations?
save_figs_to_file = 1
clust_schemab = 1;
schemaball_tresh = 25 % Threshold for the schemaball
plot_confmat_and_schemaball = 1; % Might Crash with > 1k^2 sized matrix
disp(sprintf('Will permute matrix along dimesion %d, size of which is %d',dim_to_permute,size(matrix_to_permute,dim_to_permute)))
%% With replacement
clear subject_pool
disp('Creating Subject Pool')
rng(randi(100))
rng
tic
for i = 1:nperms
rep =[[1:nperms/10:nperms]';[1:1000:nperms]'];
if ismember(i,rep)
    disp([num2str(i*100 / nperms) ' % done']);end
subject_pool(i,:) = randi([1 size(matrix_to_permute,dim_to_permute)],[1 size(matrix_to_permute,dim_to_permute)]);
end
toc
%%
tic
%t_s = GetSecs;
clear Bootstrapedkeep
disp('Collecting Bootstraped data samples')
for s = 1:size(subject_pool,1)
subjects = subject_pool(s,:);
% Collect bootstrap subjects

% but first, indexing (get features, subjects, etc)
nd = ndims(matrix_to_permute);
index = repmat({':'},1,nd); % get all
index{dim_to_permute} = subjects;
% Gets Bootstrap Sample
Bootstrapedkeep(s,:,:)= squeeze(mean(matrix_to_permute(index{:}),dim_to_permute));
% Reports Progress
report_vect = [0:size(subject_pool,1) / 100 * 10:size(subject_pool,1)]';
report_vect  = [report_vect;[0:500:size(subject_pool,1)]'];
if ismember(s,report_vect)
    perc = (100 * s) / size(subject_pool,1);
  disp([num2str(perc) ' % complete, in ' num2str(toc) ' Seconds'])
  temp = toc;
end
end
% Fancy stuff
if temp > 600
    disp('seems like this took a while, I''ve saved you a copy of the workspace on the desktop')
    ofn = ['~/Desktop/BootstrapedKeep' num2str(nperms) '_perms_' datestr(datetime) '.mat']
save(ofn,'Bootstrapedkeep','subject_pool')
end
disp('done')
toc
%% Master clustering (Ground truth)
avg_matrix_to_permute_features = squeeze(nanmean(matrix_to_permute,dim_to_permute));
avg_matrix_to_permute = avg_matrix_to_permute_features;
clear newVec
cc=0;for ii=1:size(avg_matrix_to_permute,1);for jj=ii+1:size(avg_matrix_to_permute,2),cc=cc+1;newVec(cc)=avg_matrix_to_permute(ii,jj);end;end
%newVec = get_triu(singmat);
Z = linkage(newVec,'ward'); % one minus newvec is importnat
con_clustering = figure(9);
drawnow
[h ground_x] = dendrogram(Z,numClust);%
title(sprintf('Ground Truth Clustering contrained to %d Clusters',numClust))
unc_clustering = figure(8);
%dendrogram(Z,length(Z),'Labels',labels_for_the_matrix','Colorthresh',2)
dendrogram(Z,length(labels_for_the_matrix),'Colorthresh',2,'Orientation','left')
ground_ord = str2num(unc_clustering.CurrentAxes.YTickLabel);
[t tt] = dendrogram(Z,length(labels_for_the_matrix),'labels',labels_for_the_matrix,'Colorthresh',.2,'Orientation','left')
title({'Unconstrained Ground Truth Clustering' 'numClust = length(Z)'})
if length(labels_for_the_matrix) < 50 
[t(1:end).LineWidth] = deal(3)
unc_clustering.CurrentAxes.YAxis.FontSize = 20
end
drawnow
figure(90)
%% Temp hax Aidas
if specify_model == 1
% a = [1:12;1:12];
% ground_x = a(:);
% ground_ord = 1:24
load('/Users/aidasaglinskas/Desktop/MVPA_model.mat')
end
%%
drawnow
% [h x] = dendrogram(Z,'labels',labels_for_the_matrix)
%close(r);
% x holds the roi classification
% h dend handle
% clear friendSet
% for ii=1:numClust
%     friendSet{ii}=labels_for_the_matrix(ground_x==ii);
%     disp(['Cluster ' num2str(ii)])
%     disp(friendSet{ii})
% end % collects regions that are in clusters
% Permutes the clusters
%% Collect Orderings
warning('off','stats:linkage:NotEuclideanMatrix')
warning('off','stats:iseuclidean:NotDistanceMatrix')
disp('Computing Bootstrap Clusterings')
for perm=1:size(Bootstrapedkeep,1) %number of permutations
% Progress bar
if ismember(perm,[1:size(Bootstrapedkeep,1)/10:size(Bootstrapedkeep,1)])
    perc = find([1:size(Bootstrapedkeep,1)/10:size(Bootstrapedkeep,1)] == perm) * 10;
    disp([num2str(perc) '% done']) % displays percentages done
end
% tempK = corr(squeeze(Bootstrapedkeep(perm,:,:))); %Correlate
tempK = squeeze(Bootstrapedkeep(perm,:,:));         % Not correlate
clear newVec
cc=0;for ii=1:size(tempK,1);for jj=ii+1:size(tempK,2),cc=cc+1;newVec(cc)=tempK(ii,jj);end;end
%newVec = get_triu(squeeze(Bootstrapedkeep(perm,:,:)));
Z = linkage(newVec,'ward');
[h x]=dendrogram(Z,numClust);
%drawnow
all_ord(:,perm) = x;
end
disp('Done')
%end
% for ii=1:numClust
%     stillFriends{ii}=labels_for_the_matrix(x==ii);
% end
% for ii=1:numClust
%     scoreClust(ii,perm)=0;
% for jj=1:numClust
%     if any(strcmp(stillFriends{jj},friendSet{ii}{1}));
%         break
%     end
% end
% try
%     if all(strcmp(sort(friendSet{ii}),sort(stillFriends{jj})));
%         scoreClust(ii,perm)=1;
%     end
% end
% end
% end
% mn = mean(scoreClust,2);
% disp('All done')
% for ii = 1:numClust
%     disp(['Cluster ' num2str(ii)])
%     disp(['Reliability ' num2str(mn(ii))])
%     disp(friendSet{ii})
% end
%% Manually Check Cluster replicability
%edit check_cluster_repricability
%% Auto Report Percentages;
% disp('Generating Report')
% clear report ;
% for col = 1:numClust
%     clear perc;
% in_this_clust = find(ground_x == col);
% for ind = 1:size(all_ord,2);
% score(ind) = all(all_ord(in_this_clust,ind) == all_ord(in_this_clust(1),ind));
% end
% perc = sum(score) / size(all_ord,2) * 100;
% report{1,col} = ['Cluster ' num2str(col) ' Replicability: ' num2str(perc) ' %'];
% report(2:length(in_this_clust)+1,col) = deal({labels_for_the_matrix{in_this_clust}}');
% end
% 
% disp('FINAL REPORT')
% for col = 1:numClust
%     disp({report{:,col}}')
% end
    
%% Manual Check
manual_check = 0; % keep this as zero, this is a manual code
if manual_check == 1;
% Manual Check:
clust = [2 9]; % Input indices to check, then CMD+ENTER
for ind = 1:size(all_ord,2);
score(ind) = all(all_ord(clust,ind) == all_ord(clust(1),ind));
% ^ checks if the clust_inds are assigned to same clust
end
perc = sum(score) / size(all_ord,2) * 100; % converts it to percentages
% For Qualitative analysis
that_clustering  = find(score == 1)'; % Permuted clustering with the same clustering 
diff_clust = find(score == 0)'; % Permuted clustering with the different clustering 
% report
%% Choose a perm
% whether diff_clust or that_clustering to see what they look like
perm = diff_clust(3)
%perm = that_clustering(1)
newVec = get_triu(squeeze(Bootstrapedkeep(perm,:,:)));
Z = linkage(1-newVec,'ward');
dend_labeled = figure(6);
dendrogram(Z,'labels',labels_for_the_matrix,'Orientation','left');
end
%%
%size(Bootstrapedkeep)
disp('Creating clustering_matrix')
rc = find(strcmp(index,':'));
dim_r = rc(1);
dim_c = rc(2);
for r = 1:size(matrix_to_permute,dim_r)
    for c = 1:size(matrix_to_permute,dim_c)
clust = [r c]; % Input indices to check, then CMD+ENTER
for ind = 1:size(all_ord,2);
score(ind) = all(all_ord(clust,ind) == all_ord(clust(1),ind));
perc = sum(score) / size(all_ord,2) * 100; % converts it to percentages
clustering_matrix(r,c) = perc;
% ^ checks if the clust_inds are assigned to same clust
end
    end
end

if plot_confmat_and_schemaball == 1
disp('Plotting')
figure(10);add_numbers_to_mat(clustering_matrix,labels_for_the_matrix);
title({'Probability of items being assigned to the same cluster' [sprintf('parameters: numClust=%d, permutations=%d',numClust,nperms)]});
temp_plot_mat = clustering_matrix;
temp_plot_mat(temp_plot_mat<schemaball_tresh) = 0;
figure(11);schemaball(labels_for_the_matrix(ground_ord),temp_plot_mat(ground_ord,(ground_ord)) ./ 100)
end
%%


%%
disp('Sorting Matrix')
sorting_order = ground_ord %ground_x
clustering_matrix_sorted = clustering_matrix(sorting_order,sorting_order);
%clustering_matrix_sorted = clustering_matrix(sorting_order,sorting_order);
sorted_mat = figure(12);
clf
if size(clustering_matrix_sorted,2) > 900
imagesc(clustering_matrix_sorted)
else
    add_numbers_to_mat(clustering_matrix_sorted,labels_for_the_matrix(sorting_order))
end
title({'Replicability Matrix' 'Percentage probability of cells clustering together' sprintf('Matrix size: %dx%d',size(matrix_to_permute,2),size(matrix_to_permute,2))})
sorted_mat.CurrentAxes.XTick = 1:size(matrix_to_permute,2);
sorted_mat.CurrentAxes.YTick = 1:size(matrix_to_permute,2);
% adds labels with clust ind
lbls_with_num = labels_for_the_matrix(sorting_order);
gr = ground_x(sorting_order);
for i = 1:length(labels_for_the_matrix)
lbls_with_num{i} = [lbls_with_num{i} '(' num2str(gr(i)) ')'];
end
sorted_mat.CurrentAxes.XTickLabel = lbls_with_num;
sorted_mat.CurrentAxes.YTickLabel = lbls_with_num;
sorted_mat.CurrentAxes.FontSize = 20;
sorted_mat.CurrentAxes.XTickLabelRotation = 45;
disp('done')
%%
disp('Computing Clustering')
clear temp_mat clust_clust_mat i
list =  unique(gr,'stable');

%clust_labels = cellstr(num2str(list)); % CLUSTER LABELS
clear clust_labels
for ii = list'
cand = lbls_with_num(find(gr==ii))';
if length(cand) >= 2
clust_labels{ii} = [cand{1} cand{2}]
else
clust_labels{ii} = cand{1}
end
end
clust_labels = clust_labels(list);
% collapse across cluster, IGNORE DIAGONAL
%% Pad with nans
clustering_matrix_sorted((eye(size(clustering_matrix_sorted)) == 1)) = nan;
%%
for i = list'
inds = find(gr == list(i));
temp_mat(i,:) = squeeze(nanmean(clustering_matrix_sorted(inds,:),1));
end

for i = list'
inds = find(gr == list(i));
clust_clust_mat(:,i) = nanmean(temp_mat(:,inds),2);
end
by_cluster = figure(14);
add_numbers_to_mat(clust_clust_mat,clust_labels);
% try
% by_cluster.Position = [ -1279        -223        1280         928];
% catch
% end
title('Cluster Relatedness');
if clust_schemab == 1
    try
sch = figure(15);

%a = [clust_clust_mat ./ 100];
a = clust_clust_mat;

a(a<schemaball_tresh) = 0;
a(find(isnan(a))) = 0
a = [a ./ 100]
b = clust_labels;
schemaball(b,a)
t = text(25,1,'test2')
t.Color = [1 1 1]
t.FontSize = 20
drawnow
    end
end
disp('done')
%%
fidelity.score = arrayfun(@(i) sum(ground_x(i) == all_ord(i,:)) / nperms * 100,[1:length(labels_for_the_matrix)])';
fidelity.atlas = arrayfun(@(i) [labels_for_the_matrix{i} ' Cluster: ' num2str(ground_x(i)) '  Fid. Score: ' num2str(fidelity.score(i)) ' '], [1:length(labels_for_the_matrix)],'uniformoutput',0)';
drawnow
fid_fig = figure(13)
plot(sortrows(fidelity.score))
title('Fidelity Score')
%save('/Users/aidasaglinskas/Desktop/dot_mat_files/fidelity.mat','fidelity')
%% Save figures and variables separately
fig_pos = [-1279        -223        1280         928]; %2nd screen
%fig_pos = [ -13           1        1280         704]; %main screen
drawnow
set(0, 'ShowHiddenHandles', 'on');
figs = get(0, 'Children');
%figs = {sorted_mat,unc_clustering,con_clustering,by_cluster,fid_fig};
for i = 1:length(figs); figs(i).Position = fig_pos;end;drawnow
if save_figs_to_file == 1
    unc_clustering.CurrentAxes.YAxis.FontSize = 20
tic
tm = datestr(datetime);
try
addpath('~/Documents/MATLAB/export_fig_fldr')
disp('exporting figures')
% single pdf (defunct)
%arrayfun(@(x) export_fig(['/Users/aidasaglinskas/Desktop/2nd_Fig/' tm '.pdf'],'-append',x),figs,'UniformOutput',0)
% separate PNGs
arrayfun(@(x) export_fig(['/Users/aidasaglinskas/Desktop/2nd_Fig/MVPA_Single_ROI_Taxonomy_no_model/' analysis_name tm '_' num2str(x.Number) '.png'],x),figs,'UniformOutput',0)
% single PS
%arrayfun(@(x) print(x,['/Users/aidasaglinskas/Desktop/dot_mat_files/' tm '.ps'],'-dpsc','-bestfit','-append','-opengl'),figs,'UniformOutput',0)
catch
    warning('Couldn''t export figures')
end
toc
disp('done')
end
counter = counter+1;
save('/Users/aidasaglinskas/Desktop/counter.mat','counter');
end
%%
%vars = whos;
%fig_nums = find(cell2mat(cellfun(@(x) strcmp(x,'matlab.ui.Figure'),{vars.class}','UniformOutput',0)) == 1)
%vars_not_figs = {vars([ismember([1:length(vars)],fig_nums)] == 0).name}';
%disp('Saving')
%save(['/Users/aidasaglinskas/Desktop/dot_mat_files/nperms' num2str(nperms) '.mat'],'matrix_to_permute','labels_for_the_matrix')
%arrayfun(@(x) save(['/Users/aidasaglinskas/Desktop/dot_mat_files/nperms' num2str(nperms) '.mat'],vars_not_figs{x}),1:length(vars_not_figs))
%% Colouring the labels (doesnt work)
% color_choices = nchoosek([0:0.1:1],3);
% color_choices_shuffled = color_choices(randperm(length(color_choices)),:);
% % disp('Colouring')
% for i = unique(ground_x(ground_ord))'
% ax2 = copyobj(gca, gcf);                          %// Create a copy the axes
% set(ax2, 'XTick', find(ground_x(ground_ord) == i), 'XColor', color_choices_shuffled(i,:), 'Color', 'none') %// Keep only one red tick
% set(ax2, 'YTick', find(ground_x(ground_ord) == i), 'YColor', color_choices_shuffled(i,:), 'Color', 'none') %// Keep only one red tick
% ax3 = copyobj(gca, gcf);                             %// Create another copy
% set(ax3, 'XTick', [], 'Color', 'none')  
% set(ax3, 'YTick', [], 'Color', 'none')  %// Keep only the gridline
% end
% disp('Done')
