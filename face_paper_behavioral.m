clear all; close all;loadMR;
%% Collect
[RT_mat resp_mat resp_mat_tiny RT_mat_tiny] = deal([]);
for s_ind = 1:length(subvect.face);
clc;disp(s_ind);
subID = subvect.face(s_ind);
mt_fn_temp = '/Users/aidasaglinskas/Google Drive/Aidas/Data_faces/S%d/S%d_ScannerMyTrials_RBLT.mat';
mt_fn = sprintf(mt_fn_temp,subID,subID);
myTrials = load_myTrials(mt_fn);

e_inds = cellfun(@isempty,{myTrials.RT});
[myTrials(e_inds).RT] = deal(NaN);
[myTrials(e_inds).resp] = deal(NaN);
for b = 1:10;
RT_mat(s_ind,b,:) = [myTrials([myTrials.blockNum]==b).RT];
resp_mat(s_ind,b,:) = [myTrials([myTrials.blockNum]==b).resp];
end
end
%% make tiny
tiny_inds = {[1 5] [7 8] [6 10] [2 9] [3 4]};
tiny_lbls = {'episodic' 'semantic' 'nominal' 'physical' 'social'};
for i = 1:5
   RT_mat_tiny(:,i,:) = nanmean(RT_mat(:,tiny_inds{i},:),2);
   resp_mat_tiny(:,i,:) = nanmean(resp_mat(:,tiny_inds{i},:),2);
end
%%
mats = {RT_mat resp_mat RT_mat_tiny resp_mat_tiny};
mats_lbls = {'RT-mat' 'resp-mat' 'RT-mat-tiny' 'resp-mat-tiny'};
lbls = {aBeta.t_lbls(1:10) aBeta.t_lbls(1:10) tiny_lbls tiny_lbls};
%% Make Matrix SPSS
mat_ind = 2;
use_mat = mats{mat_ind};
use_mat = nanmean(use_mat,3);
%% Means and Sd
fcc = nanmean(RT_mat(:,[11 12 13]),2);
mcc = nanmean(RT_mat(:,[14 15 16]),2);
[H,P,CI,STATS] = ttest(fcc,mcc);
[mean(fcc) std(fcc)]
[nanmean(mcc) nanstd(mcc)]
%% Bar Graphs
inds = 1:10;
mat_ind = 1;

mats{mat_ind} = mats{mat_ind}
m = nanmean(mats{mat_ind}(:,inds));
sd = nanstd(mats{mat_ind}(:,inds),[],1);

figure(1);clf;

bar(m);hold on
errorbar(m,sd,'r.');hold off
xticklabels(lbls{mat_ind});xtickangle(45);
title(mats_lbls{mat_ind},'fontsize',20)

figure(2);clf
add_numbers_to_mat([m;sd])
xticklabels(lbls{mat_ind})
%%
for s = 1:20
dt(s) = corr(mats{1}(s,1:10)',mats{2}(s,1:10)');
end
dt = atanh(dt);
[H,P,CI,STATS] = ttest(dt)
t_statement(STATS,P)
addpath('/Users/aidasaglinskas/Google Drive/Aidas/Categories_Experiment/Scripts/')
%% models
%mats = {RT_mat resp_mat RT_mat_tiny resp_mat_tiny};
%mats_lbls = {'RT-mat' 'resp-mat' 'RT-mat-tiny' 'resp-mat-tiny'};
%lbls = {aBeta.t_lbls(1:10) aBeta.t_lbls(1:10) tiny_lbls tiny_lbls};
load('/Users/aidasaglincskas/Desktop/tcmats.mat')

RT_model = corr(squeeze(nanmean(RT_mat,1))');
resp_model = corr(squeeze(nanmean(resp_mat,1))');

model_fit = func_fit_RSA_model(tcmats,{RT_model resp_model});
[H,P,CI,STATS] = ttest(model_fit)
t_statement(STATS,P)


