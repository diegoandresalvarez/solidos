import sympy as sp
import numpy as np
import matplotlib.pyplot as plt

# Resuelve el sistema de ecuaciones diferenciales para una viga-columna
# biarticulada

# Se definen las variables, las constantes y las funciones
x, L, q, P, E, I, k = sp.symbols('x L q P E I k', real=True, positive=True)

V = sp.Function('V')(x)
M = sp.Function('M')(x)
t = sp.Function('t')(x)
v = sp.Function('v')(x)

# Se define el sistema de ecuaciones diferenciales ordinarias
system = [
    sp.Eq(sp.diff(V, x), q),
    sp.Eq(sp.diff(M, x), V - P*t),
    sp.Eq(sp.diff(t, x), M/(E*I)),
    sp.Eq(sp.diff(v, x), t)
]
solucion = sp.dsolve(system, [V, M, t, v])

# Extrae las fórmulas para cada función V=0, M=1, t=2, v=3
M_sol = solucion[1].rhs
v_sol = solucion[3].rhs

# Se calculan las constantes de integración
bc_eqs = [
    sp.Eq(v_sol.subs(x, 0), 0),    # v(0) = 0
    sp.Eq(M_sol.subs(x, 0), 0),    # M(0) = 0
    sp.Eq(v_sol.subs(x, L), 0),    # v(L) = 0
    sp.Eq(M_sol.subs(x, L), 0)     # M(L) = 0
]
C1C2C3C4 = sp.solve(bc_eqs, ['C1', 'C2', 'C3', 'C4'])

# Se calcula la solución particular en función de k
sol_simplificada = []
for sol in solucion:
    # Se sustituyen las constantes de integración C1, C2, C3 y C4 en V, M, t y v
    eq = sol.subs(C1C2C3C4)

    # Se simplifica la expresión resultante en términos de k
    # eq = eq.subs(sp.sqrt(P/(E*I)), k)
    sol_simplificada.append(sp.simplify(eq))

# Imprime las soluciones simbólicas para el caso de la viga-columna biarticulada
for eq in sol_simplificada:
    sp.pprint(eq, use_unicode=True, wrap_line=False)

# Análisis numérico y gráficos

# Extrae las fórmulas para cada función V=0, M=1, t=2, v=3
V_sym = sol_simplificada[0].rhs
M_sym = sol_simplificada[1].rhs
t_sym = sol_simplificada[2].rhs   
v_sym = sol_simplificada[3].rhs

# Asignar valores típicos para una viga de acero (en unidades SI: m, N, Pa)
vals = {
    E: 200e9,      # [Pa]  Módulo de Young para el acero (200 GPa)
    I: 0.01**4/12, # [m^4] Momento de inercia para una sección cuadrada de 1cm x 1cm
    L: 1.3,        # [m]   Longitud de la viga (m)
}
E, I, L = vals[E], vals[I], vals[L]

# Se crean las funciones lambda para evaluar V, M, t y v numéricamente
M_lam = sp.lambdify([x, P, q], M_sym.subs(vals), 'numpy')
t_lam = sp.lambdify([x, P, q], t_sym.subs(vals), 'numpy')
v_lam = sp.lambdify([x, P, q], v_sym.subs(vals), 'numpy')

# Calcular la carga crítica de pandeo de Euler
P_cr = (np.pi**2 * E*I)/(L**2)
print(f"Carga crítica de pandeo (P_cr): {P_cr/1000:.2f} kN")

# Crear el rango completo para P; excluyendo 0 para evitar división por cero 
# en las funciones dependientes de P
P = np.linspace(0.05, 0.9999*P_cr, 200)

# Hacer los gráficos
fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle('Comportamiento de la viga-columna vs. Carga axial P', fontsize=16)

# Valores de la carga uniformemente distribuida q a evaluar
q_valores = [1, 10, 100, 1000, 10000] # [N/m] 

for q in q_valores:
    # Calcular M, t, v en los puntos de interés
    M_en_centro_luz = M_lam(L/2, P, q)
    t_en_apoyo_izq  = t_lam(0,   P, q)
    v_en_centro_luz = v_lam(L/2, P, q)

    # Etiqueta para la leyenda
    label = f'q = {q} N/m'

    # Dibujo 1: Deflexión máxima (en el centro de la luz)
    ax1.plot(P/1000, 1000*v_en_centro_luz, label=label)

    # Dibujo 2: Momento flector máximo (en el centro de la luz)
    ax2.plot(P/1000, M_en_centro_luz/1000, label=label)

    # Dibujo 3: Pendiente máxima (en el apoyo)
    ax3.plot(P/1000, t_en_apoyo_izq, label=label)


# Dibujo 1: Deflexión máxima (en el centro de la luz)
ax1.set_title('Deflexión en el centro de la luz vs. P')
ax1.set_xlabel('Carga Axial P (kN)')
ax1.set_ylabel('Deflexión v(L/2) (mm)')
ax1.axvline(P_cr/1000, color='red', linestyle='--', label='$P = P_{cr}$')
ax1.set_ylim(0, 1000)
ax1.legend()
ax1.grid(True)

# Dibujo 2: Momento flector máximo (en el centro de la luz)
ax2.set_title('Momento flector en el centro de la luz vs. P')
ax2.set_xlabel('Carga Axial P (kN)')
ax2.set_ylabel('Momento flector M(L/2) (kN·m)')
ax2.axvline(P_cr/1000, color='red', linestyle='--', label='$P = P_{cr}$')
ax2.set_ylim(-4, 0)
ax2.legend()
ax2.grid(True)

# Dibujo 3: Pendiente máxima (en el apoyo)
ax3.set_title('Pendiente en el apoyo vs. P')
ax3.set_xlabel('Carga Axial P (kN)')
ax3.set_ylabel('Pendiente t(0) (radianes)')
ax3.axvline(P_cr/1000, color='red', linestyle='--', label='$P = P_{cr}$')
ax3.set_ylim(0, 3)
ax3.legend()
ax3.grid(True)

plt.tight_layout()
plt.show()