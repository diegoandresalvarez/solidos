import numpy as np
from scipy.optimize import brentq
import matplotlib.pyplot as plt

# %% Gráfica de f(x)=tan(x) y g(x)=x.
# En la intersección de estas funciones se encuentran las raíces de la
# ecuación tan(x) = x

# Graficar f(x) = tan(x) evitando discontinuidades
x = np.linspace(0, 15, 1000)

f = np.tan(x)
f[np.abs(f)> 100] = np.nan  # Evitar valores muy grandes o muy pequeños
g = x

fig, ax = plt.subplots(figsize=(8, 8))
ax.plot(x, f, 'b-',  label='f(x) = tan(x)')
ax.plot(x, g, 'r--', label='g(x) = x')

# Calcular y dibujar las primeras 5 asíntotas de tan(x): x = (2n-1)*pi/2
for n in range(1, 5+1):
    asintota = (2*n - 1)*np.pi/2
    ax.axvline(x=asintota, color='green', linestyle=':', alpha=0.7, 
        label='_nolegend_' if n!=1 else 'Asíntotas de f(x) = tan(x)')

ax.set_xlabel('x')
ax.set_ylabel('f(x) = tan(x) y g(x) = x')
ax.grid(True)
ax.legend(loc='upper left', framealpha=1.0)
ax.set(xlim=(0, 15), ylim=(0, 15))
ax.set_aspect('equal', adjustable='box')

plt.tight_layout()
plt.show()

# %% Búsqueda de las primeras 4 raíces con intervalos conocidos
print("\nBúsqueda específica de las primeras 4 raíces:")
print("=" * 55)

# Intervalos conocidos aproximados para las primeras 4 raíces
intervalos = [
    ( 4.2,  4.6 ),    # Primera raíz
    ( 7.6,  7.8 ),    # Segunda raíz
    (10.8, 10.95),    # Tercera raíz
    (14.0, 14.1 )     # Cuarta raíz
]
n_raices = len(intervalos)

raices = np.zeros(n_raices)
for i, (x_min, x_max) in enumerate(intervalos):
    print(f"Intervalo {i+1}: [{x_min:10.5f}, {x_max:10.5f}] -> ", end="")

    try:
        raices[i] = brentq(lambda x: np.tan(x) - x, x_min, x_max)
    except:
        raise Exception(f"Refine el intervalo {i+1}")
    print(f"{raices[i]:>10.5f}")

# %% Verifica que las raíces calculadas sean correctas
print(f"\nVerificación de las raíces:")
print("=" * 55)
print(f"{'Raíz':<4} | {'tan(x)':<13} | {'x':<13} | {'|tan(x) - x|':<13}")
print("-" * 55)

for i, x in enumerate(raices):
    tan_x   = np.tan(x)
    err_abs = abs(tan_x - x)
    print(f"{i+1:>4} | {tan_x:>13.10f} | {x:>13.10f} | {err_abs:>13.7e}")