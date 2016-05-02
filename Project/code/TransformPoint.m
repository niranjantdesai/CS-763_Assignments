function NewPoints = TransformPoint(A,Points);

sizeP = size(Points);

temp = reshape(A,2,3);
NewPoints = (temp * [Points'; ones(1,sizeP(1))])';

end