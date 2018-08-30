bib_fn = '/Users/aidasaglinskas/Desktop/lib.bib'

%slCharacterEncoding UTF-8 US-ASCII
fid = fopen(bib_fn);
T = textscan(fid,'%s','delimiter','\n');
text = T{1};
fclose(fid)
%% Number of articles
%temp = cellfun(@(x) strfind(x,'@article'),text,'UniformOutput',0);
temp = arrayfun(@(x) ~isempty(strfind(text{x},'@article')),1:length(text))';
n_articles = length(find(temp));
article_inds = find(temp);
%%
T_cell = {};
l = 0;
for ind = article_inds'
l = l+1;
% Format paperID 
id_string = text{ind};
id_string = strrep(id_string,'@article{','');
id_string(id_string == ',') = [];
T_cell{l,1} = id_string;

% Format authors
auth_str = text{ind+1}; % author string
if strfind(auth_str,'author = {')==1;
    auth_str = strrep(auth_str,'author = {','');
    auth_str = strrep(auth_str,'},','');
auth_split = strsplit(auth_str,' and ');
for i = 1:length(auth_split);
    temp = strsplit(auth_split{i},',');
    if length(temp) < 2;temp = strsplit(auth_split{i},' ');temp = {[temp{1:end-1}] temp{end}};end
    if length(temp) >2; error('lol'); end
    last_name = temp{1};
    inits = temp{2}(strfind(temp{2},' ')+1);
    formatted_names{i} = [last_name ' ' inits];
end
commas = repmat({', '},1,size(formatted_names,2));
C = [commas;formatted_names];
C = [C{:}];C(1:2) = [];
auth_string_final = C;
T_cell{l,2} = auth_string_final;
end
% Format title
title_string = text{ind+2};
title_string = strrep(title_string,'title = {{','');
title_string = strrep(title_string,'}},','');
T_cell{l,3} = title_string;

% format year 
title_string = text{ind+3};
title_string = strrep(title_string,'year = {','');
title_string = strrep(title_string,'},','');
T_cell{l,4} = str2num(title_string);
end

