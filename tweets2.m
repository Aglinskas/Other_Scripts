TT = [];
nms = {'George Clooney'	'Michael Jackson'	'Angelina Jolie'	'Robin Williams' 'Mike Tyson' 'Laura Pausini'	'Justin Bieber'	'Bill Clinton'	'Michelle Hunziker'	'Matteo Renzi'	'Cameron Diaz'	'Julia Roberts'	'Tom Cruise'	'Romano Prodi'	'Rihanna'	'Sabrina Ferilli'	'Johnny Depp'	'Arnold Schwarzenegger'	'Paris Hilton'	'Paolo Bonolis'	'Matteo Salvini'	'Britney Spears'	'Fiorello'	'George Bush'	'Angelino Alfano'	'Giorgia Meloni'	'John Travolta'	'Filippo Inzaghi'	'Barack Obama'	'Roberto Maroni'	'Matt Damon'	'Charlize Theron'	'Giorgio Napolitano'	'Sandra Bullock'	'Silvio Berlusconi'	'Hillary Clinton'	'Donald Trump'	'Brad Pitt'	'Michelle Obama' 'Bill Gates'}';
nms_list = arrayfun(@(x) [num2str(x,'%.2i') ': ' nms{x}],1:length(nms),'UniformOutput',0)';
%%
% 37 - DJT
% 29 BHO
% 24 - GWB
% 31 - MDamo
% 32 CT
while true
for f = [37 29 24 31 32]
    query = nms{f}
    try
    T = get_tweets(query);
    if isempty(TT); TT = [T]; else TT = [TT T];end
    catch
    end
    disp(sprintf('%d unique tweets in TT',length(unique({TT.text}))))
end
end
%% Feature space;
ut = unique({TT.text});
words.all = strsplit([TT.text]);
words.tab = tabulate(words.all);
    [Y I] = sort([words.tab{:,2}]);
    words.tab = words.tab(I,:);
    mid = round(length(words.tab) / 2);
    words.tab([words.tab{:,2}] < 3,:) = []; % drop words that appear once
%hist([words.tab{:,2}])
mid = round(length(words.tab) / 2);
words.features = words.tab(mid-50:mid+50,:);
fm.f_labels = {words.features{:,1}}';
%%
fm.mat = [];
uq = unique({TT.query});
fm.p_labels = uq'
for uq_ind = 1:length(uq);
inds = strcmp({TT.query},uq{uq_ind});
temp = unique({TT(inds).text}); % unique tweets
w = strsplit([temp{:}]);
for i = 1:length(words.features)
 m = sum(strcmp(w,words.features{i}));
 fm.mat(uq_ind,i) = m; % - words.features{i,2};
end
end
%%
f = figure(1)
fm.simmat = corr(fm.mat');
Z = linkage(1-get_triu(fm.simmat),'ward')
dendrogram(Z,'orientation','left','labels',fm.p_labels)