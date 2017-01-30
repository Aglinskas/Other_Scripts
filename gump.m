loadMR
%%

masks.nii_files{7} % 7 Left FFA, 8 right FFA
subID = 17;
sess = 1;
mtfn = sprintf('/Users/aidasaglinskas/Google Drive/Data/S%d/S%d_ScannerMyTrials_RBLT.mat',subID,subID) ;
load(mtfn)
fl = sprintf('/Users/aidasaglinskas/Google Drive/Data/S%d/Functional/Sess%d/wdata.nii',subID,sess);

%%
dt = cosmo_fmri_dataset(fl,'mask',fullfile(masks.dir,masks.nii_files{7}));
%%
a = mean(dt.samples,2);
a = zscore(a);
figure(1)
plot(a)

b_mt = myTrials;


