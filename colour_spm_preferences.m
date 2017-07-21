cSPM = xSPM;
%%
temp_nii = load_nii('/Users/aidasaglinskas/Documents/MATLAB/spm12/canonical/single_subj_T1.nii');
[temp_nii.img(:)] = deal(0);
%%
% figure(1)
% c = spm_mip_ui('GetCoords');
% c = spm_mip_ui('SetCoords',c);
% v_ind = find(xSPM.XYZmm(1,:) == c(1) & xSPM.XYZmm(2,:) == c(2) & xSPM.XYZmm(3,:) == c(3))
%%
clc
for c_ind = 1:size(xSPM.XYZmm,2)
    r1 = 1:100:size(xSPM.XYZmm,2)';
    r2 = 1:round(size(xSPM.XYZmm,2)/10):size(xSPM.XYZmm,2)';
    r3 = size(xSPM.XYZmm,2);
    repvect = unique([r1';r2';r3]);
   
    if ismember(c_ind,repvect)
       disp([num2str(round(c_ind / size(xSPM.XYZmm,2) * 100)) '%'])
    end
    
    
    
    
    
    
cmm = spm_mip_ui('SetCoords',xSPM.XYZmm(:,c_ind))'; % go the coordinate
cvx = xSPM.XYZ(:,c_ind); % find subject Voxel coords
data = spm_get_data(SPM.Vbeta, cvx); % extract that data
data = data(1:12);
data = data-data(11);

%find(data)
%wh_t_labels

    t_inds = {[1 5] [7 8] [3 4] [2 9] [6 10]};
data = arrayfun(@(x) mean(data(t_inds{x})),1:5);
data = zscore(data);
data(data<0) = 0;
%figure(2);
%bar(data);

pref = find(data==max(data));
cSPM.Z(c_ind) = pref
%%
a = figure(1);
b = a.Children(1).Children;
    b1 = arrayfun(@(x) b(x).Label,1:length(b),'UniformOutput',0)';
    b_vx_ind = find(cellfun(@isempty,strfind(b1,'vx:  ')) == 0);
    b_mm_ind = find(cellfun(@isempty,strfind(b1,'mm:  ')) == 0);
vx_coords = cellfun(@str2num,strsplit(strrep(b(b_vx_ind).Label,'vx:  ',''),' '));
w_coords = cellfun(@str2num,strsplit(strrep(b(b_mm_ind).Label,'mm:  ',''),' '));

vx = round(vx_coords);


temp_nii.img(vx(1),vx(2),vx(3)) = pref;
end
%%
ref = figure(3)
imagesc(1:6)
map = colormap('hsv');
ref.Colormap = map;
%%
temp_nii.img(1,1,1) = 6
save_nii(temp_nii,'/Users/aidasaglinskas/Desktop/lols.nii')

%%

dat = xSPM
brt = nan
rendfile = '/Users/aidasaglinskas/Documents/MATLAB/spm12/canonical/cortex_5124.surf.gii'
spm_render(dat,brt,rendfile)


