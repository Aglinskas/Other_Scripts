wiki.featsim = corr(wiki.dm_avg);
Z = linkage(1-get_triu(wiki.featsim),'ward');
%%
[h x perm] = dendrogram(Z,100,'labels',wiki.featwords,'colorthreshold',1);
%HT of 1 gives 386 clusters
wiki.featClust = x;
xtickangle(45)
%% Get Features
t_word = 'slow-a';
t_word_ind = find(strcmp(wiki.featwords,t_word));
t_word_clust = wiki.featClust(t_word_ind);
t_word_clust_inds = find(wiki.featClust==t_word_clust);
clc;disp(wiki.featwords(t_word_clust_inds));
%
%% Use reduced features to construct similarity space
redmat = wiki.dm_avg(:,t_word_clust_inds); % reduces the 1.5k x 6k matrix
redcmat = corr(redmat'); % correlates it
Z = linkage(1-get_triu(redcmat),'ward'); % distnace 
[h x perm] = dendrogram(Z,0,'labels',wiki.nouns,'colorthreshold',1.5); % draw the dend
% Z,0 < how many clusters you want
% x will be the var that tells you which cluster they belong to. 
xtickangle(45);
%% Similarity across datasets
t1 = find(strcmp(wiki.nouns,'house-n'));
t2 = find(strcmp(wiki.nouns,'sweater-n'));
bar([wiki.dmCorr_avg(t1,t2) redcmat(t1,t2)])
%%  Combine getClosestFriends with feature spaces 
lolvar = wiki.featwords; % copy of nouns with -n
lolvar = strrep(lolvar,'-n',''); % drop -n
lolvar = strrep(lolvar,'-a',''); % drop -n
lolvar = strrep(lolvar,'-v',''); % drop -n
inds = find(ismember(lolvar,word)) % match with list