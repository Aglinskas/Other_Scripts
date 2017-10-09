%% Make Cormat
loadMR;
mat = aBeta.trim.mat;
lbls = aBeta.trim.r_lbls';

cmat = [];
for i = 1:20
    cmat(:,:,i) = corr(mat(:,:,i)');
end
mcmat = mean(cmat,3);

% delete cross connections
c = {[5 6 7 8 11] [2 4 9 10 12] [1 3]}
p = nchoosek(1:3,2);
for i = 1:3
    mcmat(c{p(i,1)},c{p(i,2)}) = 0
    mcmat(c{p(i,2)},c{p(i,1)}) = 0
end
mcmat(c{1},c{1}) = .5 % Core-Frontal
mcmat(c{2},c{2}) = 1% DMN
mcmat(c{3},c{3}) = .3 % Amy-ATFP


%Z = linkage(1-get_triu(mcmat),'ward');
%figure(3)
%dendrogram(Z,'labels',lbls,'orientation','left')
dlmwrite('/Users/aidasaglinskas/Desktop/BrainNet_Files/Edge2_21ROis.edge',mcmat,' ')
%a = dlmread('/Users/aidasaglinskas/Desktop/BrainNet_Files/Edge2_21ROis.edge',' ');size(a)
%%
clear
loadMR
addpath('/Users/aidasaglinskas/Documents/MATLAB/BrainNetViewer/')
addpath('/Users/aidasaglinskas/Documents/MATLAB/export_fig_fldr/')
%node_file = '/Users/aidasaglinskas/Desktop/BrainNet_Files/newNode.node' %ROIs
node_file = '/Users/aidasaglinskas/Desktop/BrainNet_Files/node2_21ROis.node' %ROIs
edge_file = '/Users/aidasaglinskas/Desktop/BrainNet_Files/Edge2_21ROis.edge'
cfg = '/Users/aidasaglinskas/Desktop/BrainNet_Files/newCfg.mat';
load(cfg)
EC.lbl_font.FontSize = 24;
save(cfg,'EC')
surf_path = '~/Documents/MATLAB/BrainNetViewer/Data/SurfTemplate/'; %surf
surf_files = dir([surf_path '*.nv']);
surf_files = {surf_files.name}';
wh_surf_file = 9; %which surf file
if exist('edge_file')  == 1;
h = BrainNet_MapCfg(fullfile(surf_path,surf_files{wh_surf_file}),node_file,edge_file,cfg);
elseif exist('edge_file') == 0;
h = BrainNet_MapCfg(fullfile(surf_path,surf_files{wh_surf_file}),node_file,cfg);
else 
    error('nothing to do')
end
h.Position = [ -837        1039        1000         629];
%%
disp('exporting')
ofn = fullfile('/Users/aidasaglinskas/Desktop/Figures/',[datestr(datetime) '.pdf'])
export_fig(ofn,'-pdf')
disp('all done')
%%

% j = [ 1     2     4     6     8    11    13    14    15    17];
% %j = 1:18
% subBeta.goodinds = j%[1:18];
% warning('off','stats:linkage:NotEuclideanMatrix')
% w_t = 1:10;
% w_rois = subBeta.goodinds;
% for ss = 1:size(subBeta.array,3)
%     keep.task(:,:,ss) = corr(subBeta.array(w_rois,w_t,ss));
%     keep.roi(:,:,ss) = corr(subBeta.array(w_rois,w_t,ss)');
% end
% mat = mean(keep.roi,3)
% mat_b = mat;
% %add_numbers_to_mat(mat,subBeta.r_labels(j))
% %f = figure(1);
% %add_numbers_to_mat(mat,subBeta.r_labels(j))
% ind{1} =  [1     2     6     8]
% ind{2} = [ 3     4     5     9]
% ind{3} =  [7 10]
% 
% nind = find(ismember([1:10],ind{2}) == 0);
% nind = []
% mat(nind,:) = 0
% mat(:,nind) = 0
% %mat(:,:) = []
% for i = 1:3;
% mat(ind{i},[ind{find([1:3] ~= i)}]) = 0;    
% mat([ind{find([1:3] ~= i)}],ind{i}) = 0;
% mat(ind{i},ind{i}) = mat(ind{i},ind{i})*2;
% end
% 
% %mat(2,ind{2}) = mat_b(2,ind{2})
% %mat(2,ind{2}) = mat(2,ind{2})/2;
% %mat(ind{2},2) = mat(ind{2},2)/2;
% %mat(7,10) = 0.3257;
% dlmwrite('/Users/aidasaglinskas/Desktop/BrainNet_Files/newEdge.edge',mat,' ')