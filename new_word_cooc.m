d = '/Users/aidasaglinskas/nltk_data/corpora/brown/';
fls = dir([d 'c*']);
%fls = {fls(find([fls.isdir] == 0)).name}';
fls = {fls.name}';
all_corpus = {};
disp('getting text')
for t_ind = 1:10; %length(fls)
txt_fn = fullfile(d,fls{t_ind});
fid = fopen(txt_fn);
corpus  = textscan(fid,'%s');
corpus = corpus{1};
all_corpus = [all_corpus;corpus];
fclose('all');
end
corpus = all_corpus;
% word the corpus
disp('pre-processing')
temp.a = cellfun(@isletter,corpus,'UniformOutput',0);
inds_to_drop = cellfun(@sum,temp.a) == 0;
corpus(inds_to_drop) = [];
nums = cellfun(@num2str,num2cell(1:9),'UniformOutput',0);
num_inds = find(cellfun(@(x) any(ismember(x,[nums{:}])),corpus));
corpus(num_inds) = [];
%
to_drop = [];
for i = 1:length(corpus);
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
disp('done')
