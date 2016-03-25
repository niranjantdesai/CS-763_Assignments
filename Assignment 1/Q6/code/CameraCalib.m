function M = CameraCalib(P1,P )
%CameraCalib Estimates the projection matrix M from the camera and world
%coordinates
%   Input arguments:
%       P1 - image coordinates (N*3)
%       P - world coordinates (N*4)
%   Output arguments:
%       M (3*4 matrix)

N = size(P1,1);

A = zeros(2*N,12);

A(1:2:2*N,1:4) = P;
A(2:2:2*N,5:8) = P;
A(1:2:2*N,9:12) = bsxfun(@times,P1(:,1),P);
A(2:2:2*N,9:12) = bsxfun(@times,P1(:,2),P);

[~,~,V] = svd(A,0);

M = reshape(V(:,end),4,3)';

end

