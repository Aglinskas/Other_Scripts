clear
loadMR
A=dir('/Users/aidasaglinskas/Google Drive/MRI_data/S*')
{A([A.isdir]).name}
cc=0;
keep=[];

for subID = subvect
    cc=cc+1;    
%subID = subvect(ii)
a = sprintf('/Users/aidasaglinskas/Google Drive/MRI_data/S%d/Analysis_mask02/SPM.mat',subID)
load(a)
tX=SPM.xX.X(SPM.Sess(1).row,1:18);
keep(cc,:)=tX(:);
end


%% Sanity Check 2
loadMR
mat = []
cmat = []
for ii = 1:20
subID = subvect(ii)
mt_fn_temp = '/Users/aidasaglinskas/Google Drive/MRI_data/S%d/S%d_Results.mat';
mt_fn = sprintf(mt_fn_temp,subID,subID);
load(sprintf('/Users/aidasaglinskas/Google Drive/MRI_data/S%d/Analysis/SPM.mat',subID))
load(mt_fn);
mat(ii,1:length([myTrials.resp]')) = [myTrials.resp]';
end

cmat = corr(mat');
f = figure(5)
add_numbers_to_mat(cmat)
f.CurrentAxes.XTick = 1:20
f.CurrentAxes.YTick = 1:20
%% Rebuilt_myTrials
mt_a_fn = '/Users/aidasaglinskas/Desktop/Trim/'

fls = cellfun(@(x) [mt_a_fn x],fl_nm,'UniformOutput',0)

%temp_fn = '/Users/aidasaglinskas/Desktop/Rebuilt_myTrials/S%d_Results.mat'
mat = []
for ii = 1:length(fls)
    ii
    clear myTrials
    load(fls{ii});
    emp = cellfun(@isempty,{myTrials.RT});
    find(emp == 1);
    [myTrials(find(emp == 1)).RT] = deal(0);
    %load(sprintf(temp_fn,subID))
    mat(ii,:) = [myTrials.RT];
end
%%
cmat = corr(mat');
%cmat(cmat<.9) = 0
lbls = cellfun(@(x) strrep(x,'_','-'),fl_nm,'UniformOutput',0);
size(cmat)
f = figure(9)
add_numbers_to_mat(cmat)
f.CurrentAxes.XTick = 1:length(cmat)
f.CurrentAxes.XTickLabel = lbls
f.CurrentAxes.XTickLabelRotation = 45
f.CurrentAxes.YTick = 1:length(cmat)
f.CurrentAxes.YTickLabel = lbls
%%
fl_nm = {}
