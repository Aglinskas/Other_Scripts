loadMR;
m_inds = ismember([all_trials.blockNum],[14 15 16]);
f_inds = ismember([all_trials.blockNum],[11 12 13]);
[all_trials(m_inds).blockNum] = deal(12)
[all_trials(f_inds).blockNum] = deal(11)
%
RTs = [];
for s_ind = 1:20
    subID = subvect(s_ind);
    disp(s_ind)
    for b_ind = 1:12
    temp = [all_trials([all_trials.subID] == subID & [all_trials.blockNum] == b_ind).RT];
    RTs(s_ind,b_ind) = nanmean(temp);
    end
end
figure(1)
add_numbers_to_mat(RTs)
%RTs = RTs - RTs(:,11)
%RTs = RTs(:,1:10);
%%
ord = [6    10     2     9     3     4     5     1     7     8];


for i = 1:5
wh = 1:2:10;
st = ord([wh(i) wh(i)+1]);

rRTs(:,i) = mean(RTs(:,st),2);
end
add_numbers_to_mat(rRTs)
%%

addpath('/Users/aidasaglinskas/Downloads/anova_rm/');
size(RTs)
anova_rm(rRTs)

%%
size(RTs)
mRT = mean(RTs,2) 
std(mRT)
[H,P,CI,STATS] = ttest(RTs(:,11),RTs(:,12))


%% Ratings

%fam task = 5
m_resp = [];
for s_ind = 1:20
    subID = subvect(s_ind);
   % disp(subID)
resp = [all_trials([all_trials.subID] == subID & [all_trials.blockNum] == 7).resp];
m_resp(s_ind) = nanmean(resp);
end

t_resp = 5 - m_resp';

mean(t_resp)
std(t_resp)
%% recog 
clear;
loadMR
clc
temp = '/Users/aidasaglinskas/Google Drive/MRI_data/S%d/S%d_recog.mat';


l = 0;
for s_ind = 3:20
    subID = subvect(s_ind);
    
    fn = sprintf(temp,subID,subID);
   if  exist(fn) > 0
   l = l+1;
   load(fn)
   r = [recog.response];
   rec(l) = sum(r == 1) / length(r) * 100;
   end
   %disp(sprintf('sub: %d, exist %d',subID,exist(fn)) )
end


mean(rec)
std(rec)



