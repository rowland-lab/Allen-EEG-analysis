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

    % Tractography
    statfolder=fullfile(dkifolder,'stat');
    mkdir(statfolder)
    
        cmd=sprintf('dsi_studio --action=trk --source=%s.src.gz.gqi.1.25.fib.gz --seed_count=1000000  --roi=HCP842_tractography:Cortico_Spinal_Tract_L --output=%s\CST_L.tt.gz --export=stat',srcfilename,statfolder);

    
    for r=1:numel(ROIs)
    cmd=sprintf('dsi_studio --action=trk --source=%s.src.gz.gqi.1.25.fib.gz --seed_count=1000000  --roi=HCP842_tractography:Cortico_Spinal_Tract_L --output=%s\CST_L.tt.gz --export=stat',srcfilename,statfolder);
    system(cmd);
    
    
        dsi_studio --action=ana --source=my.fib.gz --atlas=FreeSurferDKT
end

cd(dkifolder)
end