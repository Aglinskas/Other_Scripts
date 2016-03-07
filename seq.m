for sess = 1:5;
fn = sprintf('/Volumes/Aidas_HDD/MRI_data/Sequence_testing/S1/Functional/Sess%d/data.nii',sess);
%mask = '/Volumes/Aidas_HDD/MRI_data/Sequence_testing/S1/Analysis/mask.nii';
%'/Volumes/Aidas_HDD/MRI_data/Sequence_testing/S2/Functional/data.nii'm
a = cosmo_fmri_dataset(fn);

% 
% for i = 1:length(a.samples);
% a.samples(:,i) = mean(a.samples(:,i)) / std(a.samples(:,i));
% end
disp(['session ' num2str(sess)])

disp(['mean ' num2str(mean2(a.samples))])
disp(['max value ' num2str(max(max(a.samples)))])
disp(['# of voxels ' num2str(length(a.samples))])

for i = 1:length(a.samples);
a.samples(:,i) = mean(a.samples(:,i)) / std(a.samples(:,i));
end
a.samples(find(a.samples == inf)) = NaN;
a.samples(find(a.samples == 0)) = NaN;

disp('SNR')
disp(['median ' num2str(median(a.samples(1,:),'omitnan'))])
disp(['mean ' num2str(mean(a.samples(1,:),'omitnan'))])
disp(['max value ' num2str(max(max(a.samples(1,:))))])
disp(['min value ' num2str(min(min(a.samples(1,:))))])
disp(['# of voxels ' num2str(length(a.samples(1,:)))])
disp(['median STD ' num2str(median(nanstd(a.samples(1,:))))])
end
disp('done')




disp(['session ' num2str(sess)])
disp(['mean ' num2str(nanmean(a.samples(1,:)'))])
disp(['max ' num2str(max(a.samples(1,:)'))])

histogram(a.samples(1,:))
drawnow
disp('paused')
pause
plot(a.samples(1,:))
drawnow
disp('paused')
pause