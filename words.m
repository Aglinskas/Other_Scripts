fn = '/Users/aidasaglinskas/Desktop/lib_txt/all_refs.txt';
fid = fopen(fn);
raw = textread(fn,'%s','whitespace','','bufsize',1000000);
raw = raw{1};
disp(raw)
%%
expr = 'author = {.*?\>}'
a = regexp(raw,expr,'match')
disp(a{2})
%%

list = {};
for i = 1:length(a)
% assign
str = a{i};
% trim
str = strrep(str,'author = {',''); str = strrep(str,'},','');
nms = strsplit(str,' and ');
for n = 1:length(nms) 
    
%    if length(strfind(nms{n},', ')) ~= 1
%        error('this');end
    
   nms{n} = nms{n}(1:strfind(nms{n},', ') + 2);
   list{end+1} = nms{n};  
end
end

%%
disp('Computing list')
u_list = unique(list');
rep = u_list;
for i = 1:length(u_list)
    rep{i,2} = sum(cellfun(@(x) strcmp(x,u_list{i}),list));
end
%
t = cell2table(rep,'VariableNames',{'Name' 'freq'});
t = sortrows(t,2,'Descend')
    


