function [psi,phi,x,y] = calc_psi_phi_cuadrado(a,b,G,theta)
% Calculo de la funcion de alabeo psi y la funcion de tension de Prandtl
% phi para un rectangulo de lados 2a y 2b.
% Recuerde que:
% w(x,y) = theta*psi(x,y)

%{
a = 0.01;
b = 0.01;
E  = 21e6;         % kPa = 21GPa - modulo de Young del acero
nu = 0.28;         % coeficiente de Poisson del acero
G  = E/(2*(1+nu)); % modulo de cortante
theta = 0.05;      % rad/m
%}

xx = linspace(-a,a,21); nx = length(xx);
yy = linspace(-b,b,21); ny = length(yy);

[x,y] = meshgrid(xx,yy);

n = 0:250; %0,1,2,3... to Infinity
kn = (2*n + 1)*pi/(2*a);
tmp1 = ((32*a^2)/(pi^3))*((-1).^n)./(((2*n+1).^3) .* cosh(kn.*b));
psi1 = zeros(ny,nx);
for i = 1:ny
   for j = 1:nx
      tmp2 = sinh(kn.*y(i,j));
      tmp = tmp1 .* tmp2;
      tmp((tmp1==0) & isinf(tmp2)) = 0;
      psi1(i,j) = sum(tmp .* sin(kn.*x(i,j)));
   end
end
psi = x.*y - psi1;

n = 1:2:500; %1,3,5,... to Infinity
C2 = ((32*G*theta*a^2)/(pi^3)) .*((-1).^((n-1)/2))./(n.^3);

phi = zeros(ny,nx);
for i = 1:ny
   for j = 1:nx
      tmp1 = cosh(n*pi*y(i,j)/(2*a));
      tmp2 = cosh(n*pi*b/(2*a));
      tmp = tmp1./tmp2;
      tmp(isinf(tmp1) & isinf(tmp2)) = 1;
      phi(i,j) = sum(C2 .* (1 - tmp) .* cos(n*pi*x(i,j)/(2*a)));
   end
end

phi([1 ny],:) = 0;
phi(:,[1 nx]) = 0;

maxphi = max(max(phi));
%% Grafico que representa la funcion de tension de Prandtl
figure
surf(x,y,phi);    % Hacer un dibujo en 2D de phi
hold on;          % Permitir hacer modificaciones al dibujo anterior
shading interp;   % Hacer interpolacion de colores
colorbar          % Poner la barra de colores
contour(xx,yy,phi,20,'k'); % Dibujar 20 curvas de nivel (isobaras)
title({'Función de tension de Prandtl \phi','(solucion teorica)'},'FontSize', 18) % Escribir el titulo
%axis([-1 1 -1 1 0 maxphi]);  
axis tight

% Dibujo los bordes de la figura
%plot([-1 1 1 -1 -1], [-1 -1 1 1 -1], 'k-', 'LineWidth',5)


%% Calculo el alabeo
w = theta*psi;

%% Grafico el alabeo w = theta*psi
figure
mesh(x,y,w);    % Hacer un dibujo en 2D del alabeo
hold on;          % Permitir hacer modificaciones al dibujo anterior
shading interp;   % Hacer interpolacion de colores
colorbar          % Poner la barra de colores
axis tight
contour(xx,yy,w,20,'k'); % Dibujar 20 curvas de nivel (isobaras)
title({'Desplazamiento en z (alabeo) w(x,y) = theta*\Psi(x,y)','(solucion teorica)'},'FontSize', 18) % Escribir el titulo
%plot([-1 1 1 -1 -1], [-1 -1 1 1 -1], 'k-', 'LineWidth',5)
xlabel('Eje x');
ylabel('Eje y');
zlabel('Alabeo w(x,y)');
