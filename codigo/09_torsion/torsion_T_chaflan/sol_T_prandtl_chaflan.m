clear all  % se borra la memoria
clc        % se borra la pantalla 
close all  % se borran las graficas existentes en el entorno

% Se definen las constantes
E = 21e9;         % [Pa] = modulo de elasticidad       
nu = 0.28;        % coeficiente de Poisson
G = E/(2*(1+nu)); % modulo de cortante 
theta = 5*pi/180; % [rad/m] = angulo de giro/unidad longitud

nch = 101;
chaflanes = logspace(-5,-2,nch);
tmax1 = zeros(nch,1);
tmax2 = zeros(nch,1);
for i = 1:nch;
i
ch = chaflanes(i);

% Se definen los vertices de la T
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

% Se crea la geometria
T = [2                % codigo para el poligono
     num_vertices     % numero de vertices del poligono
     vertices(:,1)    % coord x de los vertices del poligono
     vertices(:,2)];  % coord y de los vertices del poligono

C1 = [1,              % codigo para el circulo
      0.02+ch,        % x centro
      0.02-ch         % y centro 
      ch];            % radio

C2 = [1,              % codigo para el circulo
      0.01-ch,        % x centro
      0.02-ch         % y centro 
      ch];            % radio

R1 = [3,                 % codigo para el rectangulo
      4,                 % numero lados
      [0.01-ch  0.02+ch 0.02+ch 0.01-ch]',   % x nodos
      [0.02-ch  0.02-ch 0.020   0.02]']; % y nodos   
   
% R1 = [3,                 % codigo para el rectangulo
%       4,                 % numero lados
%       [0.005   0.025 0.025 0.005]',   % x nodos
%       [0.015   0.015 0.020 0.020]']; % y nodos
        
tmp = max([length(T),length(C1),length(C2),length(R1)]);         
gd = zeros(tmp, 4);         
             
gd(1:length(T), 1) = T;
gd(1:length(C1),2) = C1;
gd(1:length(C2),3) = C2;
gd(1:length(R1),4) = R1;

ns = char('T','C1','C2','R1')';

sf = 'T+R1-C1-C2';

[dl, bt] = decsg(gd, sf, ns);
Omega_z = csgdel(dl, bt);


% Se inicializa el objeto modelo de elementos finitos
modelo = createpde;
           
% Se incluye la geometria en el modelo 
geometryFromEdges(modelo, Omega_z);

% Se dibuja la geometria
%{
figure
pdegplot(Omega_z, 'EdgeLabels', 'on', 'SubdomainLabels', 'on')
xlabel('x [m]'); ylabel('y [m]'); axis equal;
%}

% Se definen los parametros de la ecuacion diferencial
% - div(c*grad(u)) + a*u = f
c = -1;
a = 0;
f = -2*G*theta;

% Se definen las condiciones de frontera de Dirichlet (h*u = r)
% La solucion vale cero en todos los ocho bordes de la T
applyBoundaryCondition(modelo, ...
   'Edge', 1:10, ...
   'u',    0);

% Se genera la malla de elementos finitos. La longitud maxima
% de un lado de un elemento finito sera 0.0001 m
generateMesh(modelo, 'Hmax', 0.0001);

%{
% Se grafica la malla de elementos finitos
figure
pdeplot(modelo)
xlabel('x [m]'); ylabel('y [m]'); axis equal tight;
%}

% Se resuelve el modelo por el metodo de los elementos finitos
phi = assempde(modelo, c, a, f);

%{
% Se grafica la solucion (la funcion de tension de Prandtl)
figure
pdeplot(modelo, 'xydata', phi, 'zdata', phi, ...
   'colormap', 'jet', ...
   'title', 'Función de tensión de Prandtl \phi(x,y)');
grid on
axis tight
xlabel('x [m]'); ylabel('y [m]');
print('phi.png','-dpng','-r200');
%}

% Se extraen las coordenadas globales de los nodos (xnod)
% y los triangulos (LaG) que son los elementos finitos
xnod = modelo.Mesh.Nodes;
LaG  = modelo.Mesh.Elements;

% Se calculan los esfuerzos cortantes en Omega_L
[dphi_dx, dphi_dy] = pdegrad(xnod, LaG, phi);
txz =  dphi_dy;
tyz = -dphi_dx;

% esfuerzo cortante tau en cada EF
tau_en_EFs   = sqrt(txz.^2 + tyz.^2);    

% se interpola el esfuerzo cortante tau a los nodos
tau_en_nodos = pdeprtni(xnod,LaG,tau_en_EFs); 

tmax1(i) = max(tau_en_nodos);
tmax2(i) = max(tau_en_EFs)
end

figure
plot(chaflanes,tmax1,'r',chaflanes,tmax2,'b')
return;

%{
% Se calcula la posicion *aproximada* del centro de torsion
[tau_min, pos] = min(tau_en_nodos);
x_cen_torsion = xnod(1,pos);
y_cen_torsion = xnod(2,pos);
fprintf('x_cen_torsion = %g m\n', x_cen_torsion);
fprintf('y_cen_torsion = %g m\n', y_cen_torsion);
%}

%{
% Se grafican las curvas de nivel de la funcion de tension de 
% Prandtl y los esfuerzos cortantes actuantes en Omega_L
figure
hh = pdeplot(modelo, 'xydata', phi, ...
   'contour', 'on', ...        % hacer curvas de nivel de phi
   'levels', 15, ...           % numero de curvas de nivel
   'flowdata', [txz; tyz], ... % flechas del esfuerzo cortante
   'colormap', 'jet', ...   
   'title', 'Trayectorias de los esfuerzos cortantes');  
hold on;
set(hh(18), 'Color', 'm', 'LineWidth', 1.5);
h = plot(x_cen_torsion, y_cen_torsion,'k*');
legend(h, 'Centro de torsión', 'Location', 'Best')
xlabel('x [m]'); ylabel('y [m]');
axis equal tight
grid on 
print('curvas_nivel_phi.png','-dpng','-r200');

% Se calcula Mt en Omega_L
area = pdetrg(xnod, LaG)'; % se calcula el area de cada EF
% II, JJ, KK son el indice de los nodos que forma cada EF
II = LaG(1,:); JJ = LaG(2,:); KK = LaG(3,:);
Mt = 2*sum(area.*(phi(II) + phi(JJ) + phi(KK)))/3;
fprintf('Mt = %g N m\n', Mt);

% Se calcula la inercia torsional J
J = Mt/(G*theta);
fprintf('J = %g m^4/rad\n', J);
%}

% Se grafica la magnitud de los esfuerzos cortantes
figure
pdeplot(modelo, 'xydata', tau_en_nodos, 'zdata', tau_en_nodos, ...
   'contour', 'on', ...        % hacer curvas de nivel
   'levels', 30, ...           % numero de curvas de nivel
   'colormap', 'jet', ...  
   'title', ['Esfuerzos cortantes \tau(x,y) ' ...
             'sobre la cara \Omega_L [Pa]']);   
hold on;
%h = plot(x_cen_torsion, y_cen_torsion,'k*');
%legend(h, 'Centro de torsión', 'Location', 'NorthEast')
xlabel('x [m]'); ylabel('y [m]');
grid on
axis tight
print('tau.png','-dpng','-r200');

% Se grafican los esfuerzos cortantes txz y tyz
figure
txz_en_nodos = pdeprtni(xnod,LaG,txz); % se interpola a los nodos
pdeplot(modelo, 'xydata', txz_en_nodos, ...
   'contour', 'on', ...        % hacer curvas de nivel
   'levels', 30, ...           % numero de curvas de nivel
   'colormap', 'jet', ...  
   'title', ['Esfuerzos cortantes \tau_{x,z}(x,y) ' ...
             'sobre la cara \Omega_L [Pa]']);   
xlabel('x [m]'); ylabel('y [m]');
axis equal tight
print('txz.png','-dpng','-r200');

figure
tyz_en_nodos = pdeprtni(xnod,LaG,tyz); % se interpola a los nodos
pdeplot(modelo, 'xydata', tyz_en_nodos, ...
   'contour', 'on', ...        % hacer curvas de nivel
   'levels', 30, ...           % numero de curvas de nivel
   'colormap', 'jet', ...  
   'title', ['Esfuerzos cortantes \tau_{yz}(x,y) ' ...
             'sobre la cara \Omega_L [Pa]']);
xlabel('x [m]'); ylabel('y [m]');
axis equal tight
print('tyz.png','-dpng','-r200');


%{
Con chaflan 0.005:
max(tau_en_nodos)      1.1722e+07
max(txz_en_nodos)      9.6161e+06
max(tyz_en_nodos)      1.0659e+07

min(txz_en_nodos)     -8.9893e+06
min(tyz_en_nodos)     -1.0657e+07


LOS RESULTADOS LOS son los txz en nodos
load resultados_log 
figure
subplot(1,2,2);
loglog(1000*chaflaneslog(1:92),tmaxlog(1:92));
xlabel('Radio del chaflan [mm]')
ylabel('Esfuerzo cortante maximo [Pa]')
%title('Variación de los esfuerzos cortantes máximos con el radio del chaflán')
grid minor 
axis square tight

load resultados
subplot(1,2,1);
plot(1000*chaflanes(1:92),tmax1(1:92));
xlabel('Radio del chaflan [mm]')
ylabel('Esfuerzo cortante maximo [Pa]')
%title('Variación de los esfuerzos cortantes máximos con el radio del chaflán')
grid minor 
axis square tight
print('variacion_tau_radio_chaflan.eps','-depsc');

%}