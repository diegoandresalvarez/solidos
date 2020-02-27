clear
clc 
format compact

syms s

% Con este programa calcule las ecuaciones de los tramos de recta de la geometria
S = 1;
X = 2;
Y = 3;
xnod = [ ...  % s   x   y
                0	1	2
                2	3	2
                3	3	3
                6	0	3
                9	0	0
                12	3	0
                13	3	1
                15	1	1
                16	1	2  
];

figure
plot(xnod(:,X), xnod(:,Y), 'LineWidth', 4)
text(xnod(:,X), xnod(:,Y), num2str(xnod(:,S)), 'Color', 'red', 'FontSize',25);
axis equal tight

disp('X(s) = ')
for i = 1:size(xnod)-1
    coef = polyfit([xnod(i,S) xnod(i+1,S)], [xnod(i,X) xnod(i+1,X)], 1);
    coef(abs(coef) < 1e-8) = 0;
    disp([xnod(i,S), poly2sym(coef, s), xnod(i+1,S)])
end

disp('Y(s) = ')
for i = 1:size(xnod)-1
    coef = polyfit([xnod(i,S) xnod(i+1,S)], [xnod(i,Y) xnod(i+1,Y)], 1);
    coef(abs(coef) < 1e-8) = 0;    
    disp([xnod(i,S), poly2sym(coef, s), xnod(i+1,S)])
end
