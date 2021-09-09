clear all
clc

%%%%% CHANGE
% Input initial data
% SSH information
hostname='cbihome.musc.edu';
username='ajc210';
password='eR4GLRe07ceK';
remotehostfolder='/MRdata/Rowland/NR_tdcs/upload';

% Data save folder
datasavefolder='C:\Users\allen\Downloads\results';

% Git path
gitpath='C:\Users\allen\Documents\GitHub\Allen-EEG-analysis';

% Gen path
cd(gitpath)
allengit_genpaths(gitpath,'imaging')

% Region of Interest (look at the end of script for ROIS)
ROI={'Corticospinal_Tract_L',
    'Corticospinal_Tract_R',
    'Corpus_Callosum_Forceps_Minor',
    'Corpus_Callosum_Body',
    'Corpus_Callosum_Tapetum',
    'Corpus_Callosum_Forceps_Major'};

% Subject folder
subjectfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153\Imaging\sbj_0042';





%%%% DON'T CHANGE (unless paths are incorrect; paths should be correct if
%%%% cloning git)

% dcm2niix program path
if ismac
    plat='mac';
elseif isunix
    plat='linux';
elseif ispc
    plat='windows';
end
dcm2niix_path=fullfile(gitpath,'toolboxes','imaging','dcm2niix',plat);

% SPM
spm_path=fullfile(gitpath,'tooboxes','imaging','spm12');

% CONN
conn_path=fullfile(gitpath,'tooboxes','imaging','conn'); 

% DSI studio
dsipath=fullfile(gitpath,'tooboxes','imaging','dsi_studio_64');
%% Steps

% Step 1 - Download DICOM images and run Quality Check
% Requires VPN or muscsecure wifi connection
subjectfolder=imageproc_s1(hostname,username,password,remotehostfolder,datasavefolder);
cd(subjectfolder)

% Step 2 - DICOM to nifti and organize files
imageproc_s2(subjectfolder,dcm2niix_path)

% Step 3a - Process fMRI data
fmrifolder=fullfile(subjectfolder,'analysis','fmri');
mkdir(fmrifolder);
fmriproc_s3a(subjectfolder)

% Step 3b - Process DKI data
dkifolder=fullfile(subjectfolder,'analysis','dki');
mkdir(dkifolder);
dkiproc_s3b(dkifolder,subjectfolder,dsipath,ROI)

% Step 4a - Analyze fMRI data

% Step 4b - Analyze DKI data
subjectfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153\Imaging\sbj_0043';
dkifolder=fullfile(subjectfolder,'analysis','dki');
dkianal_s4b(dkifolder);
%% ROIS

% Arcuate_Fasciculus_L
% Arcuate_Fasciculus_R
% Cingulum_Frontal_Parahippocampal_L
% Cingulum_Frontal_Parahippocampal_R
% Cingulum_Frontal_Parietal_L
% Cingulum_Frontal_Parietal_R
% Cingulum_Parahippocampal_Parietal_L
% Cingulum_Parahippocampal_Parietal_R
% Cingulum_Parahippocampal_L
% Cingulum_Parahippocampal_R
% Cingulum_Rarolfactory_L
% Cingulum_Rarolfactory_R
% Extreme_Capsule_L
% Extreme_Capsule_R
% Frontal_Aslant_Tract_L
% Frontal_Aslant_Tract_R
% Inferior_Fronto_Occipital_Fasciculus_L
% Inferior_Fronto_Occipital_Fasciculus_R
% Inferior_Longitudinal_Fasciculus_L
% Inferior_Longitudinal_Fasciculus_R
% Middle_Longitudinal_Fasciculus_L
% Middle_Longitudinal_Fasciculus_R
% Parietal_Aslant_Tract_L
% Parietal_Aslant_Tract_R
% Superior_Longitudinal_Fasciculus1_L
% Superior_Longitudinal_Fasciculus1_R
% Superior_Longitudinal_Fasciculus2_L
% Superior_Longitudinal_Fasciculus2_R
% Superior_Longitudinal_Fasciculus3_L
% Superior_Longitudinal_Fasciculus3_R
% Uncinate_Fasciculus_L
% Uncinate_Fasciculus_R
% Vertical_Occipital_Fasciculus_L
% Vertical_Occipital_Fasciculus_R
% Acoustic_Radiation_L
% Acoustic_Radiation_R
% Corticobulbar_Tract_L
% Corticobulbar_Tract_R
% Corticopontine_Tract_Frontal_L
% Corticopontine_Tract_Frontal_R
% Corticopontine_Tract_Parietal_L
% Corticopontine_Tract_Parietal_R
% Corticopontine_Tract_Occipital_L
% Corticopontine_Tract_Occipital_R
% Corticospinal_Tract_L
% Corticospinal_Tract_R
% Corticostriatal_Tract_Anterior_L
% Corticostriatal_Tract_Anterior_R
% Corticostriatal_Tract_Posterior_L
% Corticostriatal_Tract_Posterior_R
% Corticostriatal_Tract_Superior_L
% Corticostriatal_Tract_Superior_R
% Thalamic_Radiation_Anterior_L
% Thalamic_Radiation_Anterior_R
% Thalamic_Radiation_Posterior_L
% Thalamic_Radiation_Posterior_R
% Thalamic_Radiation_Superior_L
% Thalamic_Radiation_Superior_R
% Dentatorubrothalamic_Tract_L
% Dentatorubrothalamic_Tract_R
% Fornix_L
% Fornix_R
% Medial_Lemniscus_L
% Medial_Lemniscus_R
% Optic_Radiation_L
% Optic_Radiation_R
% Reticulospinal_Tract_L
% Reticulospinal_Tract_R
% Anterior_Commissure
% Corpus_Callosum_Forceps_Minor
% Corpus_Callosum_Body
% Corpus_Callosum_Tapetum
% Corpus_Callosum_Forceps_Major
% Cerebellum_L
% Cerebellum_R
% Inferior_Cerebellar_Peduncle_L
% Inferior_Cerebellar_Peduncle_R
% Middle_Cerebellar_Peduncle
% Superior_Cerebellar_Peduncle
% Vermis
% CNII_L
% CNII_R
% CNIII_L
% CNIII_R
% CNV_L
% CNV_R
% CNVII_L
% CNVII_R
% CNVIII_L
% CNVIII_R