clear, close all

p = -1:0.1:1;

[x,y] = meshgrid(p);

figure
plot3(p,p,p)
hold on
grid on
box on
quiver3(0, 0, 0, 1, 0, 0, 'LineWidth', 3, 'Color', 'k')
quiver3(0, 0, 0, 0, 1, 0, 'LineWidth', 3, 'Color', 'k')
quiver3(0, 0, 0, 0, 0, 1, 'LineWidth', 3, 'Color', 'k')
xlabel('Eje x')
ylabel('Eje y')
zlabel('Eje z')
daspect([1 1 1])

z = - x - y;
s = surf(x,y,z)
alpha(0.3)

quiver3(0, 0, 0, 1/sqrt(3),  1/sqrt(3),  1/sqrt(3), 'LineWidth', 3, 'Color', 'r') % nD
quiver3(0, 0, 0, 0,         -1/sqrt(2),  1/sqrt(2), 'LineWidth', 3, 'Color', 'r') % nE
quiver3(0, 0, 0, 2/sqrt(6), -1/sqrt(6), -1/sqrt(6), 'LineWidth', 3, 'Color', 'r') % nF

%axis vis3d
%{
for i = 1:36
   camorbit(10,0,'data',[0 0 1])
   drawnow
   pause
end
%}
