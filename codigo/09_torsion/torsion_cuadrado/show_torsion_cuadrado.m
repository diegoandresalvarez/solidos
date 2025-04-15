clear
clc
close all

%% Torsion de una barra rectangular
E  = 21e6;         % kPa = 21GPa - modulo de Young del acero
nu = 0.28;         % coeficiente de Poisson del acero
G  = E/(2*(1+nu)); % modulo de cortante
theta = 0.05;      % rad/m
delta = 0.001;     % espaciado de la malla

%% Aqui hice copy/paste de MS EXCEL de la funcion de tension de Prandtl phi
phi = xlsread('torsion_cuadrado.xlsx','Prandtl','phi'); 
phi = flipud(phi);

%% Aqui hice copy/paste de MS EXCEL de la funcion de alabeo psi
psi = xlsread('torsion_cuadrado.xlsx','Alabeo','psi');
psi = flipud(psi);

%% Aqui defino las coordenas en x e y que estoy manejando
x = -0.01:delta:0.01;
y = -0.01:delta:0.01;

%% Al ejecutar "help meshgrid obtengo":
%    [X,Y] = MESHGRID(x,y) transforms the domain specified by vectors
%    x and y into arrays X and Y that can be used for the evaluation
%    of functions of two variables and 3-D surface plots.
%    The rows of the output array X are copies of the vector x and
%    the columns of the output array Y are copies of the vector y.
[xx,yy] = meshgrid(x,y);

%% Creo funciones para calcular las derivadas usando diferencias centrales
deriv_x = @(f) (f(2:end-1,3:end)-f(2:end-1,1:end-2))/(2*delta);
deriv_y = @(f) (f(3:end,2:end-1)-f(1:end-2,2:end-1))/(2*delta);

%% Calculo los esfuerzos
txz = G*theta*(deriv_x(psi) - yy);
tyz = G*theta*(deriv_y(psi) + xx);

%% Grafico que representa los esfuerzos tau_xz
figure             % Preparar al MATLAB para hacer una figura
pcolor(xx,yy,txz); % Hacer un dibujo en 2D de los esfuerzos en tau_xz
hold on;           % Permitir hacer modificaciones al dibujo anterior
shading interp;    % Hacer interpolacion de colores
hcb = colorbar;    % Poner la barra de colores
axis equal         % Hacer un grafico con coordenadas de igual tamaño
[C,h] = contour(xx,yy,txz,20,'k'); % Dibujar 20 curvas de nivel (isobaras)
set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2);
title('Esfuerzos cortantes \tau_{xz}(x,y) sobre la cara \Omega_L [kPa]');
%title('Esfuerzos cortantes \tau_{xz}','FontSize', 18) % Escribir el titulo
% Defino las coordenadas que quiero visualizar [xmin xmax ymin ymax]
axis tight
%axis([-0.01 0.01 -0.01 0.01]);
% Dibujo los bordes de la figura
%plot([-0.01 0.01 0.01 -0.01 -0.01], [-0.01 -0.01 0.01 0.01 -0.01], 'k-', 'LineWidth',5)
xlabel('x [cm]'); ylabel('y [cm]');

% Cree un archivo con el grafico listo para incluir en LaTeX
%set(gca,'FontSize',16);   % Tamano de la fuente en los numeros de los ejes x e y
%set(hcb,'FontSize',16);   % Tamano de la fuente en la barra de colores
colormap jet
%print('-depsc','txz_square.eps'); 
print('txz_square.png','-dpng','-r200');


%% Grafico que representa los esfuerzos tau_yz
figure             % Preparar al MATLAB para hacer una figura
pcolor(xx,yy,tyz); % Hacer un dibujo en 2D de los esfuerzos en tau_yz
hold on;           % Permitir hacer modificaciones al dibujo anterior
shading interp;    % Hacer interpolacion de colores
hcb = colorbar;    % Poner la barra de colores
axis equal         % Hacer un grafico con coordenadas de igual tamaño
[C,h] = contour(xx,yy,tyz,20,'k'); % Dibujar 20 curvas de nivel (isobaras)
set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2);
title('Esfuerzos cortantes \tau_{yz}(x,y) sobre la cara \Omega_L [kPa]');
%title('Esfuerzos cortantes \tau_{yz}','FontSize', 18) % Escribir el titulo
% Defino las coordenadas que quiero visualizar [xmin xmax ymin ymax]
axis tight
% Dibujo los bordes de la figura
%plot([-0.01 0.01 0.01 -0.01 -0.01], [-0.01 -0.01 0.01 0.01 -0.01], 'k-', 'LineWidth',5);
xlabel('x [cm]'); ylabel('y [cm]');

% Cree un archivo con el grafico listo para incluir en LaTeX
%set(gca,'FontSize',16);   % Tamano de la fuente en los numeros de los ejes x e y
%set(hcb,'FontSize',16);   % Tamano de la fuente en la barra de colores
colormap jet
%print('-depsc','tyz_square.eps'); 
print('tyz_square.png','-dpng','-r200');


tau = sqrt(txz.^2 + tyz.^2);
maxtau = max(max(tau));
%% Grafico que representa los esfuerzos tau
figure            % Preparar al MATLAB para hacer una figura
h = surf(xx,yy,tau);  % Hacer un dibujo en 2D de los esfuerzos en tau_yz
hold on;          % Permitir hacer modificaciones al dibujo anterior
shading interp;   % Hacer interpolacion de colores
set(h','EdgeColor','k','EdgeAlpha',0.5)
hcb = colorbar;   % Poner la barra de colores
contour(xx,yy,tau,20,'k'); % Dibujar 20 curvas de nivel (isobaras)
title('Esfuerzos cortantes \tau_{xz}(x,y) sobre la cara \Omega_L [kPa]');
%title('Esfuerzos cortantes \tau','FontSize', 18) % Escribir el titulo
% Defino las coordenadas que quiero visualizar [xmin xmax ymin ymax zmin zmax]
axis tight;
% Dibujo los bordes de la figura
%plot([-0.01 0.01 0.01 -0.01 -0.01], [-0.01 -0.01 0.01 0.01 -0.01], 'k-', 'LineWidth',5)
% Dibujo los esfuerzos cortantes
quiver(xx,yy,txz,tyz);
xlabel('x [cm]'); ylabel('y [cm]');

% Cree un archivo con el grafico listo para incluir en LaTeX
%set(gca,'FontSize',16);   % Tamano de la fuente en los numeros de los ejes x e y
%set(hcb,'FontSize',16);   % Tamano de la fuente en la barra de colores
colormap jet
%print('-depsc','tau_square_3d.eps'); 
print('tau_square_3d.png','-dpng','-r200');

maxphi = max(max(phi));
%% Grafico que representa la funcion de tension de Prandtl
figure            % Preparar al MATLAB para hacer una figura
h = surf(xx,yy,phi);  % Hacer un dibujo en 2D de phi
hold on;          % Permitir hacer modificaciones al dibujo anterior
shading interp;   % Hacer interpolacion de colores
set(h','EdgeColor','k','EdgeAlpha',0.5)
hcb = colorbar;   % Poner la barra de colores
%contour(xx,yy,phi,20,'k'); % Dibujar 20 curvas de nivel (isobaras)
title('Función de tensión de Prandtl \phi') % Escribir el titulo
% Defino las coordenadas que quiero visualizar [xmin xmax ymin ymax zmin zmax]
axis tight
%axis([-0.01 0.01 -0.01 0.01 0 maxphi]);
% Dibujo los bordes de la figura
%plot([-0.01 0.01 0.01 -0.01 -0.01], [-0.01 -0.01 0.01 0.01 -0.01], 'k-', 'LineWidth',5)
xlabel('x [cm]'); ylabel('y [cm]');
%zlabel('phi','FontSize',16);

% Cree un archivo con el grafico listo para incluir en LaTeX
%set(gca,'FontSize',16);   % Tamano de la fuente en los numeros de los ejes x e y
%set(hcb,'FontSize',16);   % Tamano de la fuente en la barra de colores
colormap jet
%print('-depsc','prandtl_square_3d.eps'); 
print('prandtl_square_3d.png','-dpng','-r200');


%% Grafico que representa la funcion de tension de Prandtl
figure            % Preparar al MATLAB para hacer una figura
pcolor(xx,yy,phi);% Hacer un dibujo en 2D de los esfuerzos en tau_yz
hold on;          % Permitir hacer modificaciones al dibujo anterior
contour(xx,yy,phi,10,'k'); % Dibujar 20 curvas de nivel (isobaras)
shading interp;   % Hacer interpolacion de colores
colormap pink     % Que colores quiero utilizar?
hcb = colorbar;   % Poner la barra de colores
axis equal        % Hacer un grafico con coordenadas de igual tamaño
title({'Curvas de nivel de la función de tensión de Prandtl \phi',...
   'Se muestran ademas los esfuerzos tangenciales',}) % Escribir el titulo
% Defino las coordenadas que quiero visualizar [xmin xmax ymin ymax]
axis([-0.011 0.011 -0.011 0.011]);
% Dibujo los bordes de la figura
%plot([-0.01 0.01 0.01 -0.01 -0.01], [-0.01 -0.01 0.01 0.01 -0.01], 'k-', 'LineWidth',5)
% Dibujo los esfuerzos cortantes
quiver(xx,yy,txz,tyz,'Color','m','LineWidth', 1.5);
%xlabel('Eje x','FontSize',16);
%ylabel('Eje y','FontSize',16);

%% Encontrar el centro de torsion
options = optimset('fminsearch');
options.MaxFunEvals = 6000;
ct = fminsearch(@(x) -interp2(xx,yy,phi,x(:,1),x(:,2)), 0.001*[rand rand]-0.0005);
h = plot(ct(1), ct(2), 'k*');
legend(h, 'Centro de torsión','Location','NorthEast');

% Cree un archivo con el grafico listo para incluir en LaTeX
%title(' ');               % Escribir el titulo
%set(gca,'FontSize',16);   % Tamano de la fuente en los numeros de los ejes x e y
%set(hcb,'FontSize',16);   % Tamano de la fuente en la barra de colores
colormap jet
xlabel('x [cm]'); ylabel('y [cm]');
%print('-depsc','prandtl_square_2d.eps'); 
print('prandtl_square_2d.png','-dpng','-r200');


%% Calcular el momento torsor equivalente
%fprintf('Calculanto momento torsor... un momento por favor.\n')
% q = dblquad(fun,xmin,xmax,ymin,ymax)
Mt = 2*dblquad(@(x,y) interp2(xx,yy,phi, x,y),-0.01,0.01,-0.01,0.01);
texto_Mt = sprintf('Momento torsor = %g kN-m',Mt);
%xlabel(texto_Mt,'FontSize', 16);
fprintf('%s\n',texto_Mt);

%% Calcular la inercia torsional J
% fprintf('Calculanto la inercia torsional J ... un momento por favor.\n')
% q = dblquad(fun,xmin,xmax,ymin,ymax)
% Mt2 = dblquad(@(x,y) interp2(xx,yy,xx.*tyz - yy.*txz, x,y),-0.01,0.01,-0.01,0.01);
J = Mt/(G*theta);
fprintf('J = %g m^4\n',J);

%% Elimino los nodos ficticios de psi
psi = psi(2:end-1,2:end-1);

%% Calculo el alabeo
w = theta*psi;

%% Grafico el alabeo w = theta*psi
figure            % Preparar al MATLAB para hacer una figura
h= surf(xx,yy,w);    % Hacer un dibujo en 2D del alabeo
hold on;          % Permitir hacer modificaciones al dibujo anterior
%alpha 0.9
shading interp;   % Hacer interpolacion de colores
set(h','EdgeColor','k','EdgeAlpha',0.5)
colorbar          % Poner la barra de colores
axis tight
contour(xx,yy,w,20,'k'); % Dibujar 20 curvas de nivel
title('Desplazamiento en z (alabeo) w(x,y) =  \theta\Psi(x,y)') % Escribir el titulo
% Dibujo los bordes de la figura
%plot([-0.01 0.01 0.01 -0.01 -0.01], [-0.01 -0.01 0.01 0.01 -0.01], 'k-', 'LineWidth',5)
xlabel('x [cm]'); ylabel('y [cm]');
zlabel('Alabeo w(x,y) [cm]');


% Cree un archivo con el grafico listo para incluir en LaTeX
%title(' ');               % Escribir el titulo
%set(gca,'FontSize',16);   % Tamano de la fuente en los n�meros de los ejes x e y
%set(hcb,'FontSize',16);   % Tamano de la fuente en la barra de colores
colormap jet
%print('-depsc','alabeo_square.eps'); 
print('alabeo_square.png','-dpng','-r200');

%return;

%% Calculo la respuesta teorica y calculo la diferencia con la estimacion
% numerica
a = 0.01;
b = 0.01;
[psi2,phi2,x2,y2] = calc_psi_phi_cuadrado(a,b,G,theta);

diffphi = abs(phi-phi2)./phi2;  
diffphi(isnan(diffphi)) = 0; % Prandtl
diffphi(isinf(diffphi)) = 0; % Prandtl

psi2(abs(psi2)<1e-5) = 0;    % Eliminando artificialmente errores por redondeo
diffpsi = abs(psi-psi2)./psi2;  
diffpsi(isnan(diffpsi)) = 0; % Alabeo
diffpsi(isinf(diffpsi)) = 0; % Alabeo

%% Grafico que representa la diferencia en error de la funcion de tension de Prandtl
figure            % Preparar al MATLAB para hacer una figura
h = surf(xx,yy,diffphi); % Hacer un dibujo en 2D de los esfuerzos en tau_yz
hold on;          % Permitir hacer modificaciones al dibujo anterior
contour(xx,yy,diffphi,20,'k'); % Dibujar 20 curvas de nivel (isobaras)
shading interp;   % Hacer interpolacion de colores
set(h','EdgeColor','k','EdgeAlpha',0.5)
colorbar          % Poner la barra de colores
%axis equal        % Hacer un grafico con coordenadas de igual tamaño
title({'Error en el cálculo de la función de Prandtl \phi',...
   'Teórico vs diferencias finitas',},'FontSize', 18) % Escribir el titulo
% Defino las coordenadas que quiero visualizar [xmin xmax ymin ymax]
axis([-0.011 0.011 -0.011 0.011]);
% Dibujo los bordes de la figura
%plot([-0.01 0.01 0.01 -0.01 -0.01], [-0.01 -0.01 0.01 0.01 -0.01], 'k-', 'LineWidth',5)

%% Grafico que representa la diferencia en error de la funcion de alabeo
figure            % Preparar al MATLAB para hacer una figura
surf(xx,yy,diffpsi); % Hacer un dibujo en 2D de los esfuerzos en tau_yz
hold on;          % Permitir hacer modificaciones al dibujo anterior
contour(xx,yy,diffpsi, 20,'k'); % Dibujar 20 curvas de nivel (isobaras)
shading interp;   % Hacer interpolacion de colores
colorbar          % Poner la barra de colores
%axis equal        % Hacer un grafico con coordenadas de igual tamaño
title({'Error en el cálculo de la función de alabeo \psi',...
   'Teórico vs diferencias finitas',},'FontSize', 18) % Escribir el titulo
% Defino las coordenadas que quiero visualizar [xmin xmax ymin ymax]
axis([-0.011 0.011 -0.011 0.011]);
% Dibujo los bordes de la figura
%plot([-0.01 0.01 0.01 -0.01 -0.01], [-0.01 -0.01 0.01 0.01 -0.01], 'k-', 'LineWidth',5)

%% bye bye

%{
mogrify -trim *.png
mogrify -format eps3 *.png
%}
