%11    12     5     6    13    14     3     4     1     2    15    16    17    18     7     8     9    10
clust = [4 3];
for ind = 1:size(all_ord,2)
score(ind) = all(all_ord(clust,ind) == all_ord(clust(1),ind));
end
perc = sum(score) / size(all_ord,2) * 100;
disp([num2str(perc)  '%'])
that_clustering  = find(score == 1)';
diff_clust = find(score == 0)';
%%
perm = diff_clust(3)
%perm = that_clustering(1)
newVec = get_triu(squeeze(Bootstrapedkeep(perm,:,:)));
Z = linkage(1-newVec,'ward');
dend_labeled = figure(6);
dendrogram(Z,'labels',lbls,'Orientation','left')
%
%% Graph?
for r = 1:18
    for c = 1:18
clust =[r c];
for ind = 1:size(all_ord,2)
score(ind) = all(all_ord(clust,ind) == all_ord(clust(1),ind));
end
perc = sum(score) / size(all_ord,2) * 100;
lolMat(r,c)  = perc;
    end
end
%%
tr_lolMat = lolMat
%tr_lolMat(find(lolMat < 10)) = 0
add_numbers_to_mat(tr_lolMat(s_ord,s_ord),masks_name(s_ord));
%%
sc = figure(9);
%for i = [1:5:100]
s_ord = ord(end:-1:1);
hold off;
clf;
tr_lolMat = lolMat;
%tr_lolMat(find(lolMat < 25)) = 0;
%mm = tr_lolMat(s_ord,s_ord) .* tr_lolMat(s_ord,s_ord) ./ 10000;
%%
tr_lolMat = lolMat;
tr_lolMat(find(lolMat < 25)) = 0;
schemaball(lbls(s_ord), tr_lolMat(s_ord,s_ord) ./ 100);
drawnow
%%
%title('hi_test')
%sc.CurrentAxes.Color = [.5 .5 .5]
%ofn = '/Users/aidas_el_cap/Desktop/mv_test/';
%saveas(sc,[ofn 'i'],'bmp')
%export_fig([ofn  num2str(i)],'-jpg')
%%

t = text(100,100,'hi')
%% looool
Z = linkage(lolMat / 100,'ward')
dendrogram(Z,'labels',masks_name,'orientation','left')