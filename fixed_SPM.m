cSPM = xSPM
clc
for c_ind = 1:size(xSPM.XYZmm,2)
    r1 = 1:100:size(xSPM.XYZmm,2)';
    r2 = 1:round(size(xSPM.XYZmm,2)/10):size(xSPM.XYZmm,2)';
    r3 = size(xSPM.XYZmm,2);
    repvect = unique([r1';r2';r3]);
   
    if ismember(c_ind,repvect)
       disp([num2str(round(c_ind / size(xSPM.XYZmm,2) * 100)) '%'])
    end
    

%cmm = spm_mip_ui('SetCoords',xSPM.XYZmm(:,c_ind))'; % go the coordinate
cvx = xSPM.XYZ(:,c_ind); % find subject Voxel coords
data = spm_get_data(SPM.Vbeta, cvx); % extract that data
data = data(1:12);
data = data-data(11);

% find(data)
% wh_t_labels

    t_inds = {[1 5] [7 8] [3 4] [2 9] [6 10]};
data = arrayfun(@(x) mean(data(t_inds{x})),1:5);
data = zscore(data);
data(data<0) = 0;

% figure(2);
% bar(data);

pref = find(data==max(data));
cSPM.Z(c_ind) = pref;
end
%%
leg = {'Episodic' 'Factual' 'Social' 'Physical' 'Nominal' ''}
cSPM.Z(1) = 6;
a = get(0,'children');

f = figure(2)
%map = colormap('hsv');
%f.Colormap = map;
f.Colormap

ref = figure(3)
imagesc(unique(cSPM.Z))
ref.Colormap = colormap('hsv')
ref.CurrentAxes.XTickLabel = leg

dat = cSPM
brt = nan
rendfile = '/Users/aidasaglinskas/Documents/MATLAB/spm12/canonical/cortex_5124.surf.gii'
spm_render(dat,brt,rendfile)
%%
figure(1)
i = [-37    17    -2]
spm_mip_ui('SetCoords',[i])

%%

spm_fig = figure(1);
%%
spm_fig.Children(1).Callback{2}.rotate3d.view


spm_fig.Children(1).Callback{2}.rotate3d.ActionPostCallback{2}.rotate3d.UIContextMenu.Children
