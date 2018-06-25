function pxds = resizePixelLabelsImages(pxds, labelFolder,size)
classes = pxds.ClassNames;
labelIDs = 1:numel(classes);
if ~exist(labelFolder,'dir')
    mkdir(labelFolder)
else
    pxds = pixelLabelDatastore(labelFolder,classes,labelIDs);
    return;
end

reset(pxds)
while hasdata(pxds)
    [C,info] = read(pxds);
    L = uint8(C);
    L = imresize(L,[size size*4/3],'nearest');
    [~, filename, ext] = fileparts(info.Filename);
    imwrite(L,[labelFolder filename ext])
end

labelIDs = 1:numel(classes);
pxds = pixelLabelDatastore(labelFolder,classes,labelIDs);
end