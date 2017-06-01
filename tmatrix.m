%#%# Set up
clear all 
loadMR
clear tmat
subBeta.ord_t = [6 10 2 9 3 4 1 5 7 8]
a = subBeta.array - subBeta.array(:,11,:);
a = a(:,1:10,:);
%#a = a - mean(a,1)
%#a = a - mean(a,2)

%a = zscore(a,[],1);
a = zscore(a,[],2);

%# T matrix calc
for r = 1:18
    for c = 1:length(subBeta.ord_t)
v = squeeze(a(r,c,:));
m = squeeze((mean(a(r,find([1:length(subBeta.ord_t)] ~= c),:),2))); %#All other tasks
%#m = squeeze(a(r,11,:));
[H,P,CI,STATS] = ttest(v,m);
tmat(r,c) = STATS.tstat;
pmat(r,c) = P;
sdmat(r,c) = std(squeeze(a(r,c,:)));
    end
end
%# Ordering 
tmat = tmat
tmat = tmat(subBeta.ord_r,subBeta.ord_t);
pmat = pmat(subBeta.ord_r,subBeta.ord_t);
lbls = {r_labels(subBeta.ord_r) t_labels(subBeta.ord_t)}
%# Plotting
f = figure(3)

%tmat(pmat>.05) = 0
%pmat(pmat>.05) = 1

clf
subplot(1,2,1)
add_numbers_to_mat(tmat,lbls{1},lbls{2})
ttl = {'T matrix' 'Task vs Mean of other tasks'}
subplot(1,2,2)
add_numbers_to_mat(pmat,lbls{1},lbls{2})
title(ttl)
%#saveas(f,['/Users/aidasaglinskas/Desktop/2nd_Fig/all/' datestr(datetime)],'jpg')
%% # Plotting 3
% lbls = {r_labels(subBeta.ord_r) t_labels(subBeta.ord_t)}
% clf
% figure(1)
% p3 = subplot(1,3,1)
% add_numbers_to_mat(mean(a(:,[1:length(subBeta.ord_t)],:),3),lbls{1},lbls{2})
% title('Mean Task beta Across subjects')
% 
% 
% p1 = subplot(1,3,3)
% add_numbers_to_mat(tmat,lbls{1},lbls{2})
% %#p1.FontSize = 16;
% ttl = {'T matrix' '2 sample ttest task beta vs Mean of all the other betas'}
% title(ttl)
% %#
% p2 = subplot(1,3,2)
% add_numbers_to_mat(sdmat,lbls{1},lbls{2})
% %#p2.FontSize = 16;
% title('Standard Deviation')
figure(3)