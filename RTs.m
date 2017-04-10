loadMR
%%
clear RTs
for s_ind = 1:20;
    subID = subvect(s_ind);
for task_ind = 1:10;
mt_ind = find([all_trials.subID] == subID & [all_trials.blockNum] == task_ind);
this_mt = all_trials(mt_ind);
RTs(s_ind,task_ind) = nanmean([this_mt.RT]);
end
end
% f = figure(1)
% add_numbers_to_mat(RTs)
% f.CurrentAxes.XTickLabel = t_labels(1:10)
% f.CurrentAxes.XTickLabelRotation = 25
% title('Mean of RTs by subject')
% %%
% lbls = t_labels(1:10)
% mat = RTs
% mat = zscore(mat,[],2)
% 
% add_numbers_to_mat(mat)
% m = corr(mat)
% %%
% newVec = mean(RTs,1)%mat %get_triu(mat);
% Z = linkage(newVec','ward')
% dendrogram(Z,'labels',lbls,'orientation','left')
% %%
% m_RT = mean(RTs,1);
% std_RT = std(RTs,1);
% 
% clf
% bar(m_RT)
% hold on
% errorbar(m_RT,std_RT,'r*','LineWidth',.1)
% title({'RTs (in seconds)' 'errorbars repr. 1 st dev'},'fontsize',20)
% f.CurrentAxes.XTickLabel = t_labels(1:10)
% f.CurrentAxes.XTickLabelRotation = 25
%
u = RTs
RTs = zscore(u,[],2);
arr = subBeta.array;
arr = zscore(arr,[],2);
mm = mean(mean(arr(:,1:12,:),3),1);


for s_ind = 1:20
   arr(19,:,s_ind) =  mean(arr(:,:,s_ind),1);
end




for s_ind = 1:20;
for r_ind = 1:19;
b = arr(r_ind,1:10,s_ind)';
r = RTs(s_ind,:)';
p_mat(s_ind,r_ind) = corr(b,r);
end
end

add_numbers_to_mat(p_mat)
%%

f = figure(1)
mp = mean(p_mat);
ord = [subBeta.ord_r 19];
[lbls{1:19}] = deal(0)
lbls = r_labels(ord(1:end-1))
lbls{19} = 'ROI-Mean'
mp = mp(ord)


add_numbers_to_mat(mp)

f.CurrentAxes.XTick = 1:19
f.CurrentAxes.XTickLabel = lbls
f.CurrentAxes.FontSize = 15
f.CurrentAxes.FontWeight = 'bold'
f.CurrentAxes.YTick = [];
f.CurrentAxes.XTickLabelRotation = 45

title({'correlation of RT and betas' 'Subject level stats (RFX)'} ,'FontSize',20)

ofn  = '/Users/aidasaglinskas/Desktop/lol_betas/';
saveas(f,[ofn 'fig'],'png')
%%

anova1
%%
all_rts = []
this_rt = []
for s_ind = 1:20
    subID = subvect(s_ind);
    clear this_rt
    for t_ind = 1:10 
        
       inds = [all_trials.subID] ==  subID & [all_trials.blockNum] ==  t_ind;
       this_mt = all_trials(find(inds));
       this_rt(:,t_ind) = [this_mt.RT]';
    end
    this_rt = nanmean(this_rt,1);
    all_rts = [all_rts;this_rt];
end
disp('done')

%%
[H,P,CI,STATS] = ttest(all_rts(:,6),all_rts(:,10))
%%

% for s_ind 1:20
%     subID = subvect(s_ind)
%     for t_ind 1:10
%         
%         
%         
%     end
% end
%%
pairs = {[6 10] [1 5 ] [7 8 ] [3 4 ] [2 9]}
pairs_lbls = {'Nominal' 'Episodic' 'Factual' 'Social' 'Physical'}

clear newRTs
for i = 1:5 
newRTs(:,i) = mean(RTs(:,pairs{i}),2)
end
f = figure(1)
add_numbers_to_mat(newRTs)

f.CurrentAxes.XTick = 1:5
f.CurrentAxes.XTickLabel = pairs_lbls
f.CurrentAxes.FontSize = 15
title({'RTs' 'Similar Tasks Collapsed'},'fontsize',20)


m_RT = mean(newRTs,1);
s_RT = std(newRTs,1);

add_numbers_to_mat(m_RT)
hold on 
errorbar(m_RT,s_RT,'r*')

%%
for i = 1:5 
 for j = 1:5
     v1 = newRTs(:,i);
     v2 = newRTs(:,j);
     
       [H,P,CI,STATS] = ttest(v1,v2);
       mat(i,j) = STATS.tstat;
       pmat(i,j) = P;
 end
end
%%
subplot(1,2,1)
add_numbers_to_mat(mat,pairs_lbls)

subplot(1,2,2)
add_numbers_to_mat(pmat,pairs_lbls)




