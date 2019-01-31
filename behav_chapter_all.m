addpath('/Users/aidasaglinskas/Google Drive/Aidas/Data_words/');
load('/Users/aidasaglinskas/Google Drive/Mat_files/Workspace/behavioral_mats.mat');
load('/Users/aidasaglinskas/Google Drive/Mat_files/Workspace/subMIA.mat');
matched = load('/Users/aidasaglinskas/Desktop/Work_Clutter/behavMAtched.mat');
    matched = matched.m;
matched_MIA = subMIA;
matched_MIA.mat([2 21],:) = [];
matched_MIA.flnms([2 21]) = [];
%% MIA;
func_plot_dendMat(squareform(1-mean(subMIA.mat,1)),subMIA.tlbls);
subplot(1,2,1);title('MIA');

sm = [];
for i = 1:size(subMIA.mat,1)
sm(:,:,i) =1-squareform(subMIA.mat(i,:));
end
%% Model
model = func_made_RSA_model(m.t_lbls,{{'First memory' 'Familiarity'} {'How many facts' 'Occupation'} {'Distinctiveness' 'Attractiveness'} {'Full name' 'Common name'} {'Friendliness' 'Trustworthiness'}});
%t_ord = [1 5 2 9 6 10 3 4 7 8];
%figure(2);clf;add_numbers_to_mat(model(t_ord,t_ord),m.t_lbls(t_ord),'nonum')

mat = cat(3,m.mats_resp{1},m.mats_resp{2});
%mat = cat(3,m.mats_RT{1},m.mats_RT{2});
cmats = func_make_cmat(mat);
% [min(cmats{2}(:)) max(cmats{2}(:))]

func_plot_dendMat(mean(cmats{2},3),m.t_lbls)
subplot(1,2,1);title('behav');

model_ev = func_fit_RSA_model(cmats{2},model);
[H,P,CI,STATS] = ttest(model_ev);
t_statement(STATS,P);
%%
model_ev1 = func_fit_RSA_model(sm,model);
[H,P,CI,STATS] = ttest(model_ev);


[H,P,CI,STATS] = ttest2(model_ev,model_ev1);
t_statement(STATS,P);

%% Matched Pairs

%model = func_made_RSA_model(m.t_lbls,{{'First memory' 'Familiarity'} {'How many facts' 'Occupation'} {'Distinctiveness' 'Attractiveness'} {'Full name' 'Common name'} {'Friendliness' 'Trustworthiness'}});
model = func_made_RSA_model(m.t_lbls,{{'First memory' 'Familiarity'} {'Distinctiveness' 'Attractiveness'} {'Full name' 'Common name'} {'Friendliness' 'Trustworthiness'}});
cmats_resp = func_make_cmat(matched.mats_resp{1});
cmats_RT = func_make_cmat(matched.mats_RT{1});

%func_plot_dendMat(mean(cmats_RT{2},3),matched.t_lbls);
cmats_MIA = [];
for i = 1:size(matched_MIA.mat,1)
    cmats_MIA(:,:,i) = 1-squareform(matched_MIA.mat(i,:));
end

%func_plot_dendMat(mean(mat,3),matched.t_lbls);
%%
test_mat = cmats_resp{2};
model_ev = func_fit_RSA_model(test_mat,model);
[H,P,CI,STATS] = ttest(model_ev);
t_statement(STATS,P)
%%

model_ev1 = func_fit_RSA_model(cmats_RT{2},model);
model_ev2 = func_fit_RSA_model(cmats_resp{2},model);
model_ev3 = func_fit_RSA_model(cmats_MIA,model);

mm = [model_ev1 model_ev2 model_ev3];

[H,P,CI,STATS] = ttest(mm);
t_statement(STATS,P);

f = figure(1);clf;
f.Color = [1 1 1]
h = bar(mean(mm)); hold on;
he = errorbar(mean(mm),std(mm) ./ sqrt(size(model_ev1,1)),'r.');
he.LineWidth = 3;
h.LineWidth = 3;

box off
yticks([]);
ylabel('correlaton with model','fontsize',20,'fontweight','bold')
xticklabels({'RT', 'Resp.','MIA'});
f.CurrentAxes.FontSize = 20;
f.CurrentAxes.FontWeight = 'bold';
f.CurrentAxes.XTickLabelRotation = 45
ylim(ylim - [.05 0])
title('Model evidence','fontsize',20)
%% 
clc
[H,P,CI,STATS] = ttest(mm(:,2));
t_statement(STATS,P);
%% Compare 
[H,P,CI,STATS] = ttest(mm(:,3),mm(:,1));
%[H,P,CI,STATS] = ttest(mmm(:,2),mm(:,2));
t_statement(STATS,P);
%%
mat = randn(12);
mat = corr(mat);
Y = squareform(1-mat);
Z = linkage(Y);
ord = optimalleaforder(Z,Y);
mat = mat(ord,ord);
mat = mat(end:-1:1,:)
mat(:,1) = [];
mat(1,:) = [];
%% pcolor 40x10
mat = randn(11,41);
f = figure(1);clf
pcolor(mat);
xticks([]);yticks([]); f.Color = [1 1 1]
f.CurrentAxes.LineWidth = 1
%% subMIA dendrogram
lbls = subMIA.tlbls;
Y = squareform(1-mean(cmats_MIA,3));
Z = linkage(Y,'ward');
f = figure(1);
f.Color = [1 1 1];
[h x perm] = dendrogram(Z,'labels',lbls)
t_ord = perm;
[h(1:end).LineWidth] = deal(5)
[h(1:end).Color] = deal([0 0 0])

f.CurrentAxes.XTickLabelRotation = 45;
f.CurrentAxes.FontSize = 14;
f.CurrentAxes.FontWeight = 'bold';
f.CurrentAxes.FontName = 'Arial';
ylabel('dissimilarity (a.u.)');
%%
mat = cmats_resp{2};
use_lbls = lbls;
dr = [8 7];
mat(dr,:,:) = [];
mat(:,dr,:) = [];
use_lbls(dr) = [];
func_plot_dendMat(mean(mat,3),use_lbls);
%%
mat = matched.mats_resp{1};
mat(:,dr,:) = [];
cmat = func_make_cmat(mat);
f = figure(1);clf
Y = squareform(1-nanmean(cmat{1},3));
Z = linkage(Y,'ward');
[h x perm] = dendrogram(Z,0,'labels',m.f_lbls,'orientation','down');
[h(1:end).LineWidth] = deal(2)
[h(1:end).Color] = deal([0 0 0])
ylabel('dissimilarity (a.u.)')
f.CurrentAxes.XTickLabelRotation = 75
f.CurrentAxes.FontSize = 10
f.CurrentAxes.FontWeight = 'bold';
%%
f = figure(2);
%t_ord = [ 3     4     2     9     1     7     5     8     6    10];
t_ord = [ 3     4     2     9     1     7     5       6    10];
%f_ord = perm(end:-1:1);
f_ord = perm

allm = matched.mats_resp{1};
plotmat = nanmean(allm,3);
plotmat = 5-plotmat(f_ord,t_ord);
add_numbers_to_mat(plotmat,lbls(t_ord),matched.f_lbls(f_ord),'nonum');
xtickangle(45)
f.CurrentAxes.FontSize = 10
f.CurrentAxes.FontWeight = 'bold';