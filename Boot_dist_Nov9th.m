clear all
loadMR
w_t = [1:10];
for s = 1:20;
    b_roi = zscore(subBeta.array(:,[1:10],s),[],2);
    keep.roi(:,:,s) = corr(b_roi');
    b_task = zscore(subBeta.array(:,1:10,s),[],1);
    keep.task(:,:,s) = corr(b_task);
end
keep.roi = mean(keep.roi,3);
keep.task = mean(keep.task,3);
roi_or_task = 1;
    all.mats = {keep.roi keep.task};
    all.labels = {r_labels t_labels(1:10)};
    t.mat = all.mats{roi_or_task};
    t.labels = all.labels{roi_or_task};
    
    newVec = get_triu(t.mat);
    Z = linkage(1-newVec,'ward')
    %Z_backup = Z;
    mat = t.mat
    Z(:,4) = length(mat) + 1 : length(mat)+length(Z);
    % Z created
% Z created, do atlas
clear Z_atlas
Z_atlas = nan(length(Z),2);
Z_atlas = num2cell(Z_atlas);

% simple cases
for r = 1:length(Z)
for c = [1 2]
    if Z(r,c) <= length(mat); 
    Z_atlas{r,c} = Z(r,c);
    end
end
end

%1 complex and 1 simplecomplex 1
for r = 1:length(Z)
for c = [1 2]
% if don't need to go back (both cols single ROIs)
if sum([Z(find(Z(:,4) == Z(r,c)),[1 2])] <= length(mat)) == 2
Z_atlas{r,c} = Z(find(Z(:,4) == Z(r,c)),[1 2]);
end
end
end





%% Backup note bookclear
% Z_atlas = nan(length(Z),2);
% Z_atlas = num2cell(Z_atlas);
% 
% % simple cases
% for r = 1:length(Z)
% for c = [1 2]
%     if Z(r,c) <= length(mat); 
%     Z_atlas{r,c} = Z(r,c);
%     end
% end
% end
% 
% %1 complex and 1 simplecomplex 1
% for r = 1:length(Z)
% for c = [1 2]
% % if don't need to go back (both cols single ROIs)
% if sum([Z(find(Z(:,4) == Z(r,c)),[1 2])] <= length(mat)) == 2
% Z_atlas{r,c} = Z(find(Z(:,4) == Z(r,c)),[1 2]);
% end
% end
% end
% 
% for r = 1:length(Z)
% for c = [1 2]
% if sum([Z(find(Z(:,4) == Z(r,c)),[1 2])] <= length(mat)) == 1
% if any(isnan([Z_atlas{find(Z(:,4) == Z(r,c)),:}])) == 0
% Z_atlas{r,c} = [Z_atlas{find(Z(:,4) == Z(r,c)),:}]; 
% end
% end
% end
% end
% 
% % Give up check if they're filled in atlas already, hope for the best;
% %
% for r = 1:length(Z)
% for c = [1 2]
%     if isnan(Z_atlas{r,c})
% a = Z_atlas(find(Z(:,4) == Z(r,c)),[1 2]);
% if any(isnan([a{:}])) == 0
% Z_atlas{r,c} = [a{:}]
% end
%     end
% end
% end
% %end
% %end
% 
% for r = 1:length(Z)
% for c = [1 2]
% if sum([Z(find(Z(:,4) == Z(r,c)),[1 2])] <= length(mat)) == 1
% if any(isnan([Z_atlas{find(Z(:,4) == Z(r,c)),:}])) == 0
% Z_atlas{r,c} = [Z_atlas{find(Z(:,4) == Z(r,c)),:}]; 
% end
% end
% end
% end
% 
% % Give up check if they're filled in atlas already, hope for the best;
% %
% for r = 1:length(Z)
% for c = [1 2]
%     if isnan(Z_atlas{r,c})
% a = Z_atlas(find(Z(:,4) == Z(r,c)),[1 2]);
% if any(isnan([a{:}])) == 0
% Z_atlas{r,c} = [a{:}];
% end
%     end
% end
% end
% Atlas done 
%%
