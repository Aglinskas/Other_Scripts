clear all
r_names = {'ATL Left'
'ATL Right'
'Amygdala Left'
'Amygdala Right'
'Angular Left'
'Angular Right'
'FFA Left'
'FFA Right'
'Face Patch Left'
'Face Patch Right'
'IFG Left'
'IFG Right'
'OFA Left'
'OFA Right'
'Orb Left'
'Orb Right'
'PFC medial'
'Precuneus'
'SFG Left'
'SFG Right'}
load('/Users/aidasaglinskas/Downloads/ckpoint_12-Oct-2016 14-35-12.mat')
size(MVPA_results) %sub,ROI,ROI
%% Unwrap
size(MVPA_results)
size(pairs)
a = []
for ss = 1:size(MVPA_results,1)
for ii = 1:size(MVPA_results,2)
    a(ss,pairs(ii,1),pairs(ii,2)) = MVPA_results(ss,ii);
    a(ss,pairs(ii,2),pairs(ii,1)) = MVPA_results(ss,ii);
end  
end
disp('done, unwrapped')
%%
mat = squeeze(mean(a([8],:,:),1));
clf
figure(1)
add_numbers_to_mat(mat,r_names)
%%

reshape(MVPA_results,length(subvect),190)
%%
matrix = mat;
labels = r_names;
newVec = get_triu(matrix);
Z = linkage(newVec,'ward')
figure(2)
dendrogram(Z,'labels',labels,'orientation','left')




