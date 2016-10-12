%%
master_coords = [3   -52    29
 48   -58    20
-42   -61    26
30   -91   -10
-33   -88   -10
 42   -46   -22
-39   -46   -22
39    17    23
-36    20    26
 -60    -7   -19
 57    -7   -19
 -21   -10   -13
 21    -7   -16
18    41    41
 -15    41    41
 3    50   -19
 33    35   -13
 -33    35   -13
45    11   -34
-48    11   -31]
%%
master_coords_labels = {'Precuneus'
'AngularRight'
'AngularLeft'
'OFARight'
'OFALeft'
'FFARight'
'FFALeft'
'IFGRight'
'IFGLeft'
'ATLLeft'
'ATLRight'
'AmygdalaLeft'
'AmygdalaRight'
'SFGRight'
'SFGLeft'
'PFCmedial'
'OrbRight'
'OrbLeft'
'Face PatchRight'
'Face PatchLeft'}
%%
w = 22
%%
spm_mip_ui('SetCoords',master_coords(w,:),mip)
w
master_coords_labels{w}
w = w+1;
%%
spm_mip_ui('GetCoords',mip)'

%%
save('/Users/aidasaglinskas/Google Drive/MRI_data/master_coords.mat','master_coords_labels', 'master_coords')


