spm_name  =  '/Volumes/Aidas_HDD/MRI_data/S3/Analysis/SPM.mat';
 roi_file  =  '/Volumes/Aidas_HDD/MRI_data/S3/L_FFA_roi.mat';

 % Make marsbar design object
 D   =  mardo(spm_name);
 1
 % Make marsbar ROI object
 R   =  maroi(roi_file);
2
 % Fetch data into marsbar data object
 Y   =  get_marsy(R,  D,  'mean');
3
 % Get contrasts from original design
 xCon  =  get_contrasts(D);
4
 % Estimate design on ROI data
 E  =  estimate(D,  Y);
 5
 % Put contrasts from original design back into design object
 E  =  set_contrasts(E,  xCon);
 6
 % get design betas
 b  =  betas(E);
 7
 % get stats and stuff for all contrasts into statistics structure
 marsS  =  compute_contrasts(E,  1:length(xCon));