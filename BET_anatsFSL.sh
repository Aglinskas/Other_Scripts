for subID in 22 23
do
echo 'Extracting Brain From: /Volumes/Aidas_HDD/MRI_data/S'$subID'/Anatomical/Ana_nopeel.nii'
bet '/Volumes/Aidas_HDD/MRI_data/S'$subID'/Anatomical/Ana_nopeel.nii' '/Volumes/Aidas_HDD/MRI_data/S'$subID'/Anatomical/Ana_peel.nii'
gunzip '/Volumes/Aidas_HDD/MRI_data/S'$subID'/Anatomical/Ana_peel.nii.gz'
done