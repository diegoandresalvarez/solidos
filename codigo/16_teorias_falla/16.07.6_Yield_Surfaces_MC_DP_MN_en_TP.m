clear, clc, close all

c = 2;
phi = 20;

fc = 2*c*cosd(phi)/(1 - sind(phi));
ft = 2*c*cosd(phi)/(1 + sind(phi));

figure;
hold on;
plot([1.5*ft 0 0],[0 0 1.5*ft])
axis([-1.75*fc 1.5*ft -1.75*fc 1.5*ft])
axis equal

%% Mohr-Coulomb
hMC = plot([ft ft  0 -fc -fc   0 ft], [ 0 ft ft   0 -fc -fc  0]);

%% Drucker-Prager
% pasando por vértices menores ((*ecuación \eqref{eq:DP_vert_menores}*))
A = 6*c*cosd(phi)/(sqrt(3)*(3+sind(phi)));
B = 2*sind(phi)/(sqrt(3)*(3+sind(phi)));
fDP_men = @(s1,s2) A - (s1 + s2)*B - sqrt((s1.^2 - s1.*s2 + s2.^2)/3);
hDP_men = fimplicit(fDP_men, [-1.5*fc 1.5*ft -1.5*fc 1.5*ft]);

% pasando por vértices mayores ((*ecuación \eqref{eq:DP_vert_mayores}*))
A = 6*c*cosd(phi)/(sqrt(3)*(3-sind(phi)));
B = 2*sind(phi)/(sqrt(3)*(3-sind(phi)));
fDP_may = @(s1,s2) A - (s1 + s2)*B - sqrt((s1.^2 - s1.*s2 + s2.^2)/3);
hDP_may = fimplicit(fDP_may, [-1.75*fc 1.5*ft -1.75*fc 1.5*ft]);

%% Matsuoka-Nakai
s0 = c*cotd(phi);
kMN = 9 + 8*tand(phi)^2;
fMN = @(s1,s2) -(s2+s1-3*s0).*((s1-s0).*(s2-s0)-s0*(s2-s0)-s0*(s1-s0)) - kMN*s0*(s1-s0).*(s2-s0);
hMN = fimplicit(fMN, [-1.5*fc 1.5*ft -1.5*fc 1.5*ft]);

%% detalles de los dibujos
legend([hMC, hDP_men, hDP_may, hMN], ...
    'MC', 'DP menor', 'DP mayor', 'MN', ...
    'Location', 'SouthEast');

%{
kill(all)$
s3 : 0$
/* I1 : s1 + s2 + s3$ */
I2 : s1*s2 + s2*s3 + s3*s1$
/* J2 : I1^2/3 - I2$ */ 
J2 : ((s1-s2)^2 + (s2-s3)^2 + (s3-s1)^2)/6$ 
f : A - B*I2 - sqrt(J2);
%}