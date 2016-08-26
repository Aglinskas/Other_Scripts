%% Similarity matrices
addpath(genpath('/Users/aidas_el_cap/Desktop/00_fmri_pilot_final/Food RSA Rating/'))
addpath(genpath('/Users/aidas_el_cap/Documents/MATLAB/altmany-export_fig_f/'))
%% grab all files
for subID = 1:12
sub_str = num2str(subID,'%02i');
dr_p = ['/Users/aidas_el_cap/Desktop/BehaviouralPilot/' 'S' sub_str];
dir(dr_p)
lf = {'EF_session1_2016-3-15_14h33m.mat'
'ep_session1_2016-3-16_9h37m.mat'
'sg_session1_2016-3-16_10h37m.mat'
'GL_session1_2016-3-16_11h30m.mat'
'vv_session1_2016-3-16_14h26m.mat'
'pz_session1_2016-3-16_15h54m.mat'
'LL_session1_2016-3-17_12h8m.mat'
'nm_session1_2016-3-17_14h31m.mat'
'CB_session1_2016-3-17_15h33m.mat'
'GM_session1_2016-3-18_9h39m.mat'
'ff_session1_2016-3-18_11h41m.mat'
'rc_session1_2016-3-18_12h31m.mat'}
%% load the file
load(fullfile(dr_p,lf{subID}))
%all_sim_mats{subID} = estimate_dissimMat_ltv;
%% print matrices
showSimmats(estimate_dissimMat_ltv);
%addHeadingAndPrint('multiple-trial RDM','figures');
addHeadingAndPrint(['Subject ' sub_str],'figures');
a = figure(500)
a.Position = [5 189 1290 616]
title('Test')
annotate500

% dd = ['/Users/aidas_el_cap/Desktop/SimMats/' sub_str '.png']
% saveas(a,dd,'png')simila
export_fig('~/Desktop/Similarity_Ratings.pdf','-append')
% annotation(figure1,'textbox',...
%     [0.13125 0.877049180327869 0.33125 0.0530983606557377],...
%     'String','1     2    3    4   5    6    7    8   9   10  11  12  13',...
%     'FontSize',20,...
%     'FitBoxToText','off');
%%
end
