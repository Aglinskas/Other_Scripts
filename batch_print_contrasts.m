clear all
spm('defaults','FMRI')
fn = '/Volumes/Aidas_HDD/MRI_data/S%d/Analysis_mask02/SPM.mat';
%ofn = '/Volumes/Aidas_HDD/MRI_data/29th_march/S%d/Analysis/batch_results/';
s = [29 30];
%%
thresh = [0.001 0.05];
threshdesc = {'none' 'FWE'};
thresh = thresh(1)
threshdesc = threshdesc(1)
%%
%%
if length(thresh) == length(threshdesc)
    l = length(thresh);
else error('thresh and threshdesc have different lengths')
end
%%
for i = 1:length(s)
    subID = s(i);
    %cd(sprintf(ofn,subID))
    load(sprintf(fn,subID))
    for v = 1:l
    for con = 1:3%length(SPM.xCon);
matlabbatch{con}.spm.stats.results.spmmat = {sprintf(fn,subID)};
matlabbatch{con}.spm.stats.results.conspec.titlestr = ['S' num2str(subID) ' ' SPM.xCon(con).name ' p<' num2str(thresh(v)) '(' threshdesc{v} ')'];
matlabbatch{con}.spm.stats.results.conspec.contrasts = con;
matlabbatch{con}.spm.stats.results.conspec.threshdesc = threshdesc{v}; %FWE
matlabbatch{con}.spm.stats.results.conspec.thresh = thresh(v);
matlabbatch{con}.spm.stats.results.conspec.extent = 0;
matlabbatch{con}.spm.stats.results.conspec.conjunction = 1;
matlabbatch{con}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{con}.spm.stats.results.units = 1;
matlabbatch{con}.spm.stats.results.print = 'ps';
matlabbatch{con}.spm.stats.results.write.none = 1; % wite treshloded images
    end
    disp(['Printing Cons for sub' num2str(subID)])
    spm_jobman('initcfg')
    spm_jobman('run',matlabbatch)
    disp('Done')
    end
end