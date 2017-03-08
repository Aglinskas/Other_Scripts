clear all
clc
loadMR
lbls = voxel_data.t_labels
% Fix Nans
for i = 1:numel(voxel_data.run_averaged)
    
voxel_data.run_averaged{i} = voxel_data.run_averaged{i}(:,1:10);

voxel_data.run_averaged{i}(find(isnan(voxel_data.run_averaged{i}(:,1))),:) = [];
voxel_data.run_raw{i}(find(isnan(voxel_data.run_raw{i}(:,1))),:) = [];

voxel_data.run_averaged{i} = zscore(voxel_data.run_averaged{i},[],2)
voxel_data.run_averaged{i} = zscore(voxel_data.run_averaged{i},[],1);
end
v = voxel_data.run_averaged;
v_labels = voxel_data.r_labels;
disp('done')
%sz_mat = cellfun(@(x) size(x,1),v); figure;add_numbers_to_mat(sz_mat,voxel_data.r_labels)
%
per_region = 0
if per_region
clear keep mkeep lbls
for m_ind = 1:size(v,2)
    for s_ind = 1:size(v,1)
    keep(s_ind,m_ind,:,:) = corr(v{s_ind,m_ind});
    end
end
mkeep = squeeze(mean(keep,1));
% Display
lbls = voxel_data.t_labels(1:size(mkeep,2))
for roi = 1:18
%for i = 1:20;a(i,:,:) = v{i,roi};end
f = figure(1)
%im = subplot(1,2,1)
%imagesc(squeeze(mean(a,1)))


this_roi_mat = squeeze(mkeep(roi,:,:));
d = subplot(1,2,1)
newVec = get_triu(this_roi_mat);
Z = linkage(1-newVec,'ward');
[h x perm] = dendrogram(Z,'labels',lbls,'orientation','left')
d.FontSize = 14
d.FontWeight = 'bold'
title(voxel_data.r_labels{roi},'FontSize',20)
[h(1:end).LineWidth] = deal(3)

ord = perm(end:-1:1);
m = subplot(1,2,2)
add_numbers_to_mat(this_roi_mat(ord,ord),lbls(ord));
m.XTickLabelRotation =45
m.FontSize = 12
m.FontWeight = 'bold'

ofn = '/Users/aidasaglinskas/Desktop/2nd_Fig/reg_RSA/';
%saveas(f,fullfile(ofn,voxel_data.r_labels{roi}),'png')
pause
end
end
%add_numbers_to_mat(squeeze(mkeep(i,:,:)),voxel_data.t_labels)
%title(voxel_data.r_labels{i},'FontSize',20)
% Find NaNs
plot_nans = 1;
if plot_nans
count_nan = cellfun(@(x) sum(sum(isnan(x))),voxel_data.run_averaged);
f = figure(4)
add_numbers_to_mat(count_nan);
title('nans in voxel data')
f.CurrentAxes.YTick = 1:size(v,1);
f.CurrentAxes.XTick = 1:size(v,2);

f.CurrentAxes.XTickLabel = v_labels
f.CurrentAxes.XTickLabelRotation = 45
end
%% Group Level
clear all;clc;loadMR
lbls = voxel_data.t_labels
% Fix Nans
for i = 1:numel(voxel_data.run_averaged)
voxel_data.run_averaged{i}(find(isnan(voxel_data.run_averaged{i}(:,1))),:) = [];
voxel_data.run_raw{i}(find(isnan(voxel_data.run_raw{i}(:,1))),:) = [];

%Zscore 
%voxel_data.run_averaged{i} = zscore(voxel_data.run_averaged{i},[],1); % Good 
%voxel_data.run_averaged{i} = zscore(voxel_data.run_averaged{i},[],2) % Bad

%subtrackt face 
%voxel_data.run_averaged{i} = voxel_data.run_averaged{i} - repmat(voxel_data.run_averaged{i}(:,11),1,size(voxel_data.run_averaged{i},2));
voxel_data.run_averaged{i} = voxel_data.run_averaged{i} - repmat(voxel_data.run_averaged{i}(:,12),1,size(voxel_data.run_averaged{i},2));
voxel_data.run_averaged{i}(:,[11 12]) = [];
end
v = voxel_data.run_averaged;
v_labels = voxel_data.r_labels;

%make mkeep
for m_ind = 1:size(v,2)
    for s_ind = 1:size(v,1)
    keep(s_ind,m_ind,:,:) = corr(v{s_ind,m_ind});
    end
end
mkeep = squeeze(mean(keep,1));


% CODE FOR netRSA
size(mkeep)
%w = 1:10;
n = []
for i = 1:18
n(:,i) = get_triu(squeeze(mkeep(i,:,:)))';
end
size(n);
net = corr(n);

figure(1);
clf;
newvec = get_triu(net);
Z = linkage(1-newvec,'ward');
d = subplot(1,2,2);
[h x perm] = dendrogram(Z,'labels',voxel_data.r_labels,'orientation','left');
[h(1:end).LineWidth] = deal(3);
d.FontSize = 14;
d.FontWeight = 'bold';
ord = perm(end:-1:1);


m = subplot(1,2,1);
add_numbers_to_mat(net(ord,ord),voxel_data.r_labels(ord));
m.XTickLabelRotation = 45
m.FontSize = 12
m.FontWeight = 'bold'
