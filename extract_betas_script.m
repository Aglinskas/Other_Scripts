%extract_betas_script

func_makeROIsFromCoords(coords,names,ofn,sph_radius)
roi_data = func_extract_data_from_ROIs(roi_dir,spm_dir)
aBeta = func_make_aBeta(roi_data)