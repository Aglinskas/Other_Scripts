%% PREP
matlabbatch = [];
matlabbatch{1}.spm.stats.con.spmmat{1} = '/Volumes/Aidas_HDD/MRI_data/S3/Analysis/SPM.mat';

%repmat([c_vect zeros(1,6)],1,5)
c_vect = repmat(0,1,15);
%repmat
%Con_name = Task 1 vs Monuments

n_cons = 14
%% LOOP

for i = 1 : n_cons
    sprintf('Task %d vs Monuments',i)
    this_c = c_vect
    this_c(i) = 1
    this_c(15) = -1
  
  
matlabbatch{1}.spm.stats.con.consess{i}.tcon.name = sprintf('Task %d vs Monuments',i);
matlabbatch{1}.spm.stats.con.consess{i}.tcon.convec = repmat([this_c zeros(1,6)],1,5);
matlabbatch{1}.spm.stats.con.consess{i}.tcon.sessrep = 'none';
end


spm_jobman('run',matlabbatch)