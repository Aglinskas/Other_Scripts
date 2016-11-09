r_ord = [1 2 3 10 11 14 4 5 6 7 8 9 15 16 12 13 17 18]
t_ord = [ 6    10     7     8     1     5     4     3     2     9]
mat = mean(subBeta.array(r_ord,t_ord,:),3)
%mat = mat - repmat(mean(subBeta.array(:,11,:),3),1,10)
%mat = zscore(mat,[],2)
%mat = zscore(mat,[],1)
m  = figure(7)
add_numbers_to_mat(mat,t_labels(t_ord),r_labels(r_ord))
m.CurrentAxes.FontSize = 16
m.CurrentAxes.XTickLabelRotation = 15
% [1 2 3 10 11 14] % DMN
% [4 5 6 7 8 9 15 16] Core-frontal
% [12 13 17 18]