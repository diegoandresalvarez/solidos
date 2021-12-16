% Programa para graficar las l�neas de flujo y las equipotenciales
% Tenga en cuenta que los bordes de Neumann son l�neas de flujo
% Y los bordes de Dirichlet
K = 1e-8; %m/s permeabilidad
H = xlsread('presa.xlsx','presiones11','acuifero'); % cargo la hoja de MS EXCEL

HH = flipud(H); % invertir filas de la matriz de arriba a abajo

Delta = 0.5;    % Delta
x = 0:Delta:67; % defino el eje x
y = 0:Delta:10; % defino el eje y

[xx,yy] = meshgrid(x,y); %comando necesario para hacer las gr�ficas 2D

figure;
subplot(1,2,1); 
pcolor(xx,yy,HH); % dibujo el gr�fico de colores
colorbar          % dibujo la barra de colores
shading interp    % difuminar el color
axis equal tight  % ejes iguales y ajustados
xlabel('Eje X','FontSize',16); % etiqueta del eje X, con tama�o de fuente 16
ylabel('Eje Y','FontSize',16); % etiqueta del eje Y, con tama�o de fuente 16
title('H','FontSize',16);      % t�tulo con tama�o de fuente 16
set(gca,'FontSize',16);        % t�tulo con tama�o de fuente 16

subplot(1,2,2);
mesh(xx,yy,HH);

xlabel('Eje X','FontSize',16); % etiqueta del eje X, con tama�o de fuente 16
ylabel('Eje Y','FontSize',16); % etiqueta del eje Y, con tama�o de fuente 16
zlabel('H','FontSize',16);     % t�tulo con tama�o de fuente 16
set(gca,'FontSize',16);        % t�tulo con tama�o de fuente 16

figure;
contour(xx,yy,HH,50);          % graficar las l�neas equipotenciales
hold on                        % evitar que se sobreescriban las gr�ficas
[vx,vy] = gradient(-K*HH,Delta,Delta); % calcular las velocidades
quiver(xx,yy,vx,vy,3);         % graficar las flechas de la velocidad
sx = 0:2:30; sy = repmat(10,size(sx)); % puntos iniciales de las l�neas de flujo
h=streamline(xx,yy,vx,vy,sx,sy); % graficar las l�neas de flujo
set(h, 'Color', 'red');        % cambiar el color de las l�neas a rojo
axis equal;              % ejes iguales y ajustados
axis([-1 68 -1 13]);
