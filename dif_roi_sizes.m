roi_dir = '/Users/aidasaglinskas/Desktop/testR/'
if length(dir(roi_dir)) ~= 2; delete([roi_dir '/*']);end
spm_dirs = {'/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/Group_Analysis_subconst/'
    '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_words/Group_Analysis_subconst/'}
exp_ind = 1 ;
spm_dir = spm_dirs{exp_ind};
sph_radius = 10;
func_makeROIsFromCoords(coords,names,roi_dir,sph_radius);
    delete([roi_dir '/*_labels.mat']);
nsubs_list = [20 24];
nsubs = nsubs_list(exp_ind);
roi_data = func_extract_data_from_ROIs(roi_dir,spm_dir);
%
ttls = {'Faces Data' 'Word Data'};
tcmat = [];rcmat = [];
albls{1} = roi_data.lbls;
albls{2} = aBeta.t_lbls;
for s_ind = 1:size(roi_data.mat,3)
   tcmat(:,:,s_ind) = corr(roi_data.mat(:,:,s_ind));
   rcmat(:,:,s_ind) = corr(roi_data.mat(:,:,s_ind)');
end

for r_t = 1:2;
cmats_all = {rcmat tcmat};
subplot(1,2,r_t);
Z = linkage(get_triu(1-mean(cmats_all{r_t},3)),'ward');
[h x perm] = dendrogram(Z,'labels',albls{r_t},'orientation','left');
make_pretty_dend(h);
end
title([ttls{exp_ind} ' : ' num2str(sph_radius)],'fontsize',20)
%%
coords = [ 3    -52  29  
 30   -91  -10 
 -33  -88  -10 
 42   -46  -22 
 -39  -46  -22 
 39   17   23  
 -36  20   26  
 -60  -7   -19 
 57   -7   -19 
 -21  -10  -13 
 21   -7   -16 
 6    59   23  
 3    50   -19 
 33   35   -13 
 -33  35   -13 
 33   -10  -40 
 -36  -10  -34 
 -48  -67  35  
 42   -64  35  
 -48  -49  14  
 48   -55  14 ]
names = { 'Precuneus'
 'OFA-right'        
 'OFA-left'         
 'FFA-right'        
 'FFA-left'         
 'IFG-right'        
 'IFG-left'         
 'ATL-left'         
 'ATL-right'        
 'Amygdala-left'    
 'Amygdala-right'   
 'PFC-dorsomedial'  
 'PFC-ventromedial' 
 'OFC-right'        
 'OFC-left'         
 'ATFP-right'       
 'ATFP-left'        
 'Angular-left'     
 'Angular-right'    
 'pSTS-left'        
 'pSTS-right'}