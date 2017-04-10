clear 
loadMR;
subID = 7
for bt_ind = 1:400;
m_ind = 1;
    bt_temp = '/Users/aidasaglinskas/Google Drive/Data/S%d/Analysisall_faces/beta_%s.nii';
    bt_str = num2str(bt_ind,'%.4i');
    m_fn = fullfile(masks.dir,masks.nii_files{m_ind});
    bt_fn = sprintf(bt_temp,subID,bt_str);
 ds = cosmo_fmri_dataset(bt_fn,'mask',m_fn);
 rep(bt_ind) = max(abs(ds.samples));
end
disp('done')
%figure;plot(rep)
out = find(rep>100);
%
all_durations = [];
all_names= [];
all_onsets = [];
for frun = 1:5;
fn = sprintf('/Users/aidasaglinskas/Google Drive/Data/S%d/sub%drun%d_multicond_all_faces.mat',subID,subID,frun);
load(fn);
all_durations = [all_durations durations];
all_names = [all_names names];
all_onsets = [all_onsets onsets];
end
%
[a{1:size(all_durations,2),1}] = deal(all_onsets{:});
[a{1:size(all_durations,2),2}] = deal(all_durations{:});
[a{1:size(all_durations,2),3}] = deal(all_names{:});
disp(a)
%%

figure(4);
clf
bar(rep)
hold on 

out = find(rep>100);
v = [a{:,1}]';

p = ones(1,400);
p(find(v>500)) = 100;
plot(p,'r*')