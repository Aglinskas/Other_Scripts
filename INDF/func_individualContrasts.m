function func_individualContrasts(subID)

spm_path_temp = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_words/S%d/Analysis_INDF/SPM.mat';
spm_path = sprintf(spm_path_temp,subID)
% Prerequisites
load(spm_path)
load('/Users/aidasaglinskas/Desktop/unique_face.mat');
cv = [[SPM.Sess(1).U.name] repmat({'RP'},1,6) [SPM.Sess(2).U.name] repmat({'RP'},1,6) [SPM.Sess(3).U.name] repmat({'RP'},1,6) [SPM.Sess(4).U.name] repmat({'RP'},1,6) [SPM.Sess(5).U.name] repmat({'RP'},1,6)]';
matlabbatch = {};
s =1
% make con
l = 0;
matlabbatch{s}.spm.stats.con.spmmat = {spm_path};%subject specific .mat file
matlabbatch{s}.spm.stats.con.consess = {}; % for length counter 
for f_ind = 1:length(unique_face);
this_con = strcmp(cv,unique_face{f_ind});
% add to batch
matlabbatch{s}.spm.stats.con.consess{f_ind}.tcon.name = unique_face{f_ind};
matlabbatch{s}.spm.stats.con.consess{f_ind}.tcon.convec = double(this_con)';
matlabbatch{s}.spm.stats.con.consess{f_ind}.tcon.sessrep = 'none';
end
matlabbatch{s}.spm.stats.con.delete = 1;
% run batch
spm_jobman('run',matlabbatch)