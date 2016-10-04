
%20    18    12    12
%% Define keep
clear MVPA_keep
w_t = [1:12]



%MVPA_keep = corr(squeeze(mean(mean(MVPA_results(:,:,w_t,w_t),1),4)))

sub_avg = squeeze(mean(MVPA_results,1));
for sub = 1:20
for r1 = 1:18
    for r2 = 1:18
    MVPA_keep(sub,r1,r2) = corr(get_triu(squeeze(MVPA_results(sub,r1,w_t,w_t)))',get_triu(squeeze(MVPA_results(sub,r2,w_t,w_t)))');
    end
end
end



size(MVPA_keep)
%%

matrix = squeeze(mean(MVPA_keep,1))
matrix(find(eye(size(matrix)) == 1)) = nan
lbls = masks_name
cor_mat = figure(8)
add_numbers_to_mat(matrix,lbls)

dend = figure(9)
newVec = get_triu(matrix);
Z = linkage(1-newVec,'ward');
[h x] = dendrogram(Z,'labels',lbls,'orientation','left');
[h(1:end).LineWidth] = deal(3);
dend.CurrentAxes.FontSize = 16;
