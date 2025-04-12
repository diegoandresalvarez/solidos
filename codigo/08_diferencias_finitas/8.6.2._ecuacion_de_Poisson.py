import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm
from mpl_toolkits.mplot3d import Axes3D

# Definimos los parámetros de la malla
nx = 4    # Número de puntos en dirección x (incluyendo fronteras)
ny = 5    # Número de puntos en dirección y (incluyendo fronteras)
Lx = 3.0  # Longitud en x
Ly = 4.0  # Longitud en y

# Calculamos el espaciado de la malla
dx = Lx/(nx - 1)
dy = Ly/(ny - 1)

# Creamos las coordenadas de la malla
x = np.linspace(0, Lx, nx)
y = np.linspace(0, Ly, ny)
X, Y = np.meshgrid(x, y)

# Inicializamos la matriz de solución
f = np.zeros((ny, nx))

# Aplicamos las condiciones de frontera de Dirichlet
# Frontera inferior: f(x,0) = x²
f[0, :] = x**2

# Frontera superior: f(x,4) = 2^x - 1
f[-1, :] = 2**x - 1

# Frontera izquierda: f(0,y) = 0
f[:, 0] = 0

# Para la condición de Neumann en x=3, necesitamos un enfoque especial
# Vamos a definir nodos auxiliares para usar diferencias centrales

# Función para el término fuente
def source_term(x, y):
    return x + y

# Implementamos el método de diferencias finitas
max_iter = 10000
for iteration in range(max_iter):
    # Copiamos la solución anterior para verificar convergencia
    f_old = f.copy()
    
    # Actualizamos los puntos interiores
    for i in range(1, ny-1):
        for j in range(1, nx-1):
            f[i, j] = (f[i+1,j] + f[i-1,j] + f[i,j+1] + f[i,j-1] - dx*dy*source_term(x[j],y[i]))/4
    
    # Aplicamos la condición de Neumann en x=3 (j=nx-1) usando nodos auxiliares
    for i in range(1, ny-1):
        # La condición es df/dn = 6x - y = 6*3 - y[i] en x=3
        # Para usar diferencias centrales necesitamos un nodo virtual en x=3+dx
        neumann_val = 6*3 - y[i]
        
        # Calculamos el valor en el nodo virtual utilizando diferencias centrales:
        # (f(3+dx,y) - f(3-dx,y))/(2*dx) = 6*3 - y[i]
        # Por lo tanto: f(3+dx,y) = f(3-dx,y) + 2*dx*(18 - y[i])
        f_virtual = f[i,nx-2] + 2*dx*neumann_val
        
        # Ahora actualizamos f(3,y) usando la ecuación de Laplace discretizada y el nodo virtual
        # ∂²f/∂x² + ∂²f/∂y² = x + y
        # Para el nodo en la frontera derecha (3,y):
        # (f(3+dx,y) - 2*f(3,y) + f(3-dx,y))/dx² + (f(3,y+dy) - 2*f(3,y) + f(3,y-dy))/dy² = 3 + y[i]
        
        # Despejamos f(3,y):
        f[i, nx-1] = (dx**2 * (f[i+1, nx-1] + f[i-1, nx-1]) + 
                      dy**2 * (f_virtual + f[i, nx-2]) - 
                      dx**2 * dy**2 * (3 + y[i])) / (2 * (dx**2 + dy**2))
    
    # Verificamos convergencia
    if np.allclose(f, f_old):
        print(f"Convergencia alcanzada en {iteration} iteraciones")
        break

# Creamos visualización 3D de la solución
fig = plt.figure(figsize=(12, 8))
ax = fig.add_subplot(111, projection='3d')

# Graficamos la superficie
surf = ax.plot_surface(X, Y, f, cmap=cm.viridis, linewidth=0, antialiased=False)

# Añadimos barra de colores
fig.colorbar(surf, ax=ax, shrink=0.5, aspect=5, label='f(x,y)')

# Etiquetas y título
ax.set_xlabel('x')
ax.set_ylabel('y')
ax.set_zlabel('f(x,y)')
ax.set_title('Solución de la ecuación ∂²f/∂x² + ∂²f/∂y² = x + y con nodos auxiliares')

# Vista 2D con contornos
plt.figure(figsize=(10, 8))
cp = plt.contourf(X, Y, f, levels=20, cmap='viridis')
plt.colorbar(cp, label='f(x,y)')
plt.title('Contornos de la solución f(x,y)')
plt.xlabel('x')
plt.ylabel('y')
plt.grid(True)

# Añadimos los puntos de la malla
plt.scatter(X, Y, color='white', s=5)

# Mostramos los valores en cada punto de la malla
for i in range(nx):
    for j in range(ny):
        plt.text(X[j,i], Y[j,i], f'{f[j,i]:.4f}', 
                 ha='center', va='center', fontsize=8, color='red')

# Dibujamos la ubicación de los nodos virtuales para la condición de Neumann
virtual_x = x[-1] + dx
virtual_y = y[1:-1]  # Solo para los nodos internos verticales
plt.scatter([virtual_x]*len(virtual_y), virtual_y, color='red', s=30, marker='x')
for i, yi in enumerate(virtual_y):
    # Calculamos el valor en el nodo virtual para visualizarlo
    neumann_val = 18 - yi
    f_virtual = f[i+1, nx-2] + 2*dx*neumann_val
    plt.text(virtual_x, yi, f'  {f_virtual:.4f}', 
             ha='left', va='center', fontsize=8, color='red')

plt.show()

# Imprimimos la matriz solución
print("Solución en los puntos de la malla:")
for j in range(ny-1, -1, -1):  # Invertimos para que coincida con la orientación del gráfico
    row_str = ""
    for i in range(nx):
        row_str += f"{f[j, i]:8.4f} "
    print(row_str)