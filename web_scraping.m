%url = 'http://linkinghub.elsevier.com/retrieve/pii/S1053811907009883';
clear 
url = 'http://www.sciencedirect.com/science/article/pii/S1053811907009883?np=y'
disp('Getting HTLM')
%h = urlread(url);
h = webread(url);
disp('done')
%%

expr = 'class="\w*"'; %expr = '((?<=<sample>).*(?=<\/sample>))';
[classes_all classes_all_ind] = regexp(h,expr,'match');
classes_unique = unique(classes_all)';
expr = '<\w*>'; %tags
[tags_all tags_all_ind] = regexp(h,expr,'match');
tags_all_unique = unique(tags_all)';

%% References
reflist_class_ind = find(cellfun(@isempty,strfind(classes,'references')) == 0)
reflist_class = classes{reflist_class_ind}
%%
%exp = sprintf('%s*</div>',reflist_class)
exp = 'class="references".*</div>'
reflist_text = regexp(h,exp,'match')
reflist_text{1}
%%
ref_class_ind = find(cellfun(@isempty,strfind(classes,'reference')) == 0);


%%ref_class = classes(ref_class_ind);

















% sc.ref_inds = strfind(h,'class="reference"')'; %ref
% sc.auth_inds = strfind(h,'class="author"')' %author
% sc.title_inds = strfind(h,'class="title"')' %author%title
% sc.source_inds = strfind(h,'class="source"')' %author%source
% disp(sprintf('%d references found',size(sc.ref_inds,1)))
% sc
% %%
% refs = strsplit(h,'class="reference"')'
% a = refs{2};
% %%
% pat = '(?<=class=")\w*"' %looks for class labels
% c_s = regexp(a,pat,'match')
% all_classes = cellfun(@(x) sprintf('class="%s"',x),strrep(c_s,'"',''),'UniformOutput',0)'
% %%
% 
% c=all_classes{2};
% %regexp(s,'(?<=w).*(?=s)','match')
% f = '(class/=/"author)">';
% l = '</li>'
% expression = '<(\w+).*>.*</\1>'%sprintf('<%s[^>](.*?)</%s>')%'<tr[^>]*>(.*)</tr>'; %'(?<=class="author">).*(?=</)'
% [tokens,matches]  = regexp(a,expression,'match')
% celldisp(v)
% 
% %%
% 
% str = '<title>My Title</title><p>Here is some text.</p>';
% expression = '<(\w+).*>.*</\1>';
% [tokens,matches] = regexp(h,expression,'tokens','match')
% 
% 



