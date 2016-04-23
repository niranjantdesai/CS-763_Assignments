function surprisalmap = contourinfoplot(x, y, signed, resolution)

% NOTE: code obtained from http://ruccs.rutgers.edu/demos/12-personal-sites/manish-singh/197-demos-info-along-contours
% Suitable modifications have been made

x = x(:); y = y(:);

if length(x) ~= length(y)
	error(' length of x and y must be the same');
end;

N = length(x);
b = 1; % spread term for the Von Mises distribution

if (x(1) == x(N) && y(1) == y(N))
    N = N-1;
    open = 0;
else
    open = 1;
end


% generating the map of sum neighbors for each point; for a point with index j,
% row j represents the sum of its neighbors
xprev = zeros(N, 1);
xnext = zeros(N, 1);
yprev = zeros(N, 1);
ynext = zeros(N, 1);

% we need to sum all the neighborss


for k = 1:resolution
    xprev = xprev + circshift(x,k);
    xnext = xnext + circshift(x,-k);
    yprev = yprev + circshift(y,k);
    ynext = ynext + circshift(y,-k);
end

% dividing by resolution
xprev = xprev/resolution;
xnext = xnext/resolution;
yprev = yprev/resolution;
ynext = ynext/resolution;

% vector _from_ the previous point; vector _to_ the next point
vecprev = [x, y] - [xprev, yprev];
vecnext = [xnext, ynext] - [x, y];

% L2 norms of the vectors
norm_vecprev = sqrt(sum(vecprev.^2,2));
norm_vecnext = sqrt(sum(vecnext.^2,2));

% compute the magnitude of the turning angle using dot product
alpha = acos( dot(vecprev, vecnext,2)./(norm_vecprev.*norm_vecnext));

% compute the sign of turning using cross product
% (assumes a counterclockwise sampling of the contour)
cp = cross( [vecprev, zeros(size(x))], [vecnext, zeros(size(x))] ,2);
alpha = sign(cp(:,3)).*alpha;


    

% compute the surprisal using -log von mises
if(signed)
    surprisalmap = -log( exp(b*cos(alpha - (2*pi/(N/resolution))) )/( 2*pi*besseli(0,b) ) );
else
    surprisalmap = -log( exp(b*cos(alpha) )/( 2*pi*besseli(0,b) ) );
end;

% turning angles not defined near the end points of an open curve
if(open) 
    surprisalmap(1:resolution)=0;
    surprisalmap(N-resolution+1:N)=0;
end

% compute the tangent and normal vectors
tangvec = vecprev + vecnext;
tangvec = [tangvec(:,1)./sqrt(sum(tangvec.^2,2)), ...
    tangvec(:,2)./sqrt(sum(tangvec.^2,2))];
normalmap = [[0 1; -1 0]*tangvec']';



% scale the size of histogram bars
surprisalmap = (1/range(surprisalmap))*(surprisalmap(:) - min(surprisalmap));
needlesize = max(range(x), range(y))/10;

% needlesize = needlesize/20;

% define the histogram normal to the shape
normalmap(:,1) = surprisalmap.*normalmap(:,1);
normalmap(:,2) = surprisalmap.*normalmap(:,2);
xnormals = [x(1:N), x(1:N) + needlesize*normalmap(:,1)];
ynormals = [y(1:N), y(1:N) + needlesize*normalmap(:,2)];

% plot
figure()
hold on
plot(y,x,'r')
%plot(xnormals', ynormals', 'k-')
