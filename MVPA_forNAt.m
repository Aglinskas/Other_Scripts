clear all
loadMR;
fn.temp = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S%d/Analysis/beta_%s.nii';
%masks.dir
bt_vec = repmat([ones(1,12) zeros(1,6)],1,5);
bt_vec = find(bt_vec);
%% Make Dataset for searchlight
this_ds = [];
all_ds = [];
task_pairs = nchoosek(1:12,2);

task_pair = task_pairs(66,:);
disp('Creating Dataset')
for t_ind = 1:2 % task index 
for s = 1:length(subvect.face)
    subID = subvect.face(s);
    run_betas = bt_vec(task_pair(t_ind):12:end);
for run_ind = 1:5 % for each run
    this_beta_ind = run_betas(run_ind);
    this_beta_str = num2str(run_ind,'%.4i');
fn.full = sprintf(fn.temp,subID,this_beta_str);
this_ds = cosmo_fmri_dataset(fn.full);
this_ds.sa.subID = subID;
this_ds.sa.task = task_pair(t_ind);
this_ds.sa.run_ind = run_ind;

    if isempty(all_ds)
      all_ds = this_ds;
    else 
        all_ds = cosmo_stack({all_ds this_ds});
    end 
end % ends subID
end % ends p
end %ends run
disp('Dataset Created')
%% Searchlight 
% prep
%ds = cosmo_remove_useless_data(all_ds); % Clean the dataset (drop nans)
%ds.samples = zscore(ds.samples,[],2) % normalize
ds.sa.targets = ds.sa.task;
ds.sa.chunks = ds.sa.run_ind;
measure = @cosmo_crossvalidation_measure;
measure_args = struct();
measure_args.classifier = @cosmo_classify_lda;
measure_args.partitions = cosmo_nfold_partitioner(ds.sa.chunks)
%% Define neighborhood
radius=3; % 3 voxels
% define a neighborhood using cosmo_spherical_neighborhood
nbrhood=cosmo_spherical_neighborhood(ds,'radius',radius);
%% Run the searchlight
% hint: use cosmo_searchlight with the measure, args and nbrhood
results = cosmo_searchlight(ds,nbrhood,measure,measure_args,'nproc',2);


