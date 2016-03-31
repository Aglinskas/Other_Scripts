load('/Users/aidas_el_cap/Desktop/BehaviouralPilot/all_sim_mats.mat')
addpath(genpath('/Users/aidas_el_cap/Desktop/00_fmri_pilot_final/Food RSA Rating/'))
%% calculate
m = [];
avg_sim = [];
for c = 1:78;
for i = 6:12;
m(i,c) = all_sim_mats{i}(c);
end
avg_sim(c) = mean(m(:,c));
end
%% Show and annotate
%avg_sim(65) = 0
showSimmats(avg_sim)
a = figure(500)
a.Position = [5 189 1290 616]
annotate500
%% find min
wh = find(avg_sim == max(avg_sim))
avg_sim(wh)
%% disable min
avg_sim(wh) = 0;
%% Flash a square
%wh = 35
tst_avg_sim = avg_sim;
for i = 1:3
tst_avg_sim(wh) = 0
showSimmats(tst_avg_sim)
a = figure(500)
a.Position = [5 189 1290 616]
drawnow
tst_avg_sim(wh) = 1
showSimmats(tst_avg_sim)
drawnow
a = figure(500)
a.Position = [5 189 1290 616]
end
annotate500

%% make a list and sort it
tyt = squareSimmats(avg_sim);
pos = 0;
for r = 1:13
    for c = 1:13
       pos = pos + 1;
        lst(pos,1) = tyt(r,c);
        lst(pos,2) = r;
        lst(pos,3) = c;
        
    end
end
%% make tables
%% Make a table of top / bottom 5 values + descripts
t2 = { 'Hair Color' 'First memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Positive Emotions' 'Familiarity' 'How much write' 'Common name' 'How many facts' 'Occupation' 'Distinctiveness of face' 'Integrity' 'Same Face' 'Same monument'}';
a = num2cell(lst);
for i = 1:length(lst);
    %a{i,4}  = [a{i,2} a{i,3}]; % add question pair
    %a{i,4}  = [t2{a{i,2}} ' & ' t2{a{i,3}}]; % add q pair lbls
   a{i,4} = [t2{a{i,2}} ' & ' t2{a{i,3}} ' (' num2str(a{i,2}) ' & '  num2str(a{i,3}) ')'];
end
% for i = 1:length(a)
%  a{i,4} = sort(a{i,4});
% end
a = sortrows(a,1);
dl = [];
for i = 1:length(a)
    if a{i,2} == a{i,3};
        dl_ind = i;
        dl = [dl dl_ind];
    end
end
a(dl,:) = []; % delete the self correlations
a(1:2:length(a),:) = []; % delete the repetitions aka make a tril



nms = {'Most_Similar_Questions','Distance','Least_Similar_Questions','Distance'}
T_cors_most = table({a{1:5,4}}',{a{1:5,1}}','VariableNames',nms(1:2))
T_cors_least = table({a{length(a):-1:length(a)-4,4}}',{a{length(a):-1:length(a)-4,1}}','VariableNames',nms(3:4))

%%
bar([a{:,1}])
hold
errorbar([a{:,1}],repmat(std([a{:,1}]) / sqrt(12),1,length(a)),'r.')
plot(repmat(mean([a{:,1}]),1,length(a)),'r','LineWidth',3)
l = legend('Distance','Standard Error','Mean')
l.FontSize = 14
%l.String
hold off
%%
% %% plot
% %avg_sim = avg_sim'
% bar(avg_sim)
% hold
% errorbar(avg_sim,repmat(std(avg_sim),1,length(avg_sim)))
% plot(repmat(mean(avg_sim),1,length(avg_sim)),'r','LineWidth',3)
% 
% hold off
% for wh = 1:78
% tst_avg_sim(wh) = 0
% showSimmats(avg_sim)
% drawnow
% tst_avg_sim(wh) = 1
% showSimmats(tst_avg_sim)
% drawnow
% end


