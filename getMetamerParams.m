% getMetamerParams.m
%
%    Computes the summary statistic texture parameters for an image.
%
%    Usage: getMetamerParams('trafGray.png', 0.5);
%
%    Inputs:
%       - imStr: path to image (.png) (default 'trafGray.png')
%       - scale: Critical scaling constant of the model. (default: 0.5)
%
function params = getMetamerParams(imStr, scale)

if ieNotDefined('imStr')
  imStr = 'trafGray.png';
end

if ieNotDefined('scale')
  scale = 0.5;
end

% load original image
oim = double(imread(imStr));

% set options
opts = metamerOpts(oim,'windowType=radial',sprintf('scale=%d',scale),'aspect=2');

% make windows
t1 = tic;
m = mkImMasks(opts);
toc(t1);

% plot windows
%plotWindows(m,opts);

% do metamer analysis on original (measure statistics)
t2 = tic;
params = metamerAnalysis(oim,m,opts);
toc(t2);
params.imStr = imStr;
params.scale = scale;
