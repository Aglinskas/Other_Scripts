%% LOAD SPM
close all
fn = '/Volumes/Aidas_HDD/MRI_data/S%d/Analysis/SPM.mat';
subID = 8;
spm_path = sprintf(fn,subID);
load(spm_path);
spm('defaults','FMRI')
%
coord = [52 -56 22]; % coordinates to center on
useContrast = 1; % which contrast to show
Ic = 1; %which con to calc (hint: F contrast)
%
t = {'First memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Familiarity' 'Common name' 'How many facts' 'Occupation' 'Distinctiveness' 'Full name' 'Same Face' 'Same monument'}';
t_old = {'Colore dei capelli' 'Memoria remota?' 'Quanto attraente?' 'Quanto amichevole?' 'Quanto affidabile?' 'Emozioni positive?' 'Quanto familiare?' 'Quanto scriveresti?' 'Nome comune?' 'Quanti fatti ricordi?' 'Che lavoro fa?' 'Volto distintivo?' 'Quanto integra?' 'Stesso volto?' 'Stesso monumento?'}';
%load([myPath '/' subFolders{sub} '/' statFold '/SPM.mat']);
    % constants again
    nConds=length(SPM.Sess(1).U);
    colsPerSess=nConds+length(SPM.Sess(1).C.name);
    nSess=length(SPM.Sess);
    regVec=[1:nConds];
    %
    xSPM=SPM;
    xSPM.Ic=useContrast;
    xSPM.Im=0;
    xSPM.Ex=0;
    xSPM.Im='/Users/aidas_el_cap/Desktop/fixed_rBroadMVPMask.nii';
    xSPM.title=SPM.xCon(useContrast).name;
    xSPM.thresDesc='FWE'; % none FWE
    xSPM.u= .05;
    xSPM.k=33;
    disp(SPM.xCon(useContrast).name)
    %
    [hReg,xSPM,SPM]=spm_results_ui('Setup',xSPM);
    hMIPax=spm_mip_ui('FindMIPax');
    hFxyz = spm_results_ui('FindXYZframe');
    % Results should be up
    
    % figure out how many figures are open
    
set(0, 'ShowHiddenHandles', 'on');
spm_figs = (get(0, 'Children')); %figure out SPM graphics window, go to graphics, get children;
for p = 1:length(spm_figs);
if strmatch(spm_figs(p).Name,'SPM12 (6685): Graphics');
    disp(['found spm graphics window, it''s ' num2str(p)]);
    spm_g = spm_figs(p);
    for o = 1: length(spm_g.Children);
        if strmatch('hMIPax',spm_g.Children(o).Tag);
            mip = spm_g.Children(o);
        end
    end
end
end
n_figs = length(get(0, 'Children')); 
eb_fig = n_figs+1;
% overlay sections
single_subj_T1_fn = '/Users/aidas_el_cap/Documents/MATLAB/spm12/canonical/single_subj_T1.nii';
spm_sections(xSPM,hReg,single_subj_T1_fn);

% positions the spm_window
try
    spm_g.Position = [-0.4861 0.0467 0.3660 0.8444];
    spm_figs(2).Position = [-1097 22 351 347];
catch
end
    
% section overlays should be at spm_g.Children(13),spm_g.Children(14), spm_g.Children(15)
%%










