%% Solución usando el toolbox de ecuaciones diferenciales parciales de 
%% MATLAB R2019a
clear all  % se borra la memoria
clc        % se borra la pantalla 
close all  % se borran las gráficas existentes en el entorno

%% Se definen las constantes
E = 21e9;         % [Pa] = módulo de elasticidad       
nu = 0.28;        % coeficiente de Poisson
G = E/(2*(1+nu)); % módulo de cortante 
theta = 5*pi/180; % [rad/m] = ángulo de giro/unidad longitud

%% Se define la geometría [m]
% Se definen los vértices del polígono Omega_z (en metros)
vertices = [ ...
     0.02     0.00     % A         estas coordenadas se deben
     0.02     0.02     % B         definir de forma contigua
     0.03     0.02     % C         de modo tal que al unirlas 
     0.03     0.03     % D         con líneas se trace en
     0.00     0.03     % E         sentido antihorario la 
     0.00     0.02     % F         geometría de la sección
     0.01     0.02     % G         transversal
     0.01     0.00 ];  % H
num_vertices = size(vertices, 1); % número de vértices de Omega_z

% Se calcula el área A y el centroide (Cx,Cy) del polígono
[Cx, Cy, A] = centroide(vertices);

% El origen de coordenadas esta en el centroide del poligono
vert_x = vertices(:,1) - Cx;
vert_y = vertices(:,2) - Cy;

% Se crea la geometría
Omega_z = decsg([2         % código para definir poligonos
              num_vertices % número de vértices del polígono
              vert_x       % coord x de los vértices del polígono
              vert_y]);    % coord y de los vértices del polígono

% Se dibuja la geometría
figure
pdegplot(Omega_z, 'EdgeLabels', 'on', 'SubdomainLabels', 'on')
xlabel('x'' [m]'); ylabel('y'' [m]'); axis equal;
           
%% Se inicializa el objeto modelo de elementos finitos
modelo = createpde();
           
% Se incluye la geometría en el modelo 
geometryFromEdges(modelo, Omega_z);

% Se definen los parametros de la ecuacion diferencial
% m*diff(u,t,2) + d*diff(u,t) - div(c*grad(u)) + a*u = f
specifyCoefficients(modelo, ...
   'm', 0, ...           % masa            (= 0 para problema estatico)
   'd', 0, ...           % amortiguamiento (= 0 para problema estatico)
   'c', 1, ...
   'a', 0, ...
   'f', 0);

%% Se definen las condiciones de frontera de Neumann 
% dot((c*grad(u)), n) + q*u = g
applyBoundaryCondition(modelo, 'neumann', ...
    'Edge', 1:8, ...
    'g', @(r,s) r.y.*r.nx - r.x.*r.ny, ...
    'q', 0, ...
    'Vectorized', 'on'); 
 
%% Se genera la malla de elementos finitos (elementos tri3)
% La longitud maxima de un lado de un elemento finito sera 0.0001 m
msh = generateMesh(modelo, 'Hmax', 0.0001, 'GeometricOrder', 'linear');

%% Se grafica la malla de elementos finitos
figure
pdeplot(modelo)
xlabel('x'' [m]'); ylabel('y'' [m]'); axis equal tight;

%% Se resuelve el modelo por el metodo de los elementos finitos
sol = solvepde(modelo);
psi = sol.NodalSolution;

%% Se extraen las coordenadas globales de los nodos (xnod)
%% y los triangulos (LaG) que son los elementos finitos
xnod = msh.Nodes;
LaG  = msh.Elements;

% se calcula el area de cada EF
[~, Area] = area(msh); Area = Area';

xp = xnod(1,:)';           % coordenada x de cada nodo
yp = xnod(2,:)';           % coordenada y de cada nodo
% II, JJ, KK son el indice de los nodos que forma cada EF
II = LaG(1,:); JJ = LaG(2,:); KK = LaG(3,:);

%% Se calculan Ix, Iy, Ixz, Q_psi, Ix_psi, Iy_psi, xc, yc y psip
integral_OmegaL = @(f) sum(Area.*(f(II) + f(JJ) + f(KK)))/3;
Ix     = integral_OmegaL(yp.^2);
Iy     = integral_OmegaL(xp.^2);
Ixy    = integral_OmegaL(xp.*yp);
Q_psi  = integral_OmegaL(psi);
Ix_psi = integral_OmegaL(xp.*psi);
Iy_psi = integral_OmegaL(yp.*psi);

xc =  (Ix_psi*Ixy - Iy*Iy_psi)/(Ix*Iy - Ixy^2);
yc = -(Iy_psi*Ixy - Ix*Ix_psi)/(Ix*Iy - Ixy^2);

fprintf('x_cen_torsion = %g m\n', Cx + xc);
fprintf('y_cen_torsion = %g m\n', Cy + yc);

psip = psi - yc.*xp + xc.*yp - Q_psi/A;

%% Se calcula dpsip_dxp y dpsip_dyp en los nodos de la malla
[dpsi_dxp, dpsi_dyp] = evaluateGradient(sol);
dpsip_dxp = dpsi_dxp - yc;
dpsip_dyp = dpsi_dyp + xc;

%% Se calcula la inercia torsional J
x = xp - xc;
y = yp - yc;
dpsi_dx = dpsip_dxp;
dpsi_dy = dpsip_dyp;
J  = integral_OmegaL(x.^2 + y.^2 + dpsi_dy.*x - dpsi_dx.*y);
Mt = G*theta*J;
fprintf('J  = %g m^4/rad\n', J);
fprintf('Mt = %g N m\n', Mt);

%% Se grafica la solucion (la funcion de alabeo de Saint-Venant)
figure
pdeplot(modelo, 'xydata', psip, 'zdata', psip, ...
   'colormap', 'jet', ...
   'title', ['Función de alabeo de Saint-Venant ' ... 
             '\psi''(x'',y'') [m/rad]']);
hold on;
h = plot(xc, yc,'rx', 0, 0, 'ro');
legend(h, 'Centro de torsión', 'Centroide', 'Location', 'Best')
xlabel('x'' [m]'); ylabel('y'' [m]');
grid on
axis tight
% print('psip.png','-dpng','-r200');

%% Se calculan los esfuerzos cortantes en Omega_L (en los nodos)
txpz = G*theta*(dpsip_dxp - yp + yc);
typz = G*theta*(dpsip_dyp + xp - xc);
tau = sqrt(txpz.^2 + typz.^2);

%% Se grafica la magnitud de los esfuerzos cortantes
figure
%{
pdeplot(modelo, 'xydata', tau, 'zdata', tau, ...
   'contour', 'on', ...        % hacer curvas de nivel
   'levels', 30, ...           % numero de curvas de nivel
   'colormap', 'jet', ...  
   'title', ['Esfuerzos cortantes \tau''(x'',y'') ' ...
             'sobre la cara \Omega_L [Pa]']);
%}

%{
pdeplot(modelo, 'xydata', tau, 'zdata', tau, ...
   'colormap', 'jet', ...  
   'title', ['Esfuerzos cortantes \tau''(x'',y'') ' ...
             'sobre la cara \Omega_L [Pa]']);
%}
          
numcurvasnivel = 30;
h = pdeplot(modelo, 'xydata', tau,  ...   
   'contour', 'on', ...         % hacer curvas de nivel
   'xystyle', 'off', ...        % no coloque color de relleno
   'levels', numcurvasnivel,... % numero de curvas de nivel
   'title', ['Esfuerzos cortantes \tau''(x'',y'') ' ...
             'sobre la cara \Omega_L [Pa]']);   

for i = 1:numcurvasnivel, set(h(i), 'color', 'k'); end

hold on;
h = plot(xc, yc,'kx', 0, 0, 'k+');
legend(h, 'Centro de torsión', 'Centroide', 'Location', 'Best')
xlabel('x'' [m]'); ylabel('y'' [m]');
grid on
axis tight
% print('taup.png','-dpng','-r200');

%% Se grafican los esfuerzos cortantes txpz y typz
figure
pdeplot(modelo, 'xydata', txpz, ...
   'contour', 'on', ...        % hacer curvas de nivel
   'levels', 30, ...           % numero de curvas de nivel
   'colormap', 'jet', ...  
   'title', ['Esfuerzos cortantes \tau_{x''z}(x'',y'') ' ...
             'sobre la cara \Omega_L [Pa]']);
xlabel('x'' [m]'); ylabel('y'' [m]');
axis equal tight
% print('txpz.png','-dpng','-r200');

figure
pdeplot(modelo, 'xydata', typz, ...
   'contour', 'on', ...        % hacer curvas de nivel
   'levels', 30, ...           % numero de curvas de nivel
   'colormap', 'jet', ...  
   'title', ['Esfuerzos cortantes \tau_{y''z}(x'',y'') ' ...
             'sobre la cara \Omega_L [Pa]']);
xlabel('x'' [m]'); ylabel('y'' [m]');
axis equal tight
% print('typz.png','-dpng','-r200');
% print('-depsc','typz.eps')
% exportgraphics(gcf,'typz2.eps','BackgroundColor','none','ContentType','vector')

%{
x_cen_torsion = 0.015 m
y_cen_torsion = 0.0229586 m
J  = 1.63475e-08 m^4/rad
Mt = 11.7025 N m

mogrify -trim *.png
mogrify -format eps3 *.png
%}
