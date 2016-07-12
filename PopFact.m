%function PopFact(subVec,statDir)
addpath('/Users/aidas_el_cap/Desktop/Other_Scripts/')
cd /Volumes/Aidas_HDD/MRI_data/
statDir='Analysis_mask02'
subVec=[7  8  9 10 11 14 15 17 18 19 20 21 22 24 25 27 28 29 30 31]
%load template
load /Users/aidas_el_cap/Desktop/F_con.mat
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).name='subject';
% populate template
nCond=12;
startContrast=4;
for i=1:length(subVec)  % increase fields to match N
    matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(i)=...
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(1);
end
count=0;
for i =subVec
    count=count+1;
    matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(count).scans(3:end)=[]; % cut most scans from templaye
    matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(count).conds=[1:nCond];
   scanCount=0;
    for j=[1:nCond]+startContrast-1
        scanCount=scanCount+1;
        if j<10
            matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(count).scans(scanCount)=...
                {[pwd '/S' num2str(i) '/'  statDir '/con_000' int2str(j) '.nii,1']};
        else
            matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(count).scans(scanCount)=...
                {[pwd '/S' num2str(i) '/'  statDir '/con_00' int2str(j) '.nii,1']};
        end
    end
end

matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters(1)=[];
 
matlabbatch{1}.spm.stats.factorial_design.dir={['./Group31_'  statDir '/']}
save (['popFact_' statDir] ,  'matlabbatch')
spm_jobman('run', matlabbatch)