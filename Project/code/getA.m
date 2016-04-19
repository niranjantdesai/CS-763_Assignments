function [ A ] = getA( a,b,c,theta )
%getA This function returnsthe 2D Affine matrix A using input params
%   A is decomposed into scale, rotation, and two components of shear as
%   follows:
%   A = s(a)R(theta)Sh1(b)Sh2(c)

s = [exp(a),0; 0,exp(a)];   % Scale
R = [cos(theta),-sin(theta); sin(theta),cos(theta)];    % Rotation
sh1 = [exp(b),0; 0,exp(-b)];    % Shear component 1
sh2 = [cosh(c),sinh(c); sinh(c),cosh(c)];   % Shear component 2

A = s*R*sh1*sh2;

end

