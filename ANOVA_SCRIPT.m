clear;loadMR;load('/Users/aidasaglinskas/Desktop/fm.mat')
addpath('/Users/aidasaglinskas/Downloads/rm_anova2/')
%%
matR = squeeze(nanstd(m.resp,1))
%matR(8,:) = []
anova_rm({matR' matR'})
%n = squeeze(sum(isnan(m.resp),1));
%add_numbers_to_mat(n)
%%
clc
r_lbls((cellfun(@length,r_inds)==1)) = []
r_inds((cellfun(@length,r_inds)==1)) = []
rst = struct;
for i = 1:length(r_inds)
% a=squeeze(mat([4],[1:5],:));
% b=squeeze(mat([5],[1:5],:));
a=squeeze(aBeta.fmat_raw([r_inds{i}(1)],[1:5],:));
b=squeeze(aBeta.fmat_raw([r_inds{i}(2)],[1:5],:));
Y=[a(:); b(:)]';
F1=[ones(1,length(a(:))) ones(1,length(b(:)))*2];
nSubs=size(b,2);
S=[];
F2=[];
for j=1:nSubs;
    S=[S ones(1,5)*j];
    F2=[F2 1:5];
end
F2=[F2 F2];
S=[S S];
%close all
%imagesc([Y; S ;F1; F2 ]')
[T] = rm_anova2(Y,S,F1,F2,{'Hemisphere', 'Task'});
%disp([r_lbls{i} ': P = ' num2str(boo{4,6},'%.4f')])
rst(i).roi = r_lbls{i};
rst(i).F = num2str(T{4,5},'%.4f');
rst(i).P = num2str(T{4,6},'%.4f');
end % ends loop