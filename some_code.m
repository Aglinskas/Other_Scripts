loadMR
%
arr = subBeta.array;
%size(arr) = [18    12    20] % ROIs, Tasks, Subjects;
task_or_roi = 1;
rfx_or_ffx = 1;
arr = arr - arr(:,11,:); %Subtrack face;
arr = arr(:,1:10,:); % drop control tasks
arr = zscore(arr,[],2); % if task, zscore ROI, if ROI, zscore task; 

fx = {'Random Effects' 'Fixed Effects'};
r_t = {'Task Clustering' 'ROI Clustering'};

clear keep
if rfx_or_ffx == 1
    
    
for s_ind = 1:20
    keep{1}(:,:,s_ind) = corr(arr(:,:,s_ind));
    keep{2}(:,:,s_ind) = corr(arr(:,:,s_ind)');
end

keep{1} = mean(keep{1},3)
keep{2} = mean(keep{2},3)


elseif rfx_or_ffx == 2
    
m_arr = mean(arr,3); % mean beta across subjects; 
add_numbers_to_mat(m_arr,r_labels,t_labels(1:10))
keep = {};
keep{1} = corr(m_arr); % Task Cor
keep{2} = corr(m_arr'); % Roi Cor
end

f = figure(2)

lbls = {t_labels(1:10) r_labels};
k_ind = task_or_roi;
newVec = get_triu(keep{k_ind});
Z = linkage(1-newVec,'ward');

d = subplot(1,2,2)
[h x perm] = dendrogram(Z,'labels',lbls{k_ind},'orientation','left');
[h(1:end).LineWidth] = deal(3)
ord = perm(end:-1:1);

d.FontSize = 12;
d.FontWeight = 'bold';
title({'Clustering' fx{rfx_or_ffx}},'FontSize',20)


m = subplot(1,2,1)
add_numbers_to_mat(keep{k_ind}(ord,ord),lbls{k_ind}(ord))
title({'Clustering' fx{rfx_or_ffx}},'FontSize',20)


m.FontSize = 12;
m.FontWeight = 'bold';
m.XTickLabelRotation = 45

f = figure(2)

title({r_t{task_or_roi} fx{rfx_or_ffx}},'FontSize',20)


ofn = '/Users/aidasaglinskas/Desktop/lol_betas/';
saveas(f,[ofn datestr(datetime)],'png')