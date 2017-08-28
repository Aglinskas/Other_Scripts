clear all
load('/Users/aidasaglinskas/Desktop/ROI_data.mat');
load('/Users/aidasaglinskas/.Trash/labels.mat');

aBeta.fmat_raw = roi_data.mat;
aBeta.fmat = aBeta.fmat_raw;
aBeta.fmat = aBeta.fmat - aBeta.fmat(:,11,:);
aBeta.fmat = aBeta.fmat(:,1:10,:);
aBeta.r_lbls = roi_data.lbls;
aBeta.t_lbls = {'First memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Familiarity' 'Common name' 'How many facts' 'Occupation' 'Distinctiveness' 'Full name' 'Same Face' 'Same monument'}';
aBeta
%%
to_trim = aBeta.fmat;
aBeta.trim.r_inds = {[13,14] [7,8] [11,12] [15,16] [1,2]  18 [5,6] 17 [3,4] [9,10]};
aBeta.trim.t_inds = {[1 5] [7 8] [3 4] [2 9] [6 10]}
aBeta.trim.r_lbls = {'OFA' 'FFA' 'IFG' 'Orb' 'ATL'  'Precuneus' 'pSTS' 'PFCmedial' 'Amygdala' 'Face Patch'};
aBeta.trim.t_lbls = {'Episodic' 'Factual' 'Social' 'Physical' 'Nominal' };

for r_ind = 1:length(aBeta.trim.r_inds)
for t_ind = 1:length(aBeta.trim.t_lbls)
temp = to_trim(aBeta.trim.r_inds{r_ind},aBeta.trim.t_inds{t_ind},:);
trimmat(r_ind,t_ind,:) = squeeze(mean(mean(temp,1),2));    
end
end
aBeta.trim.mat = trimmat;
ofn = '/Users/aidasaglinskas/Google Drive/Mat_files/Workspace/aBeta.mat';
save(ofn,'aBeta')