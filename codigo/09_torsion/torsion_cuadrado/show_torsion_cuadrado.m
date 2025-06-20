clear
clc
close all

%% Torsión de una barra con sección transversal cuadrada
E  = 21e6;         % [kPa] = 21GPa - módulo de Young del acero
nu = 0.28;         % coeficiente de Poisson del acero
G  = E/(2*(1+nu)); % [kPa] módulo de cortante 
L  = 1;            % [m]
rho_L = 0.05;      % [rad]
theta = rho_L/L;   % [rad/m]
delta = 0.001;     % [m] espaciado de la malla

%% Coordenadas del borde de la barra cuadrada
global a b borde
a = 0.01; % [m]
b = 0.01; % [m]

% coordenadas del borde (x,y) que forman el perímetro
borde = ...
    [-a -b 
      a -b
      a  b
     -a  b
     -a -b ]; % observe que se repite la primera fila

%% Leer de MS EXCEL de la función de tensión de Prandtl phi
phi = readmatrix('torsion_cuadrado.xlsx', 'Sheet', 'Prandtl', 'Range','phi');
phi = flipud(phi);

%% Leer de MS EXCEL de la función de alabeo psi
psi = readmatrix('torsion_cuadrado.xlsx', 'Sheet', 'Alabeo', 'Range','psi');
psi = flipud(psi);

%% Definir las coordenadas en x e y
x = -0.01:delta:0.01;
y = -0.01:delta:0.01;

[xx,yy] = meshgrid(x,y);

%% Funciones para calcular las derivadas usando diferencias centrales
d_dx = @(f) (f(2:end-1,3:end) - f(2:end-1,1:end-2))/(2*delta);
d_dy = @(f) (f(3:end,2:end-1) - f(1:end-2,2:end-1))/(2*delta);

%% Cálculo de los esfuerzos
txz = G*theta*(d_dx(psi) - yy);
tyz = G*theta*(d_dy(psi) + xx);

%% Eliminar los nodos ficticios alrededor de psi
psi = psi(2:end-1,2:end-1);

%% Figuras de los esfuerzos cortantes
figure
plot_esf_2d(xx,yy,txz, ...
    'Esfuerzos cortantes \tau_{xz}(x,y) sobre la cara \Omega_L [kPa]', ...
    'txz_square.eps');

figure
plot_esf_2d(xx,yy,tyz, ...
    'Esfuerzos cortantes \tau_{yz}(x,y) sobre la cara \Omega_L [kPa]', ...
    'tyz_square.eps');

%% Figura de los esfuerzos tau
tau = hypot(txz, tyz);

figure
plot_esf_3d(xx, yy, tau, ...
    'Esfuerzos cortantes \tau(x,y) sobre la cara \Omega_L [kPa]')
hold on

% Dibujo los esfuerzos cortantes
quiver(xx,yy, txz,tyz, 'LineWidth', 1.5, 'Color', 'k');

zlabel('Esfuerzo cortante \tau(x,y) [kPa]');
exportgraphics(gcf,'tau_square_3d.eps', ...
    'BackgroundColor','none',...
    'ContentType','vector')

%% Función de tension de Prandtl 3D
figure
plot_esf_3d(xx, yy, phi, ...
    {'Función de tension de Prandtl \phi(x,y)','(solución numérica)'})
hold on

% Dibujo los esfuerzos cortantes
quiver(xx,yy, txz,tyz, 'LineWidth', 1.5, 'Color', 'k');

zlabel('Función de tensión de Prandtl, \phi(x, y) [kPa*m]');
exportgraphics(gcf,'prandtl_square_3d.eps', ...
    'BackgroundColor','none',...
    'ContentType','vector')

%% Función de tension de Prandtl 2D
figure
plot_esf_2d(xx,yy,phi, ...
    {'Curvas de nivel de la función de tensión de Prandtl \phi(x,y)',...
     'Se muestran ademas los esfuerzos cortantes'});
hold on;

% Dibujo los esfuerzos cortantes
quiver(xx,yy, txz,tyz, 'LineWidth', 1.5, 'Color', 'k');

%% Encontrar el centro de torsión
options = optimset('fminsearch');
options.MaxFunEvals = 6000;
ct = fminsearch(@(x) -interp2(xx,yy,phi,x(:,1),x(:,2)), 0.001*[rand rand]-0.0005);
h = plot(ct(1), ct(2), 'r*', 'MarkerSize',15);
legend(h, 'Centro de torsion','Location','Best');

%% Calcular el momento torsor equivalente
% q = dblquad(fun,xmin,xmax,ymin,ymax)
Mt = 2*dblquad(@(x,y) interp2(xx,yy,phi, x,y), -a, a, -b, b);
texto_Mt = sprintf('Momento torsor = %g kN-m',Mt);
xlabel(texto_Mt,'FontSize', 16);
fprintf('%s\n',texto_Mt);

exportgraphics(gcf,'prandtl_square_2d.eps', ...
    'BackgroundColor','none', ...
    'ContentType','vector')

%% Calcular la inercia torsional J
% q = dblquad(fun,xmin,xmax,ymin,ymax)
% Mt2 = dblquad(@(x,y) interp2(xx,yy,xx.*tyz - yy.*txz, x,y),-0.01,0.01,-0.01,0.01);
J = Mt/(G*theta);
fprintf('J = %g m^4\n',J);

%% Graficar el alabeo w = theta*psi
w = theta*psi;

figure
plot_esf_3d(xx, yy, w, ...
    {'Desplazamiento en z (alabeo) w(x,y) = \theta*\Psi(x,y)', ...
     '(solución numérica)'}, ...
    'alabeo_square.eps')

%% Comparación de solución analítica con cálculo numérico
[psi2,phi2,x2,y2] = calc_psi_phi_cuadrado(a,b,G,theta);

diffphi = abs(phi-phi2)./phi2;  
diffphi(isnan(diffphi)) = 0; % Prandtl
diffphi(isinf(diffphi)) = 0; % Prandtl

psi2(abs(psi2)<1e-5) = 0;    % Eliminando artificialmente errores por redondeo
diffpsi = abs(psi-psi2)./psi2;  
diffpsi(isnan(diffpsi)) = 0; % Alabeo
diffpsi(isinf(diffpsi)) = 0; % Alabeo

%% Error relativo en el cálculo de la función de tensión de Prandtl
figure
plot_esf_3d(xx, yy, diffphi, ...
    {'Error relativo en el cálculo de la función de Prandtl \phi(x,y)', ...
     'Teórico vs diferencias finitas'})

%% Error relativo en el cálculo de la función de alabeo de Saint-Venant
figure
plot_esf_3d(xx, yy, diffpsi, ...
    {'Error relativo en el cálculo de la función de alabeo \psi(x,y)', ...
     'Teórico vs diferencias finitas'})

%% Se dibuja la barra deformada + alabeo
%% Recupero el borde
borde = xlsread('torsion_cuadrado.xlsx','borde','Borde');
borde = flipud(borde);
borde = [borde(:), [1:numel(borde)]'];
borde(isnan(borde(:,1)),:) = [];
borde = sortrows(borde,1);
ind = borde(:,2);
ind = [ind; ind(1)];

%% Grafico barra con rotacion
escala = 1e5;
LL = linspace(0,400*(x(end)-x(1)),11);
theta = -theta;
for z = 1:11
   zz = LL(z);
   xnew = cos(theta*zz)*xx(:) - sin(theta*zz)*yy(:);
   ynew = sin(theta*zz)*xx(:) + cos(theta*zz)*yy(:);
   SUR(:,:,z) = [xnew(ind),ynew(ind),zz-escala*w(ind)]';
end
X = squeeze(SUR(1,:,:));
Y = squeeze(SUR(2,:,:));
Z = squeeze(SUR(3,:,:));

figure; 
surf(Z,Y,X); %axis equal;
hold on
for z = 1:11
   zz = LL(z);
   xnew = cos(theta*zz)*xx - sin(theta*zz)*yy;
   ynew = sin(theta*zz)*xx + cos(theta*zz)*yy;
   surf(zz-escala*w,ynew,xnew);
end

xlabel('Eje Z')
ylabel('Eje X')
zlabel('Eje Y')
title('Barra deformada')

%camlight
%lighting gouraud
colormap([1 1 1]*0.7)
camproj('perspective')
material dull
axis off

return; %bye bye

function plot_esf_2d(x, y, esf, titulo, archivo)
    global a b borde
    
    pcolor(x,y,esf);  % Hacer un dibujo en 2D de los esfuerzos en tau_xz
    hold on;          % Permitir hacer modificaciones al dibujo anterior
    shading interp;   % Hacer interpolación de colores
    hcb = colorbar;   % Poner la barra de colores
    axis equal tight
    contour(x,y,esf,20,'k'); % Dibujar 20 curvas de nivel (isobaras)
    title(titulo);      
    plot(borde(:,1), borde(:,2), 'k-', 'LineWidth',5)

    % Defino las coordenadas que quiero visualizar [xmin xmax ymin ymax]
    axis([ -1.1*a 1.1*a -1.1*b 1.1*b ]);
    
    xlabel('x [m]');
    ylabel('y [m]');
    
    % Cree un archivo con el gráfico listo para incluir en LaTeX
    %set(gca,'FontSize',16);   % Números de los ejes x e y
    %set(hcb,'FontSize',16);   % Fuente en la barra de colores
    colormap jet
    
    if nargin == 5
        exportgraphics(gcf,archivo,   ...
            'BackgroundColor','none', ...
            'ContentType',    'vector')
    end
end

function plot_esf_3d(x, y, esf, titulo, archivo)
    global a b borde
    
    mesh(x,y,esf);  % Hacer un dibujo en 2D de los esfuerzos en tau_xz
    hold on;          % Permitir hacer modificaciones al dibujo anterior
    shading interp;   % Hacer interpolación de colores
    hcb = colorbar;   % Poner la barra de colores
    axis tight
    contour(x,y,esf,20,'k'); % Dibujar 20 curvas de nivel (isobaras)
    title(titulo);      
    plot(borde(:,1), borde(:,2), 'k-', 'LineWidth',5)

    % Defino las coordenadas que quiero visualizar [xmin xmax ymin ymax]
    % axis([ -1.1*a 1.1*a -1.1*b 1.1*b 0 maxtau]);
    
    xlabel('x [m]');
    ylabel('y [m]');
    
    % Cree un archivo con el gráfico listo para incluir en LaTeX
    %set(gca,'FontSize',16);   % Números de los ejes x e y
    %set(hcb,'FontSize',16);   % Fuente en la barra de colores
    colormap jet
    
    if nargin == 5
        exportgraphics(gcf,archivo,   ...
            'BackgroundColor','none', ...
            'ContentType',    'vector')
    end
end

%{
mogrify -trim *.png
mogrify -format eps3 *.png
%}