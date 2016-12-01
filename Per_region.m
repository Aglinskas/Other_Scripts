clear all
loadMR
for s = 1:20
a = subBeta.array(:,:,s);
a = a - a(:,11);
b = a(:,1:10);
%b = b-mean(b,1)
%b = b-mean(b,2)
smat(:,:,s) = b;
end
mat = mean(smat,3);
figure(5)
add_numbers_to_mat(mat,r_labels,t_labels(1:size(mat,2)))
%
%%% Prev
% mat = mean(subBeta.array,3);%
% mat = mat - mat(:,11)
% mat = mat(:,1:10);
figure(2)
clf
add_numbers_to_mat(mat,r_labels,t_labels(1:size(mat,2)))
%
disp('Runnning')
h = figure(1)
clf
for i = 1:10
    hold off
 sp = subplot(2,5,i)
t = subBeta.ord_t(i);
this_beta = mat(:,t);
other_betas = mean(mat(:,[find([1:10] ~= t)]),2);
scatter(other_betas,this_beta);
xlabel('Network Activity');
ylabel('Task Activity');
title(t_labels{t});

l = lsline;
arrayfun(@(x) text(other_betas(x), this_beta(x), r_labels(x),'color',[.5 0 .5]),[1 2 3 10 11 14]); %DMN
arrayfun(@(x) text(other_betas(x), this_beta(x), r_labels(x),'color',[0 .5 0]),[4  5  6  7  8  9 15 16]); %DMN
arrayfun(@(x) text(other_betas(x), this_beta(x), r_labels(x),'color',[.1 .1 .5]),[  12    13    17    18]); %DMN

% Regression and dist from line 
a = fit(other_betas,this_beta,'poly1');
hold on
%x = sp.XTick

y = a.p1* other_betas + a.p2;

res = this_beta - y;

all_r(:,t) = res;

%plot(x,y,'r*')
%saveas(h,['/Users/aidasaglinskas/Desktop/2nd_Fig/flight/' num2str(i)],'jpg')
end
disp('done')
%
%all_r = abs(all_r);

figure(3)
clf
for t_ind = 1:10
    t = subBeta.ord_t(t_ind)
    subplot(2,5,t_ind)
plot(all_r(:,t),'r*')
hold
plot(1:18,zeros(1,18))
%ylim(-.3 )
%
arrayfun(@(x) text(x, all_r(x,t), r_labels(x),'color',[.5 0 .5]),[1 2 3 10 11 14]); %DMN
arrayfun(@(x) text(x, all_r(x,t), r_labels(x),'color',[0 .5 0]),[4  5  6  7  8  9 15 16]); %DMN
arrayfun(@(x) text(x, all_r(x,t), r_labels(x),'color',[.1 .1 .5]),[  12    13    17    18]); %DMN
title(t_labels{t})
end
%%

