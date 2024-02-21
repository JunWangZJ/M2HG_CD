function [Kap] = Kappa_pixel(image,C_image)

[m,n,~] = size(image);
K = m*n;
%%%%%%%%%%%%%%%%%%%%%%
TP=0;
for x = 1:m
    for y = 1:n
        if(image(x,y)==1 && C_image(x,y)==1)
            TP = TP + 1;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%
FN=0;   %Â©¼ì
for x = 1:m
    for y = 1:n
        if(image(x,y)~=1 && C_image(x,y)==1)
            FN = FN + 1;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%
FP=0;
for x = 1:m
    for y = 1:n
        if (image(x,y)==1 && C_image(x,y)~=1)
            FP = FP + 1;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%
TN=0;
for x = 1:m
    for y = 1:n
        if (image(x,y)~=1 && C_image(x,y)~=1)
            TN = TN + 1;
        end
    end
end
P_r0 = (K-FN-FP)/K;
P_rc = ((TP+FN)*(TP+FP)+(TN+FP)*(TN+FN))/K^2;
Kap = (P_r0-P_rc)/(1-P_rc);
end

