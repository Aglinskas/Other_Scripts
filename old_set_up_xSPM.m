% set_up_xSPM
% Loads up and sets up a xSPM structure
% Overwritable params: 
% 
% Gives back figure handles for: 
% hReg, mip, [cor sag ax overlays;]

close all
spm_path = '/Volumes/Aidas_HDD/MRI_data/Group_Analysis/SPM.mat';
load(spm_path);
spm('defaults','FMRI')
%coord = [52 -56 22]; % coordinates to center on
if exist('useContrast','var') == 0
useContrast = 3;end % which contrast to show
if exist('p_tresh','var') == 0
p_tresh = 0.001;end
if exist('MCC','var') == 0
MCC = 'none';end % 'none' or 'FWE'
if exist('k_extent','var') == 0
k_extent = 30;end
mask.opt = 1; % 0 for don't use the mask, otherwise, index of mask to use.
mask.mask{1} = '/Volumes/Aidas_HDD/MRI_data/fixed_rBroadMVPMask.nii';
mask.method = {'incl.' 'excl.'};
rend.opt = 1 % 1 for sections, 2 for surface
t = {'First memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Familiarity' 'Common name' 'How many facts' 'Occupation' 'Distinctiveness' 'Full name' 'Same Face' 'Same monument'}';
t_old = {'Colore dei capelli' 'Memoria remota?' 'Quanto attraente?' 'Quanto amichevole?' 'Quanto affidabile?' 'Emozioni positive?' 'Quanto familiare?' 'Quanto scriveresti?' 'Nome comune?' 'Quanti fatti ricordi?' 'Che lavoro fa?' 'Volto distintivo?' 'Quanto integra?' 'Stesso volto?' 'Stesso monumento?'}';
    xSPM=SPM;
    xSPM.Ic=useContrast;
    %xSPM.Im=0;
    xSPM.Ex=0;
    xSPM.title=SPM.xCon(useContrast).name;
    xSPM.thresDesc=MCC; % none FWE
    xSPM.u=p_tresh;
    xSPM.k=k_extent;
    if mask.opt == 0
    xSPM.Im=[];
    else
    xSPM.Im={mask.mask{mask.opt}};
    mask.maskfn = strsplit(mask.mask{mask.opt},'/');
    mask.maskfn = mask.maskfn{length(mask.maskfn)};
    xSPM.title = [SPM.xCon(useContrast).name ' masked by ' mask.method{xSPM.Ex+1} ' ' mask.maskfn];
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
if rend.opt == 1
single_subj_T1_fn = '/Users/aidas_el_cap/Documents/MATLAB/spm12/canonical/single_subj_T1.nii';
spm_sections(xSPM,hReg,single_subj_T1_fn);
elseif rend.opt == 2
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