%% Se grafican las funciones f(x)=tan(x) y g(x)=x.
% En la intersección de estas funciones se encuentran las raíces de la 
% ecuación tan(x) = x

% Graficar f(x) = tan(x) evitando discontinuidades
x = linspace(0, 15, 1000);
f = tan(x);
f(abs(f) >  100) = NaN; % Evitar valores muy grandes o pequeños
g = x;

figure
hold on;
plot(x, f, 'b-',  'DisplayName', 'f(x) = tan(x)');
plot(x, g, 'r--', 'DisplayName', 'g(x) = x');

% Calcular y dibujar las primeras 5 asíntotas de tan(x): x = (2n-1)*pi/2
n = 1:5;
asintotas = (2*n - 1)*pi/2;

% Solo a la primera asíntota se le coloca un "legend"
xline(asintotas(1),   'g:', 'DisplayName', 'Asíntotas de f(x) = tan(x)');
xline(asintotas(2:5), 'g:', 'HandleVisibility', 'off');

xlabel('x');
ylabel('f(x) = tan(x) y g(x) = x');
grid on;
legend('Location', 'northwest');
axis([0, 15, 0, 15]);
axis square;

%% Búsqueda de las primeras 4 raíces con intervalos conocidos
fprintf('\nBúsqueda específica de las primeras 4 raíces:\n');
fprintf('======================================================\n');
% Intervalos conocidos aproximados para las primeras 4 raíces
intervalos = [
     4.2,  4.6;      % Primera raíz
     7.6,  7.8;      % Segunda raíz
    10.8, 10.95;     % Tercera raíz
    14.0, 14.1       % Cuarta  raíz
];
n_raices = size(intervalos, 1);

raices = zeros(n_raices, 1);
for i = 1:n_raices
    x_min = intervalos(i, 1);
    x_max = intervalos(i, 2);
    
    fprintf('Intervalo %d: [%10.5f, %10.5f] -> ', i, x_min, x_max);    
    try
        raices(i) = fzero(@(x) tan(x) - x, [x_min, x_max]);
    catch
        error('Refine el intervalo %d', i);
    end
    fprintf('%10.5f\n', raices(i));
end

%% Verifica que las raíces calculadas sean correctas
fprintf('\nVerificación de las raíces:\n');
fprintf('======================================================\n');
fprintf('Raíz | tan(x)        | x             | |tan(x) - x|   \n');
fprintf('------------------------------------------------------\n');

for i = 1:n_raices
    x       = raices(i);
    tan_x   = tan(x);
    err_abs = abs(tan_x - x);
    fprintf('%4d | %13.10f | %13.10f | %13.7e\n', i, tan_x, x, err_abs);
end