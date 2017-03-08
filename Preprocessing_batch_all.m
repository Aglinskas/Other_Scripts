%% Set up parameters
clear all
subvect = [23];
cd ~
addpath('/Users/aidasaglinskas/Documents/MATLAB/spm12/matlabbatch/')
for subID = subvect;
%str = num2str(subID,'%02d');
str = num2str(subID);
pref = 'data.nii';
%matlabbatch{1}.spm.stats.fmri_spec.dir = {sprintf('/Volumes/Pinky/W.P.1.2_fMRI_Experiment/Data_UltraFast/sub %s/anal_UltraFast_withMotion',str)};
clear matlabbatch
also_run = 0; % create and run the batches, 1 = yes, 0 = no
slice_time = 0;
% gets structural dir/files
    s_dir = sprintf('/Users/aidasaglinskas/Google Drive/Data/S%s/Anatomical/',str); %
    s_fl = dir([s_dir 'A*.nii']);
    s_fl_nm = s_fl.name;
%% if you do STC, takes f
if slice_time
                            error('needs a fixin''')
                            fls = {};
                            for sess = 1:4
                                % sess = 4
                                mydir = sprintf('/Volumes/Pinky/W.P.1.2_fMRI_Experiment/Data_UltraFast/sub %s/sess_%d',str,sess);
                                files  = dir([mydir '/' pref '*']);
                                files_list = {files.name}';
                                cellfun(@(x) [mydir '/' x ',1'],files_list,'UniformOutput',0);
                                fls{sess} = cellfun(@(x) [mydir '/' x ',1'],files_list,'UniformOutput',0);
                            end
                            matlabbatch{1}.spm.temporal.st.scans = fls;
                            % other STC paramters, change 'em if you change the scanning protocol
                            %
                            matlabbatch{1}.spm.temporal.st.nslices = 34;
                            matlabbatch{1}.spm.temporal.st.tr = 2; % TR, 2seconds
                            matlabbatch{1}.spm.temporal.st.ta = 1.94117647058824; %Enter  the  TA  (in  seconds). It is usually calculated as TR-(TR/nslices). You can simply enter this equation with
                            matlabbatch{1}.spm.temporal.st.so = [1 18 2 19 3 20 4 21 5 22 6 23 7 24 8 25 9 26 10 27 11 28 12 29 13 30 14 31 15 32 16 33 17 34]; % slice order
                            matlabbatch{1}.spm.temporal.st.refslice = 9;
                            matlabbatch{1}.spm.temporal.st.prefix = 'a'; % prefix

                            % if slice time correction, all the dependencies;
                            matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
                            matlabbatch{2}.spm.spatial.realign.estwrite.data{2}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 2)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{2}, '.','files'));
                            matlabbatch{2}.spm.spatial.realign.estwrite.data{3}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 3)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{3}, '.','files'));
                            matlabbatch{2}.spm.spatial.realign.estwrite.data{4}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 4)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{4}, '.','files'));
                            matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
                            matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.sep = 4;
                            matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
                            matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
                            matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.interp = 2;
                            matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
                            matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.weight = '';
                            matlabbatch{2}.spm.spatial.realign.estwrite.roptions.which = [0 1];
                            matlabbatch{2}.spm.spatial.realign.estwrite.roptions.interp = 4;
                            matlabbatch{2}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
                            matlabbatch{2}.spm.spatial.realign.estwrite.roptions.mask = 1;
                            matlabbatch{2}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
                            matlabbatch{3}.spm.spatial.coreg.estimate.ref(1) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));

                        %     s_dir = sprintf('/Volumes/Pinky/W.P.1.2_fMRI_Experiment/Data_UltraFast/sub %s/struct/',str); %
                        %     s_fl = dir([s_dir 's*.nii']);
                        %     s_fl_nm = s_fl.name;

                            matlabbatch{3}.spm.spatial.coreg.estimate.source = {[s_dir s_fl_nm ',1']};
                            matlabbatch{3}.spm.spatial.coreg.estimate.other = {''}; % should be empty
                            matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
                            matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
                            matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
                            matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
                            matlabbatch{4}.spm.spatial.preproc.channel.vols(1) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
                            matlabbatch{4}.spm.spatial.preproc.channel.biasreg = 0.001;
                            matlabbatch{4}.spm.spatial.preproc.channel.biasfwhm = 60;
                            matlabbatch{4}.spm.spatial.preproc.channel.write = [0 0];
                            matlabbatch{4}.spm.spatial.preproc.tissue(1).tpm = {'/Users/aidasaglinskas/Documents/MATLAB/spm12/tpm/TPM.nii,1'};
                            matlabbatch{4}.spm.spatial.preproc.tissue(1).ngaus = 1;
                            matlabbatch{4}.spm.spatial.preproc.tissue(1).native = [1 0];
                            matlabbatch{4}.spm.spatial.preproc.tissue(1).warped = [0 0];
                            matlabbatch{4}.spm.spatial.preproc.tissue(2).tpm = {'/Users/aidasaglinskas/Documents/MATLAB/spm12/tpm/TPM.nii,2'};
                            matlabbatch{4}.spm.spatial.preproc.tissue(2).ngaus = 1;
                            matlabbatch{4}.spm.spatial.preproc.tissue(2).native = [1 0];
                            matlabbatch{4}.spm.spatial.preproc.tissue(2).warped = [0 0];
                            matlabbatch{4}.spm.spatial.preproc.tissue(3).tpm = {'/Users/aidasaglinskas/Documents/MATLAB/spm12/tpm/TPM.nii,3'};
                            matlabbatch{4}.spm.spatial.preproc.tissue(3).ngaus = 2;
                            matlabbatch{4}.spm.spatial.preproc.tissue(3).native = [1 0];
                            matlabbatch{4}.spm.spatial.preproc.tissue(3).warped = [0 0];
                            matlabbatch{4}.spm.spatial.preproc.tissue(4).tpm = {'/Users/aidasaglinskas/Documents/MATLAB/spm12/tpm/TPM.nii,4'};
                            matlabbatch{4}.spm.spatial.preproc.tissue(4).ngaus = 3;
                            matlabbatch{4}.spm.spatial.preproc.tissue(4).native = [1 0];
                            matlabbatch{4}.spm.spatial.preproc.tissue(4).warped = [0 0];
                            matlabbatch{4}.spm.spatial.preproc.tissue(5).tpm = {'/Users/aidasaglinskas/Documents/MATLAB/spm12/tpm/TPM.nii,5'};
                            matlabbatch{4}.spm.spatial.preproc.tissue(5).ngaus = 4;
                            matlabbatch{4}.spm.spatial.preproc.tissue(5).native = [1 0];
                            matlabbatch{4}.spm.spatial.preproc.tissue(5).warped = [0 0];
                            matlabbatch{4}.spm.spatial.preproc.tissue(6).tpm = {'/Users/aidasaglinskas/Documents/MATLAB/spm12/tpm/TPM.nii,6'};
                            matlabbatch{4}.spm.spatial.preproc.tissue(6).ngaus = 2;
                            matlabbatch{4}.spm.spatial.preproc.tissue(6).native = [0 0];
                            matlabbatch{4}.spm.spatial.preproc.tissue(6).warped = [0 0];
                            matlabbatch{4}.spm.spatial.preproc.warp.mrf = 1;
                            matlabbatch{4}.spm.spatial.preproc.warp.cleanup = 1;
                            matlabbatch{4}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
                            matlabbatch{4}.spm.spatial.preproc.warp.affreg = 'mni';
                            matlabbatch{4}.spm.spatial.preproc.warp.fwhm = 0;
                            matlabbatch{4}.spm.spatial.preproc.warp.samp = 3;
                            matlabbatch{4}.spm.spatial.preproc.warp.write = [0 1];
                            matlabbatch{5}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
                            matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
                            matlabbatch{5}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                78 76 85];
                            matlabbatch{5}.spm.spatial.normalise.write.woptions.vox = [1 1 1];
                            matlabbatch{5}.spm.spatial.normalise.write.woptions.interp = 4;
                            matlabbatch{5}.spm.spatial.normalise.write.woptions.prefix = 'w';
                            matlabbatch{6}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
                            matlabbatch{6}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
                            matlabbatch{6}.spm.spatial.normalise.write.subj.resample(2) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 2)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{2}, '.','files'));
                            matlabbatch{6}.spm.spatial.normalise.write.subj.resample(3) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 3)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{3}, '.','files'));
                            matlabbatch{6}.spm.spatial.normalise.write.subj.resample(4) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 4)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{4}, '.','files'));
                            matlabbatch{6}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                78 76 85];
                            matlabbatch{6}.spm.spatial.normalise.write.woptions.vox = [3 3 3];
                            matlabbatch{6}.spm.spatial.normalise.write.woptions.interp = 4;
                            matlabbatch{6}.spm.spatial.normalise.write.woptions.prefix = 'w';
                            matlabbatch{7}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
                            matlabbatch{7}.spm.spatial.smooth.fwhm = [6 6 6];
                            matlabbatch{7}.spm.spatial.smooth.dtype = 0;
                            matlabbatch{7}.spm.spatial.smooth.im = 0;
                            matlabbatch{7}.spm.spatial.smooth.prefix = 's';

                            % if you don't do STC, this code below gets executed
else
    fls = {};
    
    sub_lvl_Dir = dir(sprintf('/Users/aidasaglinskas/Google Drive/Data/S%s/Functional/Sess*',str))
    
    for sess = 1:length({sub_lvl_Dir(find([sub_lvl_Dir.isdir] == 1)).name})
        % sess = 4
        %mydir = sprintf('/Volumes/Pinky/W.P.1.2_fMRI_Experiment/Data_UltraFast/sub %s/sess_%d',str,sess);
        mydir = sprintf('/Users/aidasaglinskas/Google Drive/Data/S%s/Functional/Sess%d/',str,sess);
        files  = dir([mydir '/' pref '*']);
        files_list = {files.name}';
        
        n_scans = size(spm_vol(fullfile(mydir,files_list{1})),1);
        %cellfun(@(x) [mydir '/' x ',1'],files_list,'UniformOutput',0);
        %fls{sess} = cellfun(@(x) [mydir '/' x ',1'],files_list,'UniformOutput',0);
        fls{sess} = arrayfun(@(x) [fullfile(mydir,files_list{1}) ',' num2str(x)],[1:n_scans],'UniformOutput',0)';
        %fls{sess} = cellfun(@(x) [mydir '/' x ',1'],files_list,'UniformOutput',0);
    end
    matlabbatch{1}.spm.spatial.realign.estwrite.data = fls;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [0 1];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
    matlabbatch{2}.spm.spatial.coreg.estimate.ref(1) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
%     s_dir = sprintf('/Volumes/Pinky/W.P.1.2_fMRI_Experiment/Data_UltraFast/sub %s/struct/',str); %
%     s_fl = dir([s_dir 's*.nii']);
%     s_fl_nm = s_fl.name;
  %[s_dir s_fl_nm ',1']
  
    matlabbatch{2}.spm.spatial.coreg.estimate.source = {[s_dir s_fl_nm ',1']}; % if something crashes, it' most likely this line. Cause it worked before. 
    matlabbatch{2}.spm.spatial.coreg.estimate.other = {''};
    matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    matlabbatch{3}.spm.spatial.preproc.channel.vols(1) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
    matlabbatch{3}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{3}.spm.spatial.preproc.channel.biasfwhm = 60;
    matlabbatch{3}.spm.spatial.preproc.channel.write = [0 0];
    matlabbatch{3}.spm.spatial.preproc.tissue(1).tpm = {'/Users/aidasaglinskas/Documents/MATLAB/spm12/tpm/TPM.nii,1'};
    matlabbatch{3}.spm.spatial.preproc.tissue(1).ngaus = 1;
    matlabbatch{3}.spm.spatial.preproc.tissue(1).native = [1 0];
    matlabbatch{3}.spm.spatial.preproc.tissue(1).warped = [0 0];
    matlabbatch{3}.spm.spatial.preproc.tissue(2).tpm = {'/Users/aidasaglinskas/Documents/MATLAB/spm12/tpm/TPM.nii,2'};
    matlabbatch{3}.spm.spatial.preproc.tissue(2).ngaus = 1;
    matlabbatch{3}.spm.spatial.preproc.tissue(2).native = [1 0];
    matlabbatch{3}.spm.spatial.preproc.tissue(2).warped = [0 0];
    matlabbatch{3}.spm.spatial.preproc.tissue(3).tpm = {'/Users/aidasaglinskas/Documents/MATLAB/spm12/tpm/TPM.nii,3'};
    matlabbatch{3}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{3}.spm.spatial.preproc.tissue(3).native = [1 0];
    matlabbatch{3}.spm.spatial.preproc.tissue(3).warped = [0 0];
    matlabbatch{3}.spm.spatial.preproc.tissue(4).tpm = {'/Users/aidasaglinskas/Documents/MATLAB/spm12/tpm/TPM.nii,4'};
    matlabbatch{3}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{3}.spm.spatial.preproc.tissue(4).native = [1 0];
    matlabbatch{3}.spm.spatial.preproc.tissue(4).warped = [0 0];
    matlabbatch{3}.spm.spatial.preproc.tissue(5).tpm = {'/Users/aidasaglinskas/Documents/MATLAB/spm12/tpm/TPM.nii,5'};
    matlabbatch{3}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{3}.spm.spatial.preproc.tissue(5).native = [1 0];
    matlabbatch{3}.spm.spatial.preproc.tissue(5).warped = [0 0];
    matlabbatch{3}.spm.spatial.preproc.tissue(6).tpm = {'/Users/aidasaglinskas/Documents/MATLAB/spm12/tpm/TPM.nii,6'};
    matlabbatch{3}.spm.spatial.preproc.tissue(6).ngaus = 2;
    matlabbatch{3}.spm.spatial.preproc.tissue(6).native = [0 0];
    matlabbatch{3}.spm.spatial.preproc.tissue(6).warped = [0 0];
    matlabbatch{3}.spm.spatial.preproc.warp.mrf = 1;
    matlabbatch{3}.spm.spatial.preproc.warp.cleanup = 1;
    matlabbatch{3}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{3}.spm.spatial.preproc.warp.affreg = 'mni';
    matlabbatch{3}.spm.spatial.preproc.warp.fwhm = 0;
    matlabbatch{3}.spm.spatial.preproc.warp.samp = 3;
    matlabbatch{3}.spm.spatial.preproc.warp.write = [0 1];
    matlabbatch{4}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
    matlabbatch{4}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
    matlabbatch{4}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
        78 76 85];
    matlabbatch{4}.spm.spatial.normalise.write.woptions.vox = [1 1 1];
    matlabbatch{4}.spm.spatial.normalise.write.woptions.interp = 4;
    matlabbatch{4}.spm.spatial.normalise.write.woptions.prefix = 'w';
    matlabbatch{5}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
    % matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
    % matlabbatch{5}.spm.spatial.normalise.write.subj.resample(2) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 2)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{2}, '.','files'));
    % matlabbatch{5}.spm.spatial.normalise.write.subj.resample(3) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 3)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{3}, '.','files'));
    % matlabbatch{5}.spm.spatial.normalise.write.subj.resample(4) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 4)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{4}, '.','files'));
    matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Realign: Estimate & Reslice: Realigned Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','cfiles'));
    matlabbatch{5}.spm.spatial.normalise.write.subj.resample(2) = cfg_dep('Realign: Estimate & Reslice: Realigned Images (Sess 2)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{2}, '.','cfiles'));
    matlabbatch{5}.spm.spatial.normalise.write.subj.resample(3) = cfg_dep('Realign: Estimate & Reslice: Realigned Images (Sess 3)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{3}, '.','cfiles'));
    matlabbatch{5}.spm.spatial.normalise.write.subj.resample(4) = cfg_dep('Realign: Estimate & Reslice: Realigned Images (Sess 4)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{4}, '.','cfiles'));
    matlabbatch{5}.spm.spatial.normalise.write.subj.resample(5) = cfg_dep('Realign: Estimate & Reslice: Realigned Images (Sess 5)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{5}, '.','cfiles'));
    matlabbatch{5}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
        78 76 85];
    matlabbatch{5}.spm.spatial.normalise.write.woptions.vox = [3 3 3];
    matlabbatch{5}.spm.spatial.normalise.write.woptions.interp = 4;
    matlabbatch{5}.spm.spatial.normalise.write.woptions.prefix = 'w';
    matlabbatch{6}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files')); % or this line tbh
    matlabbatch{6}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{6}.spm.spatial.smooth.dtype = 0;
    matlabbatch{6}.spm.spatial.smooth.im = 0;
    matlabbatch{6}.spm.spatial.smooth.prefix = 's';
end
%%
if also_run
    spm_jobman('initcfg')
    spm_jobman('run',matlabbatch)
end
end % ends the master for loop of subs
% load handel
% sound(y,Fs)
