evansIndex = calculateEvansIndex('C:\Users\Rowland Lab\Documents\NPH_study\PatientData\Allaire\preopct\vent\frontal_horn.nii', 'C:\Users\Rowland Lab\Documents\NPH_study\PatientData\Allaire\preopct\c4w95653840_1.6_TRAUMA_H_FACE_CSP_EXAM_SPLIT_20170417162825_2a_Tilt_1.nii')

%% fUNCTIONS
function evansIndex = calculateEvansIndex(ventricleNiftiFile, skullNiftiFile)
% Load NIfTI files
ventricleVol = niftiread(ventricleNiftiFile);
skullVol = niftiread(skullNiftiFile);

% Calculate the maximum width of the frontal horns of the lateral ventricles
[ventricleMaxWidth, maxSlice] = getMaxWidth(ventricleVol);

% Calculate the maximal internal diameter of the skull
skullMaxDiameter = getMaxDiameter(skullVol,maxSlice);

% Calculate the Evans Index
evansIndex = ventricleMaxWidth / skullMaxDiameter;

figure;
nexttile
title(['ventricles- ' num2str(ventricleMaxWidth)])
imagesc(ventricleVol(:,:,maxSlice))
nexttile
title(['skull- ' num2str(skullMaxDiameter)])
imagesc(skullVol(:,:,maxSlice))
sgtitle(num2str(evansIndex))
end

function [maxWidth, slice] = getMaxWidth(ventricleVol)
binaryVentricle = ventricleVol > 0;
max_brain = [];
for a = 1:size(binaryVentricle,3)
    ax_slice = binaryVentricle(:,:,a);
    max_ax = [];
    for i = 1:size(ax_slice,2)
        col_slice = ax_slice(:,i);
        range = find(col_slice);
        if any(range)
            col_slice(range(1):range(end)) = true;
        end
        tempdis = bwdist(~col_slice);
        [M,I] = max(tempdis);
        max_ax = [max_ax M];
    end
    [M,I] = max(max_ax);
    max_brain = [max_brain;M];
end
[max_distance,slice] = max(max_brain);
maxWidth = max_distance*2;

end

function maxDiameter = getMaxDiameter(skullVol,slice)
binarySkull = skullVol(:,:,slice) > 0;
max_ax = [];
for i = 1:size(binarySkull,2)
    col_slice = binarySkull(:,i);
    range = find(col_slice);
    max_ax = [max_ax; range(end)-range(1)];
end
maxDiameter = max(max_ax);
end
