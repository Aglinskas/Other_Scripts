%a = randi(20,5)
%a = singmat
function a_masked = get_triu2(a)

if numel(size(a)) == 2
    sz = size(a)
elseif numel(size(a)) > 2
temp = size(a)
sz = temp([end-1 end])
else error('size of matrix is less than 2 dimensions: You done fucked up')
end

tr_l = tril(repmat(1,sz));
mask = tr_l == 0;

a_masked = a(:,mask);
end



% 
% TheseIndices = {2 3 4};
% statisticArray(:,TheseIndices{:});

r = repmat(1,[1 2 3 4 5 6 7 8 9]);
size(r)

inds = {1 1:2 1:2 4 5 6 7 8 9}
r(inds{:})

% get inds (for long-ass arrays)
for i = ndims()

