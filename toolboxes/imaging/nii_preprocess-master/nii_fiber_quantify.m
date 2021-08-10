
function  nii_fiber_quantify (matName, baseDir, atlas, forceRecalc, num_samples)
%For each region of interest find connection to every other region
% matName : name of file to store calculations (.mat format)
% baseDir: file that includes the probtrackx folder
% atlas: name of atlas from LIME roi folder ('jhu', 'aicha', etc)
% forceRecalc : if true, this function runs even if values were previously calculated
% num_samples: how many probtrackx samples were generated? (default = 5000)

%see if we can run this faster
exeName = [];
if ismac
    exeName = fullfile(fileparts(which(mfilename)), 'fiberQuantOSX');
elseif isunix % Code to run on Linux plaform
    exeName = fullfile(fileparts(which(mfilename)), 'fiberQuantLX');
end

if ~isempty(exeName) && ~exist(exeName,'file')
    fprintf('HINT: %s will run much faster if you install %s',mfilename, exeName);
    exeName = [];
end

if ~exist('atlas','var'), atlas = 'jhu'; end;
if ~exist('forceRecalc','var'), forceRecalc = false; end;
if ~exist('num_samples','var'), num_samples = 5000; end;
probDir = [baseDir,filesep,  'probtrackx_' atlas ]; %no filesep
if ~exist(probDir,'dir') && strcmpi(atlas,'jhu')
    probDir = [baseDir,filesep,  'probtrackx' ]; %no filesep
end
maskDir = [baseDir,filesep, 'masks_' atlas]; %no filesep
if ~exist(maskDir,'dir') && strcmpi(atlas,'jhu')
    maskDir = [baseDir,filesep, 'masks']; %no filesep
end
if ~exist(probDir,'dir') || ~exist(maskDir, 'dir')
    fprintf('%s skipped: can not find %s or %s\n',mfilename, probDir, maskDir);
    return
end
[label, numLabel] = labelSub (atlas);
if forceRecalc || ~isFieldSub(matName, ['dtimx_', atlas])
    fprintf('%s processing %s\n', mfilename, matName);
    if isempty(exeName)
        t_start=tic;
        [d, fc, mn, mx, ok] = fiberQXSub (maskDir, probDir, numLabel, num_samples);
        fprintf ('Quantify took %f seconds to run.\n', toc(t_start) );
    else
       cmd = sprintf('%s "%s" "%s" %d %d',exeName, maskDir, probDir, numLabel, num_samples);
       system(cmd,'-echo');
       mn = loadMtxSub(fullfile(maskDir, 'mean.mtx'), numLabel);
       mx = loadMtxSub(fullfile(maskDir, 'max.mtx'), numLabel);
       d = loadMtxSub(fullfile(maskDir, 'density.mtx'), numLabel);
       fc = loadMtxSub(fullfile(maskDir, 'fiber_count.mtx'), numLabel);
       ok = true;
    end

    if (ok)
        mergeSub(matName, mn, label, ['dtimn_', atlas]);
        mergeSub(matName, mx, label, ['dtimx_', atlas]);
        mergeSub(matName, d, label, ['dti_', atlas]);
        mergeSub(matName, fc, label, ['dtifc_', atlas]);
    else
       fprintf('%s failed with matName: %s basedir: %s\n', mfilename, matName, baseDir);
       fid = fopen('fiber_errors.txt', 'at');
       fprintf(fid, '%s\t%s\n',matName, baseDir);
       fclose(fid);
    end %if ok
else
	fprintf('%s of %s atlas skipped for %s (already computed)\n', mfilename, atlas, matName);
end

function mtx = loadMtxSub(fnm, nROI)
%load raw binary little-endian double-precision matrix
num = nROI * nROI;
f=dir(fnm);
if (isempty(f)) 
   error('Unable to find %s\n', fnm); 
end
if (f.bytes ~= (num * 8))
	error('Incorrect file size (expected %d*%d*8 bytes) %s', nROI, nROI, fnm);
end
fid=fopen(fnm,'rb'); % opens the file for reading
[mtx, COUNT] = fread(fid, num, 'double', 'ieee-le');
fclose(fid);
if COUNT ~= num
	error('Unable to read %s', fnm);
end;
mtx = reshape(mtx, nROI, nROI);
%end loadMatSub()

function is = isFieldSub(matname, fieldname)
is = false;
if ~exist(matname, 'file'), return; end;
m = load(matname);
is = isfield(m, fieldname);
%end isFieldSub

function mergeSub(matName, m, labels, statname)
%size(label,1)
%m = spm_load(txtName);
if size(m,1) ~= size(m,2), error('Matrix not square (number of columns and rows differ)'); end;
if size(labels,1) ~= size(m,1), error('Number of labels (%d) must match matrix (%d)',size(labels,1), size(m,1)); end;
stat.(statname).label = labels;
stat.(statname).r = m;
if length(matName) < 1, return; end
if exist(matName,'file')
    old = load(matName);
    %old = rmfield(old,statname);
%     if isfield(old,'rest_aal')
%         if max(old.rest_aal.r(:)) == min(old.rest_aal.r(:))
%             fprintf('WARNING: Please check resting state data of %s\n',matName);
%             old = rmfield(old,'rest_aal');
%             old = rmfield(old,'rest_aalcat');
%             old = rmfield(old,'rest_bro');
%             old = rmfield(old,'rest_cat');
%             old = rmfield(old,'rest_fox');
%             old = rmfield(old,'rest_jhu');
%         end
%       end
    stat = nii_mergestruct(stat,old);
end
save(matName, '-struct', 'stat');
%end mergeSub()

function [label, numLabel] = labelSub(atlas)
pth = fileparts(which('NiiStat'));
if isempty(pth), error('Unable to find NiiStat'); end;
pth = [pth filesep 'roi' filesep atlas '.txt'];
if ~exist(pth,'file'), error('Unable to find %s\n',pth); end;
fid = fopen(pth);  % Open file
label=[];
tline = fgetl(fid);
while ischar(tline)
    %disp(tline)
    label=strvcat(label,tline); %#ok<DSTRVCT,REMFF1>
    tline = fgetl(fid);
end
fclose(fid);
numLabel = size(label,1);
if numLabel < 2, error('%s unable to read %s', mfilename, pth); end;
%end labelSub()

function nameFolds=subFolderSub(pathFolder)
d = dir(pathFolder);
isub = [d(:).isdir];
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];
%end subFolderSub()

% function [mean_mat, max_mat, OK] = fiberQMeanMaxSub (maskDir, probDir)
% %maskDir = '/Volumes/SSD/P042/masks';
% %probDir = '/Volumes/SSD/P042/probtrackx';
% num_samples = 5000;
% knROI = 189; %number of regions of interest
% mean_mat = eye(knROI);
% max_mat = eye(knROI);
% nvox = nan;
% for i = 1:(knROI)
%     [im, vx] = imgSub(maskDir, i);
%     if ~isnan(vx)
%         nvox = numel(im);
%         break;
%     end
% end;
% if isnan(nvox)
%    error('No regions!');
% end
% OK = false;
% vx = zeros(knROI, 1);
% vxp = zeros(knROI, 1);
% img = zeros(knROI,nvox);
% imgp = zeros(knROI,nvox);
%
% for i = 1:(knROI)
%     [im, vx(i)] = imgSub(maskDir, i);
%     if ~isempty(im), img(i,:) = im; end;
%     [im, vxp(i)] = imgSubP(probDir, i); %#ok<AGROW,NASGU>
%     if ~isempty(im), imgp(i,:) = im; end;
% end;
% %fprintf('images loaded\n');
% for i = 1:(knROI-1)
%     if ~isnan(vx(i)) && ~isnan(vxp (i))
%         %if mod(i,10) == 0, fprintf('Row %d\n', i); end;
%         for j = i+1 : knROI
%             if ~isnan(vx(j)) && ~isnan(vxp(j))
%                 %fprintf('%dx%d\n',i,j);
%                 OK = true;
%                 [ij_mean, ij_max] = fslstatsKMeanMaxSub (imgp(i,:), img(j,:));
%                 [ji_mean, ji_max] = fslstatsKMeanMaxSub (imgp(j,:), img(i,:));
%                 %fprintf('i %d j %d iVox %d, jVox %d ji_mean %g ij_mean %g norm %g density %g\n', i, j, voxi, voxj, ji_mean, ij_mean, normalizing_factor, density);
%                 mean_mat(i,j) = ij_mean+ji_mean;
%                 mean_mat(j,i) = mean_mat(i,j);
%                 %ij_max = fslstatsKMaxSub (imgp(i,:), img(j,:));
%                 %ji_max = fslstatsKMaxSub (imgp(j,:), img(i,:));
%
%                 max_mat(i,j) = ij_max+ji_max;
%                 max_mat(j,i) = max_mat(i,j);
%                 %fprintf('%gx%g\n',fiber_count, density); error('1123');
%             end %j not empty
%          end %for j
%     end %i not empty
% end
% mean_mat( ~isfinite(mean_mat)) = 0;
% max_mat( ~isfinite(max_mat)) = 0;
% %end fiberQ2Sub()


function [density_mat, fiber_count_mat, mean_mat, max_mat, OK] = fiberQXSub (maskDir, probDir, numLabel, num_samples)
%maskDir = '/Volumes/SSD/P042/masks';
%probDir = '/Volumes/SSD/P042/probtrackx';
OK = false;
knROI = numLabel; %number of regions of interest
density_mat = eye(knROI);
fiber_count_mat = eye(knROI);
mean_mat = eye(knROI);
max_mat = eye(knROI);
nvox = nan;
for i = 1:(knROI)
    [im, vx] = imgSub(maskDir, i);
    if ~isnan(vx)
        nvox = numel(im);
        break;
    end
end;
if isnan(nvox)
   error('No regions!');
end
vx = zeros(knROI, 1);
vxp = zeros(knROI, 1);
img = zeros(knROI,nvox);
imgp = zeros(knROI,nvox);
nROI = 0;
for i = 1:(knROI)
    [im, vx(i)] = imgSub(maskDir, i);
    if ~isempty(im), img(i,:) = im; end;
    [im, vxp(i)] = imgSubP(probDir, i); %#ok<AGROW,NASGU>
    if ~isempty(im),
        imgp(i,:) = im;
        nROI = nROI + 1;
    end;
end;
%cr 02032016 - parfor provides virtually no benefit, I don't know why
fprintf('Found %d of %d ROIs (serial processing)\n', nROI, knROI);
for i = 1:(knROI-1)
    if ~isnan(vx(i)) && ~isnan(vxp (i))
        %if mod(i,10) == 0, fprintf('Row %d\n', i); end;
        for j = i+1 : knROI
            if ~isnan(vx(j)) && ~isnan(vxp(j))
                %fprintf('%dx%d\n',i,j);
                OK = true;
                [ij_mean, ij_max] = fslstatsKMeanMaxSub (imgp(i,:), img(j,:));
                [ji_mean, ji_max] = fslstatsKMeanMaxSub (imgp(j,:), img(i,:));
                mean_mat(i,j) = ij_mean+ji_mean;
                mean_mat(j,i) = mean_mat(i,j);
                max_mat(i,j) = ij_max+ji_max;
                max_mat(j,i) = max_mat(i,j);
                ij_mean = fslstatsKSub (imgp(i,:), img(j,:));
                ji_mean = fslstatsKSub (imgp(j,:), img(i,:));
                %fprintf('%gx%g\n',ij_mean, ji_mean); error('mean check');
                ij_sum= ij_mean * vx(j);
                ji_sum= ji_mean * vx(i);
                fiber_count = ij_sum + ji_sum;
                normalizing_factor = (vx(i) + vx(j) ) * ( num_samples + 1 );
                density = fiber_count/normalizing_factor;
                %fprintf('i %d j %d iVox %d, jVox %d ji_mean %g ij_mean %g norm %g density %g\n', i, j, voxi, voxj, ji_mean, ij_mean, normalizing_factor, density);
                density_mat(i,j) = density;
                density_mat(j,i) = density;
                fiber_count_mat(i,j) = fiber_count;
                fiber_count_mat(j,i) = fiber_count;
                %fprintf('%gx%g\n',fiber_count, density); error('1123');
            end %j not empty
         end %for j
    end %i not empty
end
density_mat( ~isfinite(density_mat)) = 0;
fiber_count_mat( ~isfinite(fiber_count_mat)) = 0;
mean_mat( ~isfinite(mean_mat)) = 0;
max_mat( ~isfinite(max_mat)) = 0;
%end fiberQXSub()

function [imgi,voxi] = imgSubP(dir, index)
inam = fullfile(dir, sprintf('%d',index), 'fdt_paths.nii.gz');
imgi = []; voxi = nan;
if ~exist(inam,'file')
    fprintf('Unable to find %s\n', inam);
	return
end;
[~, imgi] = readNiftiSub(inam);
imgi = imgi(:);
voxi = sum(imgi > 0);
%end imgSub()

function [imgi,voxi] = imgSub(dir, index)
inam = fullfile(dir, [sprintf('%03d',index), '.nii.gz']);
imgi = []; voxi = nan;
if ~exist(inam,'file')
    inam = fullfile(dir, [sprintf('%d',index), '.nii.gz']);
    if ~exist(inam,'file')
        %fprintf('Unable to find %s\n', inam);
        return
    end
    %error('Unable to find %s', inam);
end;
[~, imgi] = readNiftiSub(inam);
imgi = imgi(:);
voxi = sum(imgi > 0);
%end imgSub()

%function mn = fslstatsKMaxSub (img, mask) %448sec (262sec in -m mode)
%emulates "fslstats img -k mask -M" or "fslstats img -k mask -m"
%this next line is required for -M, but has big speed influence...
%mask(img == 0) = 0; %-M = mean for non-zero voxels, -m for mean
%mn = mean(img(mask > 0));
%end fslstatsKSub()


function [mn, mx] = fslstatsKMeanMaxSub (img, mask) %448sec (262sec in -m mode)
%emulates "fslstats img -k mask -M" or "fslstats img -k mask -m"
%this next line is required for -M, but has big speed influence...
%mask(img == 0) = 0; %-M = mean for non-zero voxels, -m for mean
mn = mean(img(mask > 0));
mx = max(img(mask > 0));
if isempty(mx)
    mn = 0;
    mx = 0;
end
%end fslstatsKSub()


%function mn = fslstatsKSubX (img, mask) %448sec (262sec in -m mode)
%emulates "fslstats img -k mask -M" or "fslstats img -k mask -m"
%this next line is required for -M, but has big speed influence...
%mask(img == 0) = 0; %-M = mean for non-zero voxels, -m for mean
%mn = mean(img(mask > 0));
%end fslstatsKSub()

%function mn = fslstatsKSub (img, mask) %368sec
%emulates fslstats img -k mask -M
%i = img(mask > 0);
%i = i(i ~= 0); %non-zero mean %i = i(i > 0); %non-zero mean
%mn = mean(i);
%end fslstatsKSub()

%function mn = fslstatsKSub (img, mask) %399sec
%emulates fslstats img -k mask -M
%mask(img == 0) = 0;
%mn = mean(img(mask ~= 0));
%end fslstatsKSub()

function mn = fslstatsKSub (img, mask) %301sec
%emulates fslstats img -k mask -M
i = img(mask ~= 0);
mn = mean(i(i ~= 0));
mn(isnan(mn))=0; %as conditional: if isnan(mn),mn=0; end;
%end fslstatsKSub()


function [hdr, img] = readNiftiSub(filename, open4D)
%function [hdr, img] = readNifti(filename)
%load NIfTI (.nii, .nii.gz, .hdr/.img) image and header
% filename: image to open
%To do:
%  endian: rare, currently detected and reported but not handled
%Examples
% hdr = nii_loadhdrimg('myimg.nii');
% [hdr, img] = nii_loadhdrimg('myimg.nii');
% [hdr, img] = nii_loadhdrimg('img4d.nii', true);

if ~exist('filename','var')  %fnmFA not specified
   [A,Apth] = uigetfile({'*.nii;*.gz;*.hdr;';'*.*'},'Select image');
   filename = [Apth, A];
end
if ~exist('open4D','var')  %fnmFA not specified
	open4D = false;
end
[fpth, fnam,fext] = fileparts(filename);
if strcmpi(fext,'.img') %hdr/img pair
    filename = fullfile(fpth, [fnam, '.hdr']);
end
if ~exist(filename, 'file')
    error('Unable to find file %s', filename);
end
%load data
if strcmpi(fext,'.gz') %unzip compressed data
	%http://undocumentedmatlab.com/blog/savezip-utility
%http://www.mathworks.com/matlabcentral/fileexchange/39526-byte-encoding-utilities/content/encoder/gzipdecode.m
    streamCopier = com.mathworks.mlwidgets.io.InterruptibleStreamCopier.getInterruptibleStreamCopier;
    baos = java.io.ByteArrayOutputStream;
    fis  = java.io.FileInputStream(filename);
    zis  = java.util.zip.GZIPInputStream(fis);
    streamCopier.copyStream(zis,baos);
    fis.close;
    data = baos.toByteArray;
else
    fileID = fopen(filename);
    data = fread(fileID);
    data = uint8(data);
    fclose(fileID);
end
%read header
hdr = spm_vol_Sub(filename, data);
if ~open4D
    hdr.dim = hdr.dim(1:3); %no non-spatial dimensions
    Hdr.private.dime(5:8) = 1; %no non-spatial dimensions
    Hdr.private.dime(1) = 3; %3D file

end
if nargout < 2, return; end; %only read image if requested
if strcmpi(fext,'.hdr') || strcmpi(fext,'.img') %analyze style .hdr and .img pairs
    if ~exist(Hdr.fname, 'file')
        error('Unable to find image %s', Hdr.fname);
    end
    fileID = fopen(Hdr.fname);
    data = fread(fileID);
    data = uint8(data);
    fclose(fileID);
end
img = spm_read_vols_Sub(hdr, data);
%end nii_loadhdrimg()

function img = spm_read_vols_Sub(hdr, data)
% --- load NIfTI voxel data: mimics spm_read_vol without requiring SPM
switch hdr.dt(1)
   case   2,
      bitpix = 8;  myprecision = 'uint8';
   case   4,
      bitpix = 16; myprecision = 'int16';
   case   8,
      bitpix = 32; myprecision = 'int32';
   case  16,
      bitpix = 32; myprecision = 'single';%'float32';
   case  64,
      bitpix = 64; myprecision = 'double';%'float64';
   case 512
      bitpix = 16; myprecision = 'uint16';
   case 768
      bitpix = 32; myprecision = 'uint32';
   otherwise
      error('This datatype is not supported');
end
if numel(hdr.dim) > 3
    nVol = prod(hdr.dim(4:end));
else
    nVol = 1; %3D data has only a single volume
end
myvox = hdr.dim(1)*hdr.dim(2)*hdr.dim(3)*nVol;
%ensure file is large enough
imgbytes = myvox * (bitpix/8); %image bytes plus offset
if (imgbytes+hdr.pinfo(3)) > numel(data)
    fprintf('Error: expected %d but file has %d bytes %s',imgbytes, file_stats.bytes,hdr.fname);
    return;
end;
%read data
img = typecast(data(hdr.pinfo(3)+1:hdr.pinfo(3)+imgbytes),myprecision);%fread(fid, myvox, myprecision, 0, myformat);
img = double(img);
img = img(:).*hdr.pinfo(1)+hdr.pinfo(2); %apply scale slope and intercept
img = reshape(img, hdr.dim(1), hdr.dim(2), hdr.dim(3), nVol);
%end spm_read_vols_Sub()

function [Hdr] = spm_vol_Sub(filename, data)
[h, machine] = readHdrSub (data);
nDim = find(h.dime.dim > 1,1,'last') -1; %-1 since dim[2]=x, dim[3]=y, etc
if nDim < 3, nDim = 3; end;
Hdr.dim = ones(1,nDim);
for i = 1: nDim
    if (h.dime.dim(i+1) > 0), Hdr.dim(i) = h.dime.dim(i+1); end;
end
%Hdr.dim
%Hdr.dim = double([h.dime.dim(2) h.dime.dim(3) h.dime.dim(4)]);
%Hdr.dim
if (h.hist.sform_code == 0) && (h.hist.qform_code == 0)
    fprintf('Warning: no spatial transform detected. Perhaps Analyze rather than NIfTI format');
    Hdr.mat = fileUtils.nifti.hdr.hdr2m(h.dime.dim,h.dime.pixdim );
elseif (h.hist.sform_code == 0) && (h.hist.qform_code > 0) %use qform Quaternion only if no sform
    Hdr.mat = fileUtils.nifti.hdr.quarternion.hdrQ2m(h.hist,h.dime.dim,h.dime.pixdim );
else %precedence: get spatial transform from matrix (sform)
    Hdr.mat = [h.hist.srow_x; h.hist.srow_y; h.hist.srow_z; 0 0 0 1];
    Hdr.mat = Hdr.mat*[eye(4,3) [-1 -1 -1 1]']; % mimics SPM: Matlab arrays indexed from 1 not 0 so translate one voxel
end;
if strcmpi(machine, 'ieee-le')
	Hdr.dt = [h.dime.datatype 0];
else
	Hdr.dt = [h.dime.datatype 1];
end;
Hdr.pinfo = [h.dime.scl_slope; h.dime.scl_inter; h.dime.vox_offset];
if isExt('.hdr',filename)
	[pth, nam] = fileparts(filename);
    Hdr.fname =  fullfile(pth, [nam '.img']); %if file.hdr then set to file.img
else
	Hdr.fname =  filename;
end
Hdr.descrip = h.hist.descrip;
Hdr.n = [h.dime.dim(5) 1];
Hdr.private.hk = h.hk;
Hdr.private.dime = h.dime;
Hdr.private.hist = h.hist;
%end spm_vol_Sub()

function isMatch = isExt(x, fname)
% extends John Ashburner's spm_fileparts.m to include '.nii.gz' as ext
isMatch = false;
[pth,nam,ext] = fileparts(deblank(fname));
if strcmpi(ext, x)
   [pth nam ext] = fileparts(fullfile(pth, nam));
   isMatch = true;
end
%end isExt()


function [h, machine] = readHdrSub (data)
machine = 'ieee-le';
%read header key
hk.sizeof_hdr = typecast(data(1:4),'int32');
if swapbytes(hk.sizeof_hdr) == 348
   error('%s error: NIfTI image has foreign endian (solution: convert with dcm2nii)',mfilename);
end
if hk.sizeof_hdr ~= 348
    error('%s error: first byte of NIfTI image should be 348',mfilename);
end
hk.data_type =char(data(5:14));
hk.db_name =char(data(15:32));
hk.extents  = typecast(data(33:36),'int32');
hk.session_error = typecast(data(37:38),'int16');
hk.regular       = char(data(39));
hk.dim_info      = typecast(data(40),'uint8');
%next read dimensions
dime.dim        = typecast(data(41:56),'int16')';
dime.intent_p1  = typecast(data(57:60),'single')';
dime.intent_p2  = typecast(data(61:64),'single')';
dime.intent_p3  = typecast(data(65:68),'single')';
dime.intent_code= typecast(data(69:70),'int16')';
dime.datatype   = typecast(data(71:72),'int16')';
dime.bitpix     = typecast(data(73:74),'int16')';
dime.slice_start= typecast(data(75:76),'int16')';
dime.pixdim     = typecast(data(77:108),'single')';
dime.vox_offset = typecast(data(109:112),'single')';
dime.scl_slope  = typecast(data(113:116),'single')';
dime.scl_inter  = typecast(data(117:120),'single')';
dime.slice_end  = typecast(data(121:122),'int16')';
dime.slice_code = typecast(data(123),'uint8');
dime.xyzt_units = typecast(data(124),'uint8');
dime.cal_max    = typecast(data(125:128),'single')';
dime.cal_min    = typecast(data(129:132),'single')';
dime.slice_duration= typecast(data(133:136),'single')';
dime.toffset    = typecast(data(137:140),'single')';
dime.glmax      = typecast(data(141:144),'int32')';
dime.glmin      = typecast(data(145:148),'int32')';
%read history
hist.descrip     = char(data(149:228));
hist.aux_file    = char(data(229:252));
hist.qform_code  = typecast(data(253:254),'int16')';
hist.sform_code  = typecast(data(255:256),'int16')';
hist.quatern_b   = typecast(data(257:260),'single')';
hist.quatern_c   = typecast(data(261:264),'single')';
hist.quatern_d   = typecast(data(265:268),'single')';
hist.qoffset_x   = typecast(data(269:272),'single')';
hist.qoffset_y   = typecast(data(273:276),'single')';
hist.qoffset_z   = typecast(data(277:280),'single')';
hist.srow_x      = typecast(data(281:296),'single')';
hist.srow_y      = typecast(data(297:312),'single')';
hist.srow_z      = typecast(data(313:328),'single')';
hist.intent_name = char(data(329:344));
hist.magic       = char(data(345:347))';
if ~strcmp(hist.magic, 'n+1') && ~strcmp(hist.magic, 'ni1')
    hist.qform_code = 0;
    hist.sform_code = 0;
end %old analyze format image
hist.originator  = typecast(data(253:262),'int16')'; %used by SPM2 and earlier
h.hk = hk; h.dime = dime; h.hist = hist;
%end readHdrSub()