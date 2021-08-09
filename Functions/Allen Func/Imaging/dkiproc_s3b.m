function dkiproc_s3b(dkifolder,subjectfolder,dsipath,ROIs)

% Copy dki files
copyfile(fullfile(subjectfolder,'nifti','diffusion'),dkifolder)

% Find bvec files
bvecfilenames={dir(fullfile(dkifolder,'*.bvec')).name};

% Run dsi studio
for df=1:numel(bvecfilenames)
    cd(dsipath)
    inputpath=extractBefore(fullfile(dkifolder,bvecfilenames{df}),'.bvec');
    [~,filename,ext]=fileparts(inputpath);
    filename=[filename ext];
    
    % Nifti --> SRC
    srcfibfolder=fullfile(dkifolder,'src_fib');
    mkdir(srcfibfolder)
    srcfilename=fullfile(srcfibfolder,filename);
    cmd=sprintf('call dsi_studio.exe --action=src --source=%s.nii --output=%s.src.gz > %s.txt',inputpath,srcfilename,srcfilename);
    system(cmd);
    
    % SRC quality chcek
    cmd=sprintf('dsi_studio --action=qc --source=%s.src.gz',srcfilename);
    system(cmd);

    % SRC --> fib file
    cmd=sprintf('dsi_studio --action=rec --source=%s.src.gz --method=4  --param0=1.25',srcfilename);
    system(cmd);

    % Fiber tracking
    tractsfolder=fullfile(dkifolder,'tracts');
    mkdir(tractsfolder)
   
    for r=1:numel(ROIs)
%         cmd=sprintf('dsi_studio --action=trk --source=%s.src.gz.gqi.1.25.fib.gz --seed_count=1000000  --track_id=%s --output=%s --export=stat',srcfilename,ROIs{r},fullfile(tractsfolder,ROIs{r}));
        cmd=sprintf('dsi_studio --action=atk --source=%s.src.gz.gqi.1.25.fib.gz --track_id=%s',srcfilename,ROIs{r});
        system(cmd);
        movefile(fullfile(srcfibfolder,['*',ROIs{r},'*']),tractsfolder);
    end
end

cd(tractsfolder)
end