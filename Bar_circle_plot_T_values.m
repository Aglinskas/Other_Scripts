plt_list = [.3	0	0
.4	0	0
.5	0	0
.6	0	0
.7	0	0
.8	0	0
.9	0	0
1	0	0
0	.3	0
0	.4	0
0	.5	0
0	.6	0
0	.7	0
0	.8	0
0	0	.3
0	0	.4
0	0	.5
0	0	.6];
%% for trim
plt_list = [0	0	.1
0	0	.3
0	0	.5
.2	0	0
.5	0	0
.7	0	0
0	0	.7
0	.4	0
0	0	.9
1	0	0
0	.9	0]
%%
loadMR
r_ord = [ 4     5     6    10     1     9     7     3     2     8    11]
mat = trim_beta.tmat(:,subBeta.ord_t);
lbls{1} = trim_beta.lbls_t((subBeta.ord_t))
lbls{2} = trim_beta.lbls_r
f = figure(2)
clf

pl_or_text = 2
if pl_or_text == 1
for r_ind = 1:size(mat,1);
hold on
plot(1:10,mat(r_ind,1:10)','o','Color',plt_list(r_ind,:),'MarkerSize',15,'LineWidth',3)
end
elseif pl_or_text == 2

for r_ind = 1:size(mat,1); 
for t_ind = 1:size(mat,2); 
    
    text(t_ind,mat(r_ind,t_ind),lbls{2}{r_ind},'Color',plt_list(r_ind,:))
    
end
end
f.CurrentAxes.XLim = [0 11]
f.CurrentAxes.YLim = [min(mat(:))-1 max(mat(:))+1]
f.Position(2) = f.Position(2) + 100
title({'T values' 'Hemisphere averaged'},'Fontsize',20)
ylabel('T value')
xlabel('Task')
end%ends text loop


%arrayfun(@(x) text(this_beta(x), other_betas(x), r_labels(x),'color',[.1 .1 1]),[  12    13    17    18]) %DMN
%arrayfun(@(x) text(this_beta(x), other_betas(x), r_labels(x),'color',[.1 .1 1]),[  12    13    17    18]) %DMN
%arrayfun(@(x) text(x, mat(r_ind,x), lbls{2}{r_ind},'color',[.1 .1 1]),[1:10]) %DMN


xlim([-1 11])

f.CurrentAxes.XTick = 1:10;
f.CurrentAxes.XTickLabel = lbls{1};
f.CurrentAxes.XTickLabelRotation = 45
f.CurrentAxes.FontSize = 18
f.CurrentAxes.FontWeight = 'bold'
%legend(lbls{2},'northeastoutside')


saveas(f,'/Users/aidasaglinskas/Desktop/tmat.png','png')
%%



