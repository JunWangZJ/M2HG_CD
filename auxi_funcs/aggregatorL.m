function [aggregatedresults] = aggregatorL(Graph, image)
%AGGREGATION 此处显示有关此函数的摘要
[m,n] = size(image); 
aggregatedresults = zeros(m,n);
for x = 1 : m
    for y = 1 : n
       x_n = Graph(x,y).neighborL(:,1);
       y_n = Graph(x,y).neighborL(:,2);
       for i = 1 : size(x_n, 1)
            aggregatedresults(x,y) = aggregatedresults(x,y) + Graph(x,y).neighborL(i,3).* image(x_n(i), y_n(i));
       end
       aggregatedresults(x,y) = aggregatedresults(x,y)./sum(Graph(x,y).neighborL(:,3));
       clear x_n y_n;
    end
end
end

