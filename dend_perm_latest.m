clear 
loadMR
%%

mat = aBeta.fBeta;
%Random Mat
rand = 0
if rand
for i = 1:size(mat,3)
    for t = 1:12
mat(:,t,i) = mat(Shuffle([1:18]),t,i);
    end
end
end


albls = {aBeta.r_labels aBeta.t_labels(1:10)}
mat = mat - mat(:,11,:);
mat = mat(:,1:10,:);
mat = zscore(mat,[],2);



% get Cmat
cmat = [];
for s_ind = 1:20;
cmat(:,:,s_ind) = corr(mat(:,:,s_ind));
end

mmat = mean(cmat,3);

%temp.possible = arrayfun(@(x) length((nchoosek(1:20,x))),1:20);
% bar(temp.possible)

nsubs = 10;
nperms = 100;
for nclust = 2
hidden_fig = figure(13)
hidden_fig.Visible = 'off'
drawnow
%d_fig.Visible = 'on'
warning('off')
for perm_ind = 1:nperms;
rep_vec = 1:nperms/100:nperms;
if ismember(perm_ind,rep_vec)
disp(sprintf('%s%s done',num2str(round((perm_ind / nperms * 100))),'%'));
end
  
subs = randi(size(mat,3),1,nsubs);
mmat = [];
mmat = mean(cmat(:,:,subs),3);
    clust_mat(1:length(mmat),1:length(mmat),perm_ind) = zeros(length(mmat));
    fid_mat(1:length(mmat),1:length(mmat),perm_ind) = zeros(length(mmat));
newvec = get_triu(mmat);
Z = linkage(1-newvec,'ward');
Z_atlas = get_Z_atlas(Z,length(mmat));
[h x perm] = dendrogram(Z,nclust);




for i = unique(x)'
clust_mat(find(x==i),find(x==i),perm_ind) = clust_mat(find(x==i),find(x==i),perm_ind)+1;
end %ends perms

for i = 1:length(Z_atlas)
fid_mat(Z_atlas{i,1},Z_atlas{i,2},perm_ind) = fid_mat(Z_atlas{i,1},Z_atlas{i,2},perm_ind) + Z_atlas{i,3};
fid_mat(Z_atlas{i,2},Z_atlas{i,1},perm_ind) = fid_mat(Z_atlas{i,2},Z_atlas{i,1},perm_ind) + Z_atlas{i,3};
end



n_within = [];
for i = 1:nclust
n_within(i) = mean(get_triu(mmat(find(x==i),find(x==i))));
end


n_between = [];
pairs = nchoosek(1:nclust,2);
for i = 1:size(pairs,1)
%pair = pairs(i,:);
n_between(i) = mean(mean(mmat(find(x==pairs(i,1)),find(x==pairs(i,2)))));
end
null(perm_ind) = mean(n_within) / mean(n_between);


end
%%
mfid = mean(fid_mat,3);
mclust = 1-mean(clust_mat,3);
this_lbls = albls{find(cellfun(@length,albls) == length(mfid))};
collect_mats = {mfid mclust};
this_mat = collect_mats{2};
pl = 1;
if pl
collect_mats = {mfid mclust};
mat_names = {{'Fidelity Matrix' 'measure: distance'} {'Clustering Matrix' 'measure: times observed together'}};
m_ind = 2;
this_mat = collect_mats{m_ind};
dm = figure(2);
subplot(1,2,2);
[h x perm] = dendrogram(linkage(get_triu(this_mat)),'labels',this_lbls,'orientation','left');
ord = perm(end:-1:1);
subplot(1,2,1);
add_numbers_to_mat(1-this_mat(ord,ord),this_lbls(ord));
title(mat_names{m_ind},'Fontsize',20);
dm.Position =  [-1045        1072        1279         677];
sc = figure(3);
clf
schemaball_play(this_lbls(ord),1-this_mat(ord,ord));
sc.Position = [ 27   815   560   420];
end
%% Stability
permmat = mean(clust_mat,3);
asess_c_stability = 1;
if asess_c_stability == 1;
d_temp = figure(11);
d_temp.Visible = 'off'
[h x perm] = dendrogram(linkage(get_triu(this_mat)),nclust);
c_vals = [];

within = [];
stdev = [];
between = [];
for c = 1:nclust
c_inds = find(x == c);
within(c) = mean(get_triu(permmat(c_inds,c_inds)));
stdev(c) = std(get_triu(permmat(c_inds,c_inds)));
between(c) = mean(mean(permmat(c_inds,find(ismember([1:length(permmat)],c_inds)==0))));
end
%measure = mean(mean(c_vals) ./ std(mean(c_vals)));
c_stab(nclust) = mean(within ./ (between+.1) .* (stdev+.1));
c_stab(nclust) = c_stab(nclust) / nclust;
cp = figure(6)
plot(c_stab,'linewidth',3);
xlabel('Number of Clusters')
ylabel({'cluster stability' 'mean/std across perms'})
end % end asess
end
ex = 0
if ex
ofn = '/Users/aidasaglinskas/Desktop/VSS_Poster/Figures/boot2';
fm = 'pdf'
sc
export_fig([ofn '.' fm],sc,['-' fm],'-transparent')
end
access_p = 1
if access_p
[h x perm] = dendrogram(linkage(get_triu(mfid)),nclust,'labels',this_lbls,'orientation','left')
this_lbls(find(x==2))
end

disp(['Cluster Score ' num2str(mean(null))])
%% Sampling Random numbers
% for n = 1:20
%     for i = 1:10000
% a(i) = length(unique(randi(20,1,n)));
%     end
% m(n) = mean(a);
% end
% disp('done') 
% plot(m,'linewidth',4)
% xlabel('n of random samples')
% ylabel('n of unique values')
% hold on
% plot(1:20)
% legend({'Real' 'Expected'})
% title('Sampling Random Numbers','fontsize',20)