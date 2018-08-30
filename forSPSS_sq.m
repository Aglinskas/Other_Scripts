loadMR
%%
r_inds = {[9;10],[13;14],[19;20],[11;12],[15;16],[3;4],[7;8],17,18,21,[1;2],[5;6]};
r_lbls = {'FFA', 'OFA','pSTS','IFG','OFC','ATL','Angular','Precuneus','dmPFC','vmPFC','ATFP','Amygdala'}

% r_inds = {[11;12],[15;16],[3;4],[7;8],17,18,21};
% r_lbls = {'IFG','OFC','ATL','Angular','Precuneus','dmPFC','vmPFC'};


% t_inds = {[3;4] [6;10]};
% t_lbls = {'Social' 'Nominal'};

t_inds = {[3;4] [6;10] [1;5] [2;9] [7;8]};
t_lbls = {'Social' 'Nominal' 'Episodic' 'Physical' 'Biographical'};

wh_r = 3
sq = [];l = 0;
sq_lbls = {};
clc
for r = wh_r
disp(r_lbls{r})
for t = 1:length(t_inds)
l = l+1;
sq(:,l) = squeeze(mean(mean(aBeta.fmat(r_inds{r},t_inds{t},:),1),2));
sq_lbls{l,1} = [t_lbls{t} '_' r_lbls{r}];
end
end
%
%i = 10;
%sq_lbls([i*2-1 i*2])
%%

code_fn = '/Users/aidasaglinskas/Desktop/code.txt';
fid = fopen(code_fn,'wt');
pairs = nchoosek(1:length(r_lbls),2);

for p_ind = 1:length(pairs);

select_pair = {sq_lbls{[pairs(p_ind,1)*2-1 pairs(p_ind,1)*2]} sq_lbls{[pairs(p_ind,2)*2-1 pairs(p_ind,2)*2]}}';
code = {'DATASET ACTIVATE DataSet0.'
'GLM %s %s %s %s'
'/WSFACTOR=ROI 2 Polynomial Task 2 Polynomial'
'/METHOD=SSTYPE(3)'
'/PLOT=PROFILE(ROI*Task)'
'/EMMEANS=TABLES(ROI) COMPARE ADJ(BONFERRONI)'
'/EMMEANS=TABLES(Task*ROI) COMPARE(ROI) ADJ(BONFERRONI)'
'/EMMEANS=TABLES(Task*ROI) COMPARE(Task) ADJ(BONFERRONI)'
'/PRINT=DESCRIPTIVE ETASQ'
'/CRITERIA=ALPHA(.05)'
'/WSDESIGN=ROI Task ROI*Task.'}

code{2} = sprintf(code{2},select_pair{1},select_pair{2},select_pair{3},select_pair{4})
ofn_title = [r_lbls{pairs(p_ind,1)} '-' r_lbls{pairs(p_ind,2)}];
%ofn = fullfile('/Users/aidasaglinskas/Desktop/SPSS_out/',[ofn_title '.xls'])
%code{end} = sprintf('/XLS DOCUMENTFILE=''%s''',ofn)
for i = 1:length(code)
fprintf(fid,[code{i} '\n']);
end
fprintf(fid,'\n')
end

ofn = '''/Users/aidasaglinskas/Desktop/SPSS_out/SPSS_out_all.xls''';
fprintf(fid,['OUTPUT EXPORT' '\n'])
fprintf(fid,['/XLS DOCUMENTFILE=' ofn '\n'])
fclose(fid);

