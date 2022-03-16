path=C:\dsi_studio_64
for /f "delims=" %%x in ('dir *. /b /d /s') do (
call dsi_studio.exe --action=src --source=F:\HCP\%%x\T1w\Diffusion\data.nii.gz --output=F:\%%x.src.gz > F:\%%x.txt    
) 

for /f "delims=" %%x in ('dir *.fib.gz /b /d /s') do (
call dsi_studio.exe --action=trk --source="%%x" > "%%x.log.txt"
) 