loadMR
clf
all_tasks = 1:10;
figure(1);clf
figure(3);clf
for ss = 1:20
array(:,:,ss) = subBeta.array(:,:,ss) - repmat(subBeta.array(:,11,ss),1,12);
end
avg_beta = mean(array(:,[1:10]),3);

for tt = 1:10;
t_ind = subBeta.ord_t(tt)
this_beta = avg_beta(:,t_ind);%squeeze(mean(subBeta.array(:,t_ind,:),3));
other_betas = mean(avg_beta(:,find(all_tasks ~= t_ind)),2); %squeeze(mean(mean(subBeta.array(:,find(all_tasks ~= t_ind),:),2),3));

f = figure(1)
subplot(5,2,tt)
hold on
scatter(this_beta,other_betas);
xlabel('Task Beta')
ylabel('Other Betas')
a = fit(this_beta,other_betas,'poly1');
grid on
plot(f.CurrentAxes.XTick,f.CurrentAxes.XTick*a.p1 + a.p2)
title(t_labels(t_ind))
arrayfun(@(x) text(this_beta(x), other_betas(x), r_labels(x),'color',[1 .1 .1]),[1 2 3 10 11 14]) %DMN
arrayfun(@(x) text(this_beta(x), other_betas(x), r_labels(x),'color',[.1 1 .1]),[4  5  6  7  8  9 15 16]) %DMN
arrayfun(@(x) text(this_beta(x), other_betas(x), r_labels(x),'color',[.1 .1 1]),[  12    13    17    18]) %DMN
% end regression plot
ff = figure(3)
p = subplot(5,2,tt)
plot(this_beta(subBeta.ord_r))
hold on
plot(other_betas(subBeta.ord_r))
plot(1:18,this_beta*a.p1 + a.p2)
title(t_labels(t_ind))
p.XTick = 1:18;
p.XTickLabel = r_labels(subBeta.ord_r);
p.XTickLabelRotation = 35;
legend({'task beta' 'other beta'})
end
figure(2)
add_numbers_to_mat(avg_beta(subBeta.ord_r,subBeta.ord_t),r_labels(subBeta.ord_r),t_labels(subBeta.ord_t))
add_numbers_to_mat(avg_beta,r_labels,t_labels(1:10))