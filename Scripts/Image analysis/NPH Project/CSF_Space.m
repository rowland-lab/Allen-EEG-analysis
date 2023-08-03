segmentedFile ='C:\Users\Rowland Lab\Documents\NPH_study\PatientData\Allaire\preopct\c3w95653840_1.6_TRAUMA_H_FACE_CSP_EXAM_SPLIT_20170417162825_2a_Tilt_1.nii'
V = spm_vol(segmentedFile);
segmentedData = spm_read_vols(V);
voxelVolume = abs(det(V.mat)) / 1000;
csfSpace = sum(segmentedData(:) > 0) * voxelVolume;
disp(['The CSF space is: ' num2str(csfSpace) ' cubic millimeters']);