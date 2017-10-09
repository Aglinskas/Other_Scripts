%% __INIT__
coords = [3	-52	29
30	-91	-10
-33	-88	-10
42	-46	-22
-39	-46	-22
39	17	23
-36	20	26
-60	-7	-19
57	-7	-19
-21	-10	-13
21	-7	-16
6	59	23
3	50	-19
33	35	-13
-33	35	-13
33	-10	-40
-36	-10	-34
-48	-67	35
42	-64	35
-48	-49	14
48	-55	14];

names = {'Precuneus'
'OFA-right'
'OFA-left'
'FFA-right'
'FFA-left'
'IFG-right'
'IFG-left'
'ATL-left'
'ATL-right'
'Amygdala-left'
'Amygdala-right'
'dmPFC'
'vmPFC'
'OFC-right'
'OFC-left'
'ATFP-right'
'ATFP-left'
'Angular-left'
'Angular-right'
'pSTS-left'
'pSTS-right'};
%% Extrac
aBeta = [];
for i = 1:2
spm_dir_temp = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/%s/Group_Analysis_subconst/';
fldr = {'Data_faces' 'Data_words'};
spm_dir = sprintf(spm_dir_temp,fldr{i})
sph_radius = 7.5
ofn = '/Users/aidasaglinskas/Desktop/tempROIs/';delete([ofn '*']);
func_makeROIsFromCoords(coords,names,ofn,sph_radius);
roi_dir = ofn;
roi_data = func_extract_data_from_ROIs(roi_dir,spm_dir);roi_data
roi_data.lbls = strrep(roi_data.lbls,'.mat','');
if isempty(aBeta)
aBeta = func_make_aBeta(roi_data);
else
wBeta = func_make_aBeta(roi_data);
aBeta.wmat = wBeta.fmat;
aBeta.wmat_raw = wBeta.fmat_raw;
end
end
save('/Users/aidasaglinskas/Google Drive/Mat_files/Workspace/aBeta.mat','aBeta')
%%
mat = aBeta.wmat;
cmat_task = [];
cmat_ROI = [];
cmat = {};
for i = 1:size(mat,3)
cmat_task(:,:,i) = corr(mat(:,:,i));
cmat_ROI(:,:,i) = corr(mat(:,:,i)');
end
%%
cmat = {cmat_ROI cmat_task};
f = figure(1);clf
lbls = {aBeta.r_lbls aBeta.t_lbls(1:10)};
for wh = 1:2;
subplot(1,2,wh);
this_lbls = lbls{wh};
cm = cmat{wh};
avg_cm = mean(cm,3);
Z = linkage(1-get_triu(avg_cm),'ward');
[h x perm] = dendrogram(Z,'labels',this_lbls,'orientation','left');
[h(1:end).LineWidth] = deal(3);
f.CurrentAxes.FontSize = 12;
f.CurrentAxes.FontWeight = 'bold';
ttl = ['ROI radius: ' num2str(sph_radius) 'mm'];
title(ttl,'fontsize',20);
end
%%
