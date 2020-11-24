% Programa para graficar las líneas de flujo y las equipotenciales
% Tenga en cuenta que los bordes de Neumann son líneas de flujo
% Y los bordes de Dirichlet
K = 2.5e-8; %m/s permeabilidad
H = xlsread('tablestaca.xlsx','Hoja1','cabezas'); % cargo la hoja de MS EXCEL

HH = flipud(H); % invertir filas de la matriz de arriba a abajo

Delta = 0.5;    % Delta
x = 0:Delta:31; % defino el eje x
y = 0:Delta:12; % defino el eje y

[xx,yy] = meshgrid(x,y); %comando necesario para hacer las gráficas 2D

figure;
subplot(1,2,1); 
pcolor(xx,yy,HH); % dibujo el gráfico de colores
colorbar          % dibujo la barra de colores
shading interp    % difuminar el color
axis equal tight  % ejes iguales y ajustados
xlabel('Eje X','FontSize',16); % etiqueta del eje X, con tamaño de fuente 16
ylabel('Eje Y','FontSize',16); % etiqueta del eje Y, con tamaño de fuente 16
title('H','FontSize',16);      % título con tamaño de fuente 16
set(gca,'FontSize',16);        % título con tamaño de fuente 16

subplot(1,2,2);
mesh(xx,yy,HH);

xlabel('Eje X','FontSize',16); % etiqueta del eje X, con tamaño de fuente 16
ylabel('Eje Y','FontSize',16); % etiqueta del eje Y, con tamaño de fuente 16
zlabel('H','FontSize',16);     % título con tamaño de fuente 16
set(gca,'FontSize',16);        % título con tamaño de fuente 16

figure;
contour(xx,yy,HH,50, ...
   'Color', 'blue', 'LineWidth', 3);    % graficar las líneas equipotenciales
hold on                                 % evitar que se sobreescriban las gráficas
[vx,vy] = gradient(-K*HH,Delta,Delta);  % calcular las velocidades
quiver(xx,yy,vx,vy,3);                  % graficar las flechas de la velocidad
sx = 0:31; sy = repmat(12,size(sx));    % puntos iniciales de las líneas de flujo
h=streamline(xx,yy,vx,vy,sx,sy);        % graficar las líneas de flujo
set(h, 'Color', 'red', 'LineWidth', 3); % cambiar el color de las líneas a rojo

% Dibujo el borde
plot([0 31 31 16 16 15 15 0 0],[0 0 12 12 6 6 12 12 0],'k-','LineWidth',3);
axis equal
axis([-0.5 31.5 -0.5 12.5]);  % ejes iguales y ajustados manualmente