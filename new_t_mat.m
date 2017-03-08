loadMR
clear tmat;
size(subBeta.array);
lbls{1} = subBeta.r_labels;
lbls{2} = subBeta.t_labels;
%Preprocess array: -CC, zscore, trim, etc
subBeta.array = subBeta.array - subBeta.array(:,11,:); % Subtract face control
subBeta.array = subBeta.array(:,1:10,:);
subBeta.array = zscore(subBeta.array,[],2);

ms = squeeze(mean(subBeta.array,3)); % Mean of preprocesed beta array
figure(1);add_numbers_to_mat(mean(subBeta.array,3),lbls{2}(1:10),lbls{1})
title('Subbeta Array','FontSize',25)
%[mean(ms(1,:)) std(ms(1,:))]

for r_ind = 1:18
for t_ind = 1:10
v_thisTask = squeeze(subBeta.array(r_ind,t_ind,:));
v_otherTasks = mean(squeeze(subBeta.array(r_ind,find([1:10] ~= t_ind),:)),1)';
[H,P,CI,STATS] = ttest(v_thisTask,v_otherTasks);
tmat(r_ind,t_ind)  = STATS.tstat;
end
end
disp('done')
%
figure(2)
add_numbers_to_mat(tmat,subBeta.r_labels,subBeta.t_labels(1:10));
title('Tmatrix','fontsize',25);

smat = tmat(subBeta.ord_r,subBeta.ord_t);
lbls_ord{1} = lbls{1}(subBeta.ord_r);
lbls_ord{2} = lbls{2}(subBeta.ord_t);

figure(3)
add_numbers_to_mat(smat,lbls_ord{1},lbls_ord{2})
title('Tmatrix (Sorted)','fontsize',25)

cmat = tmat;
clear tmat;
tmat.unsorted.array = cmat;
tmat.unsorted.lbls_r = lbls{1};
tmat.unsorted.lbls_t = lbls{2}(1:10);
tmat.sorted.array = smat;
tmat.sorted.lbls_r = lbls_ord{1};
tmat.sorted.lbls_t = lbls_ord{2};

%save('/Users/aidasaglinskas/Google Drive/Mat_files/Workspace/tmat.mat','tmat')
%%
