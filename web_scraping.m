%url = 'http://linkinghub.elsevier.com/retrieve/pii/S1053811907009883';
clear 
url = 'http://www.sciencedirect.com/science/article/pii/S0028393216303876?np=y'
disp('Getting HTLM')
h = webread(url);
disp('done')
%%
expr = 'class="\w*"'; %expr = '((?<=<sample>).*(?=<\/sample>))';
[classes_all classes_all_ind] = regexp(h,expr,'match');
classes_unique = unique(classes_all)';
expr = '<\w*>'; %tags
[tags_all tags_all_ind] = regexp(h,expr,'match');
tags_all_unique = unique(tags_all)';
%%

strfind(h,'<title>') strfind(h,'</title>')

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

