clear 
loadMR
%%
j = [ 1     2     4     6     8    11    13    14    15    17];
%j = 1:18
subBeta.goodinds = j%[1:18];
warning('off','stats:linkage:NotEuclideanMatrix')
w_t = 1:10;
w_rois = subBeta.goodinds;
for ss = 1:size(subBeta.array,3)
    keep.task(:,:,ss) = corr(subBeta.array(w_rois,w_t,ss));
    keep.roi(:,:,ss) = corr(subBeta.array(w_rois,w_t,ss)');
end
mat = mean(keep.roi,3)
mat_b = mat;
%add_numbers_to_mat(mat,subBeta.r_labels(j))
%f = figure(1);
%add_numbers_to_mat(mat,subBeta.r_labels(j))
ind{1} =  [1     2     6     8]
ind{2} = [ 3     4     5     9]
ind{3} =  [7 10]

nind = find(ismember([1:10],ind{2}) == 0);
nind = []
mat(nind,:) = 0
mat(:,nind) = 0
%mat(:,:) = []
for i = 1:3;
mat(ind{i},[ind{find([1:3] ~= i)}]) = 0;    
mat([ind{find([1:3] ~= i)}],ind{i}) = 0;
mat(ind{i},ind{i}) = mat(ind{i},ind{i})*2;
end

%mat(2,ind{2}) = mat_b(2,ind{2})

%mat(2,ind{2}) = mat(2,ind{2})/2;
%mat(ind{2},2) = mat(ind{2},2)/2;


%mat(7,10) = 0.3257;

dlmwrite('/Users/aidasaglinskas/Desktop/BrainNet_Files/newEdge.edge',mat,' ')
%%