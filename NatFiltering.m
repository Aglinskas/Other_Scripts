fn_temp = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S%d/Functional/Sess%d/%sdata.nii'; % filename template
code_fn = '/Users/aidasaglinskas/Desktop/code.txt' %where to out code
fid = fopen(code_fn,'wt'); %make a file

for subID = 14;
for sess_ind = 1:5;

fn = sprintf(fn_temp,subID,sess_ind,'w');
ofn = sprintf(fn_temp,subID,sess_ind,'fw');

bash_line1 = ['fslmaths ' '''' fn '''' ' -bptf 100 -1 ' '''' ofn ''''] % creates bash line 1
bash_line2 = ['gunzip ' '''' [ofn '.gz'] ''''] % creates bash line 2

fprintf(fid,[bash_line1 '\n']) %writes to file
fprintf(fid,[bash_line2 '\n']) %
end
end
fclose(fid)

% now open up code.txt and copy paste it into terminal