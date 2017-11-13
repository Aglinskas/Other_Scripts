tic;spm('defaults','FMRI');toc
%%
dr.n40 = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/New42_Group/Group_anal_removeFUnky_m-3_s8n40ex/';
dr.group10 = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/Group_analysis12t/'
dr.group10words = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_words/Group_Analysis_subconst/';
dr.test = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/Group_Analysis_subconst/'
mask.grey = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/New42_Group/GMC3AveBinary.nii'
mask.psts = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/New42_Group/STS_aal.nii'
mask.angular = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/New42_Group/AG_aal.nii'
mask.cutAG = '/Users/aidasaglinskas/Downloads/cutAG.nii'
mask.cutpSTS = '/Users/aidasaglinskas/Downloads/cutSTS.nii'
mask.cut_cut_pSTS = '/Users/aidasaglinskas/Desktop/MasksCheck/cutSTS.nii'
mask.cut_cut_AG = '/Users/aidasaglinskas/Desktop/MasksCheck/cutAG.nii'
fn = [dr.n40 'SPM.mat']
load(fn);
con_list = arrayfun(@(x) [num2str(x) ': ' SPM.xCon(x).name],1:length(SPM.xCon),'UniformOutput',0)';
%%
temp.SPM_fn = '/Users/aidasaglinskas/Desktop/Raw_Data/Words_expData/S%d/Analysis/SPM.mat';
temp.sections_fn = '/Users/aidasaglinskas/Documents/MATLAB/spm12/canonical/single_subj_T1.nii'
xSPM = SPM;
    xSPM.Ic= 1; % Which contrast
xSPM.Ex=0;
    xSPM.Im= {};%{mask.grey}    %{mask.cutpSTS};
xSPM.title=SPM.xCon(xSPM.Ic).name;
    xSPM.thresDesc='FWE';
    xSPM.u= .01;
    xSPM.k= 0;
[hReg,xSPM,SPM] = spm_results_ui('Setup',[xSPM]) % SPM GUI
spm_sections(xSPM,hReg,temp.sections_fn) %SECTIONS
%spm_mip_ui('jump',spm_mip_ui('FindMIPax'),'glmax')
addpath('/Users/aidasaglinskas/Documents/MATLAB/marsbar');marsbar
%%
lpSTS_old = [-42	-61	26];
rpSTS_old = [48	-58	20];
spm_mip_ui('setcoords',rpSTS_old) %[m{2,3:5}]
[a dist] = spm_mip_ui('jump',spm_mip_ui('FindMIPax'),'nrmax')
a = a';
%%
round(spm_mip_ui('GetCoords')')
%% Plot f con
allfigs = get(0,'children');
spm_fig_index = find(strcmp({allfigs.Name}','SPM12 (6906): Graphics'));
figure(spm_fig_index); % select it
plot_f_co
%%
f = figure(1)
i = i+1
[set_coords bla] = spm_mip_ui('SetCoords',[m{i,[3:5]}]);
clc
disp(m{i,2})
%%
[new_coords diff] = spm_mip_ui('jump',spm_mip_ui('FindMIPax'),'nrmax')
disp(m{i,2})
new_coords = new_coords';
%diff
%clipboard('copy', new_coords)
