function min_fig = func_min_fig
allfigs = get(0,'children');
try 
min_fig = min(find(ismember(1:100,[allfigs.Number]) == 0));
catch 
min_fig = 1;
end
end


