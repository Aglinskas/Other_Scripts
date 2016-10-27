clear all
loadMR
%fn = '/Users/aidasaglinskas/Desktop/MVPA_mats/26-Oct-2016 02:23:44.mat'
clear MVPA_results
fn = '/Users/aidasaglinskas/Desktop/Dropbox/01-Jan-2015 06:52:46.mat'
load(fn)
%filled_cells = find(cellfun(@isempty,{meanall_corResult{:,subvect(end),66}}) == 0);
%ROI,sub,pair
%size(meanall_corResult);
filled_cells = 3:24;
for r_ind = filled_cells
for s_ind = 1:length(subvect)
subID = subvect(s_ind);
for p_ind = 1:length(pairs)
t1 = pairs(p_ind,1);
t2 = pairs(p_ind,2);
%MVPA_results(r_ind,t1,t2,s_ind) = meanall_corResult{r_ind,subID,p_ind};
%MVPA_results(r_ind,t2,t1,s_ind) = meanall_corResult{r_ind,subID,p_ind};

MVPA_results(r_ind,t1,t2,s_ind) = MVPA_output(r_ind,subID,p_ind);
MVPA_results(r_ind,t2,t1,s_ind) = MVPA_output(r_ind,subID,p_ind);
end
end
end
disp('unwrapped')

%%
filled_cells = 3:24
ofn.root = '/Users/aidasaglinskas/Desktop/2nd_Fig/';
ofn.folder_name = 'MVPA_per_ROI_fixed';

f = figure(7)
for i = 1:length(filled_cells)
wh_roi = filled_cells(i)
task_ord = [  2     9     3     4     5     1     8     7     6    10    11    12]
roi_lbl = masks.labels{wh_roi};
size(MVPA_results);
mat = squeeze(mean(MVPA_results(wh_roi,:,:,:),4));
%im = figure(9)
im = subplot(1,2,1)
add_numbers_to_mat(mat(task_ord,task_ord),tasks(task_ord));
% im.CurrentAxes.FontSize = 15
% im.CurrentAxes.FontWeight = 'bold'
im.FontSize = 15
im.FontWeight = 'bold'
title(roi_lbl)

newVec = get_triu(mat);
Z = linkage(newVec,'ward');
%d = figure(8)
d = subplot(1,2,2)
[h x] = dendrogram(Z,'labels',tasks,'orientation','left');
[h(1:end).LineWidth] = deal(5)
% d.CurrentAxes.FontSize = 16
% d.CurrentAxes.FontWeight = 'bold'
d.FontSize = 16
d.FontWeight = 'bold'
title(roi_lbl)

ofn.fullpath = fullfile(ofn.root,ofn.folder_name);
if exist(ofn.fullpath) == 0
    mkdir(ofn.fullpath);end
saveas(f,fullfile(ofn.fullpath,roi_lbl),'jpg')
end