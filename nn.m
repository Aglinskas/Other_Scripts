load('/Users/aidasaglinskas/Desktop/Matlab_Neurosynth/Neurosynth_all.mat')
n = Neurosynth_all;
%%
n.Database
%%

l_ind = find(ismember(n.labels,'face'));
p_ind = find(ismember(n.labels,'precuneus'))

%[Y I] = sort(,'descend');


n.features(find(n.features(find(n.features(:,[p_ind])),l_ind)),p_ind)


inds = n.features(:,p_ind) > 0 & n.features(:,l_ind) > 0;
find(inds)
inds = find(inds);
%%

[Y I] = sort(n.features(find(inds),p_ind),'descend');
inds = inds(I)


i = 2
unique(n.Database.title(find(n.Database.id == n.features(inds(i),1))))


