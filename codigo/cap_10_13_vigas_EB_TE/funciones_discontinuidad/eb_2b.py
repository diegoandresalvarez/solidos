# -*- coding: utf-8 -*-
"""
EJEMPLO 2: VIGA SIMPLEMENTE APOYADA (EULER-BERNOULLI)
ESTADO DE CARGA DEFINIDO POR FUNCIONES DE DISCONTINUIDAD
"""


#import numpy as np
import sympy as sp
from sympy.abc import x
sp.interactive.printing.init_printing(use_latex=True)

# %%  Se define la geometría de la viga y las propiedades del material
b = 0.1           # Ancho de la viga, m                       
h = 0.3           # Altura de la viga, m                      
E = 210e6         # Módulo de elasticidad de la viga, kPa     
I = (b*h*h*h)/12  # Momento de inercia en z, m^4     

# %%
# Caso 1: momento flector
mflec = lambda m,a : -m*sp.SingularityFunction(x, a, -2)

# Caso 2: carga puntual 
qpunt = lambda p,a : p*sp.SingularityFunction(x, a, -1)

# Caso 6: carga distribuida trapezoidal
qtrapz = lambda q1,q2,a1,a2 : \
                           q1*sp.SingularityFunction(x, a1, 0) \
                         - q2*sp.SingularityFunction(x, a2, 0) \
                         + ((q2-q1)/(a2-a1))*(sp.SingularityFunction(x, a1, 1)
                                            - sp.SingularityFunction(x, a2, 1))

# %% Se especifica el vector de cargas q(x)     
q = qpunt(-5,1) + qtrapz(-3, -6, 2, 4) + mflec(-8,3.5) + mflec(3,5)

# %% Se resuelve la ecuación diferencial
C1, C2, C3, C4 = sp.symbols('C1 C2 C3 C4')
V = sp.integrate(q, x)       + C1
M = sp.integrate(V, x)       + C2
t = sp.integrate(M/(E*I), x) + C3
v = sp.integrate(t, x)       + C4

# %% Se encuentran las constantes de integración que satisfacen las 
# condiciones de frontera 
sol = sp.solve([ sp.Eq(v.subs(x,0), 0),   # despl vert en apoyo en x=0 es 0
                 sp.Eq(M.subs(x,0), 0),   # momento flector     en x=0 es 0
                 sp.Eq(v.subs(x,6), 0),   # despl vert en apoyo en x=6 es 0
                 sp.Eq(M.subs(x,6), 0) ], # momento flector     en x=6 es 0
                 [ C1, C2, C3, C4 ])

# %% Se reemplaza aquí el valor de las constantes de integración
V = V.subs(sol)
M = M.subs(sol)
t = t.subs(sol)
v = v.subs(sol)

# %% Se simplifica lo calculado por sympy
V = sp.piecewise_fold(V.rewrite(sp.Piecewise)).nsimplify()
M = sp.piecewise_fold(M.rewrite(sp.Piecewise)).nsimplify()
t = sp.piecewise_fold(t.rewrite(sp.Piecewise))
v = sp.piecewise_fold(v.rewrite(sp.Piecewise))

#V = V.rewrite(sp.Piecewise).simplify()
#M = M.rewrite(sp.Piecewise).simplify()
#t = t.rewrite(sp.Piecewise).simplify()
#v = v.rewrite(sp.Piecewise).simplify()

# %% Se imprimen los resultados 
print("\n\nV(x) = "); sp.pprint(V)
print("\n\nM(x) = "); sp.pprint(M)
print("\n\nt(x) = "); sp.pprint(t)
print("\n\nv(x) = "); sp.pprint(v)

# %% Se grafican los resultados 
x_xmin_xmax = (x, 0+0.001, 6-0.001)
sp.plot(V, x_xmin_xmax, xlabel='x', ylabel='V(x)')
sp.plot(M, x_xmin_xmax, xlabel='x', ylabel='M(x)')
sp.plot(t, x_xmin_xmax, xlabel='x', ylabel='t(x)')
sp.plot(v, x_xmin_xmax, xlabel='x', ylabel='v(x)')

# %% Se calculan las reacciones en la viga 
print(f"Fy(x=0) = {float(+V.subs(sol).subs(x, 0))}") # Ry en x=0 
print(f"Fy(x=6) = {float(-V.subs(sol).subs(x, 6))}") # Ry en x=6 
