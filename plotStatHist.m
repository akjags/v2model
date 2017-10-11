function plotStatHist(s1, s2, s3)
% Given two structs containing parameters, plot the histograms comparing all 4 features.
%

map = brewermap(3,'Set1');

stats = {'mean', 'variance', 'skew', 'kurtosis'};
figure;
for i = 1:4
  x1 = s1.pixelStats(i,:);
  x2 = s2.pixelStats(i,:);

  subplot(4,1,i);

  bins1 = min(x1):1:max(x1);
  bins2 = min(x2):0.1:max(x2);

  histf(x1, 'facecolor', map(1,:), 'facealpha', 0.7); hold on;
  histf(x2, 'facecolor', map(2,:), 'facealpha', 0.7);
  vline(median(x1), 'r');
  vline(median(x2), 'b');
  if ~ieNotDefined('s3')
    x3 = s3.pixelStats(i,:);
    histf(x3/trapz(x3), 'facecolor', map(3,:), 'facealpha', 0.7);
    vline(mean(x3), map(3,:));
  end
  title(stats{i}, 'FontSize', 14);
end

if ~ieNotDefined('s3')
  legend('Scaling: 0.3', 'Scaling: 0.5', 'Scaling: 0.7');
else
  legend('Scaling: 0.5', 'Scaling: 0.7');
end

figure;
lps = {'LPskew', 'LPkurt'};
for i = 1:2
  lp = lps{i};

  x1 = s1.(lp);
  x2 = s2.(lp);
  dp = [];
  for j = 1:5
    subplot(5,2, 5*(i-1)+j);
    histf(x1.scale{j}, 'facecolor', map(1,:), 'facealpha', 0.7); hold on;
    histf(x2.scale{j}, 'facecolor', map(2,:), 'facealpha', 0.7);
    vline(median(x1.scale{j}), 'r');
    vline(median(x2.scale{j}), 'b');
    title(sprintf('%s Scale: %g', lp, j), 'FontSize', 14);
  end
end
  
