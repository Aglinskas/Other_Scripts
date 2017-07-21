
%% Combine Blobs and Covert Blobs
    space_fn = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S7/Analysis/beta_0002.nii';
space = mars_space(space_fn);

blobs_dir = '/Users/aidasaglinskas/Desktop/faces_blobsp01/';
    temp = dir([blobs_dir 'A*.mat']);
blobs_fn = {temp.name}';

all_blobs = [];
for i = 1:length(blobs_fn);
clear roi 
    load(fullfile(blobs_dir,blobs_fn{i}));
    if isempty(all_blobs);
        all_blobs = roi;
    else
        all_blobs = all_blobs | roi;
    end
end
saveroi(all_blobs,[blobs_dir 'Blobs_combined.mat'])
mars_rois2img([blobs_dir 'Blobs_combined.mat'],[blobs_dir 'Blobs_combined.nii'],space)
%% Make ROIs from coords
coords = [  0   -49    29
    54   -67    29
   -42   -61    32
    36   -97    -7
   -36   -94   -13
    42   -49   -22
   -42   -49   -22
    51    23    14
   -42    23    20
   -63   -10   -19
    60   -13   -28
   -21    -4   -13
    21    -4   -16
     0    53   -16
    27    38   -22
   -36    32   -16
    33   -10   -40
   -36   -13   -34];
names = {'Precuneus'
'AngularRight'
'AngularLeft'
'OFARight'
'OFALeft'
'FFARight'
'FFALeft'
'IFGRight'
'IFGLeft'
'ATLLeft'
'ATLRight'
'AmygdalaLeft'
'AmygdalaRight'
'PFCmedial'
'OrbRight'
'OrbLeft'
'Face PatchRight'
'Face PatchLeft'};
%%
sph_radius = 7.5;

all_blobs = load('/Users/aidasaglinskas/Desktop/faces_blobsp01/Blobs_combined.mat')
    space_fn = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S7/Analysis/beta_0002.nii';
space = mars_space(space_fn);
ofn = '/Users/aidasaglinskas/Desktop/faces_blobsp01/'

all_rois = [];
for i = 1:length(names)

    


this_sphere = maroi_sphere(struct('centre',coords(i,:),'radius', sph_radius));
    if isempty(all_rois); all_rois = this_sphere;end

this_sphere = this_sphere & all_blobs.roi
    all_rois = all_rois | this_sphere;
ofn_nm = [ofn 'ROI_' names{i} '.mat'];

saveroi(this_sphere,ofn_nm)    
mars_rois2img(ofn_nm,strrep(ofn_nm,'.mat','.nii'),space)

end

saveroi(all_rois,[ofn 'ROIs_Combined.mat'])    
mars_rois2img([ofn 'ROIs_Combined.mat'],[ofn 'ROIs_Combined.nii'],space)