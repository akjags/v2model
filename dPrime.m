function d = dPrime(dist1, dist2)
% Given 2 distributions, calculates the d' between them
%

d = (mean(dist1) - mean(dist2)) / (sqrt(0.5*(var(dist1) + var(dist2))));
