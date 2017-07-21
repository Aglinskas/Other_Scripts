fn_temp = '/Users/aidasaglinskas/Google Drive/Data_words/S%d/Functional/Sess%d/rp_data.txt';
l = 0;
subs = 8:10;
nsess = 5;
clf
f = figure(2);
for subID = subs
for sess = 1:nsess;
    l = l+1;
load(sprintf(fn_temp,subID,sess))
sp = subplot(length(subs),5,l)
plot(rp_data(:,1:3))
ylim([-2 4])
sp.YLabel.String = ['Sub: ' num2str(subID)]
sp.XLabel.String = ['Sess ' num2str(sess)]
sp.FontWeight = 'bold'
end
end
