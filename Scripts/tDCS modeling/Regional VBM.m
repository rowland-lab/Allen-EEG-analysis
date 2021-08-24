clear
clc
datafolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\Claudia folder\ROAST\ROAST_0043_C3';
gitpath='C:\Users\allen\Documents\GitHub\Allen-EEG-analysis';
cd(gitpath)
allengit_genpaths(gitpath,'imaging');
cd(datafolder)

%% Find Electrode

% Detect/load electrode mask
em_filename=dir(fullfile(datafolder,'*mask_elec.nii')).name;
elec=load_untouch_nii(fullfile(datafolder,em_filename));

% Detect/load CSF segment image
segment_filename=dir(fullfile(datafolder,'c3t1*')).name;
csf=load_untouch_nii(fullfile(datafolder,segment_filename));


% Find electrode around C3
elec_dim=size(elec.img);
for d=1:elec_dim(1)
    dim1(d,1)=sum(any(elec.img(d,:,:)));
end
nexttile;bar(dim1);title('dim1');xlabel('slice');
for d=1:elec_dim(2)
    dim2(d,1)=sum(any(elec.img(:,d,:)));
end
nexttile;bar(dim2);title('dim2');xlabel('slice');
for d=1:elec_dim(3)
    dim3(d,1)=sum(any(elec.img(:,:,d)));
end
nexttile;bar(dim3);title('dim3');xlabel('slice');

C3_coordinates=[30 85 188];% ALREADY CALCULATED
%% Calculate Region around electrode
pad=100; % Zero padding
radius=50; % Radius of ROI
threshold=200; % Segment threshold

% Padded Coordinates
C3_coordinates_pad=C3_coordinates+pad;

% Padded electrode dimension
elec_dim_pad=elec_dim+pad;

% Generate padded ROI matrix
roi=zeros(elec_dim_pad);

% Generate sphere
SE = strel('sphere',radius);

% Insert sphere into padded ROI matrix
roi(C3_coordinates_pad(1)-radius:C3_coordinates_pad(1)+radius,C3_coordinates_pad(2)-radius:C3_coordinates_pad(2)+radius,C3_coordinates_pad(3)-radius:C3_coordinates_pad(3)+radius)=double(SE.Neighborhood);

% Remove Padding
roi=roi(pad+1:elec_dim_pad(1),pad+1:elec_dim_pad(2),pad+1:elec_dim_pad(3));

% Save ROI matrix
roi_sphere=elec;
roi_sphere.img=roi;
save_untouch_nii(roi_sphere,fullfile(datafolder,'C3_ROI'));

%% Calculate intersection between ROI and segmented tissue
roi_log=logical(roi);
csf_log=csf.img>threshold;



sum(double(roi_log&csf_log),'all')
