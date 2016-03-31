%% Locate the file(s)
addpath(genpath('/Users/aidas_el_cap/Documents/MATLAB/altmany-export_fig_f/'));
for subID = 1:12
Override = 1;
dr = '/Users/aidas_el_cap/Desktop/BehaviouralPilot/'; % where the files are stored
%% the script should be able to take over from here
%dir_names & filenames
sub_str = num2str(subID,'%02i');
fln = ['New_Pilot_subject_test_S' sub_str ];%what the files are called
first_run = '_Results_SLF_PACE.mat';
second_run = '_Results_2run.mat';
ext = {first_run second_run};
Tasks_eng = {'Hair_Color' 'First_memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Positive_Emotions' 'Familiarity' 'How_much_write' 'Common_name' 'How_many_facts' 'Occupation' 'Distinctiveness_of_face' 'Integrity' 'Same_Face' 'Same_monument'};
lbls = {'Hair Color' 'First memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Positive Emotions' 'Familiarity' 'How much write' 'Common name' 'How many facts' 'Occupation' 'Distinctiveness of face' 'Integrity' 'Same Face' 'Same monument'};
%% self paced half
load(fullfile(dr,['S' sub_str],[fln first_run]));
%%


for i = 1:max([myTrials.blockNum]);
D_f(i).blocknum = i;
D_f(i).Task = Tasks_eng{i};
D_f(i).average = nanmean([myTrials(find([myTrials.blockNum] == i)).RT]);
D_f(i).median = nanmedian([myTrials(find([myTrials.blockNum] == i)).RT]);
D_f(i).max = nanmax([myTrials(find([myTrials.blockNum] == i)).RT]);
D_f(i).min = nanmin([myTrials(find([myTrials.blockNum] == i)).RT]);
D_f(i).std = nanstd([myTrials(find([myTrials.blockNum] == i)).RT]);
D_f(i).missed = length(find([myTrials.blockNum] == i & isempty([myTrials.response]) == 1));
D_f(i).portion = 'First Half';
end
%% second half
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%SECOND   HALF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
All_face = [];
load(fullfile(dr,['S' sub_str],[fln second_run]));
%% Descriptives
for i = 1:max([myTrials.blockNum]);
D_s(i).blocknum = i;
D_s(i).Task = Tasks_eng{i};
D_s(i).average = nanmean([myTrials(find([myTrials.blockNum] == i)).RT]);
D_s(i).median = nanmedian([myTrials(find([myTrials.blockNum] == i)).RT]);
D_s(i).max = nanmax([myTrials(find([myTrials.blockNum] == i)).RT]);
D_s(i).min = nanmin([myTrials(find([myTrials.blockNum] == i)).RT]);
D_s(i).std = nanstd([myTrials(find([myTrials.blockNum] == i)).RT]);
D_s(i).missed = length(find([myTrials.blockNum] == i & isempty([myTrials.response]) == 1));
D_s(i).portion = 'Second Half';
end
%% Combine the two into one
D_both = [D_s D_f];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FACES%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Faces
for e = 1:2 % load first then second myTrials
load(fullfile(dr,['S' sub_str],[fln ext{e}]))
fc = unique({myTrials(find(isempty([myTrials.response]) == 0 & [myTrials.task_number] ~= 15)).name});
fc = fc'; % fucking hate rows, 
%[Face_rating.face] = deal(fc{:});% adds the names to the strcut
[Face_rating([1:length({fc{:}})]).face] = deal(fc{:}); % #Magic
if e == 1
[Face_rating([1:length({fc{:}})]).portion] = deal('First Half');
elseif e == 2
[Face_rating([1:length({fc{:}})]).portion] = deal('Second Half');
end
%%
for f = 1:length(fc)
for i = 1:13
    if isempty(find(strcmp({myTrials.name},Face_rating(f).face) & [myTrials.task_number] == i)) == 1;
        Face_rating(f).(Tasks_eng{i}) = 0;
    elseif isempty(myTrials(find(strcmp({myTrials.name},Face_rating(f).face) & [myTrials.task_number] == i)).response) == 1;
        Face_rating(f).(Tasks_eng{i}) = 0;
    else
Face_rating(f).(Tasks_eng{i}) = myTrials(find(strcmp({myTrials.name},Face_rating(f).face) & [myTrials.task_number] == i)).response;
    end
end
end
af(e).s = Face_rating;
end
%%
all_f = struct;
for i = 1: length(Face_rating);
all_f(i).name = Face_rating(i).face;
end

for t = 1:13
   for f = 1:length(Face_rating);
    all_f(f).(Tasks_eng{t}) = [af(1).s(f).(Tasks_eng{t}) af(2).s(f).(Tasks_eng{t})];
   end
end
% individual face ratings;
ifr{subID} = all_f;
%% simplify ratings at the individual level, if 2 ratings are the same then present them as one
% for t = 1:13
%    for f = 1:length(Face_rating)
%     if isnan(all_f(f).(Tasks_eng{t})(1)) && isnan(all_f(f).(Tasks_eng{t})(2))
%         all_f(f).(Tasks_eng{t}) = nan
%     elseif isnan(all_f(f).(Tasks_eng{t})(1)) && length(all_f(f).(Tasks_eng{t})) == 2
%         all_f(f).(Tasks_eng{t}) = all_f(f).(Tasks_eng{t})(2)
%     elseif isnan(all_f(f).(Tasks_eng{t})(2)) && length(all_f(f).(Tasks_eng{t})) == 2
%         all_f(f).(Tasks_eng{t}) = all_f(f).(Tasks_eng{t})(1)
%     end
%     if length(all_f(f).(Tasks_eng{t})) == 2
%         if all_f(f).(Tasks_eng{t})(1) == all_f(f).(Tasks_eng{t})(2)
%             all_f(f).(Tasks_eng{t}) = all_f(f).(Tasks_eng{t})(1)
%         end
%     end 
%    end
% end
%% plotting

% pl = 0
% if pl == 1
% T = struct2table(all_f);
% writetable(T,fullfile(dr,['S' sub_str],['S' sub_str 'face_ratings.csv']));
% 
% %% SECOND LEVEL
% %Get unique 
% 
% if subID == 1 | Override == 1
% unfc = unique({myTrials(find(isempty([myTrials.response]) == 0 & [myTrials.task_number] ~= 15)).name});
% unfc = unfc';
% fc_allsubs = struct;
% [fc_allsubs([1:length({unfc{:}})]).face] = deal(unfc{:});
% %% set up struct
% %fc_allsubs = struct;
% for i = 1:13
%     fc_allsubs(2).(Tasks_eng{i}) = [];
% end
% for t = 1:13
%    for f = 1:length(fc);
%     fc_allsubs(f).(Tasks_eng{t}) = [fc_allsubs(f).(Tasks_eng{t}) fc_allsubs(f).(Tasks_eng{t})];
%    end
% end
% end
%     for f = 1:length(fc_allsubs);
%         for t = 1:13;
%     fc_allsubs(f).(Tasks_eng{t}) = [fc_allsubs(f).(Tasks_eng{t}) all_f(f).(Tasks_eng{t})];
%         end
%     end
%     fc_allsubs = [fc_allsubs fc_allsubs]
% end
% %% make a bar_chart
% for f = 1:length(fc_allsubs)
% for t = 1:13
% % dt(f,t) = nanmean(fc_allsubs(f).(Tasks_eng{t})); %data
% % et(f,t) = nanstd(fc_allsubs(f).(Tasks_eng{t})); %for errorbars
% dt(f,t) = nanmean(fc_allsubs(f).(Tasks_eng{t})(fc_allsubs(f).(Tasks_eng{t}) ~= 0)); %data
% et(f,t) = nanstd(fc_allsubs(f).(Tasks_eng{t})(fc_allsubs(f).(Tasks_eng{t}) ~= 0)); %for errorbars
% end
% end
% %% 
% for f = 1:length(fc_allsubs)
% clf
% p = axes;
% h = bar(dt(f,:))
% hold on
% tl = title(fc{f})
% tl.FontSize = 30
% %xlabel('Task')
% ylabel('Rating mean')
% legend('errorBars = StdDev')
% set(gca,'XTickLabel',{lbls{1:13}})
% set(figure(1), 'Position', [2 312 1435 493]);
% e=errorbar(dt(f,:),et(f,:),'r'); set(e,'linestyle','none')
% %eb1 = errorbar(dt(1,:),et(1,:))
% %% Print to PDF
% %export_fig('~/Desktop/Ratings.pdf','-append')
% end
% %%
% 
% 
% %% Make a redable table
% T = fc_allsubs;
% for f = 1:length(fc_allsubs);
%         for t = 1:13;
%     T(f).(Tasks_eng{t}) = num2str(T(f).(Tasks_eng{t}));
%         end
% end
% T = struct2table(T);
% %%
% writetable(T,'~/Desktop/FaceRating_Table.csv','Delimiter',',','WriteRowNames',1)
% %% 
% save('~/Desktop/FaceRating_RAW.mat','T');
% %% to print
% % end sub == 1 loop
% %struct2File( s, 'c:\file.txt', 'align', true, 'sort', false );
% %% both face ratings;
end



   




   




   




   




   




   




   








   




   




   




   




   




   








   




   




   




   




   




   








% Tasks = {'Colore dei capelli?'
% 'Memoria remota?'
% 'Quanto attraente?'
% 'Quanto amichevole?'
% 'Quanto affidabile?'
% 'Emozioni positive?'
% 'Quanto familiare?'
% 'Quanto scriveresti?'
% 'Nome comune?'
% 'Quanti fatti ricordi?'
% 'Che lavoro fa?'
% 'Volto distintivo?'
% 'Quanto integra?'
% 'Stesso Volto'
% 'Stesso Monumento'}

% %% fix button responses
% for i = 1: length(myTrials)
%     t_ans = myTrials(i).response
%     if isempty(myTrials(i).response) == 0
%         myTrials(i).response = str2num(t_ans{1}(1))
%     else 
%         myTrials(i).response = nan
%         myTrials(i).RT = nan
% end
% end

% %% fix button responses
% for i = 1: length(myTrials)
%     t_ans = myTrials(i).response
%     if isempty(myTrials(i).response) == 0
%         myTrials(i).response = str2num(t_ans{1}(1))
%     else 
%         myTrials(i).response = nan
%         myTrials(i).RT = nan
% end
% end