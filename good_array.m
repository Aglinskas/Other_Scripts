clear all
loadMR
clear a
array = subBeta.array(subBeta.ord_r,[subBeta.ord_t 11 12],:); 
lbls = {subBeta.t_labels([subBeta.ord_t 11 12]) subBeta.r_labels(subBeta.ord_r)};
w_r = [1:18]
for s = 1:size(subBeta.array,3)
   a(:,:,s) = array(w_r,:,s);
   a(:,:,s) = a(:,:,s) - a(:,11,s);
   b(:,:,s) = a(:,1:10,s);
b(:,:,s) = b(:,:,s) - mean(b(:,:,s),1);
b(:,:,s) = b(:,:,s) - mean(b(:,:,s),2);
end
mb = mean(b,3);
figure(10)
%add_numbers_to_mat(mb,lbls{1}(1:10),lbls{2})
title({'20 Subject mean beta' 'de-mean''ed per sub'})
% Check
mat = b;
l = {lbls{1}(1:size(b,2)) lbls{2}};
clear keep;
for s = 1:20
keep(:,:,s) = corr(mat(:,:,s)');
end
mkeep = mean(keep,3);
%
figure(3)
add_numbers_to_mat(mkeep,l{1},l{2})
title('Keep')
newVec = get_triu(mkeep);
Z = linkage(1-newVec,'ward');
d = figure(4)
w_l = find(cellfun(@(x) isequal(length(x),length(mkeep)),l));
[h x ord] = dendrogram(Z,'label',l{w_l},'orientation','left');
[h(1:end).LineWidth] = deal(3);
d.CurrentAxes.FontSize = 16;
%%
tmat = []
for r = 1:size(keep,1)
    for c = 1:size(keep,1)
[H,P,CI st] = ttest(squeeze(keep(r,c,:)));
tmat(r,c) = st.tstat;
end
end
tmat(tmat==inf) = nan
%tmat = tmat ./ max(max(abs(tmat)))
%tmat(tmat<0) = 0
figure(5)
clf
add_numbers_to_mat(tmat,l{w_l})
title('correlation T mat')
%%
figure(6)
clf 
p_tmat = tmat ./ max(max(abs(tmat)))
p_tmat(p_tmat<0) = 0
schemaball(l{w_l},p_tmat)