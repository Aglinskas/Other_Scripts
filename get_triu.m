% Gets the upper triangle of a matrix without the diagonal
% 
%
% Actual code
% function newVec = get_triu(singmat)
% clear newVec
% cc=0;
% for ii=1:length(singmat)
% for jj=ii+1:length(singmat)
% cc=cc+1;
% newVec(cc)=singmat(ii,jj);
% end
% end
% end

function newVec = get_triu(singmat)
clear newVec
cc=0;
for ii=1:length(singmat)
for jj=ii+1:length(singmat)
cc=cc+1;
newVec(cc)=singmat(ii,jj);
end
end
end





