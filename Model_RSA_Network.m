loadMR;
%% get data 
mat = aBeta.fmat;
%mat = zscore(mat,[],2);
lbls = aBeta.r_lbls
cmat = [];
for s = 1:size(aBeta.fmat,3)
cmat(:,:,s) = corr(mat(:,:,s)');    
end
drop = []
%drop = [[9 10 13 14  19 20 1 2 5 6]];disp(aBeta.r_lbls(drop))
cmat(drop,:,:) = [];
cmat(:,drop,:) = [];
lbls(drop) = []
clc;disp(size(cmat))
%% Describe Model
models_lbls = {};model_inds = {};
% models_lbls{end+1} = 'Core/Ext'
% model_inds{end+1} = {[ 9    10    13    14    19    20] [3     4     7     8    15    16    17    18    21  1     2     5     6    11    12]};
% models_lbls{end+1} = 'Core/Ext-IFG'
% 
% model_inds{end+1} = {[ 9    10    13    14    19    20] [3     4     7     8    15    16    17    18    21  1     2     5     6    11    12]};
% models_lbls{end+1} = 'Core-IFG/Ext'
% 
% 
% model_inds{end+1} = {[ 9    10    13    14    19    20 11 12] [3     4     7     8    15    16    17    18    21  1     2     5     6]};
% models_lbls{end+1} = 'Core-OFC/Ext'
% model_inds{end+1} = {[ 9    10    13    14    19    20 15 16] [3     4     7     8     17    18    21  1     2     5     6    11    12]};
% % models_lbls{end+1} = 'Core-ATFP/Ext'
% % model_inds{end+1} = {[ 9    10    13    14    19    20 1     2 ] [3     4     7     8    15    16    17    18    21     5     6 ]};
% % models_lbls{end+1} = 'Core-IFG/Ext'
% % model_inds{end+1} = {[ 9    10    13    14    19    20 11    12] [3     4     7     8    15    16    17    18    21  1     2     5     6 ]};
% % models_lbls{end+1} = 'Core/Ext/DMN'
% % model_inds{end+1} = {[ 9    10    13    14    19    20] [3     4     7     8    15    16    17    18    21] [ 1     2     5     6    11    12]}
% % models_lbls{end+1} = 'Core-IFG/DMN/Ext'
% % model_inds{end+1} = {[ 9    10    13    14    19    20   11    12] [3     4     7     8    15    16    17    18    21] [ 1     2     5     6  ]}
% % models_lbls{end+1} = 'Core-ATFP/DMN/Ext'
% % model_inds{end+1} = {[ 9    10    13    14    19    20 1     2] [3     4     7     8    15    16    17    18    21] [     5     6   11    12]}
% % models_lbls{end+1} = 'all paired'
% % model_inds{end+1}  = (21,randi(20),1)]');
% %     models_lbls{end+1} = 'random';
% %     model_inds{end+1}  = {r find(~ismember([1:21],r))}
% % models_lbls{end+1} = 'Core-Frontal/DMN/Amy-FP'
% % model_inds{end+1}  = {[9    10    13    14    19    20 15 16 11 12] [3 4 7 8 17 18 21] [1 2 5 6]}
% model_inds{end+1} = {[ 9    10    13    14    19    20  1     2   11    12    15    16] [ 3     4     7     8    17    18    21  5     6 ]}
% models_lbls{end+1} = 'Core-Ext-Cog / Int-Cog'
% model_inds{end+1} = {[ 9    10    13    14    19    20  1     2   11    12    15    16] [ 3     4     7     8    17    18    21  5     6 ]}
% models_lbls{end+1} = 'Core-Ext-Cog-ATFP / Int-Cog'
% model_inds{end+1} = {[ 9    10    13    14    19    20   11    12    15    16] [ 3     4     7     8    17    18    21  5     6 1     2]}
% models_lbls{end+1} = 'Core-Ext-Cog / Int-Cog-ATFP'
% model_inds{end+1} = {[ 9    10    13    14    19    20   11    12    15    16] [ 3     4     7     8    17    18    21  5     6 ] [1     2]}
% models_lbls{end+1} = 'Core-Ext-Cog / Int-Cog / ATFP'
% 
% model_inds{end+1} = {[ 9    10    13    14    19    20   11    12    15    16 5     6] [ 3     4     7     8    17    18    21   1     2]}
% models_lbls{end+1} = 'Core-Ext-Cog+Amy/ Int-Cog'
% model_inds{end+1} = {[ 9    10    13    14    19    20   11    12    15    16] [ 3     4     7     8    17    18    21  5     6 1     2]}
% models_lbls{end+1} = 'Core-Ext-Cog/ Int-Cog+Amy'

% model_inds{end+1} = {[ 9    10    13    14    19    20 11 12 1 2 ] [3     4     7     8    17    18    21     5     6]}
% models_lbls{end+1} = 'Core-ATFP / Extended'
% 
% model_inds{end+1} = {[ 9    10    13    14    19    20 11 12 ] [3     4     7     8    17    18    21     5     6 1 2]}
% models_lbls{end+1} = 'Core / Extended-ATFP'
% 
% model_inds{end+1} = {[ 9    10    13    14    19    20 11 12 1 2] [3     4     7     8    17    18    21     5     6 1 2]}
% models_lbls{end+1} = 'Core-ATFP / Extended-ATFP'
% 
% model_inds{end+1} = {[ 9    10    13    14    19    20 11 12] [3     4     7     8    17    18    21     5     6 ] [1 2]}
% models_lbls{end+1} = 'Core / Extended / ATFP'


% model_inds{end+1} = {[9    10    13    14    19    20] [  3     4     7     8   17    18    21]}
% models_lbls{end+1} = 'Core / DMN'
% 
% model_inds{end+1} = {[9    10    13    14    19    20 11 12] [  3     4     7     8   17    18    21]}
% models_lbls{end+1} = 'Core-IFG / DMN'
% 
% model_inds{end+1} = {[9    10    13    14    19    20] [  3     4     7     8   17    18    21 11 12]}
% models_lbls{end+1} = 'Core / DMN-IFG'
% 
% model_inds{end+1} = {[9    10    13    14    19    20 11 12 15 16] [  3     4     7     8   17    18    21]}
% models_lbls{end+1} = 'Core-IFG-OFC / DMN'
% 
% model_inds{end+1} = {[9    10    13    14    19    20 11 12 15 16] [  3     4     7     8   17    18    21]}
% models_lbls{end+1} = 'Core-IFG / DMN-OFC'

model_inds{end+1} = {[ 9    10    13    14    19    20] [ 3     4     7     8    17    18    21] [1     2     5     6]}
models_lbls{end+1} = 'Core/Ext/amyFP'

model_inds{end+1} = {[ 9    10    13    14    19    20] [ 3     4     7     8    17    18    21 1     2     5     6]}
models_lbls{end+1} = 'Core/Ext'

model_inds{end+1} = {[ 9    10    13    14    19    20] [ 3     4     7     8    17    18    21]}
models_lbls{end+1} = 'Core/IntCog/'

model_inds{end+1} = {[ 9    10    13    14    19    20] [ 3     4     7     8    17    18    21]}
models_lbls{end+1} = 'Core-IFG/IntCog/'

model_inds{end+1} = {[ 9    10    13    14    19    20] [ 3     4     7     8    17    18    21  11 12]}
models_lbls{end+1} = 'Core/IntCog-IFG/'

model_inds{end+1} = {[ 9    10    13    14    19    20 15 16] [ 3     4     7     8    17    18    21]}
models_lbls{end+1} = 'Core-OFC/IntCog/'

model_inds{end+1} = {[ 9    10    13    14    19    20] [ 3     4     7     8    17    18    21  15 16]}
models_lbls{end+1} = 'Core/IntCog-OFC/'


model_inds{end+1} = {[ 9    10    13    14    19    20 11 12 15 16] [ 3     4     7     8    17    18    21]}
models_lbls{end+1} = 'Core-IFG-OFC/IntCog/'

model_inds{end+1} = {[ 9    10    13    14    19    20] [ 3     4     7     8    17    18    21  11 12 15 16]}
models_lbls{end+1} = 'Core/IntCog-IFG-OFC/'

%model_inds{end+1} = {}
%models_lbls{end+1} = ''
models_lbls = models_lbls'
%% Make model
for m_ind = 1:length(model_inds)
    mat_size = size(cmat,1)%21;
    model = repmat(0,mat_size,mat_size);
    albls = {strrep(lbls,'.mat','') aBeta.t_lbls(1:10)};
    lbls = albls{find(cellfun(@length,albls) == mat_size)};
inds = model_inds{m_ind};
ttl = models_lbls{m_ind};
if ~length(unique([inds{:}])) == mat_size; warning('model does not utilize all items');end
for i = 1:length(inds)
model(inds{i},inds{i}) = 1;
end
% Show mat
add_numbers_to_mat(model,lbls);
Z = linkage(get_triu(1-model),'ward');
% model dend
[h x perm] = dendrogram(linkage(get_triu(1-model),'ward'));
%ord = perm(end:-1:1);
ord = [inds{:}];
%mm = figure(2)
%add_numbers_to_mat(model(ord,ord),lbls(ord));
%xtickangle(45)
%title({'Model' ttl },'fontsize',20)
models{m_ind} = model;
%ofn = '/Users/aidasaglinskas/Desktop/Figures/';
%saveas(mm,fullfile(ofn,[datestr(datetime) '.png']),'png');
%figure(3)
%add_numbers_to_mat(mean(cmat(ord,ord,:),3),lbls(ord))
end % ends make model
disp('done')
models_lbls;
%% Show model
m_ind = 8;
add_numbers_to_mat(models{m_ind}([model_inds{m_ind}{:}],[model_inds{m_ind}{:}]),lbls([model_inds{m_ind}{:}]))
%add_numbers_to_mat(cmat([model_inds{m_ind}{:}],[model_inds{m_ind}{:}],1),lbls([model_inds{m_ind}{:}]))
title(models_lbls{m_ind},'fontsize',20)
%title('Data: Subject 1','fontsize',20)
%% fit model
ee = [] 
collect_e = [];
w_m = 1:length(models)
for j = w_m%1:length(models) % loop through models
model = models{j}; % take one model
model(drop,:) = [];
model(:,drop) = [];
e = []; % let's call this 'model evidence' 'cause it sounds cool
%cmat is a ROIxROIxSUBJECT correlation matrix;
for i = 1:20 % loop through subs
e(i) = corr(get_triu(model)',get_triu(cmat(:,:,i))'); % upper triu of model correlated with upper triu of subjects similarity matrix;
end
collect_e(:,j) = e;
[H,P,CI,STATS] = ttest(e); % ttest model evidence across subjects;
%clc;disp(sprintf('t=%s, p=%s',num2str(round(STATS.tstat,3)),num2str(round(P,3))));
ee(end+1) = STATS.tstat; % collect t values for all models
end % loop models 

m = mean(collect_e)
sd = std(collect_e);
se = sd ./ sqrt(size(collect_e,1));

b = figure(1);
bar(m); hold on;
errorbar(m,se,'r*'); hold off;
b.CurrentAxes.XTickLabel = models_lbls(w_m);
b.CurrentAxes.XTickLabelRotation= 45;
b.CurrentAxes.FontSize = 14;
legend({'corr(model,data)' 'SE'})
title('mean model-data correlation','fontsize',20)
%% compare models 
m_pair = [6 7];
alpha = .05
[H,P,CI,STATS] = ttest(collect_e(:,m_pair(1)),collect_e(:,m_pair(2)),'alpha',alpha);clc
disp(H)
disp([models_lbls{m_pair(1)} '  -  ' models_lbls{m_pair(2)}])
disp('t')
disp(STATS.tstat)

disp('p')
disp(P)
sprintf('t(%d)=%s, p=%s',STATS.df,num2str(STATS.tstat,3),num2str(P,.2))
%% ATFP correlations with core vs extended 
clc;size(cmat);
probe = [15 16];
targ_inds = {};
%targ_inds{1} = [ 9    10    13    14    19    20      11    12 15    16  ];
targ_inds{1} = [ 9    10    13    14    19    20];
targ_inds{2} = [ 3     4     7     8    17    18    21     5     6 ];

v1 = cmat(probe,targ_inds{1},:);
v1 = squeeze(mean(mean(v1,1),2));

v2 = cmat(probe,targ_inds{2},:);
v2 = squeeze(mean(mean(v2,1),2));

[H,P,CI,STATS] = ttest(v1,v2);
disp(sprintf('t(%d)=%s, p=%s',STATS.df,num2str(STATS.tstat,3),num2str(P,.2)));