load('/Users/aidasaglinskas/Downloads/ckpoint_12-Oct-2016 18-09-02.mat')
load('/Users/aidasaglinskas/Downloads/Final_13-Oct-2016 03-26-46.mat')

%% Unwrapp Results;
for ss = 1:size(MVPA_results,1)
for pp = 1:size(MVPA_results,2)
for tt = 1:size(MVPA_results,3)
a(ss,pairs(pp,1),pairs(pp,2),tt) = MVPA_results(ss,pp,tt);
a(ss,pairs(pp,2),pairs(pp,1),tt) = MVPA_results(ss,pp,tt);
end
end
end
disp('Done,Unwrapped')
size(a)
%% Collapse across individual tasks;
task_clust{1} = [2     3     4     9]; % Perceptual
task_clust{2} = [ 1     5     7     8]; % Semantic

task_clust{3} = [6    10]; % name
task_clust{4} = [12]; % Controls
task_clust{5} = [1:10]
task_clust_str = {'Perceptual' 'Semantic' 'name' 'Controls' 'all cognitive'};
clust_ind = 5
%
ttl =task_clust_str{clust_ind};
m = figure(7);
mat = squeeze(mean(mean(a(:,:,:,task_clust{clust_ind}),4),1));
add_numbers_to_mat(mat,r_names);
title(ttl);
%tasks{ii}
%ii = ii+1
%
wh = 1:20;
matrix = mat(wh,wh);
labels = {r_names{wh}};

newVec = get_triu(matrix);
Z = linkage(newVec,'ward');
dend = figure(8);
[h x] = dendrogram(Z,'labels',labels,'Orientation','left');
title(ttl);
[h(1:end).LineWidth] = deal(3);
dend.CurrentAxes.FontSize = 16;
%% a(sub,roi1,roi2,task)
bb = squeeze(mean(mean(a(1:4,:,:,:),1),3));
add_numbers_to_mat(bb,tasks,r_names)

%% 20 labels
r_names = {'ATL Left'
'ATL Right'
'Amygdala Left'
'Amygdala Right'
'Angular Left'
'Angular Right'
'FFA Left'
'FFA Right'
'Face Patch Left'
'Face Patch Right'
'IFG Left'
'IFG Right'
'OFA Left'
'OFA Right'
'Orb Left'
'Orb Right'
'PFC medial'
'Precuneus'
'SFG Left'
'SFG Right'}