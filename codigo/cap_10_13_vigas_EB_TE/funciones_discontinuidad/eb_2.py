import sympy as sp
from sympy.abc import x

sp.init_printing()

# %% Se definen las cargas distribuidas de acuerdo con la Tabla   
# Caso 2: carga puntual 
qpunt = lambda p,a : p*sp.DiracDelta(x-a)

# Caso 5: carga distribuida variable 
qdist = lambda f,a,b : sp.Piecewise((f, (a < x) & (x < b)), (0, True))

# Funcion rectangular: si x>a y x<b retorne 1 sino retorne 0   
rect = lambda a,b : sp.Piecewise((1, (a < x) & (x < b)), (0, True))

# Se define una función que hace el código más corto y legible
integre = lambda f, x : sp.integrate(f, x, meijerg=False)

# %%  Se define la geometría de la viga y las propiedades del material
b = 0.1           # Ancho de la viga, m                       
h = 0.3           # Altura de la viga, m                      
E = 210e6         # Módulo de elasticidad de la viga, kPa     
I = (b*h*h*h)/12  # Momento de inercia en z, m^4              

# %% FORMA 1:
# Momento flector
mflec = lambda m,a : -m*sp.DiracDelta(x-a, 1)
    
# Se especifica el vector de cargas q(x)     
q = qpunt(-5,1) + qdist(-3*x/2,2,4) + mflec(-8,3.5) + mflec(3,5)

# Se resuelve la ecuación diferencial
C1, C2, C3, C4 = sp.symbols('C1 C2 C3 C4')
V = integre(q, x)       + C1
M = integre(V, x)       + C2
t = integre(M/(E*I), x) + C3
v = integre(t, x)       + C4

# %% FORMA 2:
'''
# Integral del momento flector
int_mflec = lambda m,a : -m*sp.DiracDelta(x-a)

# Se descompone el vector de cargas q(x)     
q_sin_momento = qpunt(-5,1) + qdist(-3*x/2,2,4)
int_momentos  = int_mflec(-8,3.5) + int_mflec(3,5)

# Se resuelve la ecuación diferencial
C1, C2, C3, C4 = sp.symbols('C1 C2 C3 C4')
V = integre(q_sin_momento, x) + int_momentos + C1
M = integre(V, x)                            + C2
t = integre(M/(E*I), x)                      + C3
v = integre(t, x)                            + C4
'''

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
print(f"Fy(x=0) = {float(+V.subs(x, 0))} kN") # Ry en x=0
print(f"Fy(x=6) = {float(-V.subs(x, 6))} kN") # Ry en x=6
