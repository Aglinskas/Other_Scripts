loadMR
%%
node_file = '/Users/aidasaglinskas/Desktop/newNode.node' %ROIs
cfg = '/Users/aidasaglinskas/Desktop/newCfg.mat'; %opts
surf_path = '~/Documents/MATLAB/BrainNetViewer/Data/SurfTemplate/'; %surf
edge_file = '/Users/aidasaglinskas/Desktop/newEdge.edge';
surf_files = dir([surf_path '*.nv']);
surf_files = {surf_files.name}';
wh_surf_file = 9; %which surf file
if exist('edge_file')  == 1;
h = BrainNet_MapCfg(fullfile(surf_path,surf_files{wh_surf_file}),node_file,edge_file,cfg);
elseif exist('edge_file') == 0;
h = BrainNet_MapCfg(fullfile(surf_path,surf_files{wh_surf_file}),node_file,cfg);
else 
    error('nothing to do')
end
%BrainNet_MapCfg(node_file,edge_file,cfg)
%
h.Color = [1 1 1]
h.CurrentAxes.Color = 'none'%[0 0 0]
h.CurrentAxes.ZColor = 'none'%[1 1 1]
ofn = '/Users/aidasaglinskas/Desktop/2nd_Fig/all/';
h.Color = 'none';
export_fig(fullfile(ofn,[datestr(datetime) '.png']),'-transparent')
h.Color = [1 1 1];
%saveas(h,fullfile('/Users/aidasaglinskas/Desktop/2nd_Fig/',datestr(datetime)),'jpg')