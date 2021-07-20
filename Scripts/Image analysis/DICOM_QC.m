clear all
clc
close all

Rowland_start
%%
foldername='C:\Users\allen\Downloads\20210707_104257_pro00087153_0005\dicom';
addpath(foldername);

folderdir=dir(fullfile(foldername,'MR*'));
filenames={folderdir.name};

for f=1:numel(filenames)
    tempfilename=filenames{f};
    tempfileinfo=dicominfo(filenames{f});
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
%%
fn=fieldnames(dicomdata);
for img=1
    temp_filenames=dicomdata.(fn{img}).filenames;
    [V,spatial,dim] = dicomreadVolume(temp_filenames);
    V = squeeze(V);
    intensity = [0 20 40 120 220 1024];
    alpha = [0 0 0.15 0.3 0.38 0.5];
    color = ([0 0 0; 43 0 0; 103 37 20; 199 155 97; 216 213 201; 255 255 255])/ 255;
    queryPoints = linspace(min(intensity),max(intensity),256);
    alphamap = interp1(intensity,alpha,queryPoints)';
    colormap = interp1(intensity,color,queryPoints);
    
    ViewPnl = uipanel(figure,'Title',fn{img});
    volshow(V,'Colormap',colormap,'Alphamap',alphamap,'Parent',ViewPnl);
end