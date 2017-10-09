loadMR
%%
aBeta;
lbls = {aBeta.r_lbls aBeta.t_lbls(1:10)};

mat = aBeta.fmat_raw;



matn = [];
for i = 1:20
matn(:,:,i) = mat(:,1:10,i)-repmat(mat(:,11,i),1,10);
end
mat = matn;
lbls{1}([11 12]) = [];

mat([11 12],:,:) = [];

cmat = {};a = [];b = [];
for i = 1:20
    a_mat = mat(:,:,i);
    b_mat = mat(:,:,i)';
    
% a_mat = zscore(a_mat,[],2);
% b_mat = zscore(b_mat,[],2);



a(:,:,i) = corr(a_mat);
b(:,:,i) = corr(b_mat);
end
cmat = {b a};
% Dends
f = figure(1)
for r_t = 1:2  
  sp = subplot(2,2,r_t);
  c = cmat{r_t};
  Z = linkage(1-get_triu(mean(c,3)),'ward');
% 
%   'single'    --- nearest distance (default)
%        'complete'  --- furthest distance
%        'average'   --- unweighted average distance (UPGMA) (also known as
%                        group average)
%        'weighted'  --- weighted average distance (WPGMA)
%        'centroid'  --- unweighted center of mass distance (UPGMC)
%        'median'    --- weighted center of mass distance (WPGMC)
%        'ward'      --- inner squared distance (min variance algorithm)
%  
  [h x perm] = dendrogram(Z,'labels',lbls{r_t},'orientation','left');
  [h(1:end).LineWidth] = deal(3);
  sp.FontSize = 12;
  sp.FontWeight = 'bold';
end
% boot
warning('off','stats:linkage:NotEuclideanMatrix')
temp_fig = figure(2)
temp_fig.Visible = 'off'; drawnow
clc
pmats = {}
nperms = 100;
nclust = [3 3];
disp('running perm')
for r_t = 1:2 
c = cmat{r_t};

perm_clust_mat = zeros([size(mean(c,3)) nperms]);
for p_ind = 1:nperms
    subpool = randi(20,1,10);
    perm_mat = mean(c(:,:,subpool),3);
    Z = linkage(1-get_triu(perm_mat),'ward');
    set(0, 'currentfigure', temp_fig); % set gcf as hidden figure
    [h x perm] = dendrogram(Z,nclust(r_t));
    
    for i = unique(x)';
    perm_clust_mat(find(x==i),find(x==i),p_ind) = perm_clust_mat(find(x==i),find(x==i),p_ind)+1;
    end
    %figure(3);imagesc(perm_clust_mat);drawnow
end
pmats{r_t} = perm_clust_mat;
end
disp('all done')
% Draw
figure(1)
for i = [1 2]
subplot(2,2,2+i)
m = mean(pmats{i},3);
set(0, 'currentfigure', temp_fig); % set gcf as hidden figure
[h x perm] = dendrogram(linkage(1-get_triu(m)))
ord = perm(end:-1:1);
figure(1)
add_numbers_to_mat(m(ord,ord),lbls{i}(ord))
end