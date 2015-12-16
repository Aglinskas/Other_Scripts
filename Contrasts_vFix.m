matlabbatch = [];
matlabbatch{1}.spm.stats.con.spmmat{1} = '/Volumes/Aidas_HDD/MRI_data/S1/Analysis2/SPM.mat';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = '';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.convec = [];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = '';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.convec = [];
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = '';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.convec = [];
matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = '';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.convec = [];
matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = '';
matlabbatch{1}.spm.stats.con.consess{5}.tcon.convec = [];
matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = '';
matlabbatch{1}.spm.stats.con.consess{6}.tcon.convec = [];
matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = '';
matlabbatch{1}.spm.stats.con.consess{7}.tcon.convec = [];
matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = '';
matlabbatch{1}.spm.stats.con.consess{8}.tcon.convec = [];
matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = '';
matlabbatch{1}.spm.stats.con.consess{9}.tcon.convec = [];
matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{10}.tcon.name = '';
matlabbatch{1}.spm.stats.con.consess{10}.tcon.convec = [];
matlabbatch{1}.spm.stats.con.consess{10}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{11}.tcon.name = '';
matlabbatch{1}.spm.stats.con.consess{11}.tcon.convec = [];
matlabbatch{1}.spm.stats.con.consess{11}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{12}.tcon.name = '';
matlabbatch{1}.spm.stats.con.consess{12}.tcon.convec = [];
matlabbatch{1}.spm.stats.con.consess{12}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{13}.tcon.name = '';
matlabbatch{1}.spm.stats.con.consess{13}.tcon.convec = [];
matlabbatch{1}.spm.stats.con.consess{13}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{14}.tcon.name = '';
matlabbatch{1}.spm.stats.con.consess{14}.tcon.convec = [];
matlabbatch{1}.spm.stats.con.consess{14}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{15}.tcon.name = '';
matlabbatch{1}.spm.stats.con.consess{15}.tcon.convec = [];
matlabbatch{1}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
%spm_jobman('run',matlabbatch);

for i = 1:15
    matlabbatch{1}.spm.stats.con.consess{i}.tcon.convec = c(i,:);
    matlabbatch{1}.spm.stats.con.consess{i}.tcon.name = sprintf('Task %d vs Fixation', i)
end

spm_jobman('run',matlabbatch)