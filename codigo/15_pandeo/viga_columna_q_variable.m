%% Resuelve el sistema de ecuaciones diferenciales para una viga-columna biarticulada

clear all; close all; clc;

%% Asignar valores típicos para una viga de acero
global E I L;
E = 200e9;      % [Pa]  Módulo de Young para el acero (200 GPa)
I = (0.01)^4/12;% [m^4] Momento de inercia para una sección cuadrada de 1cm x 1cm
L = 1.3;        % [m]   Longitud de la viga

%% Calcular la carga crítica de pandeo de Euler
P_cr = (pi^2*E*I)/(L^2);
fprintf('Carga crítica de pandeo (P_cr): %.2f kN\n', P_cr/1000);

%% Crear el rango completo para P; excluyendo 0 para evitar división por cero 
% en las funciones dependientes de P
P = linspace(0.05, 0.9999*P_cr, 200);

%% Valores de la carga uniformemente distribuida q a evaluar
q_valores = [1, 10, 100, 1000, 10000]; % [N/m]

%% Crear figura con tres subgráficos
sgtitle('Comportamiento de la viga-columna vs. Carga axial P', 'FontSize', 16);

for i = 1:length(q_valores)
    q = q_valores(i);
    
    % Calcular M, t, v en los puntos de interés
    M_centro_luz = M_func(L/2, P, q);
    t_apoyo_izq  = t_func(0,   P, q);
    v_centro_luz = v_func(L/2, P, q);
    
    % Etiqueta para la leyenda
    label = sprintf('q = %d N/m', q);
    
    % Gráfico 1: Deflexión máxima (en el centro de la luz)
    subplot(3, 1, 1);
    plot(P/1000, 1000*v_centro_luz, 'DisplayName', label);
    hold on;
    
    % Gráfico 2: Momento flector máximo (en el centro de la luz)
    subplot(3, 1, 2);
    plot(P/1000, M_centro_luz/1000, 'DisplayName', label);
    hold on;
    
    % Gráfico 3: Pendiente máxima (en el apoyo)
    subplot(3, 1, 3);
    plot(P/1000, t_apoyo_izq, 'DisplayName', label);
    hold on;
end

%% Configurar Gráfico 1: Deflexión máxima
subplot(3, 1, 1);
xline(P_cr/1000, 'r--', 'DisplayName', 'P = P_{cr}');
%xlabel('Carga Axial P (kN)');
ylabel('Deflexión v(L/2) (mm)');
title('Deflexión en el centro de la luz vs. P');
ylim([0 1000]);
legend('Location', 'best');
grid on;

%% Configurar Gráfico 2: Momento flector máximo
subplot(3, 1, 2);
xline(P_cr/1000, 'r--', 'DisplayName', 'P = P_{cr}');
%xlabel('Carga Axial P (kN)');
ylabel('Momento flector M(L/2) (kN·m)');
title('Momento flector en el centro de la luz vs. P');
ylim([-4 0]);
legend('Location', 'best');
grid on;

%% Configurar Gráfico 3: Pendiente máxima
subplot(3, 1, 3);
xline(P_cr/1000, 'r--', 'DisplayName', 'P = P_{cr}');
xlabel('Carga Axial P (kN)');
ylabel('Pendiente t(0) (radianes)');
title('Pendiente en el apoyo vs. P');
ylim([0 3]);
legend('Location', 'best');
grid on;

%% Solución general de la ecuación diferencial de la viga-columna
function M = M_func(x, P, q)
    global E I L;
    k = sqrt(P/(E*I));
    M = (q./k.^2).*(1 - sin(k*x).*(1 - cos(k*L))./sin(k*L) - cos(k*x));    
end

function t = t_func(x, P, q)
    global E I L;
    k = sqrt(P/(E*I));
    t = (q./(P.*k)).*(cos(k*x).*(1 - cos(k*L))./sin(k*L) - sin(k*x)) ...
        + (2*x - L)*q./(2*P);
end

function v = v_func(x, P, q)
    global E I L;
    k = sqrt(P/(E*I));
    v = (q./(P.*k.^2)).*(sin(k*x).*(1 - cos(k*L))./sin(k*L) ...
        + cos(k*x) - 1) + x.*(x - L)*q./(2*P);
end