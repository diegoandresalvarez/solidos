import numpy as np
import openpyxl
import matplotlib.pyplot as plt
from matplotlib import cm
from mpl_toolkits.mplot3d import Axes3D
from scipy.integrate import dblquad
from scipy.optimize import minimize

# Torsión de una barra con sección transversal cuadrada
E = 21e6          # [kPa] = 21GPa - Young's modulus of steel
nu = 0.28         # Poisson's coefficient of steel
G = E/(2*(1+nu))  # [kPa] shear modulus
L = 1             # [m]
rho_L = 0.05      # [rad]
theta = rho_L/L   # [rad/m]
delta = 0.001     # [m] mesh spacing

# Coordenadas del borde de la barra cuadrada
a = 0.01  # [m]
b = 0.01  # [m]

# coordenadas del borde (x,y) que forman el perímetro
borde = np.array([
    [-a, -b],
    [ a, -b],
    [ a,  b],
    [-a,  b],
    [-a, -b]  # observe que se repite la primera fila
])

def read_excel_range(filename, sheet_name, range_name):
    """Read data from Excel using openpyxl"""
    workbook = openpyxl.load_workbook(filename, data_only=True,  read_only=True)
    worksheet, coord = list(workbook.defined_names[range_name].destinations)[0]
    rango = workbook[worksheet][coord]
    data = np.array([[celda.value for celda in fila] for fila in rango]).astype(float)

    return data

# Leer de MS EXCEL de la función de tensión de Prandtl phi
phi = read_excel_range('torsion_cuadrado.xlsx', 'Prandtl', 'phi')
phi = np.flipud(phi)

# Leer de MS EXCEL de la función de alabeo psi
psi = read_excel_range('torsion_cuadrado.xlsx', 'Alabeo', 'psi')
psi = np.flipud(psi)

# Definir las coordenadas en x e y
x = np.arange(-0.01, 0.01 + delta, delta)
y = np.arange(-0.01, 0.01 + delta, delta)
xx, yy = np.meshgrid(x, y)

# Funciones para calcular las derivadas usando diferencias centrales
def d_dx(f):
    return (f[1:-1, 2:] - f[1:-1, :-2])/(2*delta)

def d_dy(f):
    return (f[2:, 1:-1] - f[:-2, 1:-1])/(2*delta)

# Cálculo de los esfuerzos
txz = G * theta * (d_dx(psi) - yy)
tyz = G * theta * (d_dy(psi) + xx)

# Eliminar los nodos ficticios alrededor de psi
psi = psi[1:-1, 1:-1]

def plot_esf_2d(x, y, esf, titulo, archivo=None):
    """Plot 2D stress field"""
    fig, ax = plt.subplots(figsize=(10, 8))

    # Create pcolor plot
    im = ax.pcolor(100*x, 100*y, esf, shading='auto', cmap='jet')

    # Add colorbar
    cbar = plt.colorbar(im, ax=ax)

    # Add contour lines
    contour = ax.contour(100*x, 100*y, esf, levels=20, colors='k', linewidths=1)

    # Plot boundary
    ax.plot(100*borde[:, 0], 100*borde[:, 1], 'k-', linewidth=3)

    # Set equal aspect ratio and tight limits
    ax.set_aspect('equal')
    ax.set_xlim(-110*a, 110*a)
    ax.set_ylim(-110*b, 110*b)

    # Labels and title
    ax.set_xlabel('x [cm]')
    ax.set_ylabel('y [cm]')
    ax.set_title(titulo)

    if archivo:
        #plt.savefig(archivo + '.png', bbox_inches='tight', dpi=300)
        plt.savefig(archivo + '.eps',format='eps')

    plt.tight_layout()
    return fig, ax

def plot_esf_3d(x, y, esf, titulo, archivo=None):
    """Plot 3D stress field"""
    fig = plt.figure(figsize=(12, 9))
    ax = fig.add_subplot(111, projection='3d')

    # Create surface plot
    surf = ax.plot_surface(100*x, 100*y, esf, cmap='jet', alpha=0.8)

    # Add colorbar
    cbar = plt.colorbar(surf, ax=ax, shrink=0.5)

    # Add contour lines at base
    ax.contour(100*x, 100*y, esf, levels=20, colors='k', linewidths=1, offset=0)

    # Plot boundary at base
    z_base = np.zeros(5)
    ax.plot(100*borde[:, 0], 100*borde[:, 1], z_base, 'k-', linewidth=3)

    # Labels and title
    ax.set_xlabel('x [cm]')
    ax.set_ylabel('y [cm]')
    ax.set_title(titulo)

    if archivo:
        #plt.savefig(archivo + '.png', bbox_inches='tight', dpi=300)
        plt.savefig(archivo + '.eps',format='eps')

    plt.tight_layout()
    return fig, ax

# Plot shear stress components
fig1, ax1 = plot_esf_2d(xx, yy, txz,
                    r'Esfuerzos cortantes $\tau_{xz}(x,y)$ sobre la cara $\Omega_L$ [kPa]',
                    'txz_square')

fig2, ax2 = plot_esf_2d(xx, yy, tyz,
                    r'Esfuerzos cortantes $\tau_{yz}(x,y)$ sobre la cara $\Omega_L$ [kPa]',
                    'tyz_square')

# Calculate and plot total shear stress
tau = np.hypot(txz, tyz)

fig3, ax3 = plot_esf_3d(xx, yy, tau,
                    r'Esfuerzos cortantes $\tau(x,y)$ sobre la cara $\Omega_L$ [kPa]',
                     'tau_square_3d')

# Add quiver plot for stress vectors
zz = np.zeros_like(xx)
ax3.quiver(100*xx, 100*yy, zz, txz, tyz, zz, length=5e-5)

ax3.set_zlabel('Esfuerzo cortante $\tau(x,y)$ [kPa]')

# Plot Prandtl stress function 3D
fig4, ax4 = plot_esf_3d(xx, yy, phi,
                    r'Función de tensión de Prandtl $\psi(x,y)$'
                     '\n(solución numérica)',
                     'prandtl_square_3d')

# Add quiver plot
ax4.quiver(100*xx, 100*yy, zz, txz, tyz, zz, length=5e-5)

ax4.set_zlabel('Función de tensión de Prandtl, φ(x, y) [kPa*m]')

# Plot Prandtl stress function 2D
fig5, ax5 = plot_esf_2d(xx, yy, phi,
                    r'Curvas de nivel de la función de tensión de Prandtl $\phi(x,y)$'
                     '\nSe muestran además los esfuerzos cortantes',
                     'prandtl_square_2d')

# Add quiver plot
ax5.quiver(100*xx, 100*yy, txz, tyz, scale=None, color='k', alpha=0.7)


# Find torsion center
def objective(coords):
    x_interp, y_interp = coords
    if (-a <= x_interp <= a) and (-b <= y_interp <= b):
        # Interpolate phi at the given coordinates
        from scipy.interpolate import griddata
        points = np.column_stack((xx.ravel(), yy.ravel()))
        values = phi.ravel()
        try:
            interp_val = griddata(points, values, (x_interp, y_interp), method='linear')
            return -interp_val if not np.isnan(interp_val) else 0
        except:
            return 0
    return 0

# Find torsion center
result = minimize(objective, 0.001*(np.random.rand(2) - 0.0005), 
                 method='Nelder-Mead')
ct = result.x

# Plot torsion center
ax5.plot(ct[0], ct[1], 'r*', markersize=15, label='Centro de torsión')
ax5.legend()

'''
# Calculate equivalent torsional moment
def phi_interp(x_val, y_val):
    from scipy.interpolate import griddata
    points = np.column_stack((xx.ravel(), yy.ravel()))
    values = phi.ravel()
    return griddata(points, values, (x_val, y_val), method='linear', fill_value=0)

Mt, _ = dblquad(phi_interp, -a, a, lambda x: -b, lambda x: b)
Mt = 2 * Mt

texto_Mt = f'Momento torsor = {Mt:.6g} kN-m'
ax5.set_xlabel(texto_Mt, fontsize=12)
print(texto_Mt)

# Calculate torsional inertia J
J = Mt / (G * theta)
print(f'J = {J:.6g} m^4')
'''

# Plot warping
w = theta*psi

fig6, ax6 = plot_esf_3d(xx, yy, w,
               r'Desplazamiento en z (alabeo) $w(x,y) = \theta\psi(x,y)$'
                '\n(solución numérica)',
                'alabeo_square')
plt.show()