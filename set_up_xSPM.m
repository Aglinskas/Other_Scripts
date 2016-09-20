% set_up_xSPM
% Loads up and sets up a xSPM structure
% Overwritable parameters are in opts_xSPM. structure
% 
% Gives back figure handles for: 
% hReg, mip, [cor sag ax overlays;]
% Defaults:
% opts_xSPM.spm_path
% opts_xSPM.useContrast
% opts_xSPM.rend_opt % 1 for sections, 2 for surface
% opts_xSPM.p_tresh = 0.999 default
% opts_xSPM.MC_correction = 'none' (default) or 'FWE'
% opts_xSPM.k_extent = 0 (default)
% opts_xSPM.mask_which_mask_ind = 1; end% 0 for don't use the mask, otherwise, index of mask to use.
% opts_xSPM.mask_mask{1} = '/Volumes/Aidas_HDD/MRI_data/Group_anal_m-3_s8n44/conj_a1.nii';end
%
% {SPM.xCon.name}'

if exist('opts_xSPM') == 0
    opts_xSPM = struct;end
close all
%
if isfield(opts_xSPM,'spm_path') == 0
opts_xSPM.spm_path = '/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/SPM.mat';
end
if isfield(opts_xSPM,'useContrast') == 0
opts_xSPM.useContrast = 1; % which contrast to show
end
%opts_xSPM.available_cons = {SPM.xCon.name}';
% {SPM.xCon.name}'
%Ic = 1; %which con to calc (hint: F contrast)
if isfield(opts_xSPM,'p_tresh') == 0
opts_xSPM.p_tresh = 0.9999;end
if isfield(opts_xSPM,'MC_correction') == 0
opts_xSPM.MC_correction = 'none'; end % 'none' or 'FWE'
if isfield(opts_xSPM,'k_extent') == 0
opts_xSPM.k_extent = 0;end
if isfield(opts_xSPM,'mask_which_mask_ind') == 0
opts_xSPM.mask_which_mask_ind = 3; end% 0 for don't use the mask, otherwise, index of mask to use.
if isfield(opts_xSPM,'mask_mask') == 0
%opts_xSPM.mask_mask{1} = '/Volumes/Aidas_HDD/MRI_data/fixed_rBroadMVPMask.nii';end
opts_xSPM.mask_mask{1} = '/Volumes/Aidas_HDD/MRI_data/Group_anal_m-3_s8n44/conj_a1.nii';
opts_xSPM.mask_mask{2} = '/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/Sphere_MASK_combined.nii'
opts_xSPM.mask_mask{3} = '/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/Sphere_MASK_combined_roi2.nii'
end
if isfield(opts_xSPM,'mask_method') == 0
opts_xSPM.mask_method = {'incl.' 'excl.'};end
if isfield(opts_xSPM,'rend_opt') == 0
opts_xSPM.rend_opt = 1;end % 1 for sections, 2 for surface
%% end of opts.
load(opts_xSPM.spm_path);
spm('defaults','FMRI')
t = {'First memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Familiarity' 'Common name' 'How many facts' 'Occupation' 'Distinctiveness' 'Full name' 'Same Face' 'Same monument'}';
t_old = {'Colore dei capelli' 'Memoria remota?' 'Quanto attraente?' 'Quanto amichevole?' 'Quanto affidabile?' 'Emozioni positive?' 'Quanto familiare?' 'Quanto scriveresti?' 'Nome comune?' 'Quanti fatti ricordi?' 'Che lavoro fa?' 'Volto distintivo?' 'Quanto integra?' 'Stesso volto?' 'Stesso monumento?'}';
    xSPM=SPM;
    xSPM.Ic=opts_xSPM.useContrast;
    %xSPM.Im=0;
    xSPM.Ex=0;
    xSPM.title=SPM.xCon(opts_xSPM.useContrast).name;
    xSPM.thresDesc=opts_xSPM.MC_correction; % none FWE
    xSPM.u=opts_xSPM.p_tresh;
    xSPM.k=opts_xSPM.k_extent;
    if opts_xSPM.mask_which_mask_ind == 0
    xSPM.Im=[];
    else
    xSPM.Im={opts_xSPM.mask_mask{opts_xSPM.mask_which_mask_ind}};
    opts_xSPM.mask_maskfn = strsplit(opts_xSPM.mask_mask{opts_xSPM.mask_which_mask_ind},'/');
    opts_xSPM.mask_maskfn = opts_xSPM.mask_maskfn{length(opts_xSPM.mask_maskfn)};
    xSPM.title = [SPM.xCon(opts_xSPM.useContrast).name ' masked by ' opts_xSPM.mask_method{xSPM.Ex+1} ' ' opts_xSPM.mask_maskfn];
    end
    %disp(xSPM.title)
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
if opts_xSPM.rend_opt == 1
single_subj_T1_fn = '/Users/aidasaglinskas/Documents/MATLAB/spm12/canonical/single_subj_T1.nii';
spm_sections(xSPM,hReg,single_subj_T1_fn);
elseif opts_xSPM.rend_opt == 2
end    
try % positions the spm_window
    spm_g.Position = [-0.4861 0.0467 0.3660 0.8444];
    spm_figs(2).Position = [-1097 22 351 347];
catch
end
map = colormap(spm_figs(1).Children(15));
% figure(500)
a = figure;
set(a,'Visible', 'off')
sag = spm_figs(1).Children(13);
cor = spm_figs(1).Children(14);
axial = spm_figs(1).Children(15);
copyobj(sag,gcf);
copyobj(cor,gcf);
copyobj(axial,gcf);
colormap(a,map);
%SPM Window is up

opts_xSPM
%%
%                spm_path: '/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/SPM.mat'
%             useContrast: 1
%                 p_tresh: 1.0000
%           MC_correction: 'none'
%                k_extent: 0
%     mask_which_mask_ind: 1
%               mask_mask: {1x3 cell}
%             mask_method: {'incl.'  'excl.'}
%                rend_opt: 1
%             mask_maskfn: 'conj_a1.nii'