%% restriccion inferior: superficie limite inferior en la 
% minimizacion; aqui la posicion de los mastiles y el suelo 
% determinan una restriccion en el problema de minimizacion
Lx = 31;    % m
Ly = 31;    % m
T  = 500;   % N/m
m  = 0.1;   % kg/m^2
g  = -9.81; % m/s^2
delta = 1;  % m

Nx = Lx/delta - 1;
Ny = Ly/delta - 1;
L = zeros(Ny,Nx);

% se especifica la altura del mastil central
idx = round([15:delta:16]/delta);           L(idx,idx) = 5;

% se especifica la altura de los cuatro mastiles laterales
idx = round([5:delta:6 25:delta:26]/delta); L(idx,idx) = 3;

% la matriz L se debe convertir a vector
borde_inf = L(:);         % restriccion inferior

%% Se resuelve el problema de optimizacion
%     minimice (x'*Q*x)/2 + c'*x
%     sujeto a la restriccion borde_inf <= x
num_nodos_int = zeros(Ny+2, Nx+2);
num_nodos_int(2:end-1, 2:end-1) = reshape(1:Nx*Ny, Ny, Nx);
Q =  delta^2*T*mi_delsq(num_nodos_int);
c = -delta^2*m*g*ones(Nx*Ny,1);

% La funcion quadprog() se encuentra en el toolbox de optimizacion
w_ast = quadprog(Q, c, [], [], [], [], borde_inf);

% y se restaura la solucion a la forma original y se incluye la 
% frontera, cuya solucion se conoce y es igual a cero
w = zeros(Ny+2, Nx+2);
w(2:end-1, 2:end-1) = reshape(w_ast, Ny, Nx);

apoyos = zeros(Ny+2, Nx+2);
apoyos(2:end-1, 2:end-1) = L;

%% Graficar la solucion
figure
x = 0:delta:Lx;
y = 0:delta:Ly;
[xx,yy] = meshgrid(x,y);

% Se grafican la forma de la carpa de circo
surfl(xx,yy,w)
alpha(0.3)
hold on;
% se grafica el suelo y los mastiles que soportan la carpa
surf(xx,yy,apoyos,'facecolor',[.5 .5 .5],'edgecolor','none')
light
title('Forma de la superficie de la carpa de circo')
axis tight;
xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]');