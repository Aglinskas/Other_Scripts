function flist = rdir_wext(fn,ext)

p.root = fn;
%p.root = '/Users/aidasaglinskas/Desktop/Dropbox/Library.papers3/Files/';
ext = ['*' ext];

temp = dir(p.root);
temp = {temp(find([temp.isdir])).name}';
temp = temp(3:end);
p.folders = temp;
clear temp;
%cellfun(@(x) fullfile(p.root,x,['*.pdf']),p.folders,'UniformOutput',0)
list = {};
for f = 1:length(p.folders)
a = dir(fullfile(p.root,p.folders{f},ext));
if length(a) > 0
    for i = 1:length(a);
list{end+1} = cellfun(@(x) fullfile(p.root,p.folders{f},x),{a(i).name}','UniformOutput',0);
    end
end %ends if
end %ends loop
flist = [list{:}]';
end