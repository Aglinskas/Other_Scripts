clear
loadMR
%%

mat = aBeta.fBeta;
roi_or_task = 1;

r = 0;
pl = 1;
if r
for s_ind = 1:20
for r_ind = 1:18
mat(r_ind,:,s_ind) = mat(r_ind,Shuffle(1:12),s_ind);
end
end
end

mat = mat - mat(:,11,:);
mat = mat(:,1:10,:);
mat = zscore(mat,[],2);
albls = {aBeta.r_labels aBeta.t_labels(1:10)};



cmat = [];
for s_ind = 1:20
    if roi_or_task == 1
cmat(:,:,s_ind) = corr(mat(:,:,s_ind)');
    else
cmat(:,:,s_ind) = corr(mat(:,:,s_ind));
    end
end

mmat = mean(cmat,3);

this_lbls = albls{find(cellfun(@length,albls) == length(mmat))};

if pl
figure(1)
dendrogram(linkage(1-get_triu(mmat),'ward'),'labels',this_lbls,'orientation','left')

figure(2)
add_numbers_to_mat(mmat)
end
%%
nrps = 1000
for rp = 1:nrps

  if ismember(rp,0:nrps/10:nrps)
    disp(rp/nrps * 100)
  end
C = {};
if roi_or_task == 1
sc = Shuffle(1:18);
C{1} = sc(1:6);
C{2} = sc(7:14);
C{3} = sc(15:18);
%C{1} = [ 1     2     5     6    17    18]; % ext DMN
%C{2} = [ 7     8    11    12    13    14    15    16]; % core
%C{3} = [ 3     4     9    10]; %ext - limb
else
% C{1} = [3  2        6     9    10];
% C{2} = [ 1     4     5     7     8];
sc = Shuffle(1:10);
C{1} = sc(1:5);
C{2} = sc(6:10);
end

aC{rp} = C;
fmat = cmat;
measure = [];
for ii = 1:20
    w = [];
    b = [];
for cc = 1:length(C)
w(cc) = mean(get_triu(fmat(C{cc},C{cc},ii)));
for bb = 1:size(nchoosek(1:length(C),2),1)
pairs = nchoosek(1:3,2);
temp = fmat(C{pairs(bb,1)},C{pairs(bb,2)},ii);
b(bb) = mean(temp(:));
end

measure(ii) =  mean(w) - mean(b);
end
end

[H,P,CI,STATS] = ttest(measure);
col(rp) = STATS.tstat;
end
disp('done')
%
figure(3)
hist(col);
th = 8
length(find(col>=th) / length(col)) / nrps;

ch = find(col>th);