fn = '/Users/aidasaglinskas/Downloads/neurosynth-data-master/current_data/database.txt'
fid = fopen(fn);

%%
tic
fn = '/Users/aidasaglinskas/Downloads/neurosynth-data-master/current_data/features.txt';
f = readtable(fn);
toc
%%
fn = '/Users/aidasaglinskas/Downloads/neurosynth-data-master/current_data/features.txt';
c = dlmread(fn,'	',1,0);

save('/Users/aidasaglinskas/Desktop/NeuroSynth_features.mat','c')