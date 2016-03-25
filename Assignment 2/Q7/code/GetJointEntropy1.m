function [ prob, jointEntropy] = GetJointEntropy1( in1,in2 )
%GetJointEntropy1 Estimates joint entropy using histograms

% assume input bounded between 0 and 1 (inclusive)

% Discarding out of space from candidate (input 2)
in2(in2==0)=NaN;

% bin widhts 10 along both X and Y

binEdges = 0:10/255:1;
binEdges(1)=0;

prob = histcounts2(in1,in2,binEdges,binEdges,'Normalization','probability');

jointEntropy = -sum(nansum(prob.*log2(prob)));


end

