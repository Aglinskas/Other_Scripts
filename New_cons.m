%% Parameters
%clear all;
%close all
clear all;
spm_jobman('initcfg')
fn = '/Volumes/Aidas_HDD/MRI_data/S%d/Analysis_mask02/SPM.mat';
%subs_to_run = [7 8 9 10 11 14 15 17 18 19 20 21 22];
subs_to_run = [31];
%%
tasks_eng = {'First_memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Familiarity' 'Common_name' 'How_many_facts' 'Occupation' 'Distinctiveness_of_face' 'Full name' 'Same_Face' 'Same_monument'};
%% Create vs Create & Run
run_immediately = 1; % if ==1 runs the cons, if not leaves it in the workspace
delete_previous_cons = 1;
nsess = 5;
%% Experiment specific parameters (aka assumptions)
n_tasks = 12;
fc_control_ind = 11; % face control task index;
mn_control_ind = 12; % monument control task index;
%% Cons to compute
compute.task_vs_monuments = 0; %implemented
compute.task_vs_face_control = 0;%implemented
compute.task_alone = 1;
compute.task_vs_task = 0;
% new ones below
compute.f_contrast = 1;
compute.all_vs_monuments = 1;
compute.all_vs_faceCC = 1;
%%
%structfun(@(x) eq(x,1),compute,'Uniform',1)
% 
%% Computed Parameters
batches = length(find(structfun(@(x) x==1,compute,'Uniform',1) == 1));
e_vect = repmat(0,1,n_tasks); % empty vector to start with
n_cons = n_tasks; % should be n_tasks - 1;
%% LOOP
matlabbatch = {};
for s = 1:length(subs_to_run) % Loop through subjects
    subID = subs_to_run(s)
matlabbatch{s}.spm.stats.con.spmmat = {sprintf(fn,subID)};%subject specific .mat file
matlabbatch{s}.spm.stats.con.consess = {}; % for length counter 
l = length(matlabbatch{s}.spm.stats.con.consess); %initiate length counter  as 0
%% F contrast
if compute.f_contrast == 1;
matlabbatch{s}.spm.stats.con.consess{l+1}.fcon.name = 'F_contrast_ALL';
matlabbatch{s}.spm.stats.con.consess{l+1}.fcon.weights = repmat([eye(n_tasks) zeros(n_tasks,6)],1,nsess);
matlabbatch{s}.spm.stats.con.consess{l+1}.fcon.sessrep = 'none';
l = length(matlabbatch{s}.spm.stats.con.consess); 
end
%% All tasks vs monuments
if compute.all_vs_monuments == 1;
    this_c = e_vect;
this_c(1:n_tasks) = 1;
this_c(mn_control_ind) = -(sum(this_c) - 1);
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.name = 'All vs Monuments';
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.convec = repmat([this_c zeros(1,6)],1,nsess);
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.sessrep = 'none';
l = length(matlabbatch{s}.spm.stats.con.consess); 
end
%% All tasks vs Face control
if compute.all_vs_faceCC == 1;
    this_c = e_vect;
this_c(1:10) = 1;
this_c(fc_control_ind) = -10;
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.name = 'All vs Face Control';
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.convec = repmat([this_c zeros(1,6)],1,nsess);
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.sessrep = 'none';
l = length(matlabbatch{s}.spm.stats.con.consess);
end
% %% Cog tasks vs face controld
% if compute.f_contrast == 1;
%     this_c = e_vect
% this_c(1:n_tasks) = 1
% this_c(mn_control_ind) = -(sum(this_c) - 1);
% matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.name = 'All vs Monuments';
% matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.convec = repmat([this_c zeros(1,6)],1,5);
% matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.sessrep = 'none';
% l = length(matlabbatch{s}.spm.stats.con.consess); 
% end
%% Task vs monuments cons
%i = 1;
if compute.task_vs_monuments == 1; % Task vs monuments contrasts
for i = 1 : n_cons
    sprintf('Task %d vs Monuments',i);
    this_c = e_vect;
%     this_c(i) = this_c(i)+1; 
%     this_c(mn_control_ind) = this_c(mn_control_ind)-1;
    this_c(i) = 1; 
    this_c(mn_control_ind) = -1;
    
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.name = sprintf('Task %d: %s vs Monuments',i,tasks_eng{i});
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.convec = repmat([this_c zeros(1,6)],1,nsess);
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.sessrep = 'none';
l = length(matlabbatch{s}.spm.stats.con.consess);
end
end
%% Task vs face control contrasts
if compute.task_vs_face_control == 1;
for i = 1 : n_cons
    sprintf('Task %s vs Face Control',tasks_eng{i})
    this_c = e_vect;
    this_c(i) = 1;
    this_c(fc_control_ind) = -1;
    
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.name = sprintf('Task %d:%s vs Face Control',i,tasks_eng{i});
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.convec = repmat([this_c zeros(1,6)],1,nsess);
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.sessrep = 'none';
l = length(matlabbatch{s}.spm.stats.con.consess);
end
end
%% Task alone (above noise)
if compute.task_alone == 1;
for i = 1 : n_cons
    this_c = e_vect;
    this_c(i) = 1;
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.name = sprintf('Task %d:%s',i,tasks_eng{i});
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.convec = repmat([this_c zeros(1,6)],1,nsess);
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.sessrep = 'none';
l = length(matlabbatch{s}.spm.stats.con.consess);
end
end
%% Task vs Task
if compute.task_vs_task == 1;
for i = 1 : n_cons
    for t = 1 : n_cons
    this_c = e_vect;
    this_c(i) = 1;
    this_c(t) = -1;
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.name = sprintf('%s vs %s',tasks_eng{i},tasks_eng{t});
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.convec = repmat([this_c zeros(1,6)],1,nsess);
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.sessrep = 'none';
l = length(matlabbatch{s}.spm.stats.con.consess);
    end
end 
end
%% Delete previous cons? Probably yes. 
if delete_previous_cons == 1
matlabbatch{s}.spm.stats.con.delete = 1;
else
matlabbatch{s}.spm.stats.con.delete = 0;
end
end %end subject loop
%% matlabbatch created decide whether to run it or not
if run_immediately == 1;
    %disp('Con Batch created, running initcfg')
disp('Running Cons')
spm_jobman('run',matlabbatch)
try
clear matlabbatch
catch
end
else 
    disp('Con Batch created, and left in the workspace: matlabbatch')
end