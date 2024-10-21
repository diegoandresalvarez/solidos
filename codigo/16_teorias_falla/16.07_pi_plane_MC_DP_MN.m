clear, clc, close all

%% parámetros del gráfico de la superficie de falla
n = 4;   % número de divisiones por plano
m = 2*n; % número de divisiones de la componente hidrostática

%% parámetros del modelo de Mohr-Coulomb
c = 2;
phi = 20; % grados

%% se calcula el ángulo de Lode (y se repite por la propiedad de simetría)
th    = linspace(0, 60, n); 
theta = [ th th(end-1:-1:2) th th(end-1:-1:2) th th(end-1:-1:1) ];

%% se calcula la superficie de fluencia de Mohr-Coulomb con la ecuación (*\eqref{eq:MCconHWcilindricalcoord}*)
xi = 0; % ya que se desea trabajar sobre el plano PI
num = c*cosd(phi) - (xi/sqrt(3))*sind(phi);
den = sqrt(1/2)*(sind(theta + 60) + cosd(theta + 60)/sqrt(3)*sind(phi));
rho = num./den;

figure
theta_ = linspace(0, 360, 5*n-1);
x = rho.*cosd(theta_ + 90);
y = rho.*sind(theta_ + 90);
hold on;
plot(x, y);
r = 5;
plot([r 0 0], [0 0 r], 'k'); % ejes x y y
axis equal
axis([-r r -r r]);

%{
%%  se calcula el radio de Drucker-Prager (exterior)
xi = 0;    % ya que se desea trabajar sobre el plano PI
theta = 60;
num = c*cosd(phi) - (xi/sqrt(3))*sind(phi);
den = sqrt(1/2)*(sind(theta + 60) + cosd(theta + 60)/sqrt(3)*sind(phi));
rho_ext = num./den;

theta_ = linspace(0, 360, 100);
x = rho_ext.*cosd(theta_ + 90);
y = rho_ext.*sind(theta_ + 90);
plot(x,y,'r');

%%  se calcula el radio de Drucker-Prager (interior)
xi = 0;    % ya que se desea trabajar sobre el plano PI
theta = 0;
num = c*cosd(phi) - (xi/sqrt(3))*sind(phi);
den = sqrt(1/2)*(sind(theta + 60) + cosd(theta + 60)/sqrt(3)*sind(phi));
rho_int = num./den;

x = rho_int.*cosd(theta_ + 90);
y = rho_int.*sind(theta_ + 90);
plot(x,y,'b');

legend('Mohr-Coulomb','Drucker-Prager (exterior)', 'Drucker-Prager (interior)')
%}

%%
xi = 0;    % ya que se desea trabajar sobre el plano PI
rho = zeros(1, 100);
s0  = c*cotd(phi);
kMN = (9 - sind(phi)^2)/(1 - sind(phi)^2); % ecuación (*\eqref{eq:kMNphi}*)
theta_ = linspace(0, 360, 100);
cos3theta = cosd(3*theta_);
for j = 1:100
    if abs(cos3theta(j)) < 1e-9 % ecuación (*\eqref{eq:rho_MN_cos3t_0}*)
        rho(j) = sqrt((2*(kMN-9))/(3*(kMN-3)))*...
            abs(xi-sqrt(3)*s0);
    else
        % se calculan los coeficientes (*\eqref{eq:coef_c1c2c3c4_MN}*)
        c0 =  sqrt(3)*(kMN - 9)*(xi - sqrt(3)*s0)^3/9;
        c2 = -sqrt(3)*(kMN - 3)*(xi - sqrt(3)*s0)/6;
        c3 = sqrt(6)*kMN*cos3theta(j)/18;
        % se corrigen los errores de cálculo en los ceros
        if abs(c0) < 1e-9, c0 = 0; end
        if abs(c2) < 1e-9, c2 = 0; end
        sol = roots([c3 c2 0 c0]); % raíces del polinomio (*\eqref{eq:MatsuokaNakai_pol1}*)
        
        % de las raíces se escoje la positiva, ya que rho >= 0
        rho(j) = max(sol(2), sol(3));
        
        COLOR = 'b';
    end
end

x = rho.*cosd(theta_ + 90);
y = rho.*sind(theta_ + 90);
plot(x,y,'r');

legend('Mohr-Coulomb','Matsuoka-Nakai')