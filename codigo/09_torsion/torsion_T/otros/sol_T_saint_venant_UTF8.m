clear all  % se borra la memoria
clc        % se borra la pantalla 
close all  % se borran las graficas existentes en el entorno

% Se definen las constantes
E = 21e9;         % [Pa] = modulo de elasticidad       
nu = 0.28;        % coeficiente de Poisson
G = E/(2*(1+nu)); % modulo de cortante 
theta = 5*pi/180; % [rad/m] = angulo de giro/unidad longitud

% Se definen los vertices del poligono Omega_z
vertices = [ ...
     0.02     0.00     % A         estas coordenadas se deben 
     0.02     0.02     % B         definir de forma contigua
     0.03     0.02     % C         de modo tal que al unirlas 
     0.03     0.03     % D         con lineas se trace en
     0.00     0.03     % E         sentido antihorario la 
     0.00     0.02     % F         geometria de la seccion 
     0.01     0.02     % G         transversal 
     0.01     0.00 ];  % H
num_vertices = size(vertices, 1); % numero de vertices de Omega_z

% Se calcula el area A y el centroide (Cx,Cy) del poligono
[Cx, Cy, A] = centroide(vertices);

% El origen de coordenadas esta en el centroide del poligono
vert_x = vertices(:,1) - Cx;
vert_y = vertices(:,2) - Cy;

% Se crea la geometria
Omega_z = decsg([2         % codigo para definir poligonos
              num_vertices % numero de vertices del poligono
              vert_x       % coord x de los vertices del poligono
              vert_y]);    % coord y de los vertices del poligono

% Se inicializa el objeto modelo de elementos finitos
modelo = createpde;
           
% Se incluye la geometria en el modelo 
geometryFromEdges(modelo, Omega_z);

% Se dibuja la geometria
figure
pdegplot(Omega_z, 'EdgeLabels', 'on', 'SubdomainLabels', 'on')
xlabel('x'' [m]'); ylabel('y'' [m]'); axis equal;

% Se definen los parametros de la ecuacion diferencial
% - div(c*grad(u)) + a*u = f
c = 1;
a = 0;
f = 0;

% Se definen las condiciones de frontera de Neumann 
% dot((c*grad(u)), n) + q*u = g
applyBoundaryCondition(modelo, ...
    'Edge', 1:8, ...
    'g', @(r,s) r.y.*r.nx - r.x.*r.ny, ...
    'q', 0, ...
    'Vectorized', 'on'); 

% Se genera la malla de elementos finitos. La longitud maxima
% de un lado de un elemento finito sera 0.0001 m
generateMesh(modelo, 'Hmax', 0.0001);

% Se grafica la malla de elementos finitos
figure
pdeplot(modelo)
xlabel('x'' [m]'); ylabel('y'' [m]'); axis equal tight;

% Se resuelve el modelo por el metodo de los elementos finitos
psi = assempde(modelo, c, a, f);

% Se extraen las coordenadas globales de los nodos (xnod)
% y los triangulos (LaG) que son los elementos finitos
xnod = modelo.Mesh.Nodes;
LaG  = modelo.Mesh.Elements;
area = pdetrg(xnod, LaG)'; % se calcula el area de cada EF
xp = xnod(1,:)';           % coordenada x de cada nodo
yp = xnod(2,:)';           % coordenada y de cada nodo
% II, JJ, KK son el indice de los nodos que forma cada EF
II = LaG(1,:); JJ = LaG(2,:); KK = LaG(3,:);

% Se calcula Ix, Iy, Ixz, Q_psi, Ix_psi, Iy_psi, xc, yc y psip
integral_OmegaL = @(f) sum(area.*(f(II) + f(JJ) + f(KK)))/3;
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

% Se calcula dpsip_dxp y dpsip_dyp en el centro de cada EF
[dpsip_dxp_en_EFs, dpsip_dyp_en_EFs] = pdegrad(xnod, LaG, psip);

% Se interpolan dichos esfuerzos a los nodos de cada EF
dpsip_dxp = pdeprtni(xnod, LaG, dpsip_dxp_en_EFs);
dpsip_dyp = pdeprtni(xnod, LaG, dpsip_dyp_en_EFs);

% Se calcula la inercia torsional J
x = xp - xc;
y = yp - yc;
dpsi_dx = dpsip_dxp;
dpsi_dy = dpsip_dyp;
J  = integral_OmegaL(x.^2 + y.^2 + dpsi_dy.*x - dpsi_dx.*y);
Mt = G*theta*J;
fprintf('J  = %g m^4/rad\n', J);
fprintf('Mt = %g N m\n', Mt);

% Se grafica la solucion (la funcion de alabeo de Saint-Venant)
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
print('psip.png','-dpng','-r200');

% Se calculan los esfuerzos cortantes en Omega_L
txpz = G*theta*(dpsip_dxp - yp + yc);
typz = G*theta*(dpsip_dyp + xp - xc);
tau_en_nodos = sqrt(txpz.^2 + typz.^2);

% Se grafica la magnitud de los esfuerzos cortantes
figure
pdeplot(modelo, 'xydata', tau_en_nodos, 'zdata', tau_en_nodos, ...
   'contour', 'on', ...        % hacer curvas de nivel
   'levels', 30, ...           % numero de curvas de nivel
   'colormap', 'jet', ...  
   'title', ['Esfuerzos cortantes \tau''(x'',y'') ' ...
             'sobre la cara \Omega_L [Pa]']);
hold on;
h = plot(xc, yc,'kx', 0, 0, 'k+');
legend(h, 'Centro de torsión', 'Centroide', 'Location', 'Best')
xlabel('x'' [m]'); ylabel('y'' [m]');
grid on
axis tight
print('taup.png','-dpng','-r200');

% Se grafican los esfuerzos cortantes txpz y typz
figure
pdeplot(modelo, 'xydata', txpz, ...
   'contour', 'on', ...        % hacer curvas de nivel
   'levels', 30, ...           % numero de curvas de nivel
   'colormap', 'jet', ...  
   'title', ['Esfuerzos cortantes \tau_{x''z}(x'',y'') ' ...
             'sobre la cara \Omega_L [Pa]']);
xlabel('x'' [m]'); ylabel('y'' [m]');
axis equal tight
print('txpz.png','-dpng','-r200');

figure
pdeplot(modelo, 'xydata', typz, ...
   'contour', 'on', ...        % hacer curvas de nivel
   'levels', 30, ...           % numero de curvas de nivel
   'colormap', 'jet', ...  
   'title', ['Esfuerzos cortantes \tau_{y''z}(x'',y'') ' ...
             'sobre la cara \Omega_L [Pa]']);
xlabel('x'' [m]'); ylabel('y'' [m]');
axis equal tight
print('typz.png','-dpng','-r200');

%{
x_cen_torsion = 0.0149999 m
y_cen_torsion = 0.0229589 m
J  = 1.63461e-08 m^4/rad
Mt = 11.7015 N m

mogrify -trim *.png
mogrify -format eps3 *.png
%}
