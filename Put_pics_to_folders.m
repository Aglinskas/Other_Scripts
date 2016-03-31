fn = '/Users/aidas_el_cap/Desktop/Stim/'
a = dir([fn '/*jpg']);
%a(1:2) = [];
%% get unique names
for i = 1:length(a)
names{i} = strsplit(a(i).name,'_');
end
for i = 1:length(a)
    names{i} = names{i}{1};
end
names = unique(names);
names = names' % delete valentino rossi.jpg entry manually
%%
for i = 1:length(names)
    mkdir(fn,names{i})
    mkdir(fullfile(fn,names{i},'selected'))
end
    
for i = 1:length(names)
a = dir([fn '/' names{i} '*.jpg']);
for p = 1:length(a);
movefile(fullfile(fn,a(p).name),fullfile(fn,names{i},'selected'));
end
end
% 
% newfn = '/Users/aidas_el_cap/Desktop/StimFixed/';
% files
% newdir = fullfile(newfn,names{i});


%movefile('source','destination')