fn_temp = '/Users/aidasaglinskas/Desktop/Raw_Data/Words_expData/S%d/Functional/Sess%d/rp_data.txt';
l = 0;
nsubs = 7;
nsess = 5;
f = figure(2);
for subID = 1:nsubs
for sess = 1:nsess;
    l = l+1;
load(sprintf(fn_temp,subID,sess))
sp = subplot(7,5,l)
plot(rp_data(:,1:3))
ylim([-2 4])
sp.YLabel.String = ['Sub: ' num2str(subID)]
sp.XLabel.String = ['Sess ' num2str(sess)]
sp.FontWeight = 'bold'
end
end
