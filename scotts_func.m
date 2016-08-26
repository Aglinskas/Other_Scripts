squeeze(mean(all_roicormats(subvect,:,:)))...
    ./(squeeze(std(all_roicormats(subvect,:,:))./size(all_roicormats,1)^.5))


%%
% pairs(unique([find(pairs(:,1) ~= 11 & pairs(:,1) ~= 12);find(pairs(:,2) ~= 11 & pairs(:,2) ~= 12)]),:)
% %%
% 
% which_ind_temp = ismember(pairs,[11 12]);
% which_ind = sum(which_ind_temp,2);
% new_pairs = pairs(find(which_ind == 0),:)
% %pairs(pairs(find(abs(1-ismember(pairs(:,2),[11 12])))),:)
