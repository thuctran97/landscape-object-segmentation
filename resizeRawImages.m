function imds = resizeRawImages(imds, imageFolder, size)
if ~exist(imageFolder,'dir') 
    mkdir(imageFolder)
else
    imds = imageDatastore(imageFolder);
    return; 
end
reset(imds)
while hasdata(imds)
    [I,info] = read(imds);     
    I = imresize(I,[size size*4/3]);    
    [~, filename, ext] = fileparts(info.Filename);
    imwrite(I,[imageFolder filename ext])
end

imds = imageDatastore(imageFolder);
end