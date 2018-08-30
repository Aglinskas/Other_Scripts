clear;
%% Setup
addpath('/Users/aidasaglinskas/Desktop/Other_Scripts/Behavioral-White-Paper/')
loadMR
vx = struct;
%% MRI data
root = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/'
ext = 'swdata.nii';
fn_temp = 'S%d/Functional/Sess%d/';
svec = subvect.face;
svec(16) = [];
%% Masks
masks = []
masks.fn_temp = '/Users/aidasaglinskas/Desktop/sROIS/S%d/'
temp = dir([sprintf(masks.fn_temp,svec(1)) 'trimROI_*.nii']);
masks.fls = {temp.name}';
masks.lbls = masks.fls;
masks.lbls = strrep(masks.lbls,'trimROI_','');
masks.lbls = strrep(masks.lbls,'.nii','');
%% MyTrials and Faces
mt_fn_temp = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S%d/S%d_ScannerMyTrials_RBLT';
myTrials = load_myTrials(sprintf(mt_fn_temp,svec(1),svec(1)));
myTrials = fix_myTrials(myTrials);
names = unique({myTrials(ismember([myTrials.blockNum],1:10)').word}');
%%
%n_iters = length(svec)*5*length(masks.fls)*length([red_myTrials.TR]);
t_start = GetSecs;
iter = 0;

all_ds = [];
TR_offset = 2;
% subject loop 
for s_ind = 1:length(svec)
    subID = svec(s_ind);
% load myTrials
mt_fn = sprintf(mt_fn_temp,subID,subID);
myTrials = load_myTrials(mt_fn);
myTrials = fix_myTrials(myTrials);
% add TRs
to_deal = [[myTrials.time_presented] / 2.5]';
to_deal = arrayfun(@(x) {x},to_deal);
[myTrials(1:length(to_deal)).TR] = deal(to_deal{:});
for sess_ind = 1:5
dt_fn = fullfile(root,[sprintf(fn_temp,subID,sess_ind) ext]);

% reduce myTrials 
red_inds = find([myTrials.fmriRun]' == sess_ind & ismember([myTrials.blockNum]',1:10) & [round([myTrials.TR])'+TR_offset] <= length(spm_vol(dt_fn)));
red_myTrials = myTrials(red_inds);
% mask loop
for r_ind = 1:length(masks.fls)
m_fn = fullfile(sprintf(masks.fn_temp,subID),masks.fls{r_ind});
% face loop
for f_ind = 1:length([red_myTrials.TR]);
iter = iter+1;
    clc;
    text = sprintf('S: %d/%d | M: %d/%d',s_ind,length(svec),r_ind,length(masks.fls));disp(text);
    disp(vx);
    b_ind = red_myTrials(f_ind).blockNum;
    TR = round(myTrials(f_ind).TR);
    f_pos = find(strcmp(names,red_myTrials(f_ind).word));
    
    
    
ds = cosmo_fmri_dataset(dt_fn,'mask',m_fn,'volumes',TR+TR_offset);
% ds.sa.s_ind = s_ind;
% ds.sa.b_ind = b_ind;
% ds.sa.f_pos = f_pos;
% ds.sa.sess_ind= sess_ind;
% 
% 
% 
% 
% 
% if iter == 1;
%     all_ds = ds;
% else 
% ds.fa.i = all_ds.fa 
% all_ds = cosmo_stack({all_ds ds});
% end

%perc = iter / n_iters * 100;
%perc_str = sprintf('%.6f perc',perc);



vx.f_voxel_data{r_ind,b_ind,f_pos,s_ind} = ds.samples;

% if isempty(all_ds)
%     all_ds = ds;
% else all_ds = cosmo_stack({all_ds ds})
% end

end % ends face loop
end % ends masks
end % end sess
save('/Users/aidasaglinskas/Desktop/vxFB.mat','vx')
end % ends s_ind
save('/Users/aidasaglinskas/Desktop/vxFB_wrkspc.mat')
%%