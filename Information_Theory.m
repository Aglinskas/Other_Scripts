


%Entropy
a = [.5 .125 .125 .25]; %probabilities of observing a value;
for i = 1:length(a)
cc(i)= -(a(i)*log2(a(i))) % don't forget the negative
end
sum(cc)

%%
i = i+1;
t = [1 1 1 1 2 3 4 4 ]';
%pdf(all_dists{i},t)
fitdist(t,'Normal')