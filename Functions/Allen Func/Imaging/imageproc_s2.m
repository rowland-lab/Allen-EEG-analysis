function imageproc_s2(subjectfolder_path,dcm2niix_path)
%% dicom 2 nifti 

% create nii folder
disp('Creating nifti folder');
nii_path=fullfile(subjectfolder_path,'nifti'); 
mkdir(nii_path);

% Run dcm2niix (DICOM -> nifti)
disp('Converting DICOM files to nifti');
cd(dcm2niix_path)
command=['dcm2niix' ' -o ' nii_path ' -f %p_%s -z n ' fullfile(subjectfolder_path,'dicom')];
system(command);

% go to nifti folder
cd(nii_path)

%% Organize files
disp('Organizing nifti files');

%%%% T1/T2
% create structure folder
struc_folder=fullfile(nii_path,'struct');
mkdir(struc_folder)

% Move t1 and t2 files
movefile('t1*',struc_folder)
movefile('t2*',struc_folder)


%%%% fMRI
% create fmri folder
fmri_folder=fullfile(nii_path,'fmri');
mkdir(fmri_folder)

% Move fmri files
movefile('*Resting*',fmri_folder)
movefile('*field_mapping*',fmri_folder)

%%%% DKI
% create diffusion folder
diff_folder=fullfile(nii_path,'diffusion');
mkdir(diff_folder)

% Move diffusion files
movefile('DKI*',diff_folder)

%%% extra scans
extra_folder=fullfile(nii_path,'extra');
mkdir(extra_folder);
movefile('*.nii',extra_folder);
movefile('*.json',extra_folder);
end