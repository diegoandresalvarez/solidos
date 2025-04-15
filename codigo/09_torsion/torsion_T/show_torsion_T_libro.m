%% Torsion de una barra con seccion transversal T
E  = 21000000;     % kPa = 21GPa - módulo de Young del acero
nu = 0.28;         % coeficiente de Poisson del acero
G  = E/(2*(1+nu)); % modulo de cortante
L  = 1;            % m
rho_L = 0.05;      % rad
theta = rho_L/L;   % rad/m
delta = 0.0025;    % espaciado de la malla (metros)
borde  = ... % coordenadas del borde (x,y) que forman el perimetro
[0.01 0.00
 0.02 0.00
 0.02 0.02
 0.03 0.02
 0.03 0.03
 0.00 0.03
 0.00 0.02
 0.01 0.02
 0.01 0.00 ]; %observe que se repite la primera fila

% Especifique un punto (x,y) dentro del sólido (semilla para la maximización)
xden = 0.015;
yden = 0.015;

%% Aqui hice copy/paste de MS EXCEL de la funcion de tension de Prandtl phi
phi = xlsread('torsionT.xlsx','Prandtl','phi');
phi = flipud(phi);

%% Aqui hice copy/paste de MS EXCEL de la funcion de alabeo psi
psi = xlsread('torsionT.xlsx','Alabeo','psi');
psi = flipud(psi);

%% Aquí defino las coordenas en x e y que estoy manejando
x = 0:delta:0.03;
y = 0:delta:0.03;

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
txz = G*theta*(deriv_x(psi)-yy);
tyz = G*theta*(deriv_y(psi)+xx);

%% Elimino los nodos ficticios alrededor de psi
psi = psi(2:end-1,2:end-1);

% Detecto los NaN en phi para eliminar nodos ficticios en txz y tyz (volverlos NaN);
txz(isnan(phi)) = NaN;
tyz(isnan(phi)) = NaN;
psi(isnan(phi)) = NaN;

%% Grafico que representa los esfuerzos tau_xz
figure             % Preparar al MATLAB para hacer una figura
pcolor(xx,yy,txz); % Hacer un dibujo en 2D de los esfuerzos en tau_xz
hold on;           % Permitir hacer modificaciones al dibujo anterior
shading interp;    % Hacer interpolacion de colores
hcb = colorbar;    % Poner la barra de colores
axis equal         % Hacer un grafico con coordenadas de igual tamaÃ±o
[C,h] = contour(xx,yy,txz,20,'k'); % Dibujar 20 curvas de nivel (isobaras)
set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2);
% title('Esfuerzos cortantes \tau_{xz}','FontSize', 18) % Escribir el titulo
% Defino las coordenadas que quiero visualizar [xmin xmax ymin ymax]
axis([x(1) x(end) y(1) y(end)]);
% Dibujo los bordes de la figura
plot(borde(:,1), borde(:,2), 'k-', 'LineWidth',5)
%xlabel('Eje x','FontSize',16);
%ylabel('Eje y','FontSize',16);
xlabel('Eje x');
ylabel('Eje y');
print('-depsc2','txz_T.eps'); 


%% Grafico que representa los esfuerzos tau_yz
figure             % Preparar al MATLAB para hacer una figura
pcolor(xx,yy,tyz); % Hacer un dibujo en 2D de los esfuerzos en tau_yz
hold on;           % Permitir hacer modificaciones al dibujo anterior
shading interp;    % Hacer interpolacion de colores
hcb = colorbar;    % Poner la barra de colores
axis equal         % Hacer un grafico con coordenadas de igual tamaÃ±o
[C,h] = contour(xx,yy,tyz,20,'k'); % Dibujar 20 curvas de nivel (isobaras)
set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2);
%title('Esfuerzos cortantes \tau_{yz}','FontSize', 18) % Escribir el titulo
% Defino las coordenadas que quiero visualizar [xmin xmax ymin ymax]
axis([x(1) x(end) y(1) y(end)]);
% Dibujo los bordes de la figura
plot(borde(:,1), borde(:,2), 'k-', 'LineWidth',5);
%xlabel('Eje x','FontSize',16);
%ylabel('Eje y','FontSize',16);
xlabel('Eje x');
ylabel('Eje y');
print('-depsc2','tyz_T.eps'); 


tau = sqrt(txz.^2 + tyz.^2);
maxtau = max(max(tau));
%% Grafico que representa los esfuerzos tau
figure            % Preparar al MATLAB para hacer una figura
surf(xx,yy,tau);  % Hacer un dibujo en 2D de los esfuerzos en tau_yz
hold on;          % Permitir hacer modificaciones al dibujo anterior
shading interp;   % Hacer interpolacion de colores
hcb = colorbar;   % Poner la barra de colores
contour(xx,yy,tau,20,'k'); % Dibujar 20 curvas de nivel (isobaras)
%title('Esfuerzos cortantes \tau','FontSize', 18) % Escribir el titulo
% Defino las coordenadas que quiero visualizar [xmin xmax ymin ymax zmin zmax]
axis([x(1) x(end) y(1) y(end) 0 maxtau]);
% Dibujo los bordes de la figura
plot(borde(:,1), borde(:,2), 'k-', 'LineWidth',5)
% Dibujo los esfuerzos cortantes
quiver(xx,yy,txz,tyz);
%xlabel('Eje x','FontSize',16);
%ylabel('Eje y','FontSize',16);
%zlabel('Esfuerzo cortante \tau','FontSize',16);
xlabel('Eje x');
ylabel('Eje y');
print('-depsc2','tau_T.eps'); 



maxphi = max(max(phi));
%% Grafico que representa la funcion de tension de Prandtl
figure            % Preparar al MATLAB para hacer una figura
surf(xx,yy,phi);  % Hacer un dibujo en 2D de phi
hold on;          % Permitir hacer modificaciones al dibujo anterior
shading interp;   % Hacer interpolacion de colores
hcb = colorbar;   % Poner la barra de colores
contour(xx,yy,phi,20,'k'); % Dibujar 20 curvas de nivel (isobaras)
%title({'Funcion de tension de Prandtl \phi','(solucion numerica)'},'FontSize', 18) % Escribir el titulo
% Defino las coordenadas que quiero visualizar [xmin xmax ymin ymax zmin zmax]
axis([x(1) x(end) y(1) y(end) 0 maxphi]);
% Dibujo los bordes de la figura
plot(borde(:,1), borde(:,2), 'k-', 'LineWidth',5)
%xlabel('Eje x','FontSize',16);
%ylabel('Eje y','FontSize',16);
%zlabel('phi',  'FontSize',16);
xlabel('Eje x');
ylabel('Eje y');
print('-depsc2','phi_T.eps'); 



%% Grafico que representa la funcion de tension de Prandtl
figure             % Preparar al MATLAB para hacer una figura
pcolor(xx,yy,phi); % Hacer un dibujo en 2D de los esfuerzos en tau_yz
hold on;           % Permitir hacer modificaciones al dibujo anterior
contour(xx,yy,phi,10,'k'); % Dibujar 20 curvas de nivel (isobaras)
shading interp;    % Hacer interpolacion de colores
colormap pink      % Que colores quiero utilizar?
hcb = colorbar;    % Poner la barra de colores
axis equal         % Hacer un grafico con coordenadas de igual tamaÃ±o
%title({'Curvas de nivel de la funcion de tension de Prandtl \phi',...
%   'Se muestran ademas los esfuerzos tangenciales',},'FontSize', 18) % Escribir el titulo
% Defino las coordenadas que quiero visualizar [xmin xmax ymin ymax]
axis([0.9*x(1) 1.1*x(end) 0.9*y(1) 1.1*y(end)]);
% Dibujo los bordes de la figura
plot(borde(:,1), borde(:,2), 'k-', 'LineWidth',5)
% Dibujo los esfuerzos cortantes
quiver(xx,yy,txz,tyz);
%xlabel('Eje x','FontSize',16);
%ylabel('Eje y','FontSize',16);


% Reemplazar los NaNs por ceros antes de minimizar
phi(isnan(phi)) = 0;

%% Encontrar el centro de torsion
options = optimset('fminsearch');
options.MaxFunEvals = 6000;
ct = fminsearch(@(x) -interp2(xx,yy,phi,x(:,1),x(:,2)), [xden, yden], options);
h = plot(ct(1), ct(2), 'r*', 'MarkerSize',15);
legend(h, 'Centro de torsion','Location','BestOutside');
xlabel('Eje x');
ylabel('Eje y');
print('-depsc2','phi_cn_T.eps'); 


%% Calcular el momento torsor equivalente
fprintf('Calculanto momento torsor... un momento por favor.\n')
% q = dblquad(fun,xmin,xmax,ymin,ymax)
Mt = 2*dblquad(@(x,y) interp2(xx,yy,phi, x,y), x(1), x(end), y(1), y(end));
texto_Mt = sprintf('Momento torsor = %g kN-m',Mt);
xlabel(texto_Mt,'FontSize', 16);
fprintf('%s\n',texto_Mt);

%% Calcular la inercia torsional J
fprintf('Calculanto la inercia torsional J ...\n')
J = Mt/(G*theta);
fprintf('J = %g m^4\n',J);


%% Calculo el alabeo
w = theta*psi;

%% Grafico el alabeo w = theta*psi
figure            % Preparar al MATLAB para hacer una figura
surf(xx,yy,w);    % Hacer un dibujo en 2D del alabeo
hold on;          % Permitir hacer modificaciones al dibujo anterior
shading interp;   % Hacer interpolacion de colores
colorbar          % Poner la barra de colores
axis tight
contour(xx,yy,w,20,'k'); % Dibujar 20 curvas de nivel
%title({'Desplazamiento en z (alabeo) w(x,y) = theta*\Psi(x,y)','(solucion numerica)'},'FontSize', 18) % Escribir el titulo
% Dibujo los bordes de la figura
plot(borde(:,1), borde(:,2), 'k-', 'LineWidth',5)
%xlabel('Eje x','FontSize',16);
%ylabel('Eje y','FontSize',16);
%zlabel('Alabeo w(x,y)','FontSize',16);
xlabel('Eje x');
ylabel('Eje y');
%title('w')
print('-depsc2','alabeo_T.eps'); 


%% Se dibuja la barra deformada + alabeo
%% Recupero el borde
borde = xlsread('torsionT.xlsx','borde','borde');
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

figure; surf(Z,Y,X); %axis equal;
hold on
for z = 1:11
   zz = LL(z);
   xnew = cos(theta*zz)*xx - sin(theta*zz)*yy;
   ynew = sin(theta*zz)*xx + cos(theta*zz)*yy;
   surf(zz-escala*w,ynew,xnew);
end

%xlabel('Eje Z')
%ylabel('Eje X')
%zlabel('Eje Y')
%title('Barra deformada')

%camlight
%lighting gouraud
colormap([1 1 1]*0.7)
camproj('perspective')
material dull
axis off

%xlabel('Eje x');
%ylabel('Eje y');
%title('w')
print('-depsc2','deformada_T.eps'); 

return; %bye bye