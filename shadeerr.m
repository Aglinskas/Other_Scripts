clear all
load('/Users/aidasaglinskas/Downloads/betaAveragedLast.mat')
addpath('/Users/aidasaglinskas/Downloads/raacampbell-shadedErrorBar-e0b2e47/')
%
dr = [3 5]
lbs(dr) = [];
mean(dr,:) = [];
se(dr,:) = [];
wh = [1 2 3 6 7 8 9 10];
f = figure(1);clf
for i = 1:8;
sp = subplot(2,5,wh(i));
m = mean(i,:);
s = se(i,:);
f = figure(1);
%shadedErrorBar([],m,s);
shadedErrorBar([],m,s,'lineprops','-k');
hold on
shadedErrorBar([],m,s,'lineprops','ok');
title(lbs{i},'Fontsize',20);
sp.XLim = [1 12];
sp.XTick = [1:12];
xl = repmat({''},1,12);
xl{1} = '100';
xl{6} = '600';
xl{12} = '1200';
sp.XTickLabel = xl;
sp.XLabel.String = 'ISI (msec)'
box on;
end
%%
f.Color = [1 1 1]
fast_save_fig