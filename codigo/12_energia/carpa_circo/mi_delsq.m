function L = mi_delsq(M)
% Calcula la matriz laplaciana discreta dada la matriz M
% M contiene la numeracion de los nodos

[Nfil,Ncol] = size(M);              % numero de filas y columnas
num_int_nodes = sum(sum(M~=0));     % numero de nodos interiores

% Se verifica que no existan nodos con numeracion repetida
% o incompleta
if ~isequal(sort(M(M~=0))', 1:num_int_nodes)
   error('Nodos incorrectamente numerados');
end

% La diagonal de la matriz esta llena de cuatros
L = 4*speye(num_int_nodes, num_int_nodes);
for i = 1:Nfil
   for j = 1:Ncol
      nodo = M(i,j);

      if nodo == 0          %                                 N
         continue           % Recuerde los puntos cardinales W+E
      end                   %                                 S

      nodoW = M(i,j-1); if 1 <= nodoW, L(nodo,nodoW) = -1; end;
      nodoN = M(i-1,j); if 1 <= nodoN, L(nodo,nodoN) = -1; end;
      nodoE = M(i,j+1); if 1 <= nodoE, L(nodo,nodoE) = -1; end;
      nodoS = M(i+1,j); if 1 <= nodoS, L(nodo,nodoS) = -1; end;
   end
end