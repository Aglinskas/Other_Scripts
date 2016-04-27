%% LOAD SPM
close all
fn = '/Volumes/Aidas_HDD/MRI_data/S%d/Analysis/SPM.mat';
subID = 9;
spm_path = sprintf(fn,subID);
load(spm_path);
spm('defaults','FMRI')
%
coord = [52 -56 22]; % coordinates to center on
useContrast = 2; % which contrast to show
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
    xSPM.Im=[];
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
% section overlays should be at spm_g.Children(13),spm_g.Children(14), spm_g.Children(15)
    %%
    spm_results_ui('setcoords',coord);%[ 39, -19,  55]);%[-18, -91,  -5]);%[ 63, -22,   1]);%[44 -46 -16]);%[ 63, -22,   1]);%[-21,  -7, -14])% [44 -46 -16]);%[57, -13,   1]);%[3 -64 30] 
    XYZmm= spm_mip_ui('Jump',hMIPax,'nrvox');%glmax/nrmax
    beta = spm_mip_ui('extract','beta','voxel');
    
    %% Global Maximum
    XYZmm= spm_mip_ui('Jump',hMIPax,'glmax');%glmax/nrmax/nrvox
    %% Local Maximum
    XYZmm= spm_mip_ui('Jump',hMIPax,'nrmax');%glmax/nrmax/nrvox
%% Get pixel coordinates for all voxels within an activated cluster
% 
% One easy way would be to position the cursor on the cluster you're
% interested in (after displaying the results using the 'results' button),
% and paste the following lines from spm_list.m at the matlab prompt:
[xyzmm,i] = spm_XYZreg('NearestXYZ',...
spm_results_ui('GetCoords'),xSPM.XYZmm);
spm_results_ui('SetCoords',xSPM.XYZmm(:,i));
A = spm_clusters(xSPM.XYZ);
j = find(A == A(i));
XYZ = xSPM.XYZ(:,j);
XYZmm = xSPM.XYZmm(:,j);

% The last two variables - XYZ and XYZmm - would contain the pixel and the
% mm coordinates of all voxels in the current cluster. (Check the cursor to
% see where it is after pasting the above, it may jump a bit, moving to 
% nearest suprathreshold voxel.)
% [Kalina Christoff 25 Jun 2000]

%%
% This function extracts beta, st error and 90% CI
% for the voxel at the current location in the SPM
% results viewer (or at a location specified in
% the third argument).
% [beta,sterr,ci90] = extractSPMData(xSPM,SPM,[coords]);
% 11/6/2010 J Carlin

%function [cbeta,SE,CI] = extractSPMData(xSPM,SPM,coords);

hReg = findobj('Tag','hReg'); % get results figure handle

% Use current coordinates, if none were provided
 %% Local Maximum
    XYZmm= spm_mip_ui('Jump',hMIPax,'nrmax');%glmax/nrmax/nrvox

%% PLOT Contrast Estimate and 90% CI (Voxel)
% Which Contrast to plot (aka indicate F Con)
%Ic = xSPM.Ic; % Use current contrast
% F CON    length({SPM.xCon.name})
T_leg = t; % Tasks: Are they  or t_old?
coords = spm_XYZreg('GetCoords',hReg)        
% Set Coordinates
% This is mostly pulled out of spm_graph
[xyz,i] = spm_XYZreg('NearestXYZ',coords,xSPM.XYZmm);
spm_XYZreg('SetCoords',xyz,hReg);
XYZ     = xSPM.XYZ(:,i); % coordinates

%-Parameter estimates:   beta = xX.pKX*xX.K*y;
%-Residual mean square: ResMS = sum(R.^2)/xX.trRV
%----------------------------------------------------------------------
beta  = spm_get_data(SPM.Vbeta, XYZ);
ResMS = spm_get_data(SPM.VResMS,XYZ);
Bcov  = ResMS*SPM.xX.Bcov;


CI    = 1.6449;
% compute contrast of parameter estimates and 90% C.I.
%------------------------------------------------------------------
cbeta = SPM.xCon(Ic).c'*beta;
SE    = sqrt(diag(SPM.xCon(Ic).c'*Bcov*SPM.xCon(Ic).c));
CI    = CI*SE;
% Plot errorbar
figure(eb_fig);
clf
bar(cbeta)
hold on
errorbar(cbeta,CI,'rx')
title([SPM.xCon(Ic).name 'est at   ' num2str([coords]')])
set(gca,'XTickLabel',T_leg)
%
% x = [1:length(cbeta)];
% text(x,cbeta,num2str(x,'%0.2f'),...
%     'HorizontalAlignment','center',...
%     'VerticalAlignment','bottom') 
%% CLUSTERS
%% Gets cluster
%Ic = 1;
T_leg = t; % Tasks: Are they  or t_old?

[xyzmm,i] = spm_XYZreg('NearestXYZ',...
spm_results_ui('GetCoords'),xSPM.XYZmm);
spm_results_ui('SetCoords',xSPM.XYZmm(:,i));
A = spm_clusters(xSPM.XYZ); % gets all clusters
j = find(A == A(i));
XYZ = xSPM.XYZ(:,j);
XYZmm = xSPM.XYZmm(:,j);
disp(['Cluster ' num2str(A(i)) '/' num2str(max(A)) ' Size ' num2str(length(XYZmm))])
%
% Average across voxels
beta  = spm_get_data(SPM.Vbeta, XYZ);
ResMS = spm_get_data(SPM.VResMS,XYZ);
beta = mean(beta,2);
ResMS = mean(ResMS,2);
Bcov  = ResMS*SPM.xX.Bcov;

CI    = 1.6449;
% compute contrast of parameter estimates and 90% C.I.
%------------------------------------------------------------------
cbeta = SPM.xCon(Ic).c'*beta;
SE    = sqrt(diag(SPM.xCon(Ic).c'*Bcov*SPM.xCon(Ic).c));
CI    = CI*SE;
% Plot errorbar
%clf
f = figure('visible','off');
bar(cbeta)
hold on
errorbar(cbeta,CI,'rx')
%title([SPM.xCon(Ic).name 'est at cluster' num2str(A(i))])
title(['Cluster ' num2str(A(i)) '/' num2str(max(A)) ' Size ' num2str(length(XYZmm)) ' Voxels'])
set(gca,'XTickLabel',T_leg)
% inset
addpath('/Users/aidas_el_cap/Downloads/inset/')
%h_eb = figure(eb_fig);
%t_fig = figure(5)
%c = a(2).Children(21)
inset(f,mip,0.2);
cluster_bar = gcf;
cluster_bar.Position = [93 165 1296 640];
%inset(h_eb,hMIPax,0.19
hold off