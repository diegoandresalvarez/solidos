%% Programa para dibujar las superficies de falla de los criterios de
%% Mohr-Coulomb, Drucker-Prager y Matsuoka-Nakai (y como casos especiales 
%% Tresca y von Mises)

%% parámetros del gráfico
n = 100; % número de divisiones por plano
m = 2*n; % número de divisiones de la componente hidrostática

%% se especifica el tipo de criterio de fluencia/falla a graficar
MOHR_COULOMB   = 1;
DRUCKER_PRAGER = 2;
MATSUOKA_NAKAI = 3;

modelo = MATSUOKA_NAKAI;

%% se activa el lienzo, de modo que se pueda sobrescribir en él
hold on;
grid on

%% parámetros del material
c   = 0;  %            cohesión
phi = 20; % [grados]   ángulo de fricción

%% se calcula el ángulo de Lode (y se repite por la propiedad de simetría)
th  = 0; 

%% se calcula la componente hidrostática
if phi == 0 && (modelo == 1 || modelo == 2)
    % en este caso cotd(phi) se vuelve infinito; 
    % si modelo == MOHR_COULOMB   se grafica TRESCA
    % si modelo == DRUCKER_PRAGER se grafica VON MISES    
    xi_ = linspace(-100, 100, m);
else    
    xi_ = linspace(-100, sqrt(3)*c*cotd(phi), m); % ver Figura (*\ref{fig:MC_perfil_meridional}*)
end

%% Se calculan theta y xi
xi = xi_;

%% se calcula el radio rho de la superficie de fluencia a graficar
switch modelo
    case MOHR_COULOMB
        %% se utiliza la ecuación (*\eqref{eq:MCconHWcilindricalcoord}*)
        num = c*cosd(phi) - (xi/sqrt(3))*sind(phi);
        den = sqrt(1/2)*(sind(theta + 60) + ...
                                       sind(phi)*cosd(theta + 60)/sqrt(3));
        rho1 = num./den;
        COLOR = 'r';
    case DRUCKER_PRAGER        
        %% se utiliza la ecuación (*\eqref{eq:fI1J2J3_DruckerPrager}*)
        % pasando por vértices menores ((*ecuación \eqref{eq:DP_vert_menores}*))
        A = 6*c*cosd(phi)/(sqrt(3)*(3+sind(phi)));
        B = 2*sind(phi)/(sqrt(3)*(3+sind(phi)));

        % pasando por vértices mayores ((*ecuación \eqref{eq:DP_vert_mayores}*))
        % A = 6*c*cosd(phi)/(sqrt(3)*(3-sind(phi)));
        % B = 2*sind(phi)/(sqrt(3)*(3-sind(phi)));
        rho1 = sqrt(2)*A - sqrt(6)*B*xi; % ecuación (*\eqref{eq:fI1J2J3_DruckerPrager}*)
        COLOR = 'g';

    case MATSUOKA_NAKAI

        %% se utiliza la ecuación (*\eqref{eq:MatsuokaNakai_pol1}*)
        s0  = c*cotd(phi);
        kMN = 0.000100000 %(9 - sind(phi)^2)/(1 - sind(phi)^2); % ecuación (*\eqref{eq:kMNphi}*)
        cos3theta = 0; %theta = 0
        rho1 = sqrt((2*(kMN-9))/(3*(kMN-3)))*abs(xi-sqrt(3)*s0); 
        
        th_ = 60;
        cos3theta = -1; %theta = 60
        rho2 = zeros(1, m);
        for i = 1:m
            % se calculan los coeficientes (*\eqref{eq:coef_c1c2c3c4_MN}*)
            c0 =  sqrt(3)*(kMN - 9)*(xi(i) - sqrt(3)*s0)^3/9;
            c2 = -sqrt(3)*(kMN - 3)*(xi(i) - sqrt(3)*s0)/6;
            c3 = sqrt(6)*kMN*cos3theta/18;
            % se corrigen los errores de cálculo en los ceros
            if abs(c0) < 1e-9, c0 = 0; end
            if abs(c2) < 1e-9, c2 = 0; end
            [c3 c2 0 c0]
            sol = real(roots([c3 c2 0 c0])); % raíces del polinomio (*\eqref{eq:MatsuokaNakai_pol1}*)

            % de las raíces se escoje la positiva, ya que rho >= 0
            rho2(i) = max(sol(2), sol(3));

            COLOR = 'b';
        end
    otherwise
        error('Criterio desconocido')
end
        
%% se grafica la superficie de fluencia
plot(xi, rho1)
plot(xi, -rho2)

axis equal tight
box off
grid off