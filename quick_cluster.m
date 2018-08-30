function [f fc h ord] = quick_cluster(mat,lbls,dend_orientation,fig_inds)
% function [f fc h ord] = quick_cluster(mat,lbls,dend_orientation,fig_inds)
% mat
% lbls
% optional: dend_orientation, 'top', 'left'
% optional: fig_inds, which figures to use, default [1 2]
if nargin == 0
    clc;
    help quick_cluster
else

% Input validation
if exist('dend_orientation')==0;dend_orientation = 'top';end
if exist('fig_inds')==0;fig_inds = [1 2];end


lbls = strrep(lbls,'_','-');


Y = pdist(mat,'correlation');
cmat = 1-squareform(Y);
Z = linkage(Y,'ward');

if length(cmat) ~= length(lbls); 
    clc;
    disp('Matrix size')
    disp(size(cmat))
    disp('labels size')
    disp(length(lbls))
    error('matrix size doesnt match labels')
end

f = figure(fig_inds(1));
[h x perm] = dendrogram(Z,0,'labels',lbls,'orientation',dend_orientation);
ord = perm(end:-1:1);
xtickangle(45);
f.CurrentAxes.FontSize = 12;
f.CurrentAxes.FontWeight = 'bold';
[h(1:end).LineWidth] = deal(2);


fc = figure(fig_inds(2));
if length(cmat) < 20
add_numbers_to_mat(cmat(ord,ord),lbls(ord));
else
    add_numbers_to_mat(cmat(ord,ord),lbls(ord),'nonum');
end
end