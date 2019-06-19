clear, clc, close all

%% Nombre del archivo de MS EXCEL en el que encuentran los calculos
archivo = 'ejemplo_losa_simplemente_apoyada.xlsm';
%archivo = 'ejemplo_losa_empotrada_borde_libre.xlsm';
%archivo = 'ejemplo_losa_borde_libre.xlsm';

w   = flipud(xlsread(archivo,'Hoja1','desp_w'));
Mx  = flipud(xlsread(archivo,'Hoja1','Mx'));    
My  = flipud(xlsread(archivo,'Hoja1','My'));    
Mxy = flipud(xlsread(archivo,'Hoja1','Mxy'));
Qx  = flipud(xlsread(archivo,'Hoja1','Qx'));     
Qy  = flipud(xlsread(archivo,'Hoja1','Qy'));

%% Definir x e y y su longitud
delta = 0.1;
xx = 0:delta:2;   nx = length(xx);
yy = 0:delta:4;   ny = length(yy);

%% Malla x,y para los graficos
[x,y] = meshgrid(xx,yy);

%% Desplazamientos verticales
hacer_grafico(x, y, w, 'w', 'Desplazamiento vertical w(x,y) [m]');

%% Momento flector por unidad de longitud Mx
hacer_grafico(x, y, Mx, 'Mx', 'Mx(x,y) [N*m/m]');

%% Momento flector por unidad de longitud My
hacer_grafico(x, y, My, 'My', 'My(x,y) [N*m/m]');

%% Momento torsor por unidad de longitud  Mxy
hacer_grafico(x, y, Mxy, 'Mxy', 'Mxy(x,y) [N*m/m]');
 
%% Fuerza cortante por unidad de longitud Qx
hacer_grafico(x, y, Qx, 'Qx', 'Qx(x,y) [N/m]');

%% Fuerza cortante por unidad de longitud Qy
hacer_grafico(x, y, Qy, 'Qy', 'Qy(x,y) [N/m]');

%% Calculo los momentos principales Mf1 y Mf2, el angulo con respecto al 
%% eje X en que se producen y el momento torsor maximo
Mf1 = (Mx+My)/2 + sqrt(((Mx-My)/2).^2 + Mxy.^2);
Mf2 = (Mx+My)/2 - sqrt(((Mx-My)/2).^2 + Mxy.^2);
ang = 0.5*atan2(2*Mxy, Mx-My); %en rad
Mtmax = (Mf1-Mf2)/2;

%% Momentos flectores principales Mf1 por unidad de longitud
hacer_grafico(x, y, Mf1, 'Mf1', 'Mf1(x,y) [N*m/m]', ...
    ang, [0, pi]);

%% Momentos flectores principales Mf2 por unidad de longitud
hacer_grafico(x, y, Mf2, 'Mf2', 'Mf2(x,y) [N*m/m]', ...
    ang, [pi/2, -pi/2]);

%% Momentos torsores maximos Mtmax por unidad de longitud
hacer_grafico(x, y, Mtmax, 'Mtmax', 'Mtmax(x,y) [N*m/m]', ...
    ang, [pi/4, -pi/4, 3*pi/4, -3*pi/4]);

%!find ./ -name "*.png" -exec convert {} -trim {} \; # remove whitespace .png
%{
!mogrify -trim *.png
!mogrify -format eps3 *.png
!rm *.eps
!rename 's/\.eps3$/\.eps/' *.eps3
%}