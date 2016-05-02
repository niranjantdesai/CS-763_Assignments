function Cost = CostFunction(A);

global Pmodel;
global bandwidth;

NewPoints = TransformPoint(A, Pmodel);

Model_KDE = CalculateKDE(Pmodel, bandwidth);
Estimated_KDE = CalculateKDE(NewPoints, bandwidth);

Cost = -sum(sum(Model_KDE.*Estimated_KDE));

end