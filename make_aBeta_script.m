roi_dir = '/Users/aidasaglinskas/Desktop/RR/'
spm_dir_words = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_words/Group_Analysis_subconst/'
spm_dir_faces = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/Group_Analysis_subconst/'
wroi_data = func_extract_data_from_ROIs(roi_dir,spm_dir_words)
froi_data = func_extract_data_from_ROIs(roi_dir,spm_dir_faces)
wBeta = func_make_aBeta(wroi_data)
fBeta = func_make_aBeta(froi_data)

%%
aBeta = fBeta
aBeta.trim = rmfield(aBeta.trim,'mat');
aBeta.trim.fmat = fBeta.trim.mat
aBeta.trim.tmat = fBeta.trim.mat;
aBeta.wmat_raw = wBeta.fmat_raw;
aBeta.wmat = wBeta.fmat;
%%