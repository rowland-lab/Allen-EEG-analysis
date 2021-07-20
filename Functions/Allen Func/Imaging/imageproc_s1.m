function imageproc_s1(hostname,username,password,remotehostfolder,outputfolder)

mkdir(outputfolder);
%% SSH into CBI host (via SSH/SFTP/SCP For Matlab (v2) toolbox)
% Requires VPN or to be on 'muscsecure' wifi
% Setup connection
ssh2_conn = ssh2_config(hostname,username,password);

% Display files
command=['cd ',remotehostfolder,'; ls'];
ssh2_conn = ssh2_command(ssh2_conn, command,1);

% Ask for which files to download
response=ssh2_conn.command_result;
for r=1:numel(response)
    display(['[',num2str(r),'] - ',response{r}]);
end
selection=input('Choose number associated with file === ');

% SSH files over to download folder
ssh2_conn = scp_get(ssh2_conn, response{selection},outputfolder,remotehostfolder);

% Close SSH connection
ssh2_conn = ssh2_close(ssh2_conn);

%% Unzip DICOM and QC raw data

% Unzip to download folder
unzip(fullfile(outputfolder,response{selection}),outputfolder)

% Define DICOM file path and add to path
dicomfolder=fullfile(outputfolder,extractBefore(response{selection},'.zip'),'dicom');
addpath(dicomfolder);

% Detect DICOM file names
dicomfilenames={dir(fullfile(dicomfolder,'MR.*')).name};

% Extract and organize DICOM files
for f=1:numel(dicomfilenames)
    tempfilename=dicomfilenames{f};
    tempfileinfo=dicominfo(dicomfilenames{f});
    Pname=tempfileinfo.SeriesDescription;
    Pname=strrep(Pname,'-','_');
    Pname=strrep(Pname,'(','_');
    Pname=strrep(Pname,')','_');
    Pname=strrep(Pname,'.','_');
    Inum=tempfileinfo.InstanceNumber;
    
    dicomdata.(Pname).info{Inum}=dicominfo(tempfilename);
    dicomdata.(Pname).data{Inum}=dicomread(tempfilename);
    dicomdata.(Pname).filenames{Inum}=tempfilename;
end

% Create T1,T2,fMRI,DKI figures
imagetypes={'t1','t2','Resting_State','DKI'};
scannames=fieldnames(dicomdata);
for img=1:numel(imagetypes)
    temp_scan=scannames(~cellfun(@isempty,(regexp(scannames,[imagetypes{img}],'ForceCelloutput'))));
    for sn=1:numel(temp_scan)
        
        % Load image
        tempdata=dicomdata.(temp_scan{sn}).data;
        
        tempimg=[];
        for i=1:numel(tempdata)
            % Gray scale and organize
            tempimg(:,:,i)=mat2gray(tempdata{i});
        end
        figure('Name',temp_scan{sn})
        imshow3D(tempimg)
    end
end
