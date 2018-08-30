%% Clear and Load
clear;load('vxFB.mat')
%% ignore this: 
% vx.legend = 'ROI|TASK|FACE|SUB'
% vx.r_lbls = masks.lbls;
% vx.f_lbls = names
% vx.t_lbls = aBeta.t_lbls(1:10);
%% Find Empty 
e_vec = [];
for c1 = 1:size(vx.f_voxel_data,1)
for c2 = 1:size(vx.f_voxel_data,2)
for c3 = 1:size(vx.f_voxel_data,3)
for c4 = 1:size(vx.f_voxel_data,4)

inds = [c1 c2 c3 c4];
vec = vx.f_voxel_data{c1,c2,c3,c4};

if length(vec) ~= 80
   e_vec(end+1,:) = inds;
end
     
end
end
end
end
%% Make a table ('Cause why not)
T = array2table(e_vec,'VariableNames',{'ROI' 'TASK' 'FACE' 'SUB'});
T = sortrows(T,'FACE','ascend');
Ttab = tabulate(T.FACE);
%% Make a clean array;
good_inds = find(~ismember([1:40],unique(T.FACE)));
vx.f_voxel_data_clean = vx.f_voxel_data(:,:,good_inds,:);
vx.f_lbls_clean = vx.f_lbls(good_inds);