loadMR
%load('/Users/aidasaglinskas/Desktop/wBeta.mat')
load('/Users/aidasaglinskas/Google Drive/Mat_files/Other_mats/wBeta.mat')
re_ord = [ 10    11    12    13     2     3     6     7    17    18     8     9     4     5    15 16    14     1];
subBeta.array = subBeta.array(re_ord,:,:)
subBeta.r_labels = {subBeta.r_labels{re_ord}}'
subBeta.warray = mean(wBeta,4);
trim.r_trim = {[ 13 14] [ 7 8] [ 15 16] [ 11 12] [18] [17] [ 1 2] [ 5 6] [ 3 4] [ 9 10]};
trim.r_trim_lbls = {'OFA' 'FFA' 'Orb' 'IFG' 'Precuneus' 'PFCmedial' 'ATL' 'pSTS' 'Amygdala' 'Face Patch'};
trim.t_trim = {[1 5] [7 8] [3 4] [2 9] [6 10]};
trim.t_trim_labels = {'Episodic' 'Factual' 'Social' 'Physical' 'Nominal' };

%
% z matrix
wsubs = [1:3 5:7]
subBeta.warray = subBeta.warray(:,:,wsubs)

mat = subBeta.warray;
mat = mat - mat(:,11,:);
mat = mat(:,1:10,:);
%mat = zscore(mat,[],2); % zscore across tasks
%mat = mat - mean(mat,2)
% collapse: 
trimBeta = [];
for r = 1:10
for t = 1:5
trimBeta(r,t,:)  = squeeze(mean(mean(mat(trim.r_trim{r},trim.t_trim{t},:),1),2));
end
end
%trimBeta = mean(trimBeta,3) % avg across subjects;


tm = [];
for t = 1:5
for r = 1:10
    this_v = squeeze(trimBeta(r,t,:));
    other_v = squeeze(mean(trimBeta(r,find([1:5]~=t),:),2));
    
    [H,P,CI,STATS] = ttest(this_v,other_v);
    tm(r,t) = STATS.tstat;
end
end
tm = zscore(tm,[],2)
figure(3);add_numbers_to_mat(tm,trim.t_trim_labels,trim.r_trim_lbls)
