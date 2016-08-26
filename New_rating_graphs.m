load('/Users/aidas_el_cap/Desktop/BehaviouralPilot/all_mt.mat');
load('/Users/aidas_el_cap/Desktop/BehaviouralPilot/Face_rating_all_subs.mat');
Tasks_eng = {'Hair_Color' 'First_memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Positive_Emotions' 'Familiarity' 'How_much_write' 'Common_name' 'How_many_facts' 'Occupation' 'Distinctiveness_of_face' 'Integrity' 'Same_Face' 'Same_monument'};
lbls = {'Hair Color' 'First memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Positive Emotions' 'Familiarity' 'How much write' 'Common name' 'How many facts' 'Occupation' 'Distinctiveness of face' 'Integrity' 'Same Face' 'Same monument'};
addpath(genpath('/Users/aidas_el_cap/Documents/MATLAB/altmany-export_fig_f/'));
%%
% rt = fc_allsubs;
% ts = Tasks_eng;
%%
 %%
 opd = '/Users/aidas_el_cap/Desktop/BehaviouralPilot/';
 %%
 n_faces = length(fc_allsubs);
fc_allsubs(n_faces+1).face = 'Overall'
 for i = 1:13
fc_allsubs(n_faces + 1).(Tasks_eng{i}) = [fc_allsubs.(Tasks_eng{i})]
 end
%%
for f = 1:length(fc_allsubs)
for t = 1:13
% dt(f,t) = nanmean(fc_allsubs(f).(Tasks_eng{t})); %data
% et(f,t) = nanstd(fc_allsubs(f).(Tasks_eng{t})); %for errorbars
fc_allsubs(f).(Tasks_eng{t}) = 4.1 - fc_allsubs(f).(Tasks_eng{t}); % Invert
dt(f,t) = nanmean(fc_allsubs(f).(Tasks_eng{t})(fc_allsubs(f).(Tasks_eng{t}) ~= 0)); %data
et(f,t) = nanstd(fc_allsubs(f).(Tasks_eng{t})(fc_allsubs(f).(Tasks_eng{t}) ~= 0)) / sqrt(12); %for errorbars
et1(f,t) = nanstd(fc_allsubs(f).(Tasks_eng{t})(fc_allsubs(f).(Tasks_eng{t}) ~= 0)) / sqrt(12);
med(f,t) = nanmedian(fc_allsubs(f).(Tasks_eng{t})(fc_allsubs(f).(Tasks_eng{t}) ~= 0));
end
end
%
for f = 1:length(fc_allsubs)
clf
p = axes;
h = bar(dt(f,:))
hold on
tl = title(fc_allsubs(f).face)
tl.FontSize = 30
%xlabel('Task')
ylabel('Rating mean')
legend('Mean','Standard Error','Median')
set(gca,'XTickLabel',{lbls{1:13}})
set(figure(1), 'Position', [2 312 1435 493]);
e=errorbar([1:13],dt(f,:),et(f,:),et1(f,:),'r'); set(e,'linestyle','none')
plot([1:13],med(f,:),'r*')
%%
tx = {'4. Moltissimo'
'3. Molto'
'2. Poco'
'1. Pochissimo'}
mTextBox = uicontrol('style','text')
set(mTextBox,'String',tx)
mTextBox.Position = [100 100 100 100] - 10
mTextBox.HorizontalAlignment = 'left'
mTextBox.FontSize = 12
legend('Mean','Standard Error','Median')
%mTextBoxPosition = get(mTextBox,'Position')
%text(50,-50,tx,'HorizontalAlignment','right');
%eb1 = errorbar(dt(1,:),et(1,:))
%% Print to PDF
%export_fig('~/Desktop/Ratings_inverted.pdf','-append')
%% export png 
export_fig(['~/Desktop/Ratings_inverted' num2str(f) '.png'])
end
%%