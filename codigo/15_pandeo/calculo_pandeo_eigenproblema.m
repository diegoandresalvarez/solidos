clear all; close all; clc;

% Raíces precalculadas de tan(x)=x para el caso empotrado-articulado
phi = [ 4.4934094579, 7.7252518369, 10.9041216594, 14.0661939128 ];

% Raíces de 2 - kL*sin(kL) - 2cos(kL) = 0 para el caso empotrado-empotrado
knL_ee = [ 2*pi, 2*phi(1), 4*pi, 2*phi(2) ];

%% Se definen los parámetros del problema
N = 100;                % Número de nodos internos en la discretización
E = 200e9;              % [Pa]  Módulo de Young para el acero (200 GPa)
I = (0.01)^4/12;        % [m^4] Momento de inercia (sección cuadrada 1cm x 1cm)
L = 1.0;                % [m]   Longitud de la viga

% Casos de condiciones de apoyo
casos = {'articulado-articulado', 'empotrado-empotrado', ...
         'empotrado-libre', 'empotrado-articulado'};

%% Resolver y graficar para cada caso de condiciones de apoyo
for c = 1:length(casos)
    caso = casos{c};
    fprintf('\n--- CASO %s ---\n', upper(caso));
    
    % Obtener solución numérica
    [P_cr_numerica, modos_pandeo] = resolver_pandeo(caso, N, L, E, I);
    
    % Calcular soluciones analíticas
    P_cr_analitica = zeros(4, 1);
    for n = 1:4
        P_cr_analitica(n) = P_cr_analitico(caso, n, L, E, I, phi, knL_ee);
    end
    
    % Tabla comparativa
    fprintf('%4s | %20s | %20s | %10s\n', 'Modo', 'P_cr Numérica (kN)', ...
            'P_cr Analítica (kN)', 'Error (%)');
    fprintf('%s\n', repmat('-', 1, 65));
    
    error = 100*abs(P_cr_numerica - P_cr_analitica)./P_cr_analitica;
    for n = 1:4
        fprintf('%4d | %20.5f | %20.5f | %10.5f\n', n, ...
                P_cr_numerica(n)/1000, P_cr_analitica(n)/1000, error(n));
    end

    % Se grafica la comparación analítica vs numérica de los modos de pandeo
    figure;
    sgtitle(sprintf('Primeros cuatro modos de pandeo: %s', caso));    
    for n = 1:4
        subplot(2, 2, n);
        hold on; grid on;
                      
        % Solución numérica (línea azul con puntos)
        x_num = linspace(0, L, N+2);
        if strcmp(caso, 'empotrado-libre')
            y_num = [0; modos_pandeo(:, n)];
        else
            y_num = [0; modos_pandeo(:, n); 0];
        end
        plot(x_num, y_num, 'bo-', 'MarkerSize', 3, 'DisplayName', 'Numérica (MDF)');
        
        % Solución analítica (línea roja punteada)
        x_an = linspace(0, L, 200);
        y_an = modo_pandeo_analitico(caso, x_an, n, L, phi, knL_ee);
        
        % Normalizar y graficar la forma analítica
        y_an_normalizada = y_an/max(abs(y_an));

        % Voltear si es necesario para coincidir con la orientación del modo numérico
        % Si y_an_normalizada y y_num tienen la misma orientación >> productos positivos
        % Si tienen orientaciones opuestas >>> productos negativos
        if sum(y_an_normalizada .* interp1(x_num, y_num, x_an)) < 0
            y_an_normalizada = -y_an_normalizada;
        end
        
        plot(x_an, y_an_normalizada, 'r--', 'DisplayName', 'Analítica');
        
        title(sprintf('Modo %d', n));
        grid on;        
        xlabel('Posición a lo largo de la columna (m)');
        ylabel('Deflexión Normalizada');
        legend('Location', 'best');
    end
end

%% Cálculo de carga crítica analítica
function P_cr = P_cr_analitico(cond_apoyo, n, L, E, I, phi, knL_ee)
    switch cond_apoyo
        case 'articulado-articulado'
            P_cr = (n^2 * pi^2 * E*I)/L^2;
        case 'empotrado-empotrado'
            P_cr = (knL_ee(n)^2 * E*I)/L^2;
        case 'empotrado-libre'
            P_cr = ((2*n - 1)^2 * pi^2 * E*I)/(4*L^2);
        case 'empotrado-articulado'
            P_cr = (phi(n)^2 * E*I)/L^2;
        otherwise
            error('Tipo de condición de apoyo desconocida');
    end
end

%% Modo de pandeo analítico
function vx = modo_pandeo_analitico(cond_apoyo, x, n, L, phi, knL_ee)
    switch cond_apoyo
        case 'articulado-articulado'
            vx = sin(n*pi*x/L);
        case 'empotrado-empotrado'
            knL = knL_ee(n);
            kn = knL/L;
            if mod(n, 2) ~= 0  % n = 1, 3, 5, 7, ...
                % Forma modal simplificada
                vx = cos(kn*x)- 1;
            else               % n = 2, 4, 6, 8, ...
                % Forma modal general
                vx = cos(kn*x) - 1 ... 
                     - ((sin(kn*x) - kn*x)/(sin(knL) - knL))*(cos(knL) - 1);
            end
        case 'empotrado-libre'
            vx = cos((2*n - 1)*pi*x/(2*L)) - 1;
        case 'empotrado-articulado'
            kn = phi(n)/L;
            vx = sin(kn*x) - kn*L*cos(kn*x) + kn*(L - x);
        otherwise
            error('Tipo de condición de apoyo desconocida');
    end
end

%% Resolver el problema de pandeo
function [P_cr, modos_pandeo] = resolver_pandeo(cond_apoyo, N, L, E, I)
    % Resuelve el problema de pandeo de columna para los primeros cuatro modos
    % usando el método de las diferencias finitas.

    % Calcula numéricamente las cargas críticas y los modos de pandeo asociados

    % Definición del paso de la malla
    h = L/(N + 1);
    
    % Extraer condiciones de apoyo izquierda y derecha
    apoyo = split(cond_apoyo, '-');
    apoyo_izq = apoyo{1};
    apoyo_der = apoyo{2};
    
    % Construcción de matrices de rigidez Ke y Kg
    if strcmp(apoyo_der, 'libre')
        Ke = zeros(N+1);
        Kg = zeros(N+1);
    else
        Ke = zeros(N);
        Kg = zeros(N);
    end
    
    % Condición de apoyo izquierda
    if strcmp(apoyo_izq, 'articulado')
        Ke(1, 1:3) = [5, -4, 1];
        Ke(2, 1:4) = [-4, 6, -4, 1];
        Kg(1, 1:2) = [2, -1];
    elseif strcmp(apoyo_izq, 'empotrado')
        Ke(1, 1:3) = [7, -4, 1];
        Ke(2, 1:4) = [-4, 6, -4, 1];
        Kg(1, 1:2) = [2, -1];
    else
        error('Condición de apoyo izquierda desconocida');
    end
    
    % Discretización de la ecuación diferencial (diferencias finitas centradas)
    if strcmp(apoyo_der, 'libre')
        for i = 3:N-1
            Ke(i, i-2:i+2) = [1, -4, 6, -4, 1];
        end
        for i = 2:N
            Kg(i, i-1:i+1) = [-1, 2, -1];
        end
    else
        for i = 3:N-2
            Ke(i, i-2:i+2) = [1, -4, 6, -4, 1];
        end
        for i = 2:N-1
            Kg(i, i-1:i+1) = [-1, 2, -1];
        end
    end
    
    % Condición de apoyo derecha
    switch apoyo_der
        case 'articulado'
            Ke(N,   N-2:N  ) = [1, -4, 5];
            Ke(N-1, N-3:N  ) = [1, -4, 6, -4];
            Kg(N,   N-1:N  ) = [-1, 2];
        case 'empotrado'
            Ke(N,   N-2:N  ) = [1, -4, 7];
            Ke(N-1, N-3:N  ) = [1, -4, 6, -4];
            Kg(N,   N-1:N  ) = [-1, 2];
        case 'libre'
            Ke(N+1, N-1:N+1) = [1, -2, 1];
            Ke(N,   N-2:N+1) = [1, -4, 5, -2];
            Kg(N+1, N  :N+1) = [-1, 1];
        otherwise
            error('Condición de apoyo derecha desconocida');
    end
    
    % Escalar las matrices de rigidez
    Ke = Ke * (E*I/h^4);
    Kg = Kg * (1/h^2);
    
    % Resolver problema de eigenvalores generalizado
    [vecp, valp] = eig(Ke, Kg);
     
    % Ordenar valores propios
    [valp, idx] = sort(diag(valp), 'ascend');
    vecp = vecp(:, idx);
    
    % Seleccionar los primeros 4 modos positivos
    idx_positivos = valp > 1e-6;
    valp_pos = valp(idx_positivos);
    vecp_pos = vecp(:, idx_positivos);
    num_modos = min(4, length(valp_pos));

    P_cr = valp_pos(1:num_modos);
    modos_pandeo = vecp_pos(:, 1:num_modos);
    
    % Normalizar modos de pandeo y asegurar orientación consistente
    for i = 1:size(modos_pandeo, 2)
        modos_pandeo(:, i) = modos_pandeo(:, i)/max(abs(modos_pandeo(:, i)));
        if sum(modos_pandeo(:, i)) < 0
            modos_pandeo(:, i) = -modos_pandeo(:, i);
        end
    end
end