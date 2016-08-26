matlabbatch = [];
matlabbatch{1}.spm.stats.con.spmmat{1} = '/Volumes/Aidas_HDD/MRI_data/S6/Analysis3/SPM.mat';


col = 1:2:30;
for i = 1:15
condd = zeros(1,36)

condd(col(i)) = 1;
condd(col(i) + 1) = 1;

matlabbatch{1}.spm.stats.con.consess{i}.tcon.name = sprintf('Task %d w/ Modulation',i);
matlabbatch{1}.spm.stats.con.consess{i}.tcon.weights = repmat(condd,1,5);
matlabbatch{1}.spm.stats.con.consess{i}.tcon.sessrep = 'none';
end
matlabbatch{1}.spm.stats.con.delete = 1;
spm_jobman('initcfg')
spm_jobman('run',matlabbatch)

for i = 1:15
condd = zeros(1,36)

condd(col(i)) = 1
%con(col(i) + 1) = 1

matlabbatch{1}.spm.stats.con.consess{i + 15}.tcon.name = sprintf('Task %d',i);
matlabbatch{1}.spm.stats.con.consess{i + 15}.tcon.convec = repmat(condd,1,5);
matlabbatch{1}.spm.stats.con.consess{i + 15}.tcon.sessrep = 'none';
end
matlabbatch{1}.spm.stats.con.delete = 1;
spm_jobman('initcfg')
spm_jobman('run',matlabbatch)