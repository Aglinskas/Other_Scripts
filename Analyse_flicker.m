dt = cosmo_fmri_dataset('/Volumes/Aidas_HDD/MRI_data/Sequence_testing/S1/Functional/Sess2/data.nii', 'mask', '/Volumes/Aidas_HDD/MRI_data/Sequence_testing/S1/Functional/Sess2/data_mask_opposite.nii')
s = size(dt.samples)
%% Analyze and plot
figure(1)
clf
for i = 1: s(1)
%r(i) = max(dt.samples(i,:));
r(i) = mean(dt.samples(i,:)) / std(dt.samples(i,:));
end
targets = [55 116 144]
targets = targets + 1
hold on
plot(r)
plot(targets(1),r(targets(1)),'r*')
plot(targets(2),r(targets(2)),'r*')
plot(targets(3),r(targets(3)),'r*')
% plot(targets(4),r(targets(4)),'r*')
% plot(targets(5),r(targets(5)),'r*')
hold off

%% rnd
epi = 80;
(dt.samples(epi,:))

%% histograms 
epi = 56
figure(2)
hist(dt.samples(epi,:))
figure(3)
hist(dt.samples(epi-1,:))
%% mask stuff
msk = cosmo_fmri_dataset('/Volumes/Aidas_HDD/MRI_data/Sequence_testing/S1/Functional/Sess1/data_mask.nii')

for i = 1:length(msk.samples)
    if msk.samples(i) == 0
        msk.samples(i) = 1;
    elseif msk.samples(i) == 1
        msk.samples(i) = 0;
    else error('wut')
    end
end

fn = '/Volumes/Aidas_HDD/MRI_data/Sequence_testing/S1/Functional/Sess1/data_mask_opposite.nii'

cosmo_map2fmri(msk,fn)

%% make a movie
figure(1)
clf
for i = 1: s(1)
%r(i) = max(dt.samples(i,:));
r(i) = mean(dt.samples(i,:)) / std(dt.samples(i,:));
end

for targets = 1:length(r)
plot(r)
hold on;
plot(targets(1),r(targets(1)),'r*');
t = xlabel(['Scan ' num2str(targets)]);
t.Color = 'red';
t.FontSize = 20;
ylabel('Scan Mean / Std. Dev');
drawnow;
WaitSecs(1);
hold off
end
%%