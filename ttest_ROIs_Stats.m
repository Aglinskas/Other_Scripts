clear;loadMR;
% r_inds = {[9;10],[13;14],[19;20],[11;12],[15;16],[3;4],[7;8],17,18,21,[1;2],[5;6]};
% r_lbls = {'FFA', 'OFA','pSTS','IFG','OFC','ATL','Angular','Precuneus','dmPFC','vmPFC','ATFP','Amygdala'}

r_inds = {[9;10],[13;14],[19;20],[11;12],[11],[12],[15;16],[3;4],[7;8],17,18,21,[1;2],[5;6]};
r_lbls = {'FFA', 'OFA','pSTS','IFG-L+R','IFG-Left','IFG-Right','OFC','ATL','Angular','Precuneus','dmPFC','vmPFC','ATFP','Amygdala'}

t_inds = {[3;4] [6;10] [1;5] [2;9] [7;8] [11] [12]};
t_lbls = {'Social' 'Nominal' 'Episodic' 'Physical' 'Biographical' 'FaceCC' 'MonCC'};

use_mat = aBeta.fmat;
wh_r = [4 5 6]
p_thresh = .05
clc;
for r = wh_r
    disp(r_lbls{r})
for t1 = 1:5
for t2 = 1:5
    v1 = squeeze(mean(mean(use_mat(r_inds{r},t_inds{t1},:),1),2));
    v2 = squeeze(mean(mean(use_mat(r_inds{r},t_inds{t2},:),1),2));
    
    [H,P,CI,STATS] = ttest(v1,v2);
    
    if P < p_thresh & STATS.tstat > 0    
    txt = '%s > %s: t(%d) = %.2f, p = %.3f';
    txtf = sprintf(txt,t_lbls{t1},t_lbls{t2},STATS.df,STATS.tstat,P);
    disp(txtf)
    end
end
end
end
%% VS control
use_mat = aBeta.fmat_raw;
wh_r = 3
p_thresh = .5
for r = wh_r
    clc;disp(r_lbls{r})
for t1 = 1:5
    v1 = squeeze(mean(mean(use_mat(r_inds{wh_r},t_inds{6},:),1),2));
    v2 = squeeze(mean(mean(use_mat(r_inds{wh_r},t_inds{t1},:),1),2));
    [H,P,CI,STATS] = ttest(v1,v2);
    
    if P < p_thresh & STATS.tstat > 0    
    txt = '%s > %s: t(%d) = %.2f, p = %.3f';
    txtf = sprintf(txt,t_lbls{6},t_lbls{t1},STATS.df,STATS.tstat,P);
    disp(txtf)
    end
end
end

%% Just Controls
use_mat = aBeta.fmat_raw;
wh_r = 7
p_thresh = .05
for r = wh_r
    clc;disp(r_lbls{r})
    v1 = squeeze(mean(mean(use_mat(r_inds{wh_r},t_inds{6},:),1),2));
    v2 = squeeze(mean(mean(use_mat(r_inds{wh_r},t_inds{7},:),1),2));
    [H,P,CI,STATS] = ttest(v1,v2);
    
    if P < p_thresh & STATS.tstat > 0    
    txt = '%s > %s: t(%d) = %.2f, p = %.3f';
    txtf = sprintf(txt,t_lbls{6},t_lbls{7},STATS.df,STATS.tstat,P);
    disp(txtf)
    end
end



