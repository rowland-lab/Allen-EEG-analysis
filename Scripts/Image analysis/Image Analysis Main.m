% Input initial data

% SSH information
hostname='cbihome.musc.edu';
username='ajc210';
password='eR4GLRe07ceK';
remotehostfolder='/MRdata/Rowland/NR_tdcs/upload';

% DICOM output folder
dicomoutputfolder='C:\Users\allen\Downloads\subject003 DICOM';

% dcm2niix program path
dcm2niix_path='C:\Users\allen\Documents\GitHub\Allen-EEG-analysis\tooboxes\dcm2niix';

%% Steps

% Step 1 - Download DICOM images and run Quality Check
% Requires VPN or muscsecure wifi connection
imageproc_s1(hostname,username,password,remotehostfolder,dicomoutputfolder)
cd(dicomoutputfolder)

% Step 2 - Preprocess images

