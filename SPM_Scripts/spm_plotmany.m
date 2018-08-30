mesh_file_dir = '/Users/aidasaglinskas/Documents/MATLAB/spm12/canonical/';
fls = [dir([mesh_file_dir '*.gii']) dir([mesh_file_dir '*.mat'])];
fls = {fls.name}';
M = fullfile(mesh_file_dir,fls{1});
H = spm_mesh_render(M)
spm_mesh_inflate(H.patch,10,0)
%% Set up spm
spm_fn = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/Group_analysis12t/SPM.mat';
temp.sections_fn = '/Users/aidasaglinskas/Desktop/MasksCheck/single_subj_T1.nii'
load(spm_fn);
combxSPM = []
for t = 1:5
    xSPM = SPM;
    [34:38]
    xSPM.Ic= 4;ans(t); % Which contrast
    xSPM.Ex=0;
    xSPM.Im= [];
    %xSPM.Im= {'/Users/aidasaglinskas/Desktop/faces_blobsp01/Combined_ROIs.nii'};
    xSPM.title=SPM.xCon(xSPM.Ic).name;
xSPM.thresDesc='none';
xSPM.u= .999;
[61 0 130 68 97]
xSPM.k= 0;ans(t);
    [hReg,xSPM,SPM] = spm_results_ui('Setup',[xSPM]) % SPM GUI
    spm_sections(xSPM,hReg,temp.sections_fn) %SECTIONS
    xSPM.t = xSPM.Z;
    xSPM.dim = xSPM.DIM;
    xSPM.mat = xSPM.M;
combxSPM = xSPM;%[combxSPM xSPM]
%end
%%
% dat = combxSPM;
% brt = nan;
% rendfile = M
% spm_render(dat,5,rendfile)
%%
col = [
     1     0     0
     1     0     1
     1     1     0
     0     1     0
     0     1     1]*1.5; % [red purple yellow green cyan] aidas
%%
spm_mesh_render('overlay',H,combxSPM)
spm_mesh_render('ColourMap',H,[0 0 1])%col(t,:))
%% Control view
if ~exist('run_once')
all.faces = H.patch.Faces;
all.VertexNormals = H.patch.VertexNormals;
all.vertices = H.patch.Vertices;
all.FaceVertexCData = H.patch.FaceVertexCData
C   = getappdata(H.patch,'cclabel');
run_once=1;
end
%% Hemisheres
% 1 = left hem
% 2 = right hem
% [1 2] = both
% for j = 1:length(ans)
% wh_hem = ans{j};
% F  = get(H.patch,'Faces');
% H.patch.Faces =all.faces(find(ismember(C,[1 2])),:)
%H.patch.FaceVertexCData  = all.FaceVertexCData(find(ismember(C,wh_hem)),:)
for i = 1:2
pos = [90 0
    -90 0]
view(H.axis,pos(i,:));
axis(H.axis,'image');
camlight(H.light);
exp = 1;
if exp == 1
ofn_dir = '/Users/aidasaglinskas/Desktop/SPMS/';
ofn_nm = ['HemRight_' 'task' num2str(t) '_view' num2str(i) '.png'];
ofn = fullfile(ofn_dir,ofn_nm);
saveas(H.figure,ofn,'png')
end
end %
end %
%%
ofn_root = '/Users/aidasaglinskas/Desktop/SPMS/';
fn_temp  = '%s_task%d_view%d.png';
str = {'HemRight' 'HemLeft'}
for t = 6
f = figure(3);
clf
hold on
l = 0;
for str_ind = 1:2
for w = 1:2
fn = sprintf(fn_temp,str{str_ind},t,w)
im = imread(fullfile(ofn_root,fn));
l = l+1;
subplot(2,2,l)
imshow(im)
%title(fn)
drawnow
end
end
%saveas(f,['/Users/aidasaglinskas/Desktop/SPMS/' 'comb' num2str(t)],'png')
end