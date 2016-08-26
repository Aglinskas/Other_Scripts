%% Get_peaks
clear mip_peaks
clusters = spm_clusters(xSPM.XYZ);
num_clust = unique(clusters);
for curr_clust = num_clust
curr_clust_inds = find(clusters == curr_clust);
peak_ind = find(xSPM.Z == max(xSPM.Z(curr_clust_inds)))
peakZ = xSPM.Z(peak_ind)
peakC = xSPM.XYZmm(:,peak_ind)'
mip_peaks{curr_clust} = peakC
mip_peaks{curr_clust,4} = peakZ
end
%% atlas
atlas = fullfile('/Users/aidas_el_cap/Documents/MATLAB/spm12/tpm/','labels_Neuromorphometrics.nii');
xA = spm_atlas('load',atlas);
%% coords
%coords = {[3;-52;29];[3;50;-19];[6;59;23];[-3;59;23];[42;-46;-22];[57;-7;-19];[48;-58;20];[42;23;20];[57;26;2];[39;5;38];[-42;-61;26];[-60;-7;-19];[-21;-10;-13];[-36;20;26];[30;-91;-10];[-39;-46;-22];[33;35;-13];[33;-10;-40];[45;-19;-25];[12;5;14];[-33;-88;-10];[3;-31;-4];[-6;-28;-1];[-36;-10;-34]};;
for i = 1:length(master_coords)
spm_mip_ui('setcoords',master_coords{i});
% master_coords{i,1} = coords{i}';
% master_coords{i,2} = spm_atlas('query',xA,coords{i});
i
master_coords{i,2}
spm_atlas('query',xA,master_coords{i}')
pause
end
%%
a = round(spm_mip_ui('getcoords'))'
%%
c = [-33,35,-13]
spm_mip_ui('setcoords',c)
%%

    
