node_file = './this.node' % ROI and Label defining text file
% Edges
%a = squeeze(mean(keep,1));
%a = zeros(10);
%t = round(a,3);
edge_file = './this.edge'; % text file defining connection matrix
%dlmwrite(edge_file,t,' ') % if you want to export a matrix to defiine %connections to a file.
% Options
cfg = '/Users/aidasaglinskas/Desktop/BrainOPTS.mat'; % configurations, sets ROIs and Connections. and default view / postition
% Get Surf file;
surf_path = './BrainNetViewer/Data/SurfTemplate/';
surf_files = dir([surf_path '*.nv']);
surf_files = {surf_files.name}'; %there are a few surf files to choose from;
wh_surf_file = 5; % which file;
%nds = '/Users/aidasaglinskas/Desktop/test.node';
h = BrainNet_MapCfg(fullfile(surf_path,surf_files{wh_surf_file}),node_file,edge_file,cfg);
%BrainNet_MapCfg(node_file,edge_file,cfg)
%%
h.Color = [1 1 1] % Back ground color 
h.CurrentAxes.Color = [0 0 0] % 
h.CurrentAxes.ZColor = [1 1 1] %
%%
%saveas(h,fullfile('/Users/aidasaglinskas/Desktop/2nd_Fig/',datestr(datetime)),'jpg')


