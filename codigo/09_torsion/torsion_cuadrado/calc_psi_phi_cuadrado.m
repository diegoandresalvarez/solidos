function [psi, phi, x, y] = calc_psi_phi_cuadrado(a, b, G, theta)
% Cálculo de la función de alabeo psi y la función de tensión de Prandtl
% phi para un rectangulo de lados 2a y 2b.
%
% Recuerde que:
% w(x,y) = theta*psi(x,y)

%{
a = 0.01;
b = 0.01;
E  = 21e6;         % kPa = 21GPa - módulo de Young del acero
nu = 0.28;         % coeficiente de Poisson del acero
G  = E/(2*(1+nu)); % módulo de cortante
theta = 0.05;      % rad/m
[psi, phi, x, y] = calc_psi_phi_cuadrado(a, b, G, theta);
%}

%% Se inicializan algunas variables
nx = 21; xx = linspace(-a, a, nx);
ny = 21; yy = linspace(-b, b, ny);

[x,y] = meshgrid(xx,yy);

%% Cálculo de la función de alabeo de Saint-Venant
n = 0:250; %0,1,2,3... to Infinity
kn = (2*n + 1)*pi/(2*a);
tmp1 = ((32*a^2)/(pi^3))*((-1).^n)./(((2*n+1).^3) .* cosh(kn.*b));
psi1 = zeros(ny,nx);
for i = 1:ny
   for j = 1:nx
      tmp2 = sin(kn.*x(i,j)) .* sinh(kn.*y(i,j));

      % se da manejo a ciertas indeterminaciones matemáticas
      tmp  = tmp1 .* tmp2;
      tmp((tmp1==0) & isinf(tmp2)) = 0;
      
      psi1(i,j) = sum(tmp);
   end
end
psi = x.*y - psi1;

%% Cálculo de la función de tensión de Prandtl
n = 1:2:500; %1,3,5,... to Infinity
tmp1 = ((32*G*theta*a^2)/(pi^3)) .*((-1).^((n-1)/2))./(n.^3);

phi = zeros(ny,nx);
for i = 1:ny
   for j = 1:nx
      tmp2 = cosh(n*pi*y(i,j)/(2*a));
      tmp3 = cosh(n*pi*b/(2*a));

      % se da manejo a ciertas indeterminaciones matemáticas
      tmp4 = tmp2./tmp3;
      tmp4(isinf(tmp2) & isinf(tmp3)) = 1;

      phi(i,j) = sum(tmp1 .* (1 - tmp4) .* cos(n*pi*x(i,j)/(2*a)));
   end
end

% La función de tensión de Prandtl es nula en el contorno
phi([1 ny],:) = 0;
phi(:,[1 nx]) = 0;

%% Grafico que representa la funcion de tension de Prandtl
figure
mesh(x,y,phi);    % Hacer un dibujo en 2D de phi
hold on;          % Permitir hacer modificaciones al dibujo anterior
%shading interp;  % Hacer interpolación de colores
colorbar          % Poner la barra de colores
contour(xx,yy,phi,20,'k'); % Dibujar 20 curvas de nivel
title({'Función de tensión de Prandtl \phi(x,y)', ...
       '(solución teórica)'},'FontSize', 18);
axis tight

% Dibujo los bordes de la figura
plot([-a a a -a -a], [-b -b b b -b], 'k-', 'LineWidth',5)


%% Grafico el alabeo w = theta*psi
w = theta*psi;

figure
mesh(x,y,w);      % Hacer un dibujo en 2D del alabeo
hold on;          % Permitir hacer modificaciones al dibujo anterior
%shading interp;  % Hacer interpolación de colores
colorbar          % Poner la barra de colores
axis tight
contour(xx,yy,w,20,'k'); % Dibujar 20 curvas de nivel
title({'Desplazamiento en z (alabeo) w(x,y) = \theta\Psi(x,y)', ...
       '(solución teórica)'},'FontSize', 18);
xlabel('Eje x');
ylabel('Eje y');
zlabel('Alabeo w(x,y)');

% Dibujo los bordes de la figura
plot([-a a a -a -a], [-b -b b b -b], 'k-', 'LineWidth',5)

%% bye, bye!!
return