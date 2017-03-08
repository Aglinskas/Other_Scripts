clear all
loadMR
wh ={[1] [2] [3] [4 5]  [6 7]  [8 9] [10 11]   [12 13]  [14]  [15 16]  [17 18]};

lbls = {'Precuneus'
    'pSTS-R'
    'pSTS-L'
    'OFA'
    'FFA'
    'IFG'
    'ATL'
    'Amygdala'
    'PFCmedial'
    'Orbital'
    'Face Patch'}
%%
clear trim_betas
for i = 1:length(wh);
trim_betas(i,:,:) = mean(subBeta.array(wh{i},:,:),1);
end
size(trim_betas)

trim_beta.array = trim_betas;
trim_beta.lbls_r = lbls;
trim_beta.lbls_t = subBeta.t_labels;
%trim_beta.ord = 
%save('~/Google Drive/Mat_files/Workspace/trimBetas.mat','trim_beta')

%%
arr = trim_beta.array;
arr = arr - arr(:,11,:);
arr = arr(:,1:10,:);
arr = zscore(arr,[],2);

figure(4)
m_arr = squeeze(mean(arr,3));
add_numbers_to_mat(m_arr,trim_beta.lbls_r,trim_beta.lbls_t(1:10))
title('Zscored trim beta array','FontSize',20)

for s_ind = 1:size(arr,3)
keep{1}(:,:,s_ind) = corr(arr(:,:,s_ind)); % TASKS
keep{2}(:,:,s_ind) = corr(arr(:,:,s_ind)'); %ROIS
end

%trim_beta.keep_r = keep{2}
%trim_beta.keep_t = keep{1}

mKeep{1} = mean(keep{1},3);
mKeep{2} = mean(keep{2},3);
mlbls = {trim_beta.lbls_t(1:10) trim_beta.lbls_r};
task_or_roi = 1;
%add_numbers_to_mat(mKeep{2},trim_beta.lbls_r)

figure(5)
d = subplot(1,2,2)
newVec = get_triu(mKeep{task_or_roi});
Z = linkage(1-newVec,'ward');
[h x perm] = dendrogram(Z,'labels',mlbls{task_or_roi},'orientation','left')
title({'dendrogram' 'Hemisphere averaged'},'FontSize',14)
[h(1:end).LineWidth] = deal(3)
d.FontSize = 14
d.FontWeight = 'bold'
ord = perm(end:-1:1);

m = subplot(1,2,1)
add_numbers_to_mat(mKeep{task_or_roi}(ord,ord),mlbls{task_or_roi}(ord))
m.FontSize = 12
m.FontWeight = 'bold'
title({'CorMat' 'Hemisphere averaged'},'FontSize',14)

%% Tmat
%trim_beta.array = zscore(trim_beta.array,[],2)
%figure(3);add_numbers_to_mat(mean(trim_beta.array,3))
for r_ind = 1:size(trim_beta.array,1)
for t_ind = 1:size(trim_beta.array,2)
v_this_task = squeeze(trim_beta.array(r_ind,t_ind,:));
v_other_tasks = squeeze(mean(trim_beta.array(r_ind,find([1:10] ~= t_ind),:),2));
[H,P,CI,STATS] = ttest(v_this_task,v_other_tasks);
ttmatt(r_ind,t_ind) = STATS.tstat;
end
end

%% TTest vs FaceCC

arr = trim_beta.array;
arr = arr - arr(:,11,:);
arr = arr(:,1:10,:);
arr = zscore(arr,[],2);


for r_ind = 1:size(trim_beta.array,1)
    for t_ind = 1:size(trim_beta.array,2)
        
   vect_task = squeeze(trim_beta.array(r_ind,t_ind,:));
   vect_cc = squeeze(trim_beta.array(r_ind,11,:));
[H,P,CI,STATS] = ttest(vect_task,vect_cc);

cm(r_ind,t_ind) = STATS.tstat;

    end
end



ord_t1 = [ 6    10     9     2     8     1     3     4     5     7];
ord_t2 = subBeta.ord_t
ord_r = [6    10     5     4    11     8     2     9     1     7     3]


trim_beta.ord_t1 = ord_t1
trim_beta.ord_t2  = ord_t2 
trim_beta.ord_r = ord_r