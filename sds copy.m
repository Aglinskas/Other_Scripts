r_t = 2;
n = 20;
c =distinguishable_colors(n);
loadMR;
mat = aBeta.fmat;
rcmat = [];
tcmat = [];
cmat = {};
for i = 1:20
tcmat(:,:,i) = corr(mat(:,:,i));
rcmat(:,:,i) = corr(mat(:,:,i)');  
end
cmat = {rcmat tcmat}
lbls = {aBeta.r_lbls aBeta.t_lbls(1:10)}
mcmat = mean(cmat{r_t},3);
f = figure(2)
Z = linkage(1-get_triu(mcmat),'ward');
[h x perm] = dendrogram(Z,'labels',lbls{r_t})
    f.CurrentAxes.XTickLabelRotation = 45
    add_colours = 1;    
if add_colours
    if r_t == 1
[h(1:end).LineWidth] = deal(3)
[h(1:end).Color] = deal([0 0 0])
    c_c = c([2 3 16],:)
c_inds = {}
c_inds{1} = [1 4 5 9 10 12 14 17 18]
c_inds{2} = [6 2 3 7 11 16 ]
c_inds{3} = [8 13 15]
        
[h(c_inds{1}).Color] = deal([c_c(1,:)])
[h(c_inds{2}).Color] = deal([c_c(2,:)])
[h(c_inds{3}).Color] = deal([c_c(3,:)])
[h([19 20]).LineWidth] = deal(5)

    elseif r_t == 2
[h(1:end).LineWidth] = deal(5);
[h(1:end).Color] = deal([0 0 0]);
        
        c_c = c([17 10 20 9 15],:);
        c_inds = [1:5];
        for i = 1:length(c_inds)
            h(i).Color = c_c(i,:);
        end
        [h([6 7]).LineWidth] = deal(3);
    end
end 

f.CurrentAxes.FontSize = 12;
f.CurrentAxes.FontWeight = 'bold';
f.CurrentAxes.YLabel.String = 'dissimilarity';
f.Color = [1 1 1]
%l = legend({'a' 'a' 'f' 'f' 'f'})
%%
%f.CurrentAxes.XTick = [];
%f.CurrentAxes.YTick = [];
%f.CurrentAxes.YColor = [1 1 1];
%f.CurrentAxes.XColor = [1 1 1];
%f.Color = [1 1 1];
ofn = fullfile('/Users/aidasaglinskas/Desktop/Figures/',[datestr(datetime) '.png']);
export_fig(ofn,'-png');
%% Get Legend
for i = 1:length(h)
h(i).Color = [1 0 0]
title(num2str(i),'Fontsize',20)
pause(.5);drawnow
h(i).Color = [0 0 1]
end