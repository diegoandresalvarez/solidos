import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import fsolve

c   = 25  # [kPa] cohesión
phi = 20  # [°]   ángulo de fricción
sin_phi = np.sin(np.deg2rad(phi))
cos_phi = np.cos(np.deg2rad(phi))

# función que calcula la superficie de falla de Mohr-Coulomb para un valor de sx dado
def calc_f(sx):
    # se define el tensor de esfuerzos
    sigma = np.array([[   sx, -250,  -31 ],
                      [ -250, -937,   24 ],  # [kPa]
                      [  -31,   24, -833 ]])

    # y luego se evaluan los esfuerzos principales máximo y mínimo
    valp = np.linalg.eigvals(sigma)
    s1   = np.max(valp)
    s3   = np.min(valp)

    # se evalúa la superficie de fluencia
    return (s1 - s3)/2 + (s1 + s3)*sin_phi/2 - c*cos_phi

# ahora hacemos que calc_f() acepte vectores y retorne vectores
calc_f = np.vectorize(calc_f)    

# se crea el vector sx = [-2000, -1975, -1950, ..., -550, -525, -500] kPa
sx = np.ogrid[-2000:-500:25j]

# y se calculan los valores de f para cada elemento en el vector sx
f = calc_f(sx)

# se grafica f para cada valor de sx
plt.figure()
plt.plot(sx, f)
plt.grid(True)
plt.xlabel('sx [kPa]')
plt.ylabel('f [Mohr-Coulomb]')
plt.show()

# observe del gráfico que el suelo se encuentra en un estado seguro si sx
# está entre aproximadamente -1700 kPa y -600 kPa

# calculemos los valores exactos
sigma_x_min = fsolve(calc_f, -1700)[0]
sigma_x_max = fsolve(calc_f,  -600)[0]

print(f'El suelo no falla siempre y cuando sx se encuentre entre {sigma_x_min:.2f} kPa y {sigma_x_max:.2f} kPa')