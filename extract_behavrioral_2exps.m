loadMR;
fn.temp = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S%d/S%d_ScannerMyTrials_RBLT.mat';
%fn.temp = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_words/S%d/wS%d_Results.mat';
m = [];
subv = 7:31;
for s_ind = 1:length(subv);
subID = subv(s_ind);
fn.fn = sprintf(fn.temp,subID,subID);
load(fn.fn)
myTrials = fix_myTrials(myTrials);
if s_ind==1;unique_faces = unique({myTrials(ismember([myTrials.blockNum],1:10)).word});end
for f = 1:40
for b = 1:10
ind = [myTrials.blockNum] == b & strcmp({myTrials.word},unique_faces{f});
ind = find(ind);
if length(ind) ~= 1; error('ind error');end
m.RT(f,b,s_ind) = myTrials(ind).RT;
m.resp(f,b,s_ind) = myTrials(ind).resp;
end
end
end
m.f_lbls = unique_faces';
m.t_lbls = aBeta.t_lbls(1:10);
disp('done')
%%
mw = m;
mf = m;