clear all
loadMR
%%
func_fn = '/Users/aidasaglinskas/Google Drive/Data/S%d/Functional/Sess%d/swdata.nii'
ana_fn = '/Users/aidasaglinskas/Google Drive/Data/S%d/Analysis/SPM.mat'
for s = 1:20
subID = subvect(s)
load(sprintf(ana_fn,subID))
% Stacking
single_sess = struct;
ds = struct;
for sess = 1:5;
sub_nii_fn = sprintf(func_fn,subID,sess);
sub_mask_fn = fullfile(masks.dir,masks.nii_files{8});
func_vols = length(spm_vol(sub_nii_fn));
single_sess = cosmo_fmri_dataset(sub_nii_fn,'mask',sub_mask_fn,'volumes',[1:func_vols]);
if sess == 1
   ds = single_sess;
else  
    ds = cosmo_stack({ds,single_sess});
end
end % ends sess stacking
disp('Stacked')
disp(ds)
%%
%SPM.xX.X % Desin matrix
con_vect = ([zeros(1,10) 1 -1 zeros(1,6)]); %monuments vs 
con = repmat(con_vect,1,5);
%cols = find(con ~= 0);
d = size(SPM.xX.X);
%%
b = sum(SPM.xX.nKX(:,1:size(con,2)) .* repmat(con,d(1),1),2); %SPM.xX.nKX
a = mean(ds.samples,2);
b = b*2
a = a ./ 4
b = b+mean(a)
%a = a ./ 2
%b = b + (a ./ 2)
%b = b+a
f = figure(7)
clf
plot(a)
hold on
plot(b,'linewidth',2)

ofn.root = '/Users/aidasaglinskas/Desktop/2nd_Fig/Voxel_vs_regressor/';
ofn.full = fullfile(ofn.root,num2str(subID))
saveas(f,ofn.full,'jpg')
end