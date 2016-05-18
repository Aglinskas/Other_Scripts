%% extract_from_adjusted_cluster
% Plots contrast estimates from a cluster.
% Options:
% opts_clust.size = 
%   1 for whole cluster, (default)
%   2 for adjusted cluster (see adjust_cluster)
% opts_clust.inset:
%   0 prints clean to gcf
%   1 for clear, 
%   2 or mip inset (default);
%   3 for do nothing (clean stays hidden with handle figure(f))
%   4 for plot w/ sections (awesome shit)
%opts_clust.suppress4: using opt 4, suppress output   
Ic = 1; % which contrast to extract estimates from: F con usually
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
% if opts_clust.size == 1
beta  = spm_get_data(SPM.Vbeta, XYZ);
ResMS = spm_get_data(SPM.VResMS,XYZ);
% else
% adjust_cluster
% beta  = spm_get_data(SPM.Vbeta, adj_cluster_XYZ);
% ResMS = spm_get_data(SPM.VResMS,adj_cluster_XYZ);
% end
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
f = figure(500);
subplot(2,1,1);
bar(cbeta)
hold on
errorbar(cbeta,CI,'rx')
%title([SPM.xCon(Ic).name 'est at cluster' num2str(A(i))])
% if opts_clust.size == 1
%title(['Cluster ' num2str(A(i)) '/' num2str(max(A)) ' Size ' num2str(length(XYZmm)) ' Voxels'])
%title(['Cluster ' num2str(A(i)) '/' num2str(max(A)) ' Size ' num2str(vx) 'Voxels'])
%%
title({xSPM.title ['Cluster ' num2str(A(i)) '/' num2str(max(A)) ' Size ' num2str(vx) ' Voxels']})
%%
set(gca,'XTickLabel',T_leg)
% inset
%addpath('/Users/aidas_el_cap/Downloads/inset/')
%h_eb = figure(eb_fig);
%t_fig = figure(5)
%c = a(2).Children(21)
%inset(f,a,0.2); %inset(f,mip,0.2);
colormap(map)
%cluster_bar = gcf;
%f.Position = [93 165 1296 640];
% title(xSPM.title)
%inset(h_eb,hMIPax,0.19
hold off
% opts_clust.inset = 1 for clear, 2 or mip inset (default)
get_sections
%g = sections_fig;
%g = figure(500)
% jj = subplot(2,1,1);
% opts_clust.inset = 0
% copyobj(f.Children(10).Children(:),jj)
% if opts_clust.size == 1
% title(['Cluster ' num2str(A(i)) '/' num2str(max(A)) ' Size ' num2str(length(XYZmm)) ' Voxels'])
% else title(['Cluster ' num2str(A(i)) '/' num2str(max(A)) ' Size ' num2str(vx) ' Most significant voxels Voxels'])
% end
% set(jj,'XTickLabel',T_leg)
% jj.XTick = [1:12];
figure(f)
%% Rest of the subplots, colormap and position
j = subplot(2,3,4);
copyobj(sag.Children(:),j);
title(num2str(xyzmm'))
j= subplot(2,3,5);
copyobj(axial.Children(:),j);
j = subplot(2,3,6);
copyobj(cor.Children(:),j);
colormap(map);
f.Position = [1 1 1436 804]