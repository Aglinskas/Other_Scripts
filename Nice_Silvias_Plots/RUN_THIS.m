clear % clear is needed because Silvia likes naming variable as built-in function like mean
load('betaAveragedLast.mat') % load Silvias mat 
% mean should be 10x12
% lbls should be 10x1
f = figure(1);clf
for i = 1:10;
sp = subplot(2,5,i);
m = mean(i,:);
s = se(i,:);
f = figure(1);
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
%fast_save_fig 
f.Color = [1 1 1]