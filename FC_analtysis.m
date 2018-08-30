load('/Users/aidasaglinskas/Desktop/c.mat')
coords = c.coords
names = c.names
%names{12} = 'dmPFC';
%names{13} = 'vmPFC';
%% FC DATA
fc.dir = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/FC_DATA/'
temp = dir([fc.dir '*.nii']);
fc.fls = {temp.name}';
fc.lbls = cellfun(@(x) strrep(x,'.nii',''),fc.fls,'UniformOutput',0);
%% 
r.ofn = '/Users/aidasaglinskas/Desktop/fcROIS/'
r.space_fn = fullfile(fc.dir,fc.fls{1})
r.space = mars_space(r.space_fn)
addpath(genpath('/Users/aidasaglinskas/Documents/MATLAB/spm12/toolbox/marsbar/'));
%% Get ROIS
sph_radius = 6;
all_rois = [];
for i = 1:length(names);
%escape pSTS and Angular;
   this_sphere = maroi_sphere(struct('centre',coords(i,:),'radius', sph_radius));
    if isempty(all_rois); all_rois = this_sphere;end
    
all_rois = all_rois | this_sphere;
ofn_nm = [r.ofn 'ROI_' names{i} '.mat'];
saveroi(this_sphere,ofn_nm);
mars_rois2img(ofn_nm,strrep(ofn_nm,'.mat','.nii'),r.space)
end
ofn_nm  = [r.ofn 'AllROis.mat'];
saveroi(all_rois,ofn_nm);
mars_rois2img(ofn_nm,strrep(ofn_nm,'.mat','.nii'),r.space)
%% Get Masks
mask = struct
mask.fn = r.ofn;
temp = dir([mask.fn 'ROI_*.nii']);
mask.fls = {temp.name}';
mask.lbls = cellfun(@(x) strrep(strrep(x,'ROI_',''),'.nii',''),mask.fls,'UniformOutput',0);
%%
clc;
fcRes = [];
for r_ind = 1:length(fc.fls)
for m_ind = 1:length(mask.fls)
    text = sprintf('%d/%d | %d/%d',r_ind,length(fc.fls),m_ind,length(mask.fls));
    disp(text)
   fc_file_fn = fullfile(fc.dir,fc.fls{r_ind});
   mask_fn = fullfile(mask.fn,mask.fls{m_ind});
   ds = cosmo_fmri_dataset(fc_file_fn,'mask',mask_fn);
   
   val = mean(ds.samples);
   fcRes(r_ind,m_ind) = val;
   
   text = 'Data: %s, Mask: %s, value: %.2f';
   textf = sprintf(text,fc.lbls{r_ind},mask.lbls{m_ind},val);
   disp(textf)
end
end
save('/Users/aidasaglinskas/Desktop/fcRes.mat','fcRes','mask')
%%

% add_numbers_to_mat(fcRes)
% xticks(1:size(fcRes,2));
% yticks(1:size(fcRes,2));
% yticklabels(fc.lbls)
% xticklabels(mask.lbls)
% xtickangle(45)
% ttl = {'FC connectivity' 'NeuroSynth'};
% title(ttl,'fontsize',20)
%% Plot
load('/Users/aidasaglinskas/Desktop/fcRes.mat')
ord = [13	14	9	10	20	21	11	12	15	16	1	2	5	6	3	4	17	19	18	7	8];
lbls = mask.lbls;
mat = fcRes;
vec = 1-get_triu(mat');
Z = linkage(vec,'ward');
d = figure(1);
%[h x perm] = dendrogram(Z,'labels',lbls);
[h x perm] = dendrogram(Z,'Reorder',ord,'labels',lbls);
d.CurrentAxes.FontSize = 14
d.CurrentAxes.FontWeight = 'bold'
d.CurrentAxes.XTickLabelRotation = 45
[h(1:end).LineWidth] = deal(3)
title('NeuroSynth FC','fontsize',20)
d.Color = [1 1 1]

m = figure(2)
ord = perm
rmat = mat(ord,ord);
rlbls = lbls(ord);
add_numbers_to_mat(rmat,rlbls)
title('NeuroSynth FC','fontsize',20)
m.Color = [1 1 1];
m.CurrentAxes.FontSize = 12
m.CurrentAxes.XTickLabelRotation = 45
m.CurrentAxes.FontWeight = 'bold'
%% Task Similarity Brain Maps 
d = [];
d.fn = '/Users/aidasaglinskas/Downloads/';
d.file = {'social cognition' 'naming' 'physical' 'episodic' 'semantic'};
d.inf = {'_pAgF_z_FDR_0.01.nii' '_pFgA_z_FDR_0.01.nii'};
mat = [];

%% Task Similarity Brain Maps 
%for m_ind = 1:21
mat = []
for i = 1:5
%mfn = fullfile(mask.fn,mask.fls{m_ind});
p = fullfile(d.fn,[d.file{i} d.inf{2}]);
ds = cosmo_fmri_dataset(p);
%mat(i,m_ind) = mean(ds.samples);
mat(i,:) = ds.samples;
end
%end
%% 
mat = [];
for m_ind = 1:21
for i = 1:5
mfn = fullfile(mask.fn,mask.fls{m_ind});
p = fullfile(d.fn,[d.file{i} d.inf{2}]);
ds = cosmo_fmri_dataset(p,'mask',mfn);
%mat(i,m_ind) = mean(ds.samples);
mat(i,m_ind) = mean(ds.samples);
end
end
%%
lbls1 = d.file
dend = figure(3);
cmat = corr(mat');
Z = linkage(1-get_triu(cmat),'ward');
[h x perm] = dendrogram(Z,'labels',lbls1);
[h(1:end).LineWidth] = deal(3);
dend.CurrentAxes.FontSize = 14;
dend.CurrentAxes.FontWeight = 'bold';
ttl = 'Neurosynth Cognition Similarity'
title(ttl,'fontsize',20)