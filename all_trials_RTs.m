load('/Users/aidasaglinskas/Google Drive/Mat_files/Workspace/Not_use/all_trials.mat');

fcc_inds = strcmp({all_trials.TaskName}','Stesso volto?');
mcc_inds = strcmp({all_trials.TaskName}','Stesso monumento?');
[all_trials(fcc_inds).blockNum] = deal(11);
[all_trials(mcc_inds).blockNum] = deal(12);
unique({all_trials(find([all_trials.blockNum] == 12)).TaskName}')




%%
for s_ind = 1:20
    subID = subvect(s_ind)
for t_ind = 1:12
    
inds = find([all_trials.subID] == subID & [all_trials.blockNum] == t_ind);

mat(s_ind,t_ind) = nanmean([all_trials(inds).RT]');


end
end
rtmat = mat;
disp('done')

save('/Users/aidasaglinskas/Desktop/RTmat.mat','rtmat')

%%
m = mean(rtmat,1)
s = std(rtmat,1)
se = s / sqrt(20);

f = figure(3);
clf
bar(m)
hold 
errorbar(m,se,'r*')

f.CurrentAxes.XTickLabel = {    'First memory'
    'Attractiveness'
    'Friendliness'
    'Trustworthiness'
    'Familiarity'
    'Common name'
    'How many facts'
    'Occupation'
    'Distinctiveness'
    'Full name'
    'Same Face'
    'Same monument'}
f.CurrentAxes.XTickLabelRotation =45
f.CurrentAxes.FontSize = 12
f.CurrentAxes.FontWeight = 'bold'


