%% Extract Betas
%
%subvect = [7 8 9 10 11 14 15 17 18 19 20 21 22];
load('/Volumes/Aidas_HDD/MRI_data/subvect.mat')
%%
for subID = subvect
opts_xSPM.spm_path = sprintf('/Volumes/Aidas_HDD/MRI_data/S%d/Analysis/SPM.mat',subID)
opts_xSPM.p_tresh = 0.9999
set_up_xSPM
%A = spm_clusters(xSPM.XYZ);
%max(A)
%%
Ic = 1; % which contrast to extract estimates from: F con usually
A = spm_clusters(xSPM.XYZ); % gets all clusters
num_clusters = unique(A);
for c = num_clusters
clust_ins = find(A == c);
XYZmm = xSPM.XYZmm(:,clust_ins);
%disp(['Cluster ' num2str(A(i)) '/' num2str(max(A)) ' Size ' num2str(length(XYZmm))])
beta  = spm_get_data(SPM.Vbeta,xSPM.XYZ(:,clust_ins));
beta = mean(beta,2);
cbeta = SPM.xCon(Ic).c'*beta;
master_betas{subID,c} = cbeta;
end
end
%% analysis
for subID = subvect;
for r = 1:12
    for c = 1:12
cor_mat(r,c) = corr(master_betas{subID,r},master_betas{subID,c});
    end
end
all_cor_mat{subID} = cor_mat;
%%
mlbls = {'rFFA' 'rATL' 'lATL' 'vmPFC' 'rHIP' 'lHIP' 'OFA' 'rpSTS' 'dmPFC' 'rdlPFC' 'lpSTS' 'PREC'}
m = figure
imagesc(cor_mat)
m.CurrentAxes.XTick = [1:12];
m.CurrentAxes.YTick = [1:12];
m.CurrentAxes.XTickLabel = mlbls;
m.CurrentAxes.YTickLabel = mlbls;
colorbar
title(['Subject ' num2str(subID) ' Region Correlation'])
ofn = '/Users/aidas_el_cap/Desktop/2nd_Fig/TaskbyRegion/';
saveas(m,[ofn num2str(subID)],'jpg')
end
%% Average
vv = all_cor_mat;
vv = vv(:,subvect);


    %%
    for c = 1:12
        for r = 1:12
            temp_sub = [];
            for sub = subvect
                temp_sub = [temp_sub all_cor_mat{1,sub}(r,c)];
            end
            avg_cor_mat(r,c) = mean(temp_sub)
        end
    end
    figure;imagesc(avg_cor_mat)
    %%
%%
%%
mlbls = {'rFFA' 'rATL' 'lATL' 'vmPFC' 'rHIP' 'lHIP' 'OFA' 'rpSTS' 'dmPFC' 'rdlPFC' 'lpSTS' 'PREC'}
m = figure
imagesc(avg_cor_mat)
m.CurrentAxes.XTick = [1:12];
m.CurrentAxes.YTick = [1:12];
m.CurrentAxes.XTickLabel = mlbls;
m.CurrentAxes.YTickLabel = mlbls;
colorbar
title('Average Region Correlation')
ofn = '/Users/aidas_el_cap/Desktop/2nd_Fig/TaskbyRegion/';
%saveas(m,'Average Region Correlation','jpg')

%% Task correlation by Region;
% create a thing
for beta = 1:12
for sub = subvect
from_all_regions = [];
for region = 1:12
from_all_regions = [from_all_regions master_betas{sub,region}(beta,1)];
end
from_all_regions_all{sub,beta} = from_all_regions;
end
end
%from_all_regions'

%% now compute correlations 
for subID = subvect;
for r = 1:12
    for c = 1:12
cor_mat_b(r,c) = corr(from_all_regions_all{subID,r}',from_all_regions_all{subID,c}');
    end
end
all_cor_b_mat{subID} = cor_mat_b;
%%
% mlbls = {'rFFA' 'rATL' 'lATL' 'vmPFC' 'rHIP' 'lHIP' 'OFA' 'rpSTS' 'dmPFC' 'rdlPFC' 'lpSTS' 'PREC'}
m = figure(34);
imagesc(cor_mat_b)
m.CurrentAxes.XTick = [1:12];
m.CurrentAxes.YTick = [1:12];
m.CurrentAxes.XTickLabel = {t{:,1}}';
m.CurrentAxes.YTickLabel = {t{:,1}}';
m.Position = [1 1 1280 800]
colorbar
title(['Subject ' num2str(subID) ' Task correlation across regions'])
ofn = '/Users/aidas_el_cap/Desktop/2nd_Fig/RegionbyTask/';
saveas(m,[ofn num2str(subID)],'jpg')
end
%% average
bb = {all_cor_b_mat{subvect}};


for r = 1:12
for c = 1:12
    all_s = [];
for s = 1:13
all_s = [all_s bb{1,s}(r,c)];
end
all_sub_cor(r,c) = mean(all_s);
end
end

m = figure(34);
imagesc(all_sub_cor)
m.CurrentAxes.XTick = [1:12];
m.CurrentAxes.YTick = [1:12];
m.CurrentAxes.XTickLabel = {t{:,1}}';
m.CurrentAxes.YTickLabel = {t{:,1}}';
m.Position = [1 1 1280 800]
colorbar
title([' All subjects: Mean task correlation across regions'])
%%
ofn = '/Users/aidas_el_cap/Desktop/2nd_Fig/RegionbyTask/';
saveas(m,[ofn 'meanRegionbyTask'],'jpg')


%%
    
    
    