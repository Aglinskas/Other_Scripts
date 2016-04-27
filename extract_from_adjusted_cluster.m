%% Gets cluster
%Ic = 1;
opt.clust_size = 2 %1 for full, 2 for else
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
if opt.clust_size == 1
beta  = spm_get_data(SPM.Vbeta, XYZ);
ResMS = spm_get_data(SPM.VResMS,XYZ);
else
adjust_cluster
beta  = spm_get_data(SPM.Vbeta, adj_cluster_XYZ);
ResMS = spm_get_data(SPM.VResMS,adj_cluster_XYZ);
end
vx = length(beta);
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
if opt.clust_size == 1
title(['Cluster ' num2str(A(i)) '/' num2str(max(A)) ' Size ' num2str(length(XYZmm)) ' Voxels'])
else title(['Cluster ' num2str(A(i)) '/' num2str(max(A)) ' Size ' num2str(vx) ' Most significant voxels Voxels'])
end
set(gca,'XTickLabel',T_leg)
% inset
%addpath('/Users/aidas_el_cap/Downloads/inset/')
%h_eb = figure(eb_fig);
%t_fig = figure(5)
%c = a(2).Children(21)
inset(f,mip,0.2); %inset(f,mip,0.2);
colormap(map)
cluster_bar = gcf;
cluster_bar.Position = [93 165 1296 640];
%inset(h_eb,hMIPax,0.19
hold off