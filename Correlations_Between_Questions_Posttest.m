%% Get Scores to Q5 as vectors
% load('/Users/aidas_el_cap/Downloads/myTrials_fMRI_last.mat')
% master_list = myTrials
fn = '/Volumes/Aidas_HDD/MRI_data/S%d/S%d_Results.mat';
clear sub_resp_fmri
subjects = 7:23%[10 11 15 16 17 19 20 21 22 23 9];% 7:23 % 
subjects(7) = [] % get rid of sub 13
clear sub_resp_fmri nms
for subID = subjects %subvect;
load(sprintf(fn,subID,subID));
for z = 1:length(myTrials); if isempty(myTrials(z).resp); myTrials(z).resp = 0;myTrials(z).RT = 0;end;end
nms = cellfun(@(x) strsplit(x,'/'),{myTrials.filepath},'UniformOutput',false)';
nms = cellfun(@(x) x{2},nms,'UniformOutput',false);
myTrials(1).name = []; [myTrials(1:length(myTrials)).name] = deal(nms{:});
[~,index] = sortrows({myTrials.filepath}.'); myTrials = myTrials(index); clear index
sub_resp_fmri(:,subID) =[myTrials(find([myTrials.blockNum] == 5)).resp]';
end
%% Mean of familiarity vectors
mean_sub_resp_fmri = mean(sub_resp_fmri(:,subjects),2);
%% Correlation of Subject vectors to the mean
clear corswmean overall_fmri
for i = 1:length(subjects)
[c p] = corr(sub_resp_fmri(:,subjects(i)),mean_sub_resp_fmri,'type','Spearman');
corswmean(i,1) =  c;
corswmean(i,2) =  p;
corswmean(i,3) =  subjects(i);
end
corswmean
overall_fmri = mean(corswmean(:,1));

%% Post Test
pt_dir_fn = '/Users/aidas_el_cap/Desktop/00_fmri_pilot_final/';
pt_ext = 's_';
pt_fls = dir([pt_dir_fn pt_ext '*']); pt_fls = {pt_fls.name}';
clear sub_resp_posttest
for i = 1:length(pt_fls)
load([pt_dir_fn pt_fls{i}]) 
[~,index] = sortrows({recog.name}.'); recog = recog(index); clear index
if isempty(recog(6).response); recog(6).response = 0;end
sub_resp_posttest(:,i) = [recog.response]';
end
sub_resp_posttest;
mean_sub_resp_posttest = mean(sub_resp_posttest,2);
%% Post test correlations to mean
for i = 1:length(pt_fls)
[c p] = corr(sub_resp_posttest(:,i),mean_sub_resp_posttest,'type','Spearman');
pt_corswmean(i,1) = c;
pt_corswmean(i,2) = p;
end
pt_corswmean
mean_pt_corswmean = mean(pt_corswmean(:,1));

%% Cors between fmri and post test
% sub_resp_fmri
% sub_resp_posttest
dsubjects = [10 11 15 16 17 19 20 21 22 23 9];
clear fmri_post_cor mean_fmri_post_cor
sub_resp_posttest(6,:) = 2;
for s = 1:length(pt_fls)
[c p] = corr(sub_resp_posttest(:,s),sub_resp_fmri(:,dsubjects(s)),'type','Spearman')
fmri_post_cor(s,1) = c;
fmri_post_cor(s,2) = p;
fmri_post_cor(s,3) = dsubjects(s);
end
fmri_post_cor
mean_fmri_post_cor = mean(fmri_post_cor(:,1))