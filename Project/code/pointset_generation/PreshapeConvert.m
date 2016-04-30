function [ preshapePointSet ] = PreshapeConvert( inpPointSet )
%PreshapeConvert conver pointsets to preshape space
centroid = sum(inpPointSet)/size(inpPointSet,1);
preshapePointSet = [inpPointSet(:,1) - centroid(1), ...
    inpPointSet(:,2) - centroid(2)];

norm = sqrt(sum(preshapePointSet.^2));
preshapePointSet = [preshapePointSet(:,1)./norm(1), ...
    preshapePointSet(:,2)./centroid(2)];


end

