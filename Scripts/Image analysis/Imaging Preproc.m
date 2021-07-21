%% paths
img_path='C:\Users\allen\Downloads\20210707_104257_pro00087153_0005\dicom';
out_path='C:\Users\allen\Downloads\20210707_104257_pro00087153_0005\nifti'; mkdir(out_path);
dcm2niix_path='C:\Users\allen\Documents\GitHub\Allen-EEG-analysis\tooboxes\dcm2niix-master'
%% dicom 2 nifti 

cd(dcm2niix_path)
command=['dcm2niix' ' -o ' out_path ' -f %p_%s -z n ' img_path];

system(command);
cd(out_path)

niifile={dir(fullfile(out_path,'T1*.nii')).name}'




%% run nii_preprocess on MUSC data 
imgs.T1=niifile;
nii_preprocess(imgs)
