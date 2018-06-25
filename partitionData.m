function [imdsTrain, imdsTest, pxdsTrain, pxdsTest] = partitionData(imds,pxds)

rng(0); 
numFiles = numel(imds.Files);
shuffledIndices = randperm(numFiles);
N = round(0.9* numFiles);
trainingIdx = shuffledIndices(1:N);
testIdx = shuffledIndices(N+1:end);

trainingImages = imds.Files(trainingIdx);
testImages = imds.Files(testIdx);
imdsTrain = imageDatastore(trainingImages);
imdsTest = imageDatastore(testImages);

classes = pxds.ClassNames;
labelIDs = 1:numel(pxds.ClassNames);

trainingLabels = pxds.Files(trainingIdx);
testLabels = pxds.Files(testIdx);
pxdsTrain = pixelLabelDatastore(trainingLabels, classes, labelIDs);
pxdsTest = pixelLabelDatastore(testLabels, classes, labelIDs);
end