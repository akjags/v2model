% metamerDistance
%    
%    Given two sets of parameters, calculates the multidimensional distance between them.
%
%    Usage:
%      p1 = getMetamerParams(params.p1_s3_07);
%      p2 = getMetamerParams(params.p2_s3_07);
%      dp = metamerDistance(p1, p2);
%      dp = metamerDistance(p1, p2, 'compFunc=2') % max difference pool
%      dp = metamerDistance(p1, p2, 'compFunc=1') % mean difference across pools (default)
%
%    Inputs:
%      - p1, p2: Params structs containing metamer params
%      - varargin:
%         - 'distFunc=1' or 'distFunc=2': either vector distance, or dprime
%         - 'compFunc=1' or 'compFunc=2': either mean or max
%
function dp = metamerDistance(p1, p2, varargin)

%% Get args
compFunc = 1; distFunc = 1;
getArgs(varargin);
if distFunc == 1, distFunc = @pdist2;
else, distFunc = @dPrime; 
end
if compFunc == 1, compFunc = @mean;
else, compFunc = @max;
end

% Get relevant texture statistics
M1 = getRelevantParams(p1);
M2 = getRelevantParams(p2);

% Compute multidimensional distance between corresponding pooling regions
dp = [];
for i = 1:size(M1,2)
  dp(i) = distFunc(M1(:,i)', M2(:,i)');
end

dp = compFunc(dp);

% getRelevantParams(p)
%    Usage:
%      p = params.p1_s3_07;
%      a = getRelevantParams(p);
%   Inputs:
%      params struct containing all the texture analysis params
%   Returns: 
%      relevant parameters for distinguishing metamers, including:
%         - pixel stats: mean, variance, skew, kurtosis
%         - variance HPR
%         - LP skew, LPkurt 
function a = getRelevantParams(p)

a = p.pixelStats(1:4,:);
a = [a; p.varianceHPR];
b = [p.LPskew.scale{1}; p.LPskew.scale{2}; p.LPskew.scale{3}; p.LPskew.scale{4}; p.LPskew.scale{5}];
b1 = [p.LPkurt.scale{1}; p.LPkurt.scale{2}; p.LPkurt.scale{3}; p.LPkurt.scale{4}; p.LPkurt.scale{5}];
a = [a; b; b1];

c = [p.magMeans.band{:}]; a = [a; c'];


% meanMaxN(V, n)
%    Given a vector V, computes the mean of the largest 3 elements.
%
function m = meanMaxN(V, n)

if ieNotDefined('n')
  n = 3;
end

a = sort(V, 'descend');
m = mean(a(1:n));

