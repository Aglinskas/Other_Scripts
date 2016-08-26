%params
fn = '/Volumes/Aidas_HDD/MRI_data/29th_march/S%d/Functional/Sess%d/data%s.nii';
% filepath to one file with %d at subID, sess, and %s at mask ext
%mskw = 2;
msk_fn = {'' '_mask_opposite' '_bet_mask'};
subID = 7;
sess = 1;
sprintf(fn,subID,sess,msk_fn{2})
%%
%%
% ex = '/Volumes/Aidas_HDD/MRI_data/29th_march/S1/Functional/Sess1/data.nii'
% a = strsplit(ex,'Sess')

%%
%%
    for subID = 7:8
        for sess = 1:5
         for m = 2:3   
dt = cosmo_fmri_dataset(sprintf(fn,subID,sess,msk_fn{1}), 'mask', sprintf(fn,subID,sess,msk_fn{m})); %_mask_opposite
s = size(dt.samples)
%% Analyze and plot
figure(1)
clf
for i = 1: s(1)
%r(i) = max(dt.samples(i,:));
r(i) = mean(dt.samples(i,:)) / std(dt.samples(i,:));
end
% targets = [22 106 149]
% targets = targets + 1
hold on
plot(r)
title(['S' num2str(subID) ' Sess ' num2str(sess) msk_fn{m}])
if m == 2
    hold on
elseif m == 3
        hold off
end
% for i = 1:length(targets)
% plot(targets(i),r(targets(i)),'r*')
% end
% plot(targets(4),r(targets(4)),'r*')
% plot(targets(5),r(targets(5)),'r*')

pause(1)
        end
    end
    end
%% rnd
epi = 80;
(dt.samples(epi,:))

%% histograms 
epi = 56
figure(2)
hist(dt.samples(epi,:))
figure(3)
hist(dt.samples(epi-1,:))
%% make the opposite stuff
%fn1 = sprintf('/Volumes/Aidas_HDD/MRI_data/29th_march/S%d/Functional/Sess%d/data.nii',subID,sess)
for subID = 7:8
    for sess = 1:5
fnmask = sprintf('/Volumes/Aidas_HDD/MRI_data/29th_march/S%d/Functional/Sess%d/data_bet_mask.nii',subID,sess)

msk = cosmo_fmri_dataset(fnmask)
%
for i = 1:length(msk.samples)
    if msk.samples(i) == 0
        msk.samples(i) = 1;
    elseif msk.samples(i) == 1
        msk.samples(i) = 0;
    else error('wut')
    end
end

fn = sprintf('/Volumes/Aidas_HDD/MRI_data/29th_march/S%d/Functional/Sess%d/data_mask_opposite.nii',subID,sess)
cosmo_map2fmri(msk,fn)
    end
end
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
WaitSecs(0.3);
hold off
end
%%