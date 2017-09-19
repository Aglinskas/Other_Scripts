T = struct;
clc
root_folder = '/Users/aidasaglinskas/Downloads/theFairLab Slack export Jul 25 2017';
root_files = dir(root_folder);
root_folders = {root_files([root_files.isdir]).name}';
root_folders = root_folders(3:end);
for fldr = 1:length(root_folders)
%folder_name = '/Users/aidasaglinskas/Downloads/theFairLab Slack export Jul 25 2017/wp1_4/';
folder_name = fullfile(root_folder,root_folders{fldr})
files = dir([folder_name '/*.json']);
files = {files.name}';
for fl = 1:length(files)   
%fname = '/Users/aidasaglinskas/Downloads/theFairLab Slack export Jul 25 2017/wp1_4/2017-03-13.json';
fname = fullfile(folder_name,files{fl});
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
value = jsondecode(str);
%%
for i = 1:length(value);
if iscell(value)
    temp = value{i};
elseif isstruct(value)
    temp = value;
end
fld_names = fieldnames(temp);
l = size(T,2)+1;
for f = 1:length(fld_names);
   fld_name = fld_names{f};
T(l).channel = root_folders{fldr};
expr = ['T(' num2str(l) ').'  fld_name '  = temp. ' fld_name ' ;'];
eval(expr);
end
end
end % ends fname
end % ends folders
disp('done')
%% Add usernames
disp('adding usernames')
usr_ids = find(cellfun(@isempty,{T.username})==0);
unique_names = unique({T(usr_ids).username})';
unique_names(1) = [];
for i = 1:length(unique_names)
 y = find(strcmp({T.username},unique_names{i}));
 y = y(1);
unique_names{i,2} = T(y).user;
end
%%
% Add bots
T(1) = [];
[T(find(cellfun(@isempty,{T.user}))).user] = deal('bot');
for i = 1:length(unique_names)
o = strrep({T.user},unique_names{i,2},unique_names{i,1});
[T.user] = deal(o{:});
end
disp('done')
%% Create Table
TT = struct2table(T);
disp('converting dates')
for i = 1:size(TT,1)
    if ~isempty(TT.ts{i})
       TT.ts{i} = datestr(str2num(TT.ts{i})/86400 + datenum(1970,1,1));
       %TT.ts{i} = datetime(TT.ts{i});
    end
end
disp('done')
disp('all done')

TT.date = datetime(TT.ts);

save('/Users/aidasaglinskas/Desktop/Slack_Data_Table.mat','TT');