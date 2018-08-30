load('/Users/aidasaglinskas/Desktop/face_data_models15.mat');
load('/Users/aidasaglinskas/Desktop/word_data_models15.mat');
%face_data word_data

task_model = mean(face_data.tcmats,3);
ROI_model = mean(face_data.rcmats,3);

model = ROI_model;
%data = face_data.tcmats;
%data = word_data.tcmats;

data = face_data.rcmats;
data = word_data.rcmats;
dt = [];
for s = 1:size(data,3)
    v1 = get_triu(model)';
    v2 = get_triu(data(:,:,s))';
    dt(s) = corr(v1,v2);
end
%[H,P,CI,STATS] = ttest2(dt,dt1);
[H,P,CI,STATS] = ttest(dt);
t_statement(STATS,P);
%%
[H,P,CI,STATS] = ttest2(dt,dtf);
t_statement(STATS,P);
