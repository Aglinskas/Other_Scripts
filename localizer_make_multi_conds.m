%load('Danilo5_Results.mat')
for sess = 1:4
    
load(sprintf('/Volumes/Aidas_HDD/aaa results silvia dan/10th/Aidas_Run_%d_Results.mat',sess))

%[myTrials(find([myTrials.blockNum] == 1)).time_presented]'
names{1} = 'faces'
onsets{1} = [myTrials([myTrials.blockNum] == 1).time_presented]
durations{1} = 2
names{2} = 'monuments'
onsets{2} = [myTrials([myTrials.blockNum] == 2).time_presented]
durations{2} = 2;

fn = sprintf('/Volumes/Aidas_HDD/MRI_data/Feb10th/S2/seq_multi_cond_run%d',sess);
save(fn,'durations','onsets','names');
end