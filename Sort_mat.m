%figure(3);imagesc(squeeze(mean(keep,1)))
loadMR
lbls = masks_name;
%load('/Users/aidas_el_cap/Desktop/ord.mat')
%ord = str2num(dend_num.CurrentAxes.YTickLabel); % Dendogram
%%
dt = 'MVPA'; % which data is inputted {'betas' 'MVPA'}
switch dt
    case 'betas'
b = squeeze(mean(keep,1))% for betas
singmat = squeeze(mean(keep,1));
sorted_mat = keep(:,ord,ord);
    case 'MVPA'
b = squeeze(mean(all_roicormats,1)) % for decoding acc's
singmat = squeeze(mean(all_roicormats,1));
load('/Users/aidas_el_cap/Desktop/ord2_MVPA.mat');
ord = ord_MVPA;
sorted_mat = all_roicormats(:,ord,ord);
end

    %a = sortrows(squeeze(mean(keep,1)),ord)
a = b(ord,ord)
sorted_mat_fig = figure(2);
imagesc(a)
sorted_mat_fig.CurrentAxes.YTick = 1:18;
sorted_mat_fig.CurrentAxes.YTickLabel = lbls(ord)%num2str(ord)
sorted_mat_fig.CurrentAxes.XTick = 1:18;
sorted_mat_fig.CurrentAxes.XTickLabel = lbls(ord)%num2str(ord)
sorted_mat_fig.CurrentAxes.YTickLabelRotation = 0
sorted_mat_fig.CurrentAxes.XTickLabelRotation = 15

textStrings = num2str(a(:),'%0.2f');
textStrings = strtrim(cellstr(textStrings));
[x,y] = meshgrid(1:length(singmat));
hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center');
midValue = max(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(singmat(:) > midValue,1,3);  %# Choose white or black for the
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
%%
%size(sorted_mat)
%clust1_ind = [1,1;4,4]
switch dt
    case 'betas'
% clust1_2_cross_ind = [1,5;4,10] % Beta Cluster
% clust2_3_cross_ind = [5,11;10,18] % Beta Cluster

disp('Working on betas values data')

    case 'MVPA'
clust1_2_cross_ind = [1,8;7,12] % MVPA 1%2
clust2_3_cross_ind = [8,13;12,18] % MVPA 2%3
clust1_3_cross_ind = [1,13;7,18]  % MVPA 2%3
disp('Working on decoding acc data')


    otherwise 
        error('Bad input')
end
% clust1_2_cross_ind = [1,8;7,18] % MVPA Mega clust 1%2
% clust2_3_cross_ind = [1,13;12,18] % MVPA 2%3

%%
clust1_2 = sorted_mat(:,clust1_2_cross_ind(1,1):clust1_2_cross_ind(2,1),clust1_2_cross_ind(1,2):clust1_2_cross_ind(2,2));
clust2_3 = sorted_mat(:,clust2_3_cross_ind(1,1):clust2_3_cross_ind(2,1),clust2_3_cross_ind(1,2):clust2_3_cross_ind(2,2));
% clust1_3 = sorted_mat(:,clust1_3_cross_ind(1,1):clust1_3_cross_ind(2,1),clust1_3_cross_ind(1,2):clust1_3_cross_ind(2,2));
size(clust1_2);
size(clust2_3);
% size(clust1_3)
mn_clust1_2 = squeeze(mean(mean(clust1_2,2),3));
mn_clust2_3 = squeeze(mean(mean(clust2_3,2),3));
% mn_clust1_3 = squeeze(mean(mean(clust1_3,2),3));
size(mn_clust1_2);
size(mn_clust2_3);
% size(mn_clust1_3)
var1 = mn_clust1_2;
var2 = mn_clust2_3;
% var3 = mn_clust1_3;
% if vartest2(mn_clust1_2,mn_clust2_3)
%     disp('Unequal variances')
%     T_score = (mean(var1) - mean(var2)) / sqrt((std(var1)^2 / numel(var1)) + (std(var2)^2 / numel(var2)))
% elseif vartest2(mn_clust1_2,mn_clust2_3) == 0
%     disp('Equal Variances')
%     pooled_var = ((numel(var1) - 1) * var(var1) +  (numel(var2) - 1) * var(var2)) / (numel(var1) + numel(var2) -2);
% T_score = (mean(var1) - mean(var2)) / pooled_var * sqrt(1/numel(var1) + 1/numel(var2))
% end
%
% [h,p,ci,stats] = ttest2(var1,var2);
% disp(['p val: ' num2str(p)]);disp(stats);
[h,p,ci,stats] = ttest(var1,var2);
disp(['p val: ' num2str(p)]);disp(stats);
if p < .05
fprintf(2,'Significant ')
else 
 fprintf(1,'NOT Significant ')
end



