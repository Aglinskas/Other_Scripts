clear all
path(path,'/Users/aidasaglinskas/Documents/spm12/')

n_sess          = 4;      % number of sessions
%n_scans         = [352 160 352 157; 153 354	153	354; 352 153 352 153; 153 340 153 340; 334 148 328 148; 170 340	170	340; 354 153 354 153; 153 340 153 340; 345 159 344 159; 159 340	159	340];
TR              = 2;      % repetition time in s
num_slices      = 33;     % number of slices
ref_slice       = 17;     % reference slice for slice timing (e.g. first slice or middle slice)
			  % IMPORTANT: The microtime-onset needs to be adjusted according to the reference slice!
			  %            The default is SPM.xBF.T0 = 8 (middle slice), but if you choose the first slice
			  %	       as reference you have to change SPM.xBF.T0 = 1. 
			  %	       The parameter can be find in the parameter-block for defining the design matrix.
 
dir_base        = '/Volumes/Aidas_HardDrive/BRIG_MACLAB_HARVEST/GLM_iMac1/'; % directory which contains all subject-specific directory
dir_analysis    = 'analysis2';   % directory where SPM.mat, beta images, con images etc. are stored for each subject
dir_functional  = 'functional'; % directory of functional data (NIfTI files)
dir_anatomical  = 'anatomical'; % directory including the T1 3D high resoluation anatomical data set
name_scans      = 'data';       % name of the NIfTI functional data-file
name_fmap	= 'fmap';       % name of the NIfTI fieldmap-file
name_ana        = 'ana';        % name of the (high resolution) anatomical NIfTI file 
sess_prfx       = 'sess';       % prefix of session directories (only needed for multi-session analyses)

delete_files	= 0;  % delete intermediate steps during pre-processing? 1=yes, 0=no
unwarp          = 0;  % unwarp during realignment? 1=yes, 0=no
fieldmap 	= 0;  % fieldmap scan available? 1=yes, 0=no
slice_timing    = 1;  % slice timing? 2=before realignment, 1=after realignment, 0=no correction
slice_order     = 1;  % slice order? 2=custom, 1=ascending, 0=descending
slice_ord       = [1:1:num_slices];	% Syntax: [first_slice:increment/decrement:last_slice]
							% Examples:
							% descending acquisition [num_slices:-1:1]
							% ascending acquisition [1:1:num_slices]
							% interleaved acquisition (ascending - even slices first): [2:2:num_slices 1:2:num_slices-1]
norm_type       = 1;  % normalization: 1=T1 segmentation, 0=EPI template
dst_reso_func   = 3;  % resolution for functional data after normalization in mm
dst_reso_ana    = 1;  % resolution for anatomical data after normalization in mm
smooth_fwhm     = 8;  % smoothing after normalization in mm
rp              = 0;  % include realignment parameters in design matrix? 1=yes, 0=no
cutoff_highpass = 100;% cutoff for high pass filter in s [Inf = no filtering]
start_analysis  = 1;  % start of analysis
    % 1 = realignment & unwarp and slicetime
    % 2 = normalization & smoothing
    % 3 = design matrix definition & parameter estimation
    % 4 = define and compute contrasts
    
% names of subjects (list all names of subject directories)
name_subj = {'S18_D2'};
%name_subj = {'s10'};


%===========================================================================
% end of user specified settings
%===========================================================================

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
%
%         !!! DO NOT EDIT BELOW !!! DO NOT EDIT BELOW !!!
%
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------


% call SPM to have the graphics windows in place
%===========================================================================
spm fmri
global defaults
defaults.stats.maxmem   = 2^30;
fs = filesep; % platform-specific file separator
k  = 1;

% set slicetime parameters
    
    if slice_timing>0
      
    slice_time = TR /num_slices;
    slice_gap  = slice_time;	    % continuous scanning
    
    % descending slice acquisition
    if slice_order == 0
         slice_ord = [num_slices:-1:1];
    end 

    % ascending slice acquisition
    if slice_order == 1
         slice_ord = [1:1:num_slices];
    end

end   


% loop through all subjects
%===========================================================================
while (k<=length(name_subj)),
    
    fprintf(1,'==================================\n');
    fprintf(1,'Starting analysis for subject %s\n',name_subj{k});
    fprintf(1,'==================================\n');

    
    
         
    % define subject-specific scan directories
    % ----------------------------------------
    if n_sess > 1 
    	for sess    = 1:n_sess,
    	    dir_scans{sess} = [dir_base fs name_subj{k} fs dir_functional fs sess_prfx num2str(sess)];
    	end
    else
    	dir_scans{1} = [dir_base fs name_subj{k} fs dir_functional];
    end
    dir_ana = [dir_base fs name_subj{k} fs dir_anatomical];
    
    
    % realign & unwarp
    %===========================================================================
    if start_analysis <= 1

    
        % Go through all sessions of the subject
    	%---------------------------------------
    	for sess = 1:n_sess,

            
            
            
    	    % Slice-timing correction 
    	    %------------------------
	    prefix = '';
    	    if slice_timing == 2
	    
	        % load NIfTI files
    		%-----------------------------
		prefix = 'a';
    		cd (dir_scans{sess})
		P = fullfile(dir_scans{sess},[name_scans '.nii']);
		V = spm_vol(P);
        
        % Slicetime correction
    		%------------------------------------
    		spm_slice_timing(V, slice_ord, ref_slice, [slice_time slice_gap]);
            
            end
              
        % load NIfTI files
   	    %-----------------------------
        cd (dir_scans{sess})
   	    P = fullfile(dir_scans{sess},[prefix name_scans '.nii']);
   	    V = spm_vol(P);
               
n_scans = length(V);
        
        
        %% shuffle check
       % shuff{sess} = ah_shuffle_check8(P);
        %n_scans=
	    
        % Realignment (coregister only)
    	    %------------------------------------
    	    FlagsC  = struct('quality',  1,...
    			     'fwhm',	 5,...
    			     'rtm',	 0,...
    			     'wrap',	 [0 0 0],...
    			     'interp',   7);
    	    spm_realign(V,FlagsC);

        
        %% show realignment and shuffle_check nicely
        %--------------------------------------------
        F = spm_figure('GetWin','Graphics');
        spm_figure('clear',F)
        ys = (1:num_slices)*0.25+4;
        
            ra = load([dir_scans{sess},'/rp_data.txt']);
            p.ra{sess} = ra;



            dra = diff(ra(:,1:3));
            [x,y] = find(abs(dra)>1);
            plot(ra-repmat(ra(1,:),n_scans,1))
            for j=1:length(x)
                plot([x(j),x(j)],[-5,20],'k--')
            end
            axis([0,n_scans,-4,max(ys)])
            title([name_subj{k},' - ',num2str(sess)])
            
            spm_print        
            pause(0.1);               
            
                  	
    	    % Reslice (unwarp and reslice)
    	    %------------------------------------
    	    if ~unwarp
    	
    	    	FlagsR  = struct('which',  2,...
    				 'mask',   1,...
    				 'mean',   1,...
    				 'wrap',   [0 0 0],...
    				 'interp', 7);
    	    	spm_reslice(V,FlagsR);		 
    	
    	    else 

		if fieldmap == 1						% fieldmap scan available?
    			fmap = fullfile(dir_scans{sess},[name_fmap '.nii']);
			
        		uw_est_flags = struct('order',     [12 12],...
    				      'sfP',	   fmap,...
    				      'M',	   V(1).mat,...
    				      'regorder',  1,...
    				      'lambda',    1e5,...
    				      'jm',	   0,...
    				      'fot',	   [4 5],...
    				      'sot',	   [],...
    				      'fwhm',	   4,...
    				      'rem',	   1,...
    				      'exp_round', 'Average',...
    				      'noi',	   5);

		else
        		uw_est_flags = struct('order',     [12 12],...
    				      'sfP',	   [],...				    
    				      'M',	   V(1).mat,...
    				      'regorder',  1,...
    				      'lambda',    1e5,...
    				      'jm',	   0,...
    				      'fot',	   [4 5],...
    				      'sot',	   [],...
    				      'fwhm',	   4,...
    				      'rem',	   1,...
    				      'exp_round', 'Average',...
    				      'noi',	   5);
        	end

    		% Estimate unwarping parameters
    		ds     = spm_uw_estimate(P,uw_est_flags);
    		pefile = fullfile(dir_scans{sess},[name_scans '_uw.mat']);
    		save(pefile,'ds');
    		    
    		% parameters for writing the unwarped images
    		uw_write_flags = struct('mask',       1,...
    					'mean',       1,...
    					'interp',     7,...
    					'wrap',       [0 0 0],...
    					'which',      1,...
    					'udc',        1);
    		
    		% Write unwarped images
    		spm_uw_apply(ds,uw_write_flags);    
    		
    	    end % unwarp
    
    	    % Slice-timing correction 
    	    %------------------------
    	    if slice_timing == 1
    		   		
    		% load NIfTI files
    		%-----------------------------
		if unwarp
    		   prefix = 'u';
		else
		   prefix = 'r';
		end 
		cd (dir_scans{sess})
		P = fullfile(dir_scans{sess},[prefix name_scans '.nii']);     	
    		V   = spm_vol(P);
     	 
    		% Slicetime correction
    		%------------------------------------
    		spm_slice_timing(V, slice_ord, ref_slice, [slice_time slice_gap]);

    	    end % slice timing

    	    % delete intermediate steps (I)
    	    %------------------------------
    	    if delete_files == 1
		if (slice_timing > 0 && unwarp == 1)
    		    if slice_timing == 2
	    		del_prefix = 'a';
		    elseif slice_timing == 1   
			if unwarp
	    		    del_prefix = 'u';
	    		else
	    		    del_prefix = 'r';
	    		end
		    end
		del = fullfile(dir_scans{sess},[del_prefix name_scans '.*']);
	        delete(del);
		end
        end
	end % loop over sessions
    
    end % if-block for realign & unwarp sectio
 
    

    % Normalization & smoothing
    %=======================================
    
    if start_analysis <= 2
    
	for sess = 1:n_sess,
            	    	
    	    % Load NIfTI files
    	    %-----------------------------
	    if unwarp
    	       prefix = 'u';
	       meanprefix = 'u';
	    else
	       prefix = 'r';
	       meanprefix = '';
	    end
	    if slice_timing==1
	       prefix = ['a' prefix];
	    end
	    if slice_timing==2
	       prefix = [prefix 'a'];
	       meanprefix = [meanprefix 'a'];
	    end	   
	    cd (dir_scans{sess})
	    mean_img = fullfile(dir_scans{sess},['mean' meanprefix name_scans '.nii']);
	    Vm = spm_vol(mean_img);
    	    P = fullfile(dir_scans{sess},[prefix name_scans '.nii']);
    	    V  = spm_vol(P);
	 
    	    % Estimate normalisation parameters
    	    %----------------------------------
	    if norm_type==0

         	    sn_estimate_flags = struct('smosrc',    8,...
    	  				       'smoref',    0,...
    					       'regtype',   'mni',...
    					       'cutoff',    25,...
    	    				       'nits',      16,...
        				       'reg',	    1);
    	    			        
	    	    matname = [spm_str_manip(Vm.fname,'sd') '_sn.mat'];
    		    VG      = fullfile(spm('Dir'),'templates',['EPI' '.nii']);
		    sn      = spm_normalise(VG,Vm,matname,'','',sn_estimate_flags);

	    else
	    
		    % Coreg peeled struc to mean func
		    %-------------------------
		    copyfile(fullfile(dir_ana,[name_ana '_peel.nii']),dir_scans{sess});	    
		    struc = fullfile(dir_scans{sess},[name_ana '_peel.nii']);
		    x  = spm_coreg(Vm, spm_vol(struc));
		    M  = inv(spm_matrix(x));
		    MM = spm_get_space(deblank(struc));
		    spm_get_space(deblank(struc), M*MM);
		    
		    % Non-peeled anatomy for segmentation
		    %-------------------------
		    copyfile(fullfile(dir_ana,[name_ana '_nopeel.nii']),dir_scans{sess});	    
                    struc = fullfile(dir_scans{sess},[name_ana '_nopeel.nii']);
		    spm_get_space(deblank(struc), M*MM);
		    
		    % 1st pass
                    % -------------------------------
                    estopts.regtype=''; 		    % turn off affine
                    out = spm_preproc(struc,estopts);
                    [sn,isn]  = spm_prep2sn(out);

                    % only write out attenuation corrected image
                    writeopts.biascor = 1;
                    writeopts.GM  = [0 0 0];
                    writeopts.WM  = [0 0 0];
                    writeopts.CSF = [0 0 0];
                    writeopts.cleanup = [0];
                    spm_preproc_write(sn,writeopts);
                    
                    [pth,nam,ext,num] = spm_fileparts(struc);
                    struc = fullfile(pth,['m' nam ext]);	    


                    % 2nd pass
                    % -------------------------------
                    estopts.regtype='mni';		    % turn on affine
                    out = spm_preproc(struc,estopts);
                    [sn,isn]  = spm_prep2sn(out);

                    % assume GM(2) means unmod
                    writeopts.biascor = 1;
                    writeopts.GM  = [0 1 1];
                    writeopts.WM  = [0 0 0];
                    writeopts.CSF = [0 0 0];
                    writeopts.cleanup = [0];
                    spm_preproc_write(sn,writeopts);

                    save(sprintf('%s_seg_sn.mat',spm_str_manip(struc,'sd')),'sn')
                    save(sprintf('%s_seg_inv_sn.mat',spm_str_manip(struc,'sd')),'isn')
		    
		    [pth,nam,ext,num] = spm_fileparts(struc);
                    struc = fullfile(pth,['m' nam ext]);
                     
	    end	    

	    
    	    % Write normalised & smoothed
    	    %-------------------------------------------------
    	    sn_write_flags = struct('preserve',     0,...
	     			    'bb',	    [-78 -112 -50 ; 78 76 85],...	% [-90 -126 -72 ; 90 90 108],...
    				    'interp',	    1,...
    				    'vox',	    [dst_reso_func dst_reso_func dst_reso_func],...
    				    'wrap',	    [0 0 0]);
				    
    	    % Generate mask and normalize
    	    %------------------------------------------------			    
    	    msk = spm_write_sn(V,sn,sn_write_flags,'mask');
    	    spm_write_sn(Vm,sn,sn_write_flags,msk);
    	    spm_write_sn(V,sn,sn_write_flags,msk);
	    if norm_type==1
   	          sn_write_flags_ana = struct('preserve',     0,...
	     			    'bb',	    [-78 -112 -50 ; 78 76 85],...	% [-90 -126 -72 ; 90 90 108],...
    				    'interp',	    1,...
    				    'vox',	    [dst_reso_ana dst_reso_ana dst_reso_ana],...
    				    'wrap',	    [0 0 0]);	          
                  spm_write_sn(struc,sn,sn_write_flags_ana);
	    end

    	    % delete intermediate steps (II)
    	    %-------------------------------
    	    if delete_files == 1
    		if unwarp
    	    	   del_prefix = 'u';
		else
	    	   del_prefix = 'r';
		end
		if slice_timing==1
	           del_prefix = ['a' del_prefix];
	        end
		if slice_timing==2
	           del_prefix = [del_prefix 'a'];
		end	   
		del = fullfile(dir_scans{sess},[del_prefix name_scans '.*']);
		delete(del);
	    end

    	    % smooth images
    	    %------------------------------------------------
	    cd (dir_scans{sess})
    	    prefix = ['w' prefix];
	    fname = fullfile(dir_scans{sess},['s' prefix name_scans '.nii']);
	    P = fullfile(dir_scans{sess},[prefix name_scans '.nii']);
    	    V  = spm_vol(P);
    	    for i=1:length(V),
    		spm_smooth(V(i),fname,smooth_fwhm); 
    	    end;
	    
    	    % delete intermediate steps (III)
    	    %--------------------------------
    	    if delete_files == 1
	        del_prefix = ['w' del_prefix];
		del = fullfile(dir_scans{sess},[del_prefix name_scans '.*']);
		delete(del);
	    end

	end % loop over sessions	    
    		
    end    % if-block for normalisation & smoothing
   
  
    
    % Switch to next subject
    %=======================================
    k   = k + 1;
   % clear SPM V Vm P tmpP;
    
    
end     % end of main loop

cd (dir_base);
