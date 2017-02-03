testfilename1 = '1.txt';                           % Experimental list
testfilename2 = '2.txt';
testfilename3 = '3.txt';

%%
testfilename = {}
for i = 1:40
testfilename{i} = [num2str(i) '.txt']
end   
testfilename = testfilename'
%%
s = {}
objnumber = {}
objname = {}
for mat_file = 1:40
for i = 1:5
    objnumber{i,1} = i
    objname{i,1} = sprintf('GRID%d.%d.jpg',mat_file,i)
end
save(['/Users/aidasaglinskas/Desktop/raw_dump/' num2str(mat_file) '.mat'],'objnumber','objname')
end



