function hacer_grafico(x, y, f, tituloz, titulo, theta, angulos_dp)

figure;                  % Crea el lienzo para el dibujo

title(titulo);
colormap jet
subplot(1,2,1);
pcolor(x,y,f);           % Dibuje f
hold on;                 % Si se escribe algo nuevo, no se borre lo anterior
shading interp;          % Interpole los colores de modo que se vean suaves y continuos
h=colorbar;              % Cree la barra de colores a la derecha
contour(x,y,f,20,'k');   % Cree 20 curvas de nivel de color negro
set(gca,'FontSize',7);   % Tamaño de la fuente en los números de los ejes x e y
set(h,'FontSize',7);     % Tamaño de la fuente en la barra de colores
xlabel('Eje X [m]');
ylabel('Eje Y [m]');
zlabel(tituloz);
title(titulo);

% Se grafican las líneas que indican las direcciones principales
if nargin == 7
    esc = 0.5;
    for t = angulos_dp
%            f.*cos(theta+t),f.*sin(theta+t),... % indicando la direccion principal de Mf1        
        quiver(x,y, ...                 % En el punto (x,y) grafique una flecha (linea)
            cos(theta+t),sin(theta+t),... % indicando la direccion principal de Mf1
            esc,...                     % con una escala esc
            'k',...                     % de color negro
            'ShowArrowHead','off',...   % una flecha sin cabeza
            'LineWidth',1);             % con un ancho de linea 2
           %'Marker','.');              % y en el punto (x,y) poner un punto '.'
    end
end

axis equal tight;        % Ponga los ejes de la misma dimensión en x y en y

%print([tituloz '1.png'],'-dpng','-r200');

subplot(1,2,2);
mesh(x,y,f);             % Dibuje f
hold on;                 % Si se escribe algo nuevo, no se borre lo anterior
set(gca,'FontSize',7);   % Tamaño de la fuente en los números de los ejes x e y
set(h,'FontSize',7);     % Tamaño de la fuente en la barra de colores
xlabel('Eje X (m)');
ylabel('Eje Y (m)');
zlabel(tituloz);
%print([tituloz '2.png'],'-dpng','-r200');

return;