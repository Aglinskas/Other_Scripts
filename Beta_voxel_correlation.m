x=reshape(y,12,20,[]);
for ii=1:20
    keep(ii,:,:)=(corr(zscore(squeeze(x(1:10,ii,:)))'));
end
sbp = figure(8)
subplot(1,2,1)
add_numbers_to_mat((triu(squeeze(mean(keep)),1)),{tasks{1:10}})
colorbar

ave=squeeze(mean(x,2));
plot(ave(1,:),ave(2,:),'x')
imagesc((triu(squeeze(mean(keep)),1)))
plot(ave(1,:),ave(2,:),'x')
%% Masks and betas
loadMR
r_ind = 1
% Gets ROI



betas.all = [1:95]


%y = getdata(all_rois{r_ind},subBetas{b_ind});
%%
subDir_temp = '/Users/aidasaglinskas/Google Drive/Data/S%d/Analysis/'
subID = 7
subDir = sprintf(subDir_temp,subID); % inserts subID to template
all_betas = 1:90; %all betas
betas_ind = (find(repmat([ones(1,12) zeros(1,6)],1,5) == 1)); % without 
beta_temp = 'beta_00%s.nii'
subBetas = arrayfun(@(x) sprintf([subDir beta_temp],num2str(x,'%0.2u')),betas_ind,'UniformOutput',0)'

%extracted_betas = nan(length(subvect),length(all_rois),size(subBetas,1));
for r_ind = 1:length(masks.files_mat);
    clear roi
    load(fullfile(masks.dirfn,masks.files_mat{r_ind}))
for s_ind = 1:length(subvect);
    disp(sprintf('Running Roi %d/%d, subject %d/%d',r_ind,length(masks.files_mat),s_ind,length(subvect)))
    subID = subvect(s_ind);
    subDir = sprintf(subDir_temp,subID);
    subBetas = arrayfun(@(x) sprintf([subDir beta_temp],num2str(x,'%0.2u')),betas_ind,'UniformOutput',0)';
for b_ind = 1:12;
    wh_betas = b_ind:18:90;
    wh_betas_fn = arrayfun(@(x) sprintf([subDir beta_temp],num2str(x,'%0.2u')),wh_betas,'UniformOutput',0)';
y = [];
    for run = 1:5
y(run,:) = getdata(roi,wh_betas_fn{run});
    end
voxel_betas.run_averaged{r_ind,s_ind,b_ind} = mean(y,1);
%extracted_betas(s_ind,r_ind,b_ind) = mean(y);
%ROI_size(s_ind,r_ind,b_ind) = length(y);
end
end
end

% Mean across runs
% for t_ind = 1:12
%     subBetaArray(r_ind,t_ind,s_ind) = mean(extracted_betas(s_ind,r_ind,[t_ind:12:60]));
% end
% end
% end



