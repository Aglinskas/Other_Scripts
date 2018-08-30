clear all;
close all;
loadMR;
%%
%load('newVX.mat')
if ~exist('r_ind')
    r_ind = 0;
elseif r_ind == 21
    r_ind = 0;
end
r_ind = r_ind+1;
mat = [];
for i = 1:20
    mat(i,:) = vx.f_voxel_data{r_ind,1,i,1};
end
m = isnan(mat);
f = figure(1);
imagesc(m)
ylabel('Subject')
xlabel('is voxel a nan?')
f.CurrentAxes.FontSize = 14
title(vx.r_labels{r_ind},'fontsize',20)