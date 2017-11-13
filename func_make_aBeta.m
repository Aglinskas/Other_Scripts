function aBeta = func_make_aBeta(roi_data)
% aBeta = func_make_aBeta(roi_data)
sort = 0;
aBeta.fmat_raw = roi_data.mat;
aBeta.fmat = aBeta.fmat_raw;
aBeta.fmat = aBeta.fmat - aBeta.fmat(:,11,:);
aBeta.fmat = aBeta.fmat(:,1:10,:);
aBeta.r_lbls = roi_data.lbls;
aBeta.t_lbls = {'First memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Familiarity' 'Common name' 'How many facts' 'Occupation' 'Distinctiveness' 'Full name' 'Same Face' 'Same monument'}';
%%
to_trim = aBeta.fmat;
aBeta.trim.t_inds = {[1 5] [7 8] [3 4] [2 9] [6 10]};
aBeta.trim.t_lbls = {'Episodic' 'Factual' 'Social' 'Physical' 'Nominal' };
drop = {'left', 'right', '-', '.mat'};
unique_rois = roi_data.lbls;
for i = 1:length(drop);
   unique_rois =  strrep(unique_rois,drop{i},'');
end
unique_rois = unique(unique_rois);

% figure out roi trim
for r_ind = 1:length(unique_rois);
inds = find(cellfun(@isempty, strfind(roi_data.lbls,unique_rois{r_ind})) == 0);
aBeta.trim.r_inds{r_ind} = inds;
aBeta.trim.r_lbls{r_ind} = unique_rois{r_ind};
end

for r_ind = 1:length(aBeta.trim.r_inds);
for t_ind = 1:length(aBeta.trim.t_lbls);
temp = to_trim(aBeta.trim.r_inds{r_ind},aBeta.trim.t_inds{t_ind},:);
trimmat(r_ind,t_ind,:) = squeeze(mean(mean(temp,1),2));    
end
end
aBeta.trim.mat = trimmat;

% Cluster and order
if sort == 1;
set(0, 'DefaultFigureVisible', 'off');
mats = {aBeta.fmat aBeta.trim.mat};
for r_t = 1:2 % Order Rois and Tasks
for mat_ind = 1:2 % Big and Tiny
m = [];
for i = 1:20
if r_t==1
m(:,i) = pdist(mats{mat_ind}(:,:,i),'correlation');
elseif r_t==2
m(:,i) = pdist(mats{mat_ind}(:,:,i)','correlation');
end
end
m = mean(m,2);
Z = linkage(m','ward');
try
[h x perm] = dendrogram(Z);
ord = perm(end:-1:1);
catch
perm = 1:length(Z)+1;
ord = perm;
end
%disp(length(ord))


wh = [num2str(mat_ind) num2str(r_t)];

switch wh
    case '11' % big rois
aBeta.fmat = aBeta.fmat(perm,:,:);
aBeta.fmat_raw = aBeta.fmat_raw(perm,:,:);
aBeta.r_lbls = aBeta.r_lbls(perm);
    case '12' % big tasks
aBeta.fmat = aBeta.fmat(:,perm,:);
aBeta.fmat_raw = aBeta.fmat_raw(:,perm,:);
aBeta.t_lbls = aBeta.t_lbls(perm);
    case '21' % tiny rois
aBeta.trim.mat = aBeta.trim.mat(perm,:,:);
aBeta.trim.r_inds = aBeta.trim.r_inds(perm);
aBeta.trim.r_lbls = aBeta.trim.r_lbls(perm);
    case '22' % tiny tasks
aBeta.trim.mat = aBeta.trim.mat(:,perm,:);
aBeta.trim.t_inds = aBeta.trim.t_inds(perm);
aBeta.trim.t_lbls = aBeta.trim.t_lbls(perm);                
end
end

end % end mat_ind
end % end roi or taks

aBeta.list_R = arrayfun(@(x) [num2str(x) ' ' aBeta.r_lbls{x}],1:length(aBeta.r_lbls),'UniformOutput',0)';
aBeta.list_T = arrayfun(@(x) [num2str(x) ' ' aBeta.t_lbls{x}],1:length(aBeta.t_lbls),'UniformOutput',0)';
aBeta.trim.list_R = arrayfun(@(x) [num2str(num2str(x)) ' ' aBeta.trim.r_lbls{x}],1:length(aBeta.trim.r_lbls),'UniformOutput',0)';
aBeta.trim.list_T = arrayfun(@(x) [num2str(num2str(x)) ' ' aBeta.trim.t_lbls{x}],1:length(aBeta.trim.t_lbls),'UniformOutput',0)';

overwrite = 0
if overwrite
ofn = '/Users/aidasaglinskas/Google Drive/Mat_files/Workspace/aBeta.mat';
save(ofn,'aBeta')
disp('overwriten')
end
set(0, 'DefaultFigureVisible', 'on');
end % ends function