patient_dir = 'C:\Users\Rowland Lab\Documents\NPH_study\PatientData';
thres = 20;
patients = dir(patient_dir);
patients(contains({patients.name},'.')) = [];

for p = 1:numel(patients)
    patient_folder = fullfile(patients(p).folder,patients(p).name);
    
    % Find file path
    CSF_file = dir(fullfile(patient_folder,'PreopCT','c3*.nii'));
    if isempty(CSF_file)
        continue
    end
    CSF_file_path = fullfile(CSF_file.folder,CSF_file.name);
    
    % Load Nii
    CSF_nii = load_nii(CSF_file_path);
    
    % Threshold
    CSF_nii.img = CSF_nii.img > 0.5;
    
    % Cut off bottom half
    CSF_nii.img(:,:,1:size(CSF_nii.img,3)/3) = 0;
    niftiwrite(double(CSF_nii.img),fullfile(vent_folder,'raw.nii'))

    % Create ventricle folder
    vent_folder = fullfile(CSF_file.folder,'vent');
    mkdir(vent_folder)
    
    % 6 directions
    CC = bwconncomp(CSF_nii.img,6);
    stats = regionprops3(CC,'all');
    [~,idx] = max(stats.Volume);
    CSF_nii.img = zeros(size(CSF_nii.img));
    CSF_nii.img(stats.VoxelIdxList{idx}) = 1;
    CSF_nii.img = polish_img(CSF_nii.img,thres);
    CC = bwconncomp(CSF_nii.img,6);
    stats = regionprops3(CC,'all');
    [~,idx] = max(stats.Volume);
    CSF_nii.img = zeros(size(CSF_nii.img));
    CSF_nii.img(stats.VoxelIdxList{idx}) = 1;

    CSF_nii.img(:,1:size(CSF_nii.img,2)/2,:) = 0;
    
    % Find width of frontal horn
    widest_point = [];
    for a = 1:size(CSF_nii.img,3)
        temp_slice = CSF_nii.img(:,:,a);
        max(temp_slice==1)-min(temp_slice==1)
    end
    niftiwrite(double(CSF_nii.img),fullfile(vent_folder,'frontal_horn.nii'))
%     
%     
%     % 18 directions
%     CC = bwconncomp(CSF_nii.img,18);
%     stats = regionprops3(CC,'all');
%     [~,idx] = max(stats.Volume);
%     niftiwrite(double(stats.Image{idx}),fullfile(vent_folder,'vent_18.nii'))
%     
%     CSF_nii.img = polish_img(stats.Image{idx},thres);
%     CC = bwconncomp(CSF_nii.img,18);
%     stats = regionprops3(CC,'all');
%     [~,idx] = max(stats.Volume);
%     niftiwrite(double(stats.Image{idx}),fullfile(vent_folder,'vent_18_polish.nii'))
%     
%     % 26 directions
%     CC = bwconncomp(CSF_nii.img,26);
%     stats = regionprops3(CC,'all');
%     [~,idx] = max(stats.Volume);
%     niftiwrite(double(stats.Image{idx}),fullfile(vent_folder,'vent_26.nii'))
%     
%     CSF_nii.img = polish_img(stats.Image{idx},thres);
%     CC = bwconncomp(CSF_nii.img,26);
%     stats = regionprops3(CC,'all');
%     [~,idx] = max(stats.Volume);
%     niftiwrite(double(stats.Image{idx}),fullfile(vent_folder,'vent_26_polish.nii'))
end
%% Polishing
function img = polish_img(img,thres)

for i = 1:size(img,3)
    temp_slice = img(:,:,i);
    bw = bwconncomp(temp_slice,4);
    s = regionprops(bw,'all');
    pieces_idx = [s.Area] <= thres;
    if any(pieces_idx,'all')
        temp_slice(cat(1,s(pieces_idx).PixelIdxList)) = 0;
        img(:,:,i) = temp_slice;
    end
end
end