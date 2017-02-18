%%
clear all
p.root = '/Users/aidasaglinskas/Desktop/Dropbox/Library.papers3/Files/';
temp = dir(p.root);
temp = {temp(find([temp.isdir])).name}';
temp = temp(3:end);
p.folders = temp
clear temp
%%
%cellfun(@(x) fullfile(p.root,x,['*.pdf']),p.folders,'UniformOutput',0)
list = {}
for f = 1:length(p.folders)
a = dir(fullfile(p.root,p.folders{f},['*.pdf']))
if length(a) > 0
    for i = 1:length(a)
list{end+1} = cellfun(@(x) fullfile(p.root,p.folders{f},x),{a(i).name}','UniformOutput',0);
    end
end %ends if
end %ends loop
[list{:}]'
%%
list_fn = arrayfun(@(x) list{x}{1},1:length(list),'UniformOutput',0)';
ofn_dir = '/Users/aidasaglinskas/Desktop/lib_txt/files/';
ofn = arrayfun(@(x) fullfile(ofn_dir,[num2str(x) '.txt']),1:length(list_fn),'UniformOutput',0)';

c = sprintf('pdfx %s -d ''/Users/aidasaglinskas/Desktop/lib_txt/ref/'' -o %s',list_fn{1},ofn{1})

c_fn = '/Users/aidasaglinskas/Desktop/lib_txt/c.txt';
dlmwrite(c_fn,'')
%%
d = 4
list_fn{4} = [];ofn{4} = []
%%
delete('/Users/aidasaglinskas/Desktop/lib_txt/c.txt')
fid = fopen(c_fn,'wt')
for i = 1:length(list_fn)
    fprintf(fid,'pdfx %s -d ''/Users/aidasaglinskas/Deskto p/lib_txt/ref/'' -o %s  -t \n',list_fn{i},ofn{i})
%fprintf(fid,'pdfx %s -d ''/Users/aidasaglinskas/Deskto p/lib_txt/ref/'' -o -t %s \n',list_fn{i},ofn{i})
end
fclose(fid)
%% Import text file
fn = '/Users/aidasaglinskas/Desktop/lib_txt/files/9.txt';
val.strnum = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPLKJHGFDSAZXCVBNM1234567890';
val.str = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPLKJHGFDSAZXCVBNM';
%fid = fopen(fn);
%C = textscan(fid,'%C');
t.text = textread(fn,'%s','delimiter','\n');
t.words = textread(fn,'%s');
%fclose(fid)
%%
t.clean = t.words;
disp('cleaning words')
for i = 1:length(t.clean)
t.clean{i}(find(ismember(t.clean{i},val.str) == 0)) = [];
end
t.clean(find(cellfun(@isempty,t.clean))) = []
%%
tab = tabulate(t.clean)
[Y,I] = sort(cell2mat(tab(:,2,:)))
%%
ref_ind = find([cellfun(@isempty,cellfun(@(x) strmatch('References',x),C,'UniformOutput',0)) == 0]);
a = tabulate(t.words);
%%

str = 'a3,\tt';












