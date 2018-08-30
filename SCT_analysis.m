function m = SCT_analysis(filename)
load(filename)

for condition = 1:2
myPitches = [500 1500];
myIndex = find(allPitches==myPitches(condition));
subSNR(:,condition) = allSNR(myIndex);
end

m = mean(subSNR(end-3:end,:));

plot(subSNR)
legend({'Pitch: 500HZ' 'Pitch: 1500HZ'})
ylabel('SNR')
xlabel('Trial')
title('Auditory Staircase')