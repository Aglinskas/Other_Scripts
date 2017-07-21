%clear;
i = 0
loadMR
% Show SPM
temp.SPM_fn = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/LOSO/LOSO_allExcept%d/SPM.mat';
temp.sections_fn = '/Users/aidasaglinskas/Documents/MATLAB/spm12/canonical/single_subj_T1.nii'

%for i = 1%:20
i = i + 1
subID = subvect(i);
clear SPM;
spm('defaults','FMRI')
%arrayfun(@(x) ['Con ' num2str(x),':' SPM.xCon(x).name],1:length(SPM.xCon),'UniformOutput',0)'
load(sprintf(temp.SPM_fn,subID))
xSPM = SPM;
xSPM.Ic=3;
xSPM.Ex=0;
xSPM.Im=[];

%xSPM.Ex=1;
%xSPM.Im=['/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/Group_analysis12t/mask.nii'];

xSPM.title=SPM.xCon(xSPM.Ic).name;
xSPM.thresDesc='none';
xSPM.u= .9999;
xSPM.k=15;

[hReg,xSPM,SPM] = spm_results_ui('Setup',[xSPM]) % SPM GUI
spm_sections(xSPM,hReg,temp.sections_fn) %SECTIONS
a = [];
i = 0
%%
i = i +1
for r_ind = 1:18
title(m{r_ind,2})
c = [m{r_ind,3:end}];
spm_mip_ui('setcoords',c);
disp(m{r_ind,2});
h=spm_mip_ui('FindMIPax');
pause(1)
[a_coords dist] = spm_mip_ui('jump',h,'nrmax');
%plot_f_co
    a_coords = a_coords';
pause(1)
disp(a_coords)
disp(dist)
a(r_ind,1) = dist;
cc(r_ind,:) = a_coords';
a = round(a);
end
%disp(round(a))
%%
    all_figs = get(0,'children');
    spm_g_fig = all_figs(find(cellfun(@isempty,arrayfun(@(x) strfind(all_figs(x).Name,': Graphics'),[1:2],'UniformOutput',0)) == 0));
    spm_res_fig = all_figs(find(cellfun(@isempty,arrayfun(@(x) strfind(all_figs(x).Name,': Results'),[1:2],'UniformOutput',0)) == 0));
    
spm_g_fig.Position = spm_g_fig.Position *1.5
% y=spm_mip_ui('Extract', 'y', 'voxel');
% collect(:,i) = y;


%hReg.Position = [0.0093    0.0197    0.9817    0.9597]


% round(spm_mip_ui('GetCoords'))'
%end

%%
i = 4;
spm_mip_ui('SetCoords',[m{i,3:end}])'

