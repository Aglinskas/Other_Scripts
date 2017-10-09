
figure(1);clf
mat = aBeta.fmat([15 16],:,:);
m = mean(mat,3);
sd = std(mat,[],3);
se = sd ./ sqrt(20)

sp = subplot(1,2,1)
bar(m(1,:))
hold on 
errorbar(m(1,:),se(1,:),'r*')
sp.XTickLabel = aBeta.t_lbls(1:10)
sp.XTickLabelRotation  =45
sp.FontSize = 12
sp.FontWeight = 'bold'
title(aBeta.r_lbls{15},'FontSize',20)

sp = subplot(1,2,2)
bar(m(2,:))
hold on 
errorbar(m(2,:),se(2,:),'r*')
sp.XTickLabel = aBeta.t_lbls(1:10)
sp.XTickLabelRotation  =45
sp.FontSize = 12
sp.FontWeight = 'bold'
title(aBeta.r_lbls{16},'FontSize',20)