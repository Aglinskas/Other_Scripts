loadMR
fig_ofn = '/Users/aidasaglinskas/Desktop/2nd_Fig/Region_Hunt/';
L = spm_atlas('list');
xA = spm_atlas('load',L.file);

for wh_c = [9 10]
for subID = subvect;
 
 opts_xSPM.spm_path = sprintf('/Users/aidasaglinskas/Google Drive/Data/S%d/Analysis/SPM.mat',subID);
 opts_xSPM.mask_which_mask_ind = 0;
 opts_xSPM.p_tresh = .001;
 opts_xSPM.useContrast = 4;
    opts_xSPM.mask_which_mask_ind = 0;% 0 for don't use the mask, otherwise, index of mask to use.
    %opts_xSPM.mask_mask{1} = sprintf('/Users/aidasaglinskas/Google Drive/Data/S%d/Analysis/mask.nii',subID)
 set_up_xSPM
%
clusters = spm_clusters(xSPM.XYZ);
%wh_c = 10
group_coord = spm_mip_ui('SetCoords',master_coords(wh_c,:),mip)'
this_peak_coord = spm_mip_ui('jump',mip,'nrmax')'
group_coord = spm_mip_ui('SetCoords',master_coords(wh_c,:),mip)'
dist = pdist([group_coord;this_peak_coord],'euclidean');
%
ttl = { master_coords_labels{wh_c}
    ['Group Coordinate : ' num2str(group_coord)]
['Subject Coordinate : ' num2str(this_peak_coord)]
['Distance : ' num2str(dist)]};
%title(ttl);
cor.Title.String = ttl;
ofn_name = ['Sub ' num2str(subID) ' ' master_coords_labels{wh_c}];

v_ind = find(xSPM.XYZmm(1,:) == this_peak_coord(1) & xSPM.XYZmm(2,:) == this_peak_coord(2) & xSPM.XYZmm(3,:) == this_peak_coord(3));

clys

spm_atlas('query',xA,this_peak_coord')

%sag.Title.String = 





saveas(mip,fullfile(fig_ofn,ofn_name),'jpg');
end
end
%%
%   hReg, mip, [cor sag ax overlays;]
%   Defaults:
%   opts_xSPM.spm_path
%   opts_xSPM.useContrast
%   opts_xSPM.rend_opt % 1 for sections, 2 for surface
%   opts_xSPM.p_tresh = 0.999 default
%   opts_xSPM.MC_correction = 'none' (default) or 'FWE'
%   opts_xSPM.k_extent = 0 (default)
%   opts_xSPM.mask_which_mask_ind = 1; end% 0 for don't use the mask, otherwise, index of mask to use.
%   opts_xSPM.mask_mask{1} = '~/Google Drive/MRI_data/Group_anal_m-3_s8n44/conj_a1.nii';end
%  
%   {SPM.xCon.name}'








%%
%X = master_coords([1 2],:);
% X = [-21    -7   -13
%     -21    -7   -16]
% pdist(X,'euclidean')



%%
master_coords = [ -27    -4   -19
 21    -4   -16
 -39   -61    32
49 -61 28
 -48    11   -34
54    14   -34
 -63   -10   -19
 60   -13   -28
-42   -49   -22
42   -49   -22
-39   -13   -34
36   -10   -40
-45    23    20
47 23 20
 0    53   -16
 -39   -85   -13
36   -97    -7
 -33    17   -22
36    23   -19
-3   -61    32
 -18    29    50
18    32    56]
%
master_coords_labels = {'Amygdala-l'
'Amygdala-r'
'Angular-l'
'Angular-r'
'ATL-ant-l'
'ATL-ant-r'
'ATL-l'
'ATL-r'
'FFA-l'
'FFA-r'
'FP-l'
'FP-r'
'IFG-l'
'IFG-r'
'mPFC'
'OFA-l'
'OFA-r'
'Orb-l'
'Orb-r'
'Prec'
'SFG-l'
'SFG-r'}