for ii=1:1000
    x=randi([1 20],[1 20]);
k2(ii)=length(x)-length(unique(x));
end
subplot(1,2,1),hist(k2,3:15)

for ii=1:1000
    x=randi([1 30],[1 30]);
k3(ii)=length(x)-length(unique(x));
end
subplot(1,2,2),hist(k3,3:15)