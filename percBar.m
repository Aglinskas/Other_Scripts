loadMR;
%%
%r_inds = {[9 10],[11;12],[15;16],[3;4],[7;8],17,18,21,[1;2],[5;6]};
%rlbls = {'FFA','IFG','OFC','ATL','Angular','Precuneus','dmPFC','vmPFC','ATFP','Amygdala'}
r_inds = {[11;12],[15;16],[3;4],[7;8],17,18,21,[1;2],[5;6]};
rlbls = {'IFG','OFC','ATL','Angular','Precuneus','dmPFC','vmPFC','ATFP','Amygdala'}


r_inds = {[9;10],[13;14],[19;20],[11;12],[15;16],[3;4],[7;8],17,18,21,[1;2],[5;6]};
rlbls = {'FFA', 'OFA','pSTS','IFG','OFC','ATL','Angular','Precuneus','dmPFC','vmPFC','ATFP','Amygdala'}

%r_inds = {[11] [12],[15;16],[3;4],[7;8],17,18,21,[1;2],[5;6]};
%rlbls = {'IFG-L','IFG-R','OFC','ATL','Angular','Precuneus','dmPFC','vmPFC','ATFP','Amygdala'}


t_inds = aBeta.trim.t_inds;
tlbls = aBeta.trim.t_lbls

%rlbls = aBeta.r_lbls
mats = {aBeta.fmat aBeta.wmat cat(3,aBeta.fmat,aBeta.wmat)} 
for exp = 1:3
mat = mats{exp};
subplot(3,1,exp)
tmat = [];
for r = 1:length(r_inds)
for t = 1:length(t_inds)
   v = squeeze(mean(mean(mat(r_inds{r},t_inds{t},:),1),2));
   [H,P,CI,STATS] = ttest(v,0,'tail','right','alpha',.1);
   if H
   tmat(r,t) = STATS.tstat;
   else 
   tmat(r,t) = 0;
   %tmat(r,t) = STATS.tstat;
   end
end
end

axlbls = {'Face Stimuli' 'Name Stimuli' 'Both'};
f = figure(1)
tmat = tmat ./ sum(tmat,2)
b = bar(tmat,'stacked')
xticks(1:r)
xticklabels(rlbls)
xtickangle(45)
l = legend(tlbls,'Location','NorthEastOutside')
xlim([0 12.5])
ylim([0 1])
box off
f.Color = [1 1 1]
f.CurrentAxes.FontSize = 12;
f.CurrentAxes.FontWeight = 'bold'

% f.CurrentAxes.YLabel.String = axlbls{exp}
% f.CurrentAxes.YLabel.FontSize = 14
% f.CurrentAxes.YLabel.Rotation = 45
% f.CurrentAxes.YLabel.HorizontalAlignment = 'right'

title(axlbls{exp},'fontsize',20)
offs= 1
b(5).FaceColor = [0 .53 0.16] /offs %  nominal green 
b(4).FaceColor = [1 .61 0.22] /offs% physical
b(3).FaceColor = [0.0078 .69 .94] /offs %socal 
b(1).FaceColor = [1 .38 .78] /offs% episodic
b(2).FaceColor = [.43 .18 .62] /offs %factual
end