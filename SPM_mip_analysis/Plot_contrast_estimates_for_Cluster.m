%% Gets cluster
Ic = 4;
T_leg = {'First memory'	'Attractiveness'	'Friendliness'	'Trustworthiness'	'Familiarity'	'Common name'	'How many facts'	'Occupation'	'Distinctiveness'	'Full name'	'Same Face'	'Same monument'}
[xyzmm,i] = spm_XYZreg('NearestXYZ',...
spm_results_ui('GetCoords'),xSPM.XYZmm);
spm_results_ui('SetCoords',xSPM.XYZmm(:,i));
A = spm_clusters(xSPM.XYZ); % gets all clusters
j = find(A == A(i));
XYZ = xSPM.XYZ(:,j);
XYZmm = xSPM.XYZmm(:,j);
disp(['Cluster ' num2str(A(i)) '/' num2str(max(A)) ' Size ' num2str(length(XYZmm))])
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
set(gca,'XTickLabel',T_leg)
% inset
%addpath('/Users/aidas_el_cap/Downloads/inset/')
%h_eb = figure(eb_fig);
%t_fig = figure(5)
%c = a(2).Children(21)
inset(f,a,0.2); %inset(f,mip,0.2);
cluster_bar = gcf;
cluster_bar.Position = [93 165 1296 640];
%inset(h_eb,hMIPax,0.19
hold off