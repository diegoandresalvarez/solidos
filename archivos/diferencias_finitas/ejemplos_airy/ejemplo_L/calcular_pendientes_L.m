% Con este programa calcule las ecuaciones de los tramos de recta de la geometria
xnod = [ ...
0  0  0
1  1  0 
3  1  2
5  3  2
6  3  3
9  0  3
12 0  0 ];

for i = 1:size(xnod)-1
   polyfit([xnod(i,1) xnod(i+1,1)], [xnod(i,3) xnod(i+1,3)], 1)
end
