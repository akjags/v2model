% plotScaleMatrix.m
%
%     Plots a color matrix of the distance between metamers generated with the same scaling constant,
%      when analyzed by a model using one of 3 different scaling constants.
%
%     Usage: 
%        params = load('save/params.mat');
%        plotScaleMatrix(params); % default distFunc=1 (vector distance) and compFunc=1 (mean)
%        plotScaleMatrix(params, 'distFunc=2') % use distance function dPrime
%        plotScaleMatrix(params, 'compFunc=2') % use pooling region of maximum difference, rather than mean
%
%     Inputs:
%        - p: Structure of params, containing substructs each of which are metamer texture statistics.
%        - varargin:
%           - 'distFunc': possible values 1 or 2 denoting vector distance or dPrime
%           - 'compFunc': possible values 1 or 2 denoting mean or max.
function mtx = plotScaleMatrix(p, varargin)

% Get arguments
plotControl = 0; distFunc = 1; compFunc = 1;
getArgs(varargin);
if distFunc == 1, df = 'vector distance'; else, df = 'dPrime'; end
if compFunc == 1, cf = 'mean'; else, cf = 'max'; end
v = varargin;

scales = [3 5 7];

mtx = nan(3,3+plotControl);
for i = 1:3
  for j = 1:3
    s1 = scales(i); s2 = scales(j);
    p1 = p.(sprintf('p1_s%d_0%d', s1, s2));
    p2 = p.(sprintf('p2_s%d_0%d', s1, s2));
    p3 = p.(sprintf('p3_s%d_0%d', s1, s2));

    d1 = metamerDistance(p1, p2, v{:});
    d2 = metamerDistance(p1, p3, v{:});
    d3 = metamerDistance(p2, p3, v{:});

    mtx(j,i) = mean([d1, d2, d3]);


    c = p.(sprintf('control_0%d', s2));
    if plotControl
      mtx(j,4) = mean([metamerDistance(p1,c,v{:}), metamerDistance(p2,c,v{:}), metamerDistance(p3,c,v{:})]);
    end
  end
end


a = mat2str(mtx(:));
b = strsplit(a(2:end-1), ';');

figure;
imagesc(mtx); colormap('hot'); colorbar; hold on;
xlabel('Synthesis generation scaling', 'FontSize', 18);
ylabel('Model analysis scaling', 'FontSize', 18);
set(gca, 'XTick', 1:size(mtx,2));
set(gca, 'YTick', 1:size(mtx,1));
set(gca, 'XTickLabel', {'0.3', '0.5', '0.7', 'control'});
set(gca, 'YTickLabel', {'0.3', '0.5', '0.7'});
title(sprintf('Metameric distance (%s %s)', cf, df), 'FontSize', 20);
set(gca, 'FontSize', 14);

x = vectify(repmat(1:3+plotControl, 3, 1))'; y = repmat(1:3,1,3+plotControl);
text(x, y, b, 'Color', 'b', 'HorizontalAlignment', 'center', 'FontSize', 16, 'FontWeight', 'bold');

