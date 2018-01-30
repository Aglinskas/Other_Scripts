fn_root = '/Users/aidasaglinskas/Desktop/Clutter/QS/moves_export/csv/daily/';
fldrs = {'activities'    'places'    'storyline'    'summary'};
f_ind = 2;
fn_fldr = fullfile(fn_root,fldrs{f_ind});
temp = dir([fn_fldr '/*.csv']);
fls = {temp.name}';
clc;disp(fldrs{f_ind})
%%
T =table
all_files = {};
for i = 1:length(fls)
clc;disp(sprintf('%d/%d',i,length(fls)))
fn = fullfile(fn_fldr,fls{i});
fid = fopen(fn,'r','n','UTF-8');
t_orig = textscan(fid,'%s','Delimiter','\n');t_orig = t_orig{1};
fclose(fid);
tx = t_orig;
line = {};
hdr = strsplit(tx{1},',')';
hdrs{i} = hdr;
for j = 2:length(tx);
dt = strsplit(tx{2},',');
[line{j,1:length(dt)}] = deal(dt{:});
end
line(1,:) = [];
if size(all_files,2)>size(line,2)
[line{:,size(line,2)+1:size(all_files,2)}] = deal([]);
elseif size(all_files,2)<size(line,2)
[all_files{:,size(all_files,2)+1:size(line,2)}] = deal([]);
big_head = hdr;
end
all_files = [all_files;line];
end
%
T = cell2table(all_files,'VariableNames',big_head);
disp('table created')

