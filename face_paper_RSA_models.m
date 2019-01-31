addpath('/Users/aidasaglinskas/Google Drive/Aidas/Categories_Experiment/Scripts/');
addpath(genpath('/Users/aidasaglinskas/Desktop/Other_Scripts/'));
clear;close all;
%%
loadMR;
% aBeta.fmat = aBeta.wmat;
% aBeta.fmat_raw = aBeta.wmat_raw;

% drop_subs = [24 23 22]
% aBeta.fmat(:,:,drop_subs) = [];
% aBeta.fmat_raw(:,:,drop_subs) = [];

t_ord = [4     3     9     2    10     6     8     7     5     1];
r_ord = [ 8     7    21    17    18     4     3     6     5     2     1    16    15    12 11    20    19    10     9    14    13];
t_ord = t_ord(end:-1:1);
r_ord = r_ord(end:-1:1);
t_ord = [t_ord 11 12];

aBeta.fmat_raw = aBeta.fmat_raw(r_ord,t_ord,:);
aBeta.r_lbls = aBeta.r_lbls(r_ord);
aBeta.t_lbls = aBeta.t_lbls(t_ord);

aBeta.r_lbls = strrep(aBeta.r_lbls,'.mat','');
aBeta.r_lbls = strrep(aBeta.r_lbls,'-right','-R');
aBeta.r_lbls = strrep(aBeta.r_lbls,'-left','-L');
data_mat = aBeta.fmat_raw;
data_mat = data_mat - data_mat(:,11,:);
data_mat = data_mat(:,1:10,:);
aBeta.fmat = data_mat;

%r_inds = ~ismember([1:21],[1:6 11:14]);
r_inds = 1:21; 
aBeta.fmat = aBeta.fmat(r_inds,:,:);
aBeta.fmat_raw = aBeta.fmat_raw(r_inds,:,:);
aBeta.r_lbls =  aBeta.r_lbls(r_inds);

data_mat = aBeta.fmat;
% Clustering
tcmats = [];rcmats = [];
for s = 1:size(aBeta.fmat,3)
    tcmats(:,:,s) = corr(data_mat(:,:,s));
    rcmats(:,:,s) = corr(data_mat(:,:,s)');
end


%face_data.tcmats = tcmats;
%face_data.rcmats = rcmats;
%save('/Users/aidasaglinskas/Desktop/face_data_models15.mat','face_data')

tcmat = mean(tcmats,3);rcmat = mean(rcmats,3);
mats = {tcmat rcmat}
lbls = {aBeta.t_lbls(1:size(tcmat,1)) aBeta.r_lbls}
f = figure(1)
res = func_plot_dendMat(mats,lbls);
%% Pairs Model
clust_pairs = {}
clust_pairs{end+1} = {'First memory' 'Familiarity'}
clust_pairs{end+1} = {'Attractiveness' 'Distinctiveness'}
clust_pairs{end+1} = {'Friendliness' 'Trustworthiness'}
clust_pairs{end+1} = {'Common name' 'Full name'}
clust_pairs{end+1} = {'How many facts' 'Occupation'}
clust_names{1} = 'Pairs';

clust_semNom = {};
clust_semNom{end+1} = {'How many facts' 'Occupation' 'Common name' 'Full name'}
clust_semNom{end+1} = {'First memory' 'Familiarity'}
clust_semNom{end+1} = {'Attractiveness' 'Distinctiveness'}
clust_semNom{end+1} = {'Friendliness' 'Trustworthiness'}
clust_names{2} = 'Semantic-Nominal';



clust_semEP = {};
clust_semEP{end+1} = {'How many facts' 'Occupation' 'First memory' 'Familiarity'}
clust_semEP{end+1} = {'Attractiveness' 'Distinctiveness'}
clust_semEP{end+1} = {'Friendliness' 'Trustworthiness'}
clust_semEP{end+1} = {'Common name' 'Full name'}
clust_names{3} = 'Semantic-Episodic';


clusts = {clust_pairs clust_semNom clust_semEP}
models = {};
f = figure(2);
for i = 1:length(clusts)
subplot(1,length(clusts),i)
models{i} = func_made_RSA_model(lbls{1},clusts{i},1,clust_names{i})
xtickangle(45);

xticks([]);yticks([]);
end
%f.CurrentAxes.FontSize = 12;
%f.CurrentAxes.FontWeight = 'bold';
%f.CurrentAxes.Title.FontSize = 24
data = tcmats;
model_fit = func_fit_RSA_model(data,models);
%%
[H,P,CI,STATS] = ttest(model_fit);t_statement(STATS,P)
%%
[H,P,CI,STATS] = ttest(model_fit(:,2),model_fit(:,3));
clc;str = t_statement(STATS,P);
%% Regional Models
clust = {};
l = 0

% l = l+1;clust{l}= {};
% clust{l}{end+1} = {'FFA-R'    'FFA-L' 'OFA-R'    'OFA-L' 'pSTS-R'    'pSTS-L' };
% clust{l}{end+1} = {'Angular-R'    'Angular-L'    'vmPFC'    'Precuneus'    'dmPFC'    'ATL-R' 'ATL-L'    'Amygdala-R'    'Amygdala-L' }
% clust_names{l} = 'Core-Extended'


% l = l+1;clust{l}= {};
% clust{l}{end+1} = {'IFG-R'    'IFG-L' 'FFA-R'    'FFA-L' 'OFA-R'    'OFA-L' 'pSTS-R'    'pSTS-L' };
% clust{l}{end+1} = {'Angular-R'    'Angular-L'    'vmPFC'    'Precuneus'    'dmPFC'    'ATL-R' 'ATL-L'    'Amygdala-R'    'Amygdala-L'}
% clust_names{l} = 'Core-IFG-Extended'
% 
% l = l+1;clust{l}= {};
% clust{l}{end+1} = { 'FFA-R'    'FFA-L' 'OFA-R'    'OFA-L' 'pSTS-R'    'pSTS-L' };
% clust{l}{end+1} = {'IFG-R'    'IFG-L' 'Angular-R'    'Angular-L'    'vmPFC'    'Precuneus'    'dmPFC'    'ATL-R' 'ATL-L'    'Amygdala-R'    'Amygdala-L'}
% clust_names{l} = 'Core-Extended-IFG'

l = l+1;clust{l}= {};
clust{l}{end+1} = {'IFG-R'    'IFG-L' 'OFC-L' 'OFC-R' 'FFA-R'    'FFA-L' 'OFA-R'    'OFA-L' 'pSTS-R'    'pSTS-L' };
clust{l}{end+1} = { 'Angular-R'    'Angular-L'    'vmPFC'    'Precuneus'    'dmPFC'    'ATL-R' 'ATL-L'    'Amygdala-R'    'Amygdala-L'}
clust_names{l} = 'Core+FL - Extended'

l = l+1;clust{l}= {};
clust{l}{end+1} = {'FFA-R'    'FFA-L' 'OFA-R'    'OFA-L' 'pSTS-R'    'pSTS-L' };
clust{l}{end+1} = {'OFC-L' 'OFC-R' 'IFG-R'    'IFG-L' 'Angular-R'    'Angular-L'    'vmPFC'    'Precuneus'    'dmPFC'    'ATL-R' 'ATL-L'    'Amygdala-R'    'Amygdala-L'}
clust_names{l} = 'Core-Extended+FL'


l = l+1;clust{l}= {};
clust{l}{end+1} = {'OFA-L'    'OFA-R' };
clust{l}{end+1} = {'FFA-L'    'FFA-R'};
clust{l}{end+1} = {'pSTS-L'    'pSTS-R'};
clust{l}{end+1} = {'IFG-L' 'IFG-R'};
clust{l}{end+1} = {'OFC-L' 'OFC-R'};
clust{l}{end+1} = {'ATFP-L' 'ATFP-R'};
clust{l}{end+1} = {'Amygdala-L' 'Amygdala-R'};
clust{l}{end+1} = {'ATL-L' 'ATL-R'};
clust{l}{end+1} = {'Angular-L' 'Angular-R'};
clust_names{l} = 'ROI pairs'

l = l+1;clust{l}= {};
clust{l}{end+1} = {'IFG-R'    'IFG-L' 'ATFP-L' 'ATFP-R' 'FFA-R'    'FFA-L' 'OFA-R'    'OFA-L' 'pSTS-R'    'pSTS-L' };
clust{l}{end+1} = {'Angular-R'    'Angular-L'    'vmPFC'    'Precuneus'    'dmPFC'    'ATL-R' 'ATL-L'    'Amygdala-R'    'Amygdala-L' }
clust_names{l} = 'Core+ATFP / Extended'

l = l+1;clust{l}= {};
clust{l}{end+1} = {'IFG-R'    'IFG-L' 'FFA-R'    'FFA-L' 'OFA-R'    'OFA-L' 'pSTS-R'    'pSTS-L' };
clust{l}{end+1} = {'ATFP-L' 'ATFP-R' 'Angular-R'    'Angular-L'    'vmPFC'    'Precuneus'    'dmPFC'    'ATL-R' 'ATL-L'    'Amygdala-R'    'Amygdala-L' }
clust_names{l} = 'Core / Extended+ATFP'

% 
% l = l+1;clust{l}= {};
% clust{l}{end+1} = {'IFG-R'    'IFG-L' 'OFC-L' 'OFC-R' 'FFA-R'    'FFA-L' 'OFA-R'    'OFA-L' 'pSTS-R'    'pSTS-L' };
% clust{l}{end+1} = {'Angular-R'    'Angular-L'    'vmPFC'    'Precuneus'    'dmPFC'    'ATL-R' 'ATL-L'    'Amygdala-R'    'Amygdala-L' }
% clust_names{l} = 'Core+IFG+OFC/Extended'
% 
% l = l+1;clust{l}= {};
% clust{l}{end+1} = {'FFA-R'    'FFA-L' 'OFA-R'    'OFA-L' 'pSTS-R'    'pSTS-L' };
% clust{l}{end+1} = {'IFG-R'    'IFG-L' 'OFC-L' 'OFC-R' 'Angular-R'    'Angular-L'    'vmPFC'    'Precuneus'    'dmPFC'    'ATL-R' 'ATL-L'    'Amygdala-R'    'Amygdala-L' }
% clust_names{l} = 'Core/Extended+IFG+OFC'
% 
% 
% l = l+1;clust{l}= {};
% clust{l}{end+1} = {'Amygdala-R'    'Amygdala-L' 'ATFP-R' 'ATFP-L' 'IFG-R'    'IFG-L' 'OFC-L' 'OFC-R' 'FFA-R'    'FFA-L' 'OFA-R'    'OFA-L' 'pSTS-R'    'pSTS-L' };
% clust{l}{end+1} = {'Angular-R'    'Angular-L'    'vmPFC'    'Precuneus'    'dmPFC'    'ATL-R' 'ATL-L'}
% clust_names{l} = 'Core+IFG+OFC+Amy+ATFP/Extended'
% 
% l = l+1;clust{l}= {};
% clust{l}{end+1} = {'IFG-R'    'IFG-L' 'OFC-L' 'OFC-R' 'FFA-R'     'FFA-L' 'OFA-R'    'OFA-L' 'pSTS-R'    'pSTS-L'};
% clust{l}{end+1} = {'Amygdala-R'    'Amygdala-L' 'ATFP-R' 'ATFP-L' 'Angular-R'    'Angular-L'    'vmPFC'    'Precuneus'    'dmPFC'    'ATL-R' 'ATL-L'    'Amygdala-R'    'Amygdala-L' }
% clust_names{l} = 'Core+IFG+OFC/Extended+Amy+ATFP'
% 
% 
% l = l+1;clust{l}= {};
% clust{l}{end+1} = {'IFG-R'    'IFG-L' 'OFC-L' 'OFC-R' 'FFA-R'     'FFA-L' 'OFA-R'    'OFA-L' 'pSTS-R'    'pSTS-L'}
% clust{l}{end+1} = {'Amygdala-R'    'Amygdala-L' 'ATFP-R' 'ATFP-L' 'Angular-R'    'Angular-L'    'vmPFC'    'Precuneus'    'dmPFC'    'ATL-R' 'ATL-L'}
% clust_names{l} = 'Extended'
% 
% 
% l = l+1;clust{l}= {};
% clust{l}{end+1} = {'IFG-R'    'IFG-L' 'OFC-L' 'OFC-R' 'FFA-R'     'FFA-L' 'OFA-R'    'OFA-L' 'pSTS-R'    'pSTS-L'}
% clust{l}{end+1} = {'Amygdala-R'    'Amygdala-L' 'ATFP-R' 'ATFP-L'};
% clust{l}{end+1} = { 'Angular-R'    'Angular-L'    'vmPFC'    'Precuneus'    'dmPFC'    'ATL-R' 'ATL-L'   }
% clust_names{l} = 'amy+FP / Extended'


% Estimate Regional Models
f = figure(2);clf
data = rcmats;
for i = 1:length(clust)
sp = subplot(2,ceil(length(clust)/2),i);
models{i} = func_made_RSA_model(lbls{2},clust{i},1,{[num2str(i) '. '] clust_names{i}})
sp.Title.FontSize = 14;
this_model_fit = func_fit_RSA_model(data,models{i});
xtickangle(65)
[H,P,CI,STATS] = ttest(this_model_fit);
%xlabel(t_statement(STATS,P))

xticks([]);yticks([]);
end
model_fit = func_fit_RSA_model(data,models);
%%
[H,P,CI,STATS] = ttest(model_fit);



%%
% [H,P,CI,STATS] = ttest(model_fit(:,11),model_fit(:,12));
% clc;t_statement(STATS,P);
%% Bar Graph
mdata = squeeze(mean(data_mat,2));
m = mean(mdata,2);
sd = std(mdata,[],2) ./sqrt(20);

f = figure(4);
bar(m);hold on;
errorbar(m,sd,'r.','LineWidth',1);hold off
xticks(1:21);
xticklabels(aBeta.r_lbls);
xtickangle(45)
box off
f.CurrentAxes.FontSize = 12
f.Color = [1 1 1]
%%
data_mat = aBeta.fmat;
%data_mat = aBeta.fmat_raw(:,11,:) - aBeta.fmat_raw(:,12,:);
%data_mat = mean(aBeta.fmat_raw(:,1:10,:)) - aBeta.fmat_raw(:,12,:);
clust_pairs = {};
clust_pairs{end+1} = {'First memory' 'Familiarity'};
clust_pairs{end+1} = {'Attractiveness' 'Distinctiveness'};
clust_pairs{end+1} = {'Friendliness' 'Trustworthiness'};
clust_pairs{end+1} = {'Common name' 'Full name'};
clust_pairs{end+1} = {'How many facts' 'Occupation'};
clust_pairs_leg = {'Episodic' 'Physical' 'Social' 'Nominal' 'Semantic'};
data_mat_tiny = [];

for i = 1:5
data_mat_tiny(:,i,:) = mean(data_mat(:,ismember(aBeta.t_lbls(1:10),clust_pairs{i}),:),2);
end

core = {'OFA-L'    'OFA-R'    'FFA-L'    'FFA-R'    'pSTS-L'    'pSTS-R'};
extended = {'IFG-L'    'IFG-R'    'OFC-L'    'OFC-R'    'ATFP-L'    'ATFP-R'  'Amygdala-L' 'Amygdala-R'    'ATL-L'    'ATL-R'    'dmPFC'    'Precuneus'    'vmPFC' 'Angular-L'    'Angular-R'};

amy =  {'Amygdala-L' };
ATFP =  {'ATFP-R' };
psts = {'pSTS-L'    'pSTS-R'}
ang = {'Angular-L'    'Angular-R'}
rlbls = aBeta.r_lbls;
left = ~cellfun(@isempty,strfind(rlbls,'-L'));
right = ~cellfun(@isempty,strfind(rlbls,'-R'));


[H,P,CI,STATS] = ttest(squeeze(mean(data_mat_tiny(ismember(rlbls,psts),2,:),1)))
t_statement(STATS,P)

v1 = squeeze(mean(mean(data_mat(ismember(rlbls,psts),2,:),1),2));
v2 = squeeze(mean(mean(data_mat(ismember(rlbls,psts),:,:),1),2));


v1 = squeeze(mean(mean(data_mat(ismember(rlbls,core),:,:),1),2));
v2 = squeeze(mean(mean(data_mat(ismember(rlbls,extended),:,:),1),2));

v3 = squeeze(mean(mean(data_mat(ismember(rlbls,amy),:,:),1),2));
v4 = squeeze(mean(mean(data_mat(ismember(rlbls,ATFP),:,:),1),2));

v1 = squeeze(mean(mean(data_mat(left,:,:),1),2));
v2 = squeeze(mean(mean(data_mat(right,:,:),1),2));

v1 = squeeze(mean(mean(data_mat(ismember(rlbls,psts),:,:),1),2));
v2 = squeeze(mean(mean(data_mat(ismember(rlbls,ang),:,:),1),2));
%%
[H,P,CI,STATS] = ttest(v2);t_statement(STATS,P)
t_statement(STATS,P)
[H,P,CI,STATS] = ttest(v1,v2);

[H,P,CI,STATS] = ttest(squeeze(mean((data_mat),2))');
clc;t_statement(STATS,P);
%%

mat= squeeze(mean(data_mat_tiny(ismember(aBeta.r_lbls,ang),:,:),1));
clust_pairs_leg
%%
v1 = squeeze(mean(mean(data_mat(ismember(aBeta.r_lbls,'Angular-L'),:,:),1),2));
v2 = squeeze(mean(mean(data_mat(ismember(aBeta.r_lbls,'Angular-R'),:,:),1),2));
[H,P,CI,STATS] = ttest(v1,v2);t_statement(STATS,P)
%% Interaction
clc
for i = 1:5
for j = 1:5
    
v1 = squeeze(data_mat_tiny(ismember(aBeta.r_lbls,'Angular-L'),i,:));
v11 = squeeze(data_mat_tiny(ismember(aBeta.r_lbls,'Angular-L'),j,:));

v2 = squeeze(data_mat_tiny(ismember(aBeta.r_lbls,'Angular-R'),i,:));
v22 = squeeze(data_mat_tiny(ismember(aBeta.r_lbls,'Angular-R'),j,:));

[H,P,CI,STATS] = ttest(v1-v11,v2-v22);

tmat(i,j) = STATS.tstat;

if ~isnan(H)
if P<.05/10 & STATS.tstat>0;
    t_statement(STATS,P);
end
end

end
end

f = figure(2);
add_numbers_to_mat(tmat,clust_pairs_leg);
f.CurrentAxes.CLim = [1.9 2]
%%
dt = [];
for i = 1:5
v1 = squeeze(data_mat_tiny(ismember(aBeta.r_lbls,'Angular-L'),i,:));
disp(['Angular-L' '-' clust_pairs_leg{i}])
v2 = squeeze(data_mat_tiny(ismember(aBeta.r_lbls,'Angular-R'),i,:));
disp(['Angular-R' '-' clust_pairs_leg{i}])
dt = [dt v1 v2];
end

%% Grouped Bar
l_inds = ~cellfun(@isempty,strfind(aBeta.r_lbls,'-L'));
r_inds = ~cellfun(@isempty,strfind(aBeta.r_lbls,'-R'));
m_inds = ~[l_inds+r_inds];


bar_lbls = strrep(aBeta.r_lbls([find(l_inds);find(m_inds)]),'-L','');

m = squeeze(mean(mean(aBeta.fmat,2),3));
e = squeeze(std(mean(aBeta.fmat,2),[],3)) ./ sqrt(20);

mbar = zeros(3,sum(l_inds)+sum(m_inds));
ebar = mbar;
mbar(1,1:9) = m(l_inds)
    ebar(1,1:9) = e(l_inds)
mbar(2,1:9) = m(r_inds)
    ebar(2,1:9) = e(r_inds)
mbar(3,10:12) = m(m_inds)
    ebar(3,10:12) = e(m_inds)


addpath('/Users/aidasaglinskas/Downloads/pierremegevand-errorbar_groups-0e167a1/')
f = figure(1);clf
try 
errorbar_groups(mbar,ebar,'bar_width',1,'errorbar_width',.75,'FigID',1);
catch
end

f.CurrentAxes.XLim = [0-1 numel(mbar)+1]
f.Color = [1 1 1];
xt =  [1.5 4.5 7.5 10.5 13.5 16.5 19.5 22.5 25.5 30 33 36];
%f.CurrentAxes.XTick = 1:2:numel(mbar)+1;
f.CurrentAxes.XTick = xt;
f.CurrentAxes.XTickLabel = bar_lbls;
f.CurrentAxes.FontSize = 12;
f.CurrentAxes.FontWeight = 'bold';
f.CurrentAxes.FontName = 'Helvetica'
legend({'Left' 'Right' 'Medial'},'Location','bestoutside')
ylabel('task > beta')
%% Stacked.
%r_group = { {'OFA-L'    'OFA-R'} {'FFA-L'    'FFA-R' } {'pSTS-L'    'pSTS-R' } {'IFG-L' 'IFG-R'} {'OFC-L'    'OFC-R'} {'ATFP-L'    'ATFP-R'} {'Amygdala-L' 'Amygdala-R'} {'ATL-L'    'ATL-R' } {'Angular-L'    'Angular-R'} {'dmPFC'} {'Precuneus'} {'vmPFC' } };
r_group = {{'IFG-L' 'IFG-R'} {'OFC-L'    'OFC-R'} {'ATFP-L'    'ATFP-R'} {'Amygdala-L' 'Amygdala-R'} {'ATL-L'    'ATL-R' } {'Angular-L'    'Angular-R'}  {'Precuneus'} {'vmPFC' } {'dmPFC'}};
r_group_lbls = arrayfun(@(x) strrep(r_group{x}{1},'-L',''),1:length(r_group),'UniformOutput',0);
%t_group = { {'First memory' 'Familiarity'} {'How many facts'    'Occupation'} {'Common name'    'Full name' } {'Friendliness'    'Trustworthiness'  } {'Distinctiveness'    'Attractiveness' }};
%t_group_lbls = {'episodic' 'semantic' 'nominal' 'social' 'physical'};

t_group = { {'Distinctiveness'    'Attractiveness' } {'First memory' 'Familiarity'} {'How many facts'    'Occupation'} {'Common name'    'Full name' } {'Friendliness'    'Trustworthiness'  }};
t_group_lbls = {'physical' 'episodic' 'semantic' 'nominal' 'social' };

tord = [1 5 2 3 4];
t_group_lbls = t_group_lbls(tord)
t_group = t_group(tord)


data_mat = aBeta.fmat;
rlbls = aBeta.r_lbls;
tlbls = aBeta.t_lbls;


tiny_data_mat = [];
for r = 1:length(r_group)
for t = 1:length(t_group)
redmat = data_mat(ismember(rlbls,r_group{r}),ismember(tlbls,t_group{t}),:);
tiny_data_mat(r,t,:) = mean(mean(redmat,1),2);
end
end
%%
figure(2);
[H,P,CI,STATS] = ttest(permute(tiny_data_mat,[3 2 1]),0,'alpha',.05);
tmat = squeeze(STATS.tstat);
pmat = squeeze(P);

t_group_lbls = t_group_lbls(end:-1:1);
tmat = tmat(end:-1:1,:);
pmat = pmat(end:-1:1,:);
sp = subplot(1,2,1);
add_numbers_to_mat(pmat,r_group_lbls,t_group_lbls);sp.CLim = [.0049 .005];
sp = subplot(1,2,2);
add_numbers_to_mat(tmat,r_group_lbls,t_group_lbls);sp.CLim = [1.95 1.96]


a = arrayfun(@(x) num2str(x,'%.4f'),pmat,'UniformOutput',0)
%%
% Stacked
m = mean(tiny_data_mat,3);
%m(m<0) = 0.00001;
for r = 1:size(tiny_data_mat)
m(r,:) = m(r,:) ./ sum(m(r,:));
end

f = figure(1);clf
b = bar(m,'stacked');
%b(1).FaceColor = [1 0 0]

c = [ 0         0    1.0000
    1.0000         0         0
         0    1.0000         0
         0         0    0.1724
    1.0000    0.1034    0.7241];


b(find(strcmp(t_group_lbls,'physical'))).FaceColor = [238 120 28] ./ 255 * .9
b(find(strcmp(t_group_lbls,'social'))).FaceColor = [48 80 153] ./ 255
b(find(strcmp(t_group_lbls,'episodic'))).FaceColor = [207 73 143] ./ 255
b(find(strcmp(t_group_lbls,'semantic'))).FaceColor = [98 57 135] ./ 255
b(find(strcmp(t_group_lbls,'nominal'))).FaceColor = [9 133 51] ./ 255
%[b(1:end).FaceAlpha] = deal(.99)




f.CurrentAxes.FontSize = 14;
f.CurrentAxes.FontWeight = 'bold';
f.CurrentAxes.XTickLabel = r_group_lbls;
box off
legend(t_group_lbls,'Location','bestoutside');
ylabel('% total activation')
ylim([0 1])
xtickangle(45);
%f.Position = [ -1037        1224        1433         511]
f.CurrentAxes.FontSize = 11
%ofn = '/Users/aidasaglinskas/Desktop/paper_figs/stacked.pdf';
%print(ofn,'-dpdf','-bestfit')
%% Bar Graph
% Paper one
r_lbls = {'OFA-L'    'OFA-R'    'FFA-L'    'FFA-R'    'pSTS-L'    'pSTS-R'    'IFG-L' 'IFG-R'    'OFC-L'    'OFC-R'    'ATFP-L'    'ATFP-R'    'Amygdala-L' 'Amygdala-R'    'ATL-L'    'ATL-R'  'Angular-L'    'Angular-R' 'dmPFC'    'Precuneus'    'vmPFC' };
tl = strrep(r_lbls,'-L','');
tl = strrep(tl,'-R','');
tl = unique(tl,'stable');

l = ~cellfun(@isempty,strfind(r_lbls,'-L'));
r = ~cellfun(@isempty,strfind(r_lbls,'-R'));
med = ~[l+r];
r_ord = arrayfun(@(x) find(strcmp(aBeta.r_lbls,r_lbls{x})),1:length(r_lbls));

data_mat = aBeta.fmat;
data_mat = data_mat(r_ord,:,:);
data_mat = squeeze(mean(data_mat,2));


m = mean(data_mat,2);
e = std(data_mat,[],2) ./ sqrt(20);
f = figure(1);clf; hold on
inds = {l r med}

c = [1 0 0; 0 0 1;0 1 0] .* .7;
%c = [0 0 0;1 1 1;.3 .3 .3;]
for i = 1:3
plot_m = m;
plot_m(~inds{i}) = 0
    plot_e = e;
    plot_e(~inds{i}) = 0;
    
HB = bar(plot_m);
HB.FaceColor = c(i,:);
HB.FaceAlpha = .8;
HE = errorbar(plot_m,plot_e,'r.')
HE.Color = [0 0 0];
HE.LineWidth = 1;
HE.Marker = 'none';
end


xt = [1.5 3.5 5.5 7.5 9.5 11.5 13.5 15.5 17.5 19.2 20.4 21.6];
spc = 1.2
x = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 18+spc 18+2*spc 18+3*spc]
HB.XData = x;
HE.XData = x;
f.CurrentAxes.FontSize = 12;
f.CurrentAxes.FontWeight = 'bold';
f.CurrentAxes.XTick = xt;
f.CurrentAxes.XTickLabel = tl;
f.CurrentAxes.XTickLabelRotation = 45;
f.CurrentAxes.LineWidth = 1;
box off
l = legend({'left' 'none' 'right' 'SE' 'medial'},'Location','bestoutside')
l.Box = 'off';

f.CurrentAxes.LineWidth = 1.5;
f.CurrentAxes.FontSize = 10
plot(0:22,zeros(1,23),'k-','LineWidth',1.5);
ylim([-2.5 5])
%ofn = '/Users/aidasaglinskas/Desktop/paper_figs/Bar.pdf';
%print(ofn,'-dpdf','-bestfit');
%% Control Mats
data_mat_fc = aBeta.fmat_raw(:,11,:) - aBeta.fmat_raw(:,12,:);
    data_mat_fc = squeeze(data_mat_fc);
    
data_mat_cg = squeeze(mean(aBeta.fmat,2));

mats = {data_mat_fc data_mat_cg};
mats_lbls = {'FaceCC > Monuments' 'Task > FaceCC'};
for m = 1:2
    figure(1+m)
[H,P,CI,STATS] =  ttest(mats{m}');
sp = subplot(2,1,1);
add_numbers_to_mat(STATS.tstat)
title(mats_lbls{m},'fontsize',20)
sp.XTick = 1:21;
sp.XTickLabel = aBeta.r_lbls;
sp.XTickLabelRotation = 45;
sp.CLim = [1.95 1.96]

sp = subplot(2,1,2);
add_numbers_to_mat(P);
sp.XTick = 1:21;
sp.XTickLabel = aBeta.r_lbls;
sp.XTickLabelRotation = 45;
sp.CLim = [.049 .049999]
end
