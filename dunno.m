master_coords = [[3  -52 29
3   50  -19
6   59  23
-3  59  23
42  -46 -22
57  -7  -19
48  -58 20
60  -52 11
42  23  20
57  26  2
39  5   38
-42 -61 26
-60 -7  -19
-21 -10 -13
21  -7  -16
-36 20  26
-36 26  -22
-48 11  -31
-42 20  -25
30  -91 -10
-39 -46 -22
33  35  -13
33  -10 -40
-33 -88 -10
45  11  -34]]
%% 
w = 0
%%
w = w + 1
spm_mip_ui('SetCoords',master_coords(w,:),mip)

%%
%for w = 1:length(master_coords)
for w = 1:length(master_coords)
%t = spm_mip_ui('SetCoords',master_coords(w,:));
L = spm_atlas('list');
xA = spm_atlas('load',L.file);
master_coords_labels{w} = spm_atlas('query',xA,master_coords(w,:)')
end
%master_labels{w} = lbl
%end
master_coords_labels = master_coords_labels'
%%
ofn = '/Users/aidasaglinskas/Google Drive/MRI_data/master_coords.mat'
save(ofn,'master_coords','master_coords_labels')
%%

here = spm_mip_ui('GetCoords');
spm_atlas('query',xA,here)
% FORMAT xA = spm_atlas('load',atlas)
%   FORMAT L = spm_atlas('list')
%   FORMAT [S,sts] = spm_atlas('select',xA,label)
%   FORMAT Q = spm_atlas('query',xA,XYZmm)
%   FORMAT [Q,P] = spm_atlas('query',xA,xY)
%   FORMAT VM = spm_atlas('mask',xA,label,opt)
%   FORMAT V = spm_atlas('prob',xA,label)
%   FORMAT V = spm_atlas('maxprob',xA,thresh)
%   FORMAT D = spm_atlas('dir')
%  
%   FORMAT url = spm_atlas('weblink',XYZmm,website)
%   FORMAT labels = spm_atlas('import_labels',labelfile,fmt)
%   FORMAT spm_atlas('save_labels',labelfile,labels)
