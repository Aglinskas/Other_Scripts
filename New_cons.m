%% PREP
matlabbatch = [];
matlabbatch{1}.spm.stats.con.spmmat{1} = '/Volumes/Aidas_HDD/MRI_data/S6/Analysis/SPM.mat';

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

matlabbatch{1}.spm.stats.con.consess{i+1}.tcon.name = 'All Tasks v Monuments';
matlabbatch{1}.spm.stats.con.consess{i+1}.tcon.convec = repmat([ones(1,14) -14 zeros(1,6)],1,5);
matlabbatch{1}.spm.stats.con.consess{i+1}.tcon.sessrep = 'none';
i = i + 1
clear this_c
for p = 1 : 13
    sprintf('Task %d vs Face Control & Monuments',p)
    this_c = c_vect
    this_c(p) = 2
    this_c(14) = -1
    this_c(15) = -1
  
  
matlabbatch{1}.spm.stats.con.consess{i + p}.tcon.name = sprintf('Task %d vs Face Control & Monuments',p);
matlabbatch{1}.spm.stats.con.consess{i + p}.tcon.convec = repmat([this_c zeros(1,6)],1,5);
matlabbatch{1}.spm.stats.con.consess{i + p}.tcon.sessrep = 'none';
end

clear this_c
e_vect = repmat(-1,1,15);
for l = 1:15
this_c = e_vect
this_c(l) = 14

matlabbatch{1}.spm.stats.con.consess{i + p +l}.tcon.name = sprintf('Task %d above all',l);
matlabbatch{1}.spm.stats.con.consess{i + p + l}.tcon.convec = repmat([this_c zeros(1,6)],1,5);
matlabbatch{1}.spm.stats.con.consess{i + p + l}.tcon.sessrep = 'none';
end
spm_jobman('run',matlabbatch)