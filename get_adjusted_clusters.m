%% Set up SPM
close all
spm_path = '/Volumes/Aidas_HDD/MRI_data/Group_Analysis/SPM.mat';
load(spm_path); spm('defaults','FMRI')
useContrast = 3; % which contrast to show
Ic = 1; %which con to calc (hint: F contrast)


p_tresh = 0.1;
MCC = 'none'; % 'none' or 'FWE'
k_extent = 0;
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

%%
cluster_k = 10
n_clust = max(all_clust);
all_clust = spm_clusters(xSPM.XYZ);
for clust_counter = unique(all_clust);
j = find(all_clust == clust_counter);
if length(j) > cluster_k
clust_c = xSPM.XYZmm(:,j);
clust_z = xSPM.Z(j)';
clust_z(:,2) = j;
clust_z(:,3) = 1:length(clust_z);
top = sortrows(clust_z,1);
top_ind = top(length(top):-1:length(top)-cluster_k,2);
%adj_cluster_XYZmm = clust_c(:,top_ind) % adjusted cluster coordinates;
adj_cluster_XYZ = xSPM.XYZ(:,top_ind);
adj_cluster_XYZmm = xSPM.XYZmm(:,top_ind);
else
adj_cluster_XYZ = xSPM.XYZ(:,j);
adj_cluster_XYZmm = xSPM.XYZmm(:,j);
length(adj_cluster_XYZmm)
end
end