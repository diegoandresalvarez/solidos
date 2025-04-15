function [Cx, Cy, A] = centroide(vertices)
% Dados los vértices de un polígono, esta función calcula su área
% y su centroide
% Formulas tomadas de https://en.wikipedia.org/wiki/Centroid

n = size(vertices, 1);

x = vertices(:,1);  x = x([1:end 1]);
y = vertices(:,2);  y = y([1:end 1]);

A  = 0; 
Cx = 0;
Cy = 0;

for i = 1:n
   tmp = x(i)*y(i+1) - x(i+1)*y(i);
   A  = A  + tmp;
   Cx = Cx + (x(i) + x(i+1))*tmp;
   Cy = Cy + (y(i) + y(i+1))*tmp;
end

A  = A/2;
Cx = Cx/(6*A);
Cy = Cy/(6*A);

return