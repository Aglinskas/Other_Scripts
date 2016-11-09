loadMR
%%
node_file = '/Users/aidasaglinskas/Desktop/this.node'
% Edges
%a = squeeze(mean(keep,1));
%a = zeros(10);
%t = round(a,3);
%edge_file = '/Users/aidasaglinskas/Desktop/this.edge';
%dlmwrite(edge_file,t,' ')
% Options
cfg = '/Users/aidasaglinskas/Desktop/BrainOPTS.mat';
% Get Surf
surf_path = '~/Documents/MATLAB/BrainNetViewer/Data/SurfTemplate/';
surf_files = dir([surf_path '*.nv']);
surf_files = {surf_files.name}';
wh_surf_file = 5;
%nds = '/Users/aidasaglinskas/Desktop/test.node';
h = BrainNet_MapCfg(fullfile(surf_path,surf_files{wh_surf_file}),node_file,cfg);
%BrainNet_MapCfg(node_file,edge_file,cfg)
%%
h.Color = [1 1 1]
h.CurrentAxes.Color = [0 0 0]
h.CurrentAxes.ZColor = [1 1 1]
%%

saveas(h,fullfile('/Users/aidasaglinskas/Desktop/2nd_Fig/',datestr(datetime)),'jpg')