m = money;
%% In vs Out
red = m(t_inds,:);
bar([sum(red.in) sum(red.out)])
%% Bar
f = gcf
data = red.out;
bar(data)
f.CurrentAxes.XTick = 1:length(data);
f.CurrentAxes.XTickLabel = red.kind2_str;
f.CurrentAxes.XTickLabelRotation = 45;
f.CurrentAxes.FontWeight = 'bold'
%% Pie Chart
cat1out = arrayfun(@(x) sum(red.out(red.kind1_ID == x)),unique(red.kind1_ID))
lbls = arrayfun(@(x) unique(red.kinds1_str(red.kind1_ID == x)),unique(red.kind1_ID))
lbls = arrayfun(@(x) [lbls{x} ': ' num2str(cat1out(x)) ' EUR'],1:length(lbls),'UniformOutput',0)'
pie(cat1out,lbls)
title(['Spending since ' red.date{end}],'fontsize',20)
%% 
cats = {'PRIME' 'AMAZON' 'SUPERMERCATO' 'ITUNES' 'SPOTIFY' 'RYANAIR' 'REEBOK' 'NETFLIX' 'PAYPAL' 'WIND' 'PIZZERIA BRIONE' 'VISION DIRECT' 'RISTORANTE GIAPPONESE' 'STEAM' 'GILDA'}
    

%%
%eurospar - 'SUPERMERCATO ASPIAG SERVICE S.R.L'
%coop SUPER.TRENTINI V.TRENTO TN

% Trim
from  = datetime - calmonths(1)


unique(m.kinds1_str)
t0 = dateshift(datetime - calmonths(1),'end','month');
m = m(m.date > t0,:)