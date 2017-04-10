d = '/Users/aidasaglinskas/nltk_data/corpora/brown/';
fls = dir([d 'c*']);
%fls = {fls(find([fls.isdir] == 0)).name}';
fls = {fls.name}';
all_corpus = {};
disp('getting text')
for t_ind = 1:length(fls)
txt_fn = fullfile(d,fls{t_ind});
fid = fopen(txt_fn);
corpus  = textscan(fid,'%s');
corpus = corpus{1};
all_corpus = [all_corpus;corpus];
fclose('all');
end
corpus = all_corpus;
% word the corpus
disp('computing')
temp.a = cellfun(@isletter,corpus,'UniformOutput',0);
inds_to_drop = cellfun(@sum,temp.a) == 0;
corpus(inds_to_drop) = [];
nums = cellfun(@num2str,num2cell(1:9),'UniformOutput',0);
num_inds = find(cellfun(@(x) any(ismember(x,[nums{:}])),corpus));
corpus(num_inds) = [];
%
to_drop = [];
for i = 1:length(corpus);
    if ismember(i,1:10000:1005904);
        disp([num2str(i/length(corpus)*100) 'percent done'])
    end
sp = strsplit(corpus{i},'/');
if length(sp) ~= 2;
to_drop(end+1) = i;
else

corpus2{i,1} = sp{1};
corpus2{i,2} = sp{2};
corpus2{i,3} = porterStemmer(corpus2{i,1});
end
end
corpus(to_drop,:);
%tab_corpus2 = tabulate(corpus2(:,3));
disp('done')
% Samples features
n_rows = strfind(cellfun(@(x) x(1),{corpus2{:,2}}),'n')';
a_rows = strfind(cellfun(@(x) x(1),{corpus2{:,2}}),'j')';
v_rows = strfind(cellfun(@(x) x(1),{corpus2{:,2}}),'v')';
fmat.row_labels = unique(corpus2(n_rows,3));
fmat.col_labels = unique(corpus2([a_rows;v_rows],3));
% co-ocurence
win = 5;
corpus2_reduced = corpus2(sort([n_rows;a_rows;v_rows]),:);
fmat.mat_coocurrence = [];
fmat.mat_coocurrence = zeros(length(fmat.row_labels),length(fmat.col_labels));
disp('computing co-ocurence')
for i = win+1:length(corpus2_reduced);
words = corpus2(i-win:i+win,3);
r = ismember(fmat.row_labels,words);
c = ismember(fmat.col_labels,words);
fmat.mat_coocurrence(find(r),find(c)) = fmat.mat_coocurrence(find(r),find(c)) + 1;
end
disp('done')
e_cols = sum(fmat.mat_coocurrence,1)'; %sums nouns, features that are low for all nouns  
e_rows = sum(fmat.mat_coocurrence,2); % sum features, nouns that dont cluster with anything

max_cols = find(zscore(e_cols) > 3);
max_rows = find(zscore(e_rows) > 3);

e_cols = find(e_cols < 20);
e_rows = find(e_rows < 20);

drop_rows = [e_rows;max_rows];
drop_cols = [e_cols;max_cols];
fmat.mat_coocurrence(drop_rows,:) = [];
fmat.mat_coocurrence(:,drop_cols) = [];
fmat.col_labels(drop_cols) = [];
fmat.row_labels(drop_rows) = [];
%
disp('Plotting')
tcmats = {fmat.mat_coocurrence fmat.mat_coocurrence'};
tlbls = {fmat.col_labels fmat.row_labels};
ttitles = {'Feature Clustering' 'Sample Clustering'};
for w_c = [1 2]
ff = figure(w_c);
fmat.f_cmat{w_c} = corr(tcmats{w_c});
newVec = get_triu(fmat.f_cmat{w_c});
Z = linkage(1-newVec,'ward');
[h x perm] = dendrogram(Z,0);
ord = perm(end:-1:1);
ords{w_c} = ord;
imagesc(fmat.f_cmat{w_c}(ord,ord));
ff.CurrentAxes.XTick = 1:length(tlbls{w_c});
ff.CurrentAxes.XTickLabel = tlbls{w_c}(ord);
ff.CurrentAxes.YTick = 1:length(tlbls{w_c});
ff.CurrentAxes.YTickLabel = tlbls{w_c}(ord);
title(ttitles{w_c},'FontSize',20);
end

fmat.mat_coocurrence  = fmat.mat_coocurrence(ords{2},ords{1});
fmat.col_labels = fmat.col_labels(ords{1});
fmat.row_labels = fmat.row_labels(ords{2});
f = figure(3);
imagesc(fmat.mat_coocurrence);
f.CurrentAxes.XTick = 1:length(fmat.col_labels);
f.CurrentAxes.YTick = 1:length(fmat.row_labels);
f.CurrentAxes.XTickLabel = fmat.col_labels;
f.CurrentAxes.YTickLabel = fmat.row_labels;
title({'Co-occurence matrix' 'Nouns by Adjectives|Verbs'},'FontSize',20);
disp('all done')