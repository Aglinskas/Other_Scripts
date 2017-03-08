load('/Users/aidasaglinskas/Desktop/person_beta.mat')
%%
b = person_beta;
done_subs = 1:7;
arr = b.roi(done_subs,:,:);

steps = 1:10:400;
for s_ind = 1:size(arr,1)
for r_ind = 1:size(arr,2)
for f_ind = 1:40   
mat(s_ind,r_ind,f_ind,:) = arr(s_ind,r_ind,steps(f_ind):steps(f_ind)+9);
end
end
end
%% cycle through
%mat( 7    18    40    10)
loadMR
lbls{1} = t_labels([1 10 2:9])
lbls{2} = names%person_beta.names
f = figure(1)
for sub = 1:7
add_numbers_to_mat(squeeze(mat(sub,1,:,:)),lbls{1},lbls{2})
title(sprintf('Subject %d betas',sub),'FontSize',20)
drawnow
pause(1)
end
%% 

mmat = squeeze(mean(mat,1));
add_numbers_to_mat(squeeze(mmat(2,:,:)))

