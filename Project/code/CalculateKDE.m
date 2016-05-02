function KDE = CalculateKDE(Points, bandwidth)

% P is the point set with n-Dimensional rows

sizeP = size(Points);

KCG = zeros(sizeP(2),sizeP(2));

for i = 1:sizeP(2)
	for j = 1:sizeP(2)
		if (j ~= i)
			KCG(i,j) = ((pi*bandwidth^2)^(-sizeP(1)/2))*(exp(-(((Points(1,i)-Points(1,j))^2 + (Points(2,i)-Points(2,j))^2))/(2*bandwidth^2)));
		end
	end
	% leave one out kernel correlation
	LKC(i) = sum(KCG(i,:));
end


norm = sum(sum(KCG.^2));
KDE = KCG/norm;

