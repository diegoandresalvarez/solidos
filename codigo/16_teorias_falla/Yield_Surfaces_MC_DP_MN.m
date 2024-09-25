%% Programa para graficar las superficies de falla de los criterios de
%% Mohr-Coulomb, Drucker-Prager y Matsuoka-Nakai (y como casos especiales 
%% Tresca y von Mises)

%% parámetros del gráfico
n = 8;   % número de divisiones por plano
m = 2*n; % número de divisiones de la componente hidrostática

%% se especifica el tipo de criterio de fluencia/falla a dibujar
MOHR_COULOMB   = 1;
DRUCKER_PRAGER = 2;
MATSUOKA_NAKAI = 3;

modelo = MOHR_COULOMB;

%% se activa el lienzo, de modo que se pueda sobrescribir en él
hold on;
grid on

%% parámetros del material
c   = 2;  %            cohesión
phi = 20; % [grados]   ángulo de fricción

%% se calcula el ángulo de Lode (y se repite por la propiedad de simetría)
th  = linspace(0, 60, n); 
th_ = [ th th(end-1:-1:2) th th(end-1:-1:2) th th(end-1:-1:1) ];

%% se calcula la componente hidrostática
if phi == 0 && (modelo == MOHR_COULOMB || modelo == DRUCKER_PRAGER)
    % en este caso cotd(phi) se vuelve infinito; 
    % si modelo == MOHR_COULOMB   con c=fy/2 y phi=0, se grafica TRESCA
    % si modelo == DRUCKER_PRAGER con c=fy/2 y phi=0, se grafica VON MISES
    xi_ = linspace(-10, 10, m);
else    
    xi_ = linspace(-10, sqrt(3)*c*cotd(phi), m); % ver figura (*\ref{fig:MC_perfil_meridional}*)
end

%% Se calculan theta y xi
[theta, xi] = meshgrid(th_, xi_);

%% se calcula el radio rho de la superficie de fluencia a graficar
switch modelo
    case MOHR_COULOMB
        %% se utiliza la ecuación (*\eqref{eq:MCconHWcilindricalcoord}*)
        num = sqrt(2)*(c*cosd(phi) - (xi/sqrt(3))*sind(phi));
        den = sind(theta + 60) + sind(phi)*cosd(theta + 60)/sqrt(3);
        rho = num./den;
        COLOR = 'r';

    case DRUCKER_PRAGER        
        %% se utiliza la ecuación (*\eqref{eq:fI1J2J3_DruckerPrager}*)
        % pasando por vértices menores, ecuación (*\eqref{eq:DP_vert_menores}*)
        % A = 6*c*cosd(phi)/(sqrt(3)*(3+sind(phi)));
        % B = 2*sind(phi)/(sqrt(3)*(3+sind(phi)));

        % pasando por vértices mayores, ecuación (*\eqref{eq:DP_vert_mayores}*)
        A = 6*c*cosd(phi)/(sqrt(3)*(3-sind(phi)));
        B = 2*sind(phi)/(sqrt(3)*(3-sind(phi)));
        
        rho = sqrt(2)*A - sqrt(6)*B*xi; % ecuación (*\eqref{eq:fI1J2J3_DruckerPrager}*)
        COLOR = 'g';

    case MATSUOKA_NAKAI
        %% se utiliza la ecuación (*\eqref{eq:MatsuokaNakai_pol1}*)
        rho = zeros(m, 6*n-5);
        s0  = c*cotd(phi);
        kMN = (9 - sind(phi)^2)/(1 - sind(phi)^2); % ecuación (*\eqref{eq:kMNphi}*)
        cos3theta = cosd(3*th_);
        for i = 1:m
            for j = 1:6*n-5
                if abs(cos3theta(j)) < 1e-9 % ecuación (*\eqref{eq:rho_MN_cos3t_0}*)
                    rho(i,j) = sqrt((2*(kMN-9))/(3*(kMN-3)))*...
                                                    abs(xi(i,j)-sqrt(3)*s0); 
                else
                    % se calculan los coeficientes (*\eqref{eq:coef_c1c2c3c4_MN}*)
                    c0 =  sqrt(3)*(kMN - 9)*(xi(i,j) - sqrt(3)*s0)^3/9;
                    c2 = -sqrt(3)*(kMN - 3)*(xi(i,j) - sqrt(3)*s0)/6;
                    c3 =  sqrt(6)*kMN*cos3theta(j)/18;
                    % se corrigen los errores de cálculo en los ceros
                    if abs(c0) < 1e-9, c0 = 0; end
                    if abs(c2) < 1e-9, c2 = 0; end
                    sol = roots([c3 c2 0 c0]); % raíces del polinomio (*\eqref{eq:MatsuokaNakai_pol1}*)

                    % como rho debe ser un número mayor o igual a cero, se 
                    % desechan las raíces negativas
                    sol(sol < 0) = NaN;

                    % y de las raíces que quedan se escoge la menor
                    rho(i,j) = min(sol, [], 'omitnan');
                end
            end
        end
        COLOR = 'b';
        
    otherwise
        error('Criterio desconocido')
end
        
%% se convierte la coordenada cilíndrica de HW a los esfuerzos principales
theta = linspace(0, 360, 6*n-5);  % 6*n-5 = length(th_)
s1  = xi/sqrt(3) + sqrt(2/3)*rho.*cosd(theta      );
s2  = xi/sqrt(3) + sqrt(2/3)*rho.*cosd(theta - 120); % ecuaciones (*\eqref{eq:HW_to_s1s2s3}*)
s3  = xi/sqrt(3) + sqrt(2/3)*rho.*cosd(theta + 120);

%% se dibuja la superficie de fluencia
mesh(s1,s2,s3, 'edgecolor', COLOR)

% se colocan los ejes
quiver3(0,0,0, 10,  0,  0, 'LineWidth',2); text(10,  0,  0, '\sigma_1');
quiver3(0,0,0,  0, 10,  0, 'LineWidth',2); text( 0, 10,  0, '\sigma_2');
quiver3(0,0,0,  0,  0, 10, 'LineWidth',2); text( 0,  0, 10, '\sigma_3');

% y el eje hidrostático
line([-10 10], [-10 10], [-10 10], 'LineWidth',2, 'Color', 'r'); 
text(10, 10, 10, 'eje hidrostático');

axis equal tight
box off
grid off
