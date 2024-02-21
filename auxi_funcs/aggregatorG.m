function [aggregatedresults] = aggregatorG(Graph, image)
%AGGREGATION �˴���ʾ�йش˺�����ժҪ
[m,n] = size(image); 
aggregatedresults = zeros(m,n);
for x = 1 : m
    for y = 1 : n
       x_n = Graph(x,y).neighborG(:,1);
       y_n = Graph(x,y).neighborG(:,2);
       for i = 1 : size(x_n, 1)
            aggregatedresults(x,y) = aggregatedresults(x,y) + Graph(x,y).neighborG(i,3).* image(x_n(i), y_n(i));
       end
       aggregatedresults(x,y) = aggregatedresults(x,y)./sum(Graph(x,y).neighborG(:,3));
       clear x_n y_n;
    end
end
end

