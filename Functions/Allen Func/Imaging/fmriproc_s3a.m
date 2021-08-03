
function fmriproc_s3a(subject_folder)


%% Define files

% nifti path
nii_path=fullfile(subject_folder,'nifti');

% structural files
struct_path=fullfile(nii_path,'struct');
T1file.name={dir(fullfile(struct_path,'t1*.nii')).name};
T1file.header={dir(fullfile(struct_path,'t1*.json')).name};

% resting state files
fmri_path=fullfile(nii_path,'fmri');
rsfile.name={dir(fullfile(fmri_path,'*Resting_State*.nii')).name};
rsfile.header={dir(fullfile(fmri_path,'*Resting_State*.json')).name};

% fmri analysis path
fmrianal_path=fullfile(subject_folder,'analysis','fmri');

% Copy files from nifti folder to preproc folder
copyfile(fmri_path,fmrianal_path);
copyfile(struct_path,fmrianal_path);

cd(fmrianal_path);

%% Define parameters


% Read .json file (DICOM headers)
fname = fullfile(fmrianal_path,rsfile.header{1}); 
fid = fopen(fname); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
val = jsondecode(str);

% Define TR
TR=val.RepetitionTime;

% Define slice order
[~,I]=sort(val.SliceTiming);
SO=I;


%% Run CONN toolbox (SPM toolbox)
%%%% Motify Batch fields
[~,sbjname]=fileparts(subject_folder);
batch.name=sbjname;
batch.filename=fullfile(subject_folder,[sbjname,'_conn.mat']);


%%%%% Create SETUP field --> preprocessing (realignment/coregistration/segmentation/normalization/smoothing)
batch.Setup.isnew=1;
batch.Setup.nsubjects=1;
batch.Setup.RT=TR;
for ff=1:numel(rsfile.name)
    batch.Setup.functionals{1}{ff}{1}=fullfile(pwd,rsfile.name{ff});
end
for sf=1:numel(rsfile.name)
    batch.Setup.structurals{sf}=fullfile(pwd,T1file.name{1});
end
batch.Setup.conditions.names={'rest'};
for nses=1:numel(rsfile.name)
    batch.Setup.conditions.onsets{1}{1}{nses}=0;
    batch.Setup.conditions.durations{1}{1}{nses}=inf;
end
batch.Setup.preprocessing.steps='default_mni';
batch.Setup.preprocessing.sliceorder=SO;
batch.Setup.done=1;
batch.Setup.overwrite='Yes';

%%%% Create Denoising field
batch.Denoising.done=1;
batch.Denoising.overwrite='Yes';

%%%% Create Analysis field
batch.Analysis.done=1;
batch.Analysis.overwrite='Yes';

conn_batch(batch)

% conn
% conn('load',fullfile(pwd,'sbj_005_conn.mat'));
% conn gui_results
