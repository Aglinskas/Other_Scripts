function perm_struct = func_lastBoot_bootmat(perm_struct)
disp('running permutation')
hidden_fig = figure(10);
hidden_fig.Visible = 'off';drawnow;
mat = perm_struct.mat;
perm_struct.clustmat = zeros([size(mat,1) size(mat,2) perm_struct.nperms]);
tic
for i = 1:perm_struct.nperms;
    % progress report every 5 sec
    p.t = toc;if p.t > 5;disp([num2str(i/perm_struct.nperms*100) '% done']);tic;end
    
p = struct; % clear within loop thing
 % Subjects 
 %%% One Way to do it, exclusive subs
 p.S = Shuffle(1:size(mat,3));
 p.subject_pool(1,:) = p.S(1:10);
 p.subject_pool(2,:) = p.S(11:20);
 
%%% Semi exclusive
% p.subject_pool(1,:) = randi(20,1,10);
% left = find(~ismember(1:20,p.subject_pool(1,:)));
% p.subject_pool(2,:) = left(randi(length(left),1,10));



 % Cluster subpools
for spool_ind = [1 2];
    p.m = mean(mat(:,:,p.subject_pool(spool_ind,:)),3);
    p.newVec = get_triu(p.m);
    p.Z{spool_ind} = linkage(1-p.newVec,'ward');
    %p.Z_atlas{spool_ind} = get_Z_atlas(p.Z{spool_ind});
    set(0,'currentfigure',hidden_fig);
    [p.h{spool_ind} p.x(spool_ind,:) p.perm(spool_ind,:)] = dendrogram(p.Z{spool_ind},perm_struct.nclust);
end


% check clustering
p.pairs = nchoosek(1:size(mat,1),2);
for p_ind = 1:size(p.pairs,1)

p.bool = p.x(1,p.pairs(p_ind,1)) == p.x(1,p.pairs(p_ind,2)) & p.x(2,p.pairs(p_ind,1)) == p.x(2,p.pairs(p_ind,2));

perm_struct.clustmat(p.pairs(p_ind,1),p.pairs(p_ind,2),i) = perm_struct.clustmat(p.pairs(p_ind,1),p.pairs(p_ind,2),i)+p.bool;
perm_struct.clustmat(p.pairs(p_ind,2),p.pairs(p_ind,1),i) = perm_struct.clustmat(p.pairs(p_ind,2),p.pairs(p_ind,1),i)+p.bool;
end % ends pairs loop
end % ends nperms


perm_struct.meanClust = mean(perm_struct.clustmat,3);
Z = linkage(1-get_triu(perm_struct.meanClust));
[h x perm] = dendrogram(Z);
perm_struct.final_ord = perm(end:-1:1);





disp('done');