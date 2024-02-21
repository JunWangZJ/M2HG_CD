function [Dis] = PPB_dist(Vec, Mat, par)
n = max(size(Mat));
Dis = zeros(1,n);
for i = 1 : n
    PPB = log((Vec./Mat(i,:) + Mat(i,:)./Vec)*par);
    Dis(1,i) = exp(-sum(PPB(:)));   
end

