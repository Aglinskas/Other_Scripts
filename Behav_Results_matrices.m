%% Get all the myTrials (for the last time now.. I swear)
load('/Users/aidas_el_cap/Desktop/BehaviouralPilot/all_mt.mat')
load('/Users/aidas_el_cap/Desktop/BehaviouralPilot/Face_rating_all_subs.mat')
load('/Users/aidas_el_cap/Desktop/BehaviouralPilot/individual_face_ratings.mat')
Tasks_eng = {'Hair_Color' 'First_memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Positive_Emotions' 'Familiarity' 'How_much_write' 'Common_name' 'How_many_facts' 'Occupation' 'Distinctiveness_of_face' 'Integrity' 'Same_Face' 'Same_monument'};
%% sub 6:12
for f = 1:10
    for t = 1:13
       fc_allsubs(f).(Tasks_eng{t}) = fc_allsubs(f).(Tasks_eng{t})(13:24);
    end
end
%% Get all rating in a matrix
%% Correlation matrix
for r = 1:13
    for c = 1:13
cf = corrcoef([fc_allsubs([1:10]).(Tasks_eng{r})],[fc_allsubs([1:10]).(Tasks_eng{c})]);
cm(r,c) = cf(2,1);
    end
end
%% Flatten into a vector
%tyt = tril(cm)
tyt = 1 - abs(cm);
pos = 0;
for r = 1:13
    for c = 1:13
       pos = pos + 1;
        lst_cm(pos,1) = tyt(r,c);
        lst_cm(pos,2) = r;
        lst_cm(pos,3) = c;
        
    end
end
%% Fix the vector
t2 = { 'Hair Color' 'First memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Positive Emotions' 'Familiarity' 'How much write' 'Common name' 'How many facts' 'Occupation' 'Distinctiveness of face' 'Integrity' 'Same Face' 'Same monument'}';
a = num2cell(lst_cm);

for i = 1:length(lst_cm)
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

%% Make a table of top / bottom 5 values + descripts
nms = {'Most_Similar_Questions','One_Minus_Correlation','Least_Similar_Questions','One_Minus_Correlation'}
T_cors_most = table({a{1:5,4}}',{a{1:5,1}}','VariableNames',nms(1:2))
T_cors_least = table({a{length(a):-1:length(a)-4,4}}',{a{length(a):-1:length(a)-4,1}}','VariableNames',nms(3:4))
%%
%%
%xlwrite(T_cors_most,'/Users/aidas_el_cap/Desktop/BehaviouralPilot/T_cors_most.csv','Delimiter','tab')
%disp('done')
%%
%T_cors_most;T_cors_least}
%% plot
%avg_sim = avg_sim'
% bar(lst_cm)
% hol}
% errorbar(lst_cm,repmat(std(lst_cm),1,length(lst_cm)))
% plot(repmat(mean(lst_cm),1,length(lst_cm)),'r','LineWidth',3)
% hold off
%%
bar([a{:,1}])
hold
errorbar([a{:,1}],repmat(std([a{:,1}]) / sqrt(6),1,length(a)),'r.')
plot(repmat(mean([a{:,1}]),1,length(a)),'r','LineWidth',3)
l = legend('1-Correlation','Standard Error','Mean')
l.FontSize = 14
%l.String
hold off
%%
disp('done')        
        
