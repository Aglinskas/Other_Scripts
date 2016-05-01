for subID = [23];
a = '/Volumes/Aidas_HDD/MRI_data/S%d/Anatomical/';
f = '/Volumes/Aidas_HDD/MRI_data/S%d/Functional/Sess%d/';
ana_path = sprintf(a,subID);
%% Anatomical
if exist(fullfile(ana_path,'Ana_nopeel.nii')) == 0
ana_fn = dir([ana_path '*.nii']);
ana_fn = ana_fn.name;
movefile(fullfile(ana_path,ana_fn),fullfile(ana_path,'Ana_nopeel.nii'));end
%% Fucntiona;
for sess = 1:5;
fucn_fn = sprintf(f,subID,sess);
f_file = dir(fullfile(fucn_fn,'*.nii'));f_file = f_file.name;
if exist(fullfile(fucn_fn,'data.nii')) == 0;
movefile(fullfile(fucn_fn,f_file),fullfile(fucn_fn,'data.nii'));
end % ends if loop
end % ends sess loop
end % ends subID loop