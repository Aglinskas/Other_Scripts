

%%

%w = list{1,2}
%spm_mip_ui('GetCoords')
%h=spm_mip_ui('FindMIPax')
% p tresh   .9999
wh = 12
figure(1)
spm_mip_ui('SetCoords',list{wh,2})
nm = list{wh,1}

%%

figure(1)
curr_coords = spm_mip_ui('GetCoords');
%S_cor_L_ATL_beta = beta([1 2 9 10])
figure(2)
bar(beta([1 2 9 10]))
pth = strsplit(xSPM.swd,'/');
title([nm pth(numel(pth) - 1)])
xt = get(gca, 'XTick');
set(gca, 'XTick', xt, 'XTickLabel', {'Faces(Run1)' 'Monuments(Run1)' 'Faces(Run2)' 'Monuments(Run2)'})
xlabel({['betas at ' num2str(curr_coords')]  xSPM.Vspm.private.descrip})
whr = '/Users/aidas_el_cap/Desktop/Betas/';
exts = '.jpg';
counter = numel(dir([fullfile(whr,nm) '*'])) + 1
saveas(figure(2),fullfile(whr,[nm num2str(counter) exts ]))

% %%
% 
% 
% for i = 1:18
% list{i,2} = [list{i,3} list{i,4} list{i,5}]
% end
% Loc_For_Silvia_L = [-34.5	-11.5	-35.75]
% Loc_For_Silvia_R = [33	-12.25	-36.5]
% Loc_for_Aidas_L = [-36	-6.25	-31.25]
% Loc_for_Aidas_R = [30.75	-7	-32.75]
% Loc_for_Danilo_L = [-34.5	-4.75	-30.5]
% Loc_for_Danilo_R = [33.75	-4.75	-34.25]