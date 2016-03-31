%% Parameters
clear all;
close all
%clear cases
%clear clases
fn = '/Volumes/Aidas_HDD/MRI_data/29th_march/S%d/Analysis/SPM.mat';
subs_to_run = [7 8];
%% Create vs Create & Run
run_immediately = 0; % if ==1 runs the cons, if not leaves it in the workspace
delete_previous_cons = 1;
%% Experiment specific parameters (aka assumptions)
n_tasks = 12;
fc_control_ind = 11; % face control task index;
mn_control_ind = 12; % monument control task index;
%% Cons to compute
compute.task_vs_monuments = 1;
compute.task_vs_face_control = 0;
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
%% Task vs monuments cons
%i = 1;
if compute.task_vs_monuments == 1; % Task vs monuments contrasts
for i = 1 : n_cons
    sprintf('Task %d vs Monuments',i);
    this_c = e_vect;
    this_c(i) = 1;
    this_c(mn_control_ind) = -1;
    
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.name = sprintf('Task %d vs Monuments',i);
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.convec = repmat([this_c zeros(1,6)],1,5);
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.sessrep = 'none';
l = length(matlabbatch{s}.spm.stats.con.consess);
end
end
%% Task vs face control contrasts
if compute.task_vs_face_control == 1;
for i = 1 : n_cons
    sprintf('Task %d vs Face Control',i);
    this_c = e_vect;
    this_c(i) = 1;
    this_c(fc_control_ind) = -1;
    
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.name = sprintf('Task %d vs Monuments',i);
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.convec = repmat([this_c zeros(1,6)],1,5);
matlabbatch{s}.spm.stats.con.consess{l+1}.tcon.sessrep = 'none';
l = length(matlabbatch{s}.spm.stats.con.consess);
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
    disp('Con Batch created, running initcfg')
spm_jobman('initcfg')
disp('Running Cons')
spm_jobman('run',matlabbatch)
else 
    disp('Con Batch created, and left in the workspace: matlabbatch')
end