% generateMetamers.m
%
% Given an image, a name (savename), and a scale, this function generates metamers.
%
%  Inputs:
%    - imstr: string path to the .png image
%    - name: name to save the file under
%    - scale: Critical scaling constant with which to generate metamers
%    - numMetamers: Number of metamers to generate and output.
%
function [res, params] = generateMetamers(imstr, name, scale, numMetamers, outputPath)

% Specify unspecified inputs
if ieNotDefined('imstr')
  imstr = 'trafGray.png';
end
if ieNotDefined('scale')
  scale = 0.5;
end
if ieNotDefined('numMetamers')
  numMetamers = 1;
end
if ieNotDefined('name')
  name = '';
end

disp(sprintf('(generateMetamers) Generating %d metamers with scaling %g', numMetamers, scale));

% Path to save synthesized metamers in
if ieNotDefined('outputPath')
  outputPath = fullfile(pwd, 'output');
end

% Load image
oim = double(imread(imstr));

% Set options
opts = metamerOpts(oim, 'windowType=radial', 'printing=0', sprintf('scale=%g', scale), sprintf('outputPath=%s', outputPath));

% Make windows
t1 = tic;
m = mkImMasks(opts);
toc(t1);

% Get metamer analysis params
t2 = tic;
params = metamerAnalysis(oim, m, opts);
toc(t2);
params.imStr = imstr;
params.scale = scale;

% Synthesize metamers
for mi = 1:numMetamers
  x = sprintf('%ssynth%d_s%g', name, mi, scale*10);
  t3 = tic;
  synth = metamerSynthesis(params, size(oim), m, opts);
  imwrite(uint8(synth), sprintf('%s/%s.png', outputPath, x));
  res.(x) = synth;
  toc(t3);
end

res.params = params;
