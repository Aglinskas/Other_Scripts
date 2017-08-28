combxSPM = xSPM
mesh_file_dir = '/Users/aidasaglinskas/Documents/MATLAB/spm12/canonical/';
fls = [dir([mesh_file_dir '*.gii']) dir([mesh_file_dir '*.mat'])];
fls = {fls.name}';
M = fullfile(mesh_file_dir,fls{1});
dat = combxSPM;
brt = nan;
rendfile = M
spm_render(dat,brt,rendfile)
%%
H = spm_mesh_render(M)
%%
for t = 1:5;
temp.sections_fn = '/Users/aidasaglinskas/Desktop/MasksCheck/single_subj_T1.nii'
load(spm_fn);
combxSPM = []
    xSPM = SPM;
    [34:38]
    xSPM.Ic= ans(t); % Which contrast
    xSPM.Ex=0;
    xSPM.Im= [];
    xSPM.title=SPM.xCon(xSPM.Ic).name;
xSPM.thresDesc='none';
xSPM.u= .001;
xSPM.k= 30;
    [hReg,xSPM,SPM] = spm_results_ui('Setup',[xSPM]) % SPM GUI
    spm_sections(xSPM,hReg,temp.sections_fn) %SECTIONS
    xSPM.t = xSPM.Z;
    xSPM.dim = xSPM.DIM;
    xSPM.mat = xSPM.M;
%%
spm_mesh_render('overlay',H,xSPM)
col = [
     1     0     0
     1     0     1
     1     1     0
     0     1     0
     0     1     1]*1.5;
pos = [1263.9993     -18.056725      14.890892
-1263.8099     -18.056725      14.890892]
%%
for pos_ind = 1:2;
 H.figure.CurrentAxes.CameraPosition = pos(pos_ind,:)
 H.light.Position = H.figure.CurrentAxes.CameraPosition
 
ofn_dir = '/Users/aidasaglinskas/Desktop/SPMS/';
ofn = fullfile(ofn_dir,[num2str(pos_ind) num2str(t) '.png']);
sf = figure(3)
saveas(sf,ofn,'png')
end
end