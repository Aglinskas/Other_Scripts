loadMR;


r_ord = [  10     9     4     3     6    18    17     2     5     1    12    11    16    15  8     7    14    13]
%r_ord = [18    17    16     1     2    11    15    14    12     3     9     7    13     4   8    10     5     6];
t_ord = [6    10     2     3     9     8     1     4     5     7]
aBeta.r_ord = r_ord;
aBeta.t_ord = t_ord;

aBeta.wBeta = aBeta.wBeta(aBeta.r_ord,:,:)
aBeta.fBeta = aBeta.fBeta(aBeta.r_ord,:,:)
aBeta.r_labels = aBeta.r_labels(aBeta.r_ord)

aBeta.wBeta = aBeta.wBeta % grab the beta values;
aBeta.wBeta = aBeta.wBeta - aBeta.wBeta(:,11,:); % subtract face repsonse;
aBeta.wBeta = aBeta.wBeta(:,1:10,:); % drop the control tasks
aBeta.wBeta = zscore(aBeta.wBeta,[],2);

aBeta.fBeta = aBeta.fBeta % grab the beta values;
aBeta.fBeta = aBeta.fBeta - aBeta.fBeta(:,11,:); % subtract face repsonse;
aBeta.fBeta = aBeta.fBeta(:,1:10,:); % drop the control tasks
aBeta.fBeta = zscore(aBeta.fBeta,[],2);

%aBeta.fBeta = mean(aBeta.fBeta,3);
%aBeta.wBeta = mean(aBeta.wBeta,3)


mat = []
inds = [1:18]%[18 14 12]
for w = 1:length(inds)
ind = inds(w)
for i = 1:size(aBeta.wBeta,3)
a = mean(aBeta.fBeta(ind,:,:),3)';
b = aBeta.wBeta(ind,:,i)'

mat(i,w) = corr(a,b)

end
end


%
f = figure(1);
clf
bar(mean(mat))
hold
errorbar(mean(mat),std(mat) ./ sqrt(size(mat,1)),'r*')

f.CurrentAxes.XTick = 1:length(inds)
f.CurrentAxes.XTickLabel = aBeta.r_labels(inds)
f.CurrentAxes.XTickLabelRotation = 45
f.CurrentAxes.FontSize = 14
f.CurrentAxes.FontWeight = 'bold'
box off

title('Word Exp Subject correlation with mean of face exp')
legend({'Mean Correlation' 'Standard Error'},'fontsize',12)
saveas(f,'/Users/aidasaglinskas/Desktop/a.png','png')
%%

bar(mat)
legend(aBeta.r_labels(inds),'FontSize',10)
xlabel('subject')
ylabel('correlation')
box off
f.CurrentAxes.FontSize = 12
f.CurrentAxes.FontWeight = 'bold'
title('ROI pattern Correlation: face exp mean & word exp subject','Fontsize',16)
saveas(f,'/Users/aidasaglinskas/Desktop/a.png','png')


%% Over FaceCC
loadMR
aBeta.wBeta = aBeta.wBeta(aBeta.r_ord,:,:)
aBeta.fBeta = aBeta.fBeta(aBeta.r_ord,:,:)
aBeta.r_labels = aBeta.r_labels(aBeta.r_ord)


m = aBeta.wBeta;
m = m - m(:,11,:);
m = m(:,1:10,:);
m = mean(m,2);
m = squeeze(m);


ste = std(m') ./ sqrt(size(m,2))

eb2 = figure(2)
clf
bar(mean(m'))
hold on
errorbar(mean(m'),ste,'r*')

eb2.CurrentAxes.XTick = 1:18
eb2.CurrentAxes.XTickLabel = aBeta.r_labels
eb2.CurrentAxes.XTickLabelRotation = 45
eb2.CurrentAxes.FontSize = 14
eb2.CurrentAxes.FontWeight = 'bold'
eb2.CurrentAxes.YLim = [-0.4000    1.2000]
box off

title({'Activity for [Mean(CogTasks) - nBack]' 'Word Dataset'})
legend({'Cog-nBack beta' 'Standard Error'},'fontsize',12)
saveas(eb2,'/Users/aidasaglinskas/Desktop/b.png','png')
%%
a = [];
for r = 1:18    
a(r) = corr(aBeta.fBeta(r,:)',aBeta.wBeta(r,:)');
end


f = figure(1);
bar(a(aBeta.r_ord))

f.CurrentAxes.XTick = 1:18;
f.CurrentAxes.XTickLabel = aBeta.r_labels(aBeta.r_ord);
f.CurrentAxes.XTickLabelRotation = 45;
f.CurrentAxes.TickDir = 'out'
%f.CurrentAxes.YTick = []
f.CurrentAxes.FontSize = 12
f.CurrentAxes.FontWeight = 'bold'
f.CurrentAxes.Box = 'off'
f.CurrentAxes.LineWidth = 0.1
title('Pattern Correlation between Names and Faces','FontSize',20)

saveas(f,'/Users/aidasaglinskas/Desktop/a.png','png')