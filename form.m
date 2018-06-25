function varargout = form(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @form_OpeningFcn, ...
                   'gui_OutputFcn',  @form_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function form_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = form_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function pushbutton1_Callback(hObject, eventdata, handles)
[filename pathname] = uigetfile({'*.jpg';'*.png'},'File Selector');
testImage = strcat(pathname,filename);
axes(handles.axes1)
imshow(testImage)
set(handles.edit1,'string',filename);
handles.image = testImage;
guidata(hObject,handles);


function mainProcess(projectDir,handles)

imageFolder = fullfile(projectDir,'Images');
labelFolder = fullfile(projectDir,'Labels');
imds = imageDatastore(imageFolder);
classes = initClasses;
labelIDs = setPixelLabelIDs();
pxds = pixelLabelDatastore(labelFolder,classes,labelIDs); 

size = 180;

imageFolder = fullfile(projectDir,'imagesResized',filesep);
imds = resizeRawImages(imds,imageFolder,size);

labelFolder = fullfile(projectDir,'labelsResized',filesep);
pxds = resizePixelLabelsImages(pxds,labelFolder,size);

[imdsTrain,imdsTest,pxdsTrain,pxdsTest] = partitionData(imds,pxds);

imageSize = [size size*4/3 3];
numClasses = numel(classes);
layers = segnetLayers(imageSize,numClasses,'vgg16');

options = trainingOptions('sgdm', ...
    'Momentum',0.9, ...
    'InitialLearnRate',1e-3, ...
    'MaxEpochs',50, ...  
    'MiniBatchSize',5, ...
    'Shuffle','every-epoch', ...
    'VerboseFrequency',4);

pximds = pixelLabelImageDatastore(imdsTrain,pxdsTrain);
doTraining = false;
if doTraining    
    [net, info] = trainNetwork(pximds,layers,options);
else
    trainedNet = fullfile(projectDir,'trainedNet_7c_180240.mat');
    data = load(trainedNet);
    net = data.net;
end
% net.Layers

path = handles.image;
I = imread(path);
C = semanticseg(I, net);
cmap = setColorMap;
B = labeloverlay(I,C,'Colormap',cmap,'Transparency',0.4);
axes(handles.axes2)
imshow(B)
pixelLabelColorbar(cmap, classes);

% pxdsResults = semanticseg(imdsTest,net,'Verbose',false);
% metrics = evaluateSemanticSegmentation(pxdsResults,pxdsTest,'Verbose',false);
% metrics.DataSetMetrics


function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton2_Callback(hObject, eventdata, handles)
mainProcess('link to project',handles);
