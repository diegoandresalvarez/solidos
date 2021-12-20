fid = fopen('airy_L_x_s.txt');     xs = str2num(fscanf(fid,'%c')); fclose(fid);
fid = fopen('airy_L_y_s.txt');     ys = str2num(fscanf(fid,'%c')); fclose(fid);

%% Nombre del archivo de MS EXCEL en el que encuentran los calculos
archivo = 'L_airy.xlsx';

%% Definir delta, E y nu
delta = 0.1;          % espaciado de la malla [m]
E     = 210e6;        % modulo de elasticidad [kPa]
nu    = 0.3;          % coeficiente de Poisson
G     = E/(2*(1+nu)); % modulo de cortante

%% Definir x, y, y su longitud
x  = 0:delta:3;       % se define el eje x
nx = length(x);       % numero de puntos que definen el eje x
y  = 0:delta:3;       % se define el eje y
ny = length(y);       % numero de puntos que definen el eje y

%% Malla xy para los graficos
[xx,yy] = meshgrid(x,y);

%% Se leen los esfuerzos de la hoja de MS EXCEL
sx  = xlsread(archivo, 'airy', 'sigmax');  sx = flipud(sx);
sy  = xlsread(archivo, 'airy', 'sigmay');  sy = flipud(sy);
txy = xlsread(archivo, 'airy', 'tauxy');  txy = flipud(txy);
sz  = zeros(ny,nx);
txz = zeros(ny,nx);
tyz = zeros(ny,nx);

%% Se calculan las deformaciones
ex  = (sx - nu*(sy+sz))/E;
ey  = (sy - nu*(sx+sz))/E;
ez  = (sz - nu*(sx+sy))/E;
gxy = txy/G;
gxz = txz/G;
gyz = tyz/G;

%% Calculo los esfuerzos principales s1 y s2, el angulo con el eje X en que
%  se producen y el esfuerzo cortante maximo
s1 = (sx+sy)/2 + sqrt(((sx-sy)/2).^2+txy.^2);
s2 = (sx+sy)/2 - sqrt(((sx-sy)/2).^2+txy.^2);
ang = 0.5*atan2(2*txy,(sx-sy));
tmax = (s1-s2)/2;

%% Se grafican las deformaciones del cubo
% Grafico ex
figure;                 % Crea el lienzo para el dibujo
set(gca,'FontSize',12); % Tamano de la fuente en los numeros de los ejes x e y
pcolor(xx,yy,ex);       % Dibuje las deformaciones ex
hold on;                % Si se escribe algo nuevo, no se borre lo anterior
shading interp;         % Interpole los colores de modo que se vean suaves y continuos
h=colorbar;             % Cree la barra de colores a la derecha
title('ex');            % Titulo del grafico
contour(xx,yy,ex,20,'k'); % Cree 20 curvas de nivel de color negro 
axis equal tight;       % Ponga los ejes de la misma dimension en x y en y
set(h,'FontSize',12);   % Tamano de la fuente en la barra de colores

% Grafico ey
figure;
set(gca,'FontSize',12);
pcolor(xx,yy,ey); hold on; shading interp; h=colorbar; title('ey');
contour(xx,yy,ey,20,'k'); axis equal tight;
set(h,'FontSize',12); 

% Grafico ez
figure
set(gca,'FontSize',12);
pcolor(xx,yy,ez); hold on; shading interp; h=colorbar; title('ez');
contour(xx,yy,ez,20,'k'); axis equal tight;
set(h,'FontSize',12); 

% Grafico gxy
figure;
set(gca,'FontSize',12);
pcolor(xx,yy,gxy); hold on; shading interp; h=colorbar; title('gxy');
contour(xx,yy,gxy,20,'k'); axis equal tight;
set(h,'FontSize',12);

%% Se grafican los esfuerzos en el cubo
% Grafico sx
figure;
set(gca,'FontSize',12);
pcolor(xx,yy,sx);  hold on; shading interp; h=colorbar; title('sx');
contour(xx,yy,sx,20,'k'); axis equal tight;
set(h,'FontSize',12); 

% Grafico sy
figure;
set(gca,'FontSize',12);
pcolor(xx,yy,sy);  hold on; shading interp; h=colorbar; title('sy');
contour(xx,yy,sy,20,'k');  axis equal tight;
set(h,'FontSize',12);

% Grafico txy
figure;
set(gca,'FontSize',12);
pcolor(xx,yy,txy); hold on; shading interp; h=colorbar; title('txy');
contour(xx,yy,txy,20,'k'); axis equal tight;
set(h,'FontSize',12); 

%% Se grafican los esfuerzos principales
% Grafique los esfuerzos principales sigma_1
figure;
esc = 5;
set(gca,'FontSize',12);
pcolor(x,y,s1); hold on; shading interp; h=colorbar; title('s1');
contour(x,y,s1,20,'k');
set(h,'FontSize',12); 
axis equal tight

% Grafique lineas que indiquen direcciones principales de sigma_1
quiver(x,y,...                   % En el punto (x,y) grafique una flecha (linea)
   s1.*cos(ang),s1.*sin(ang),... % indicando la direccion principal de sigma_1
   esc,...                       % con una escala esc
   'k', ...                      % de color negro
  'ShowArrowHead','off',...      % una flecha sin cabeza
  'LineWidth',2); %,...              % con un ancho de linea 2
  %'Marker','.');                 % y en el punto (x,y) poner un punto '.'
quiver(x,y,...                   % La misma flecha ahora en la otra direccion,
   s1.*cos(ang+pi),s1.*sin(ang+pi),...  % es decir girando 180 grados
   esc,'k',...
   'ShowArrowHead','off','LineWidth',2); %,'Marker','.');

% Grafique los esfuerzos principales sigma_2
figure
set(gca,'FontSize',12);
pcolor(x,y,s2); hold on; shading interp; h=colorbar; title('s2');
contour(x,y,s2,20,'k');
set(h,'FontSize',12); 
axis equal tight

% Grafique lineas que indiquen direcciones principales de sigma_2
                                           % El el punto (x,y) grafique una 
quiver(x,y,...                             % flecha que indique la direccion 
   s2.*cos(ang+pi/2),s2.*sin(ang+pi/2),... % principal de sigma_2
   esc,'k',...
   'ShowArrowHead','off','LineWidth',2); %,'Marker','.');
quiver(x,y, s2.*cos(ang-pi/2),s2.*sin(ang-pi/2),...
   esc,'k',...
   'ShowArrowHead','off','LineWidth',2); %,'Marker','.');

% Grafique el cortante maximo, tau_max
figure;
set(gca,'FontSize',12);
pcolor(x,y,tmax); hold on; shading interp; h=colorbar; title('tmax');
contour(x,y,tmax,20,'k');
set(h,'FontSize',12); 
axis equal tight

% Grafique lineas que indiquen direcciones principales de tau_max,
quiver(x,y, tmax.*cos(ang+pi/4),tmax.*sin(ang+pi/4),'k',...
         'ShowArrowHead','off','LineWidth',2); %,'Marker','.');
quiver(x,y, tmax.*cos(ang-pi/4),tmax.*sin(ang-pi/4),'k',...
         'ShowArrowHead','off','LineWidth',2); %,'Marker','.');
quiver(x,y, tmax.*cos(ang+3*pi/4),tmax.*sin(ang+3*pi/4),'k',...
         'ShowArrowHead','off','LineWidth',2); %,'Marker','.');
quiver(x,y, tmax.*cos(ang-3*pi/4),tmax.*sin(ang-3*pi/4),'k',...
         'ShowArrowHead','off','LineWidth',2); %,'Marker','.');

return; % bye bye