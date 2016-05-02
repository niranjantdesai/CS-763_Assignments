function param = KCPRegiatration(modelpoints, Psample, variance)

% Pmodel input set of points to be correlated wtih sample
% Psample output set of points to be correlated wtih model points

global Pmodel;
Pmodel = modelpoints;
global bandwidth;
bandwidth = variance;

KDE_M = CalculateKDE(Pmodel, bandwidth);

options = optimset('MaxFunEvals',10000,'MaxIter',10000,'TolFun',1e-6,'TolX',1e-9);
param = fminsearch('CostFunction',[1 0 0 1 0 0] ,options);

% affine transforamtions used as it includes all 2-D transformations
% output in homogenous coordinatets


end