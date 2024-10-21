% se definen las constantes del suelo
c   = 25;  % [kPa] cohesión
phi = 20;  % [°]   ángulo de fricción

% se crea el vector sx = [-2000, -1975, -1950, ..., -550, -525, -500] kPa
sx = -2000:25:-500;

% y se calculan los valores de f para cada elemento en el vector sx
f = arrayfun(@(esf_sx) calc_f(esf_sx, c, phi), sx);

% se grafica f para cada valor de sx
figure
plot(sx, f)
grid on
xlabel('sx [kPa]')
ylabel('f [Mohr-Coulomb]')
%exportgraphics(gcf,'sx_f_Mohr_Coulomb.eps','BackgroundColor','none','ContentType','vector')

% observe del gráfico que el suelo se encuentra en un estado seguro si sx
% se encuentra, aproximadamente, entre -1700 kPa y -600 kPa

% calculemos los valores exactos de los límites seguros
sigmax_min = fzero(@(esf_sx) calc_f(esf_sx, c, phi), -1700);
sigmax_max = fzero(@(esf_sx) calc_f(esf_sx, c, phi),  -600);

fprintf(['El suelo no falla siempre y cuando sx se encuentre ', ...
         'entre %.2f kPa y %.2f kPa\n'], sigmax_min, sigmax_max);

% del gráfico se observa que la condición más segura se encuentra cuando
% sx = - 1100, aproximadamente

% calculemos el valor exacto de sx
arg_minf = fminsearch(@(esf_sx) calc_f(esf_sx, c, phi), -1100);
fprintf('El mínimo de f se encuentra para sx = %.2f kPa\n', arg_minf);

function f = calc_f(sx, c, phi)
    % función que calcula la superficie de falla de Mohr-Coulomb para un
    % valor de sx dado
    
    % se define el tensor de esfuerzos
    sigma = [   sx  -250   -31
              -250  -937    24    % [kPa]
               -31    24  -833 ];

    % y luego se evaluan los esfuerzos principales máximo y mínimo
    valp     = eig(sigma);
    [s3, s1] = bounds(valp); % esto es: s3 = min(valp); s1 = max(valp);

    % se evalúa la superficie de fluencia ((*\ref{eq_MC_s1s2s3}*))
    f = (s1 - s3)/2 + (s1 + s3)*sind(phi)/2 - c*cosd(phi);
end
