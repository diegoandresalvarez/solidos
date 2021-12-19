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

# Se especifica el vector de cargas q(x)                       
q = qdist(-12,10,16) + qpunt(-30,5)

# %%  Se define la geometría de la viga y las propiedades del material
b = 0.1           # Ancho de la viga, m                       
h = 0.3           # Altura de la viga, m                      
E = 210e6         # Modulo de elasticidad de la viga, kPa     
I = (b*h*h*h)/12  # Momento de inercia en z, m^4              

# %% Se resuelve la ecuacion diferencial tramo por tramo
# Tramo 1
C1_1, C1_2, C1_3, C1_4 = sp.symbols('C1_1 C1_2 C1_3 C1_4')
q1 = q*rect(0,10)                           # restriccion de q al tramo 1   
V1 = sp.integrate(q1,x,       meijerg=False) + C1_1
M1 = sp.integrate(V1,x,       meijerg=False) + C1_2
t1 = sp.integrate(M1/(E*I),x, meijerg=False) + C1_3
v1 = sp.integrate(t1,x,       meijerg=False) + C1_4

# Tramo 2 
C2_1, C2_2, C2_3, C2_4 = sp.symbols('C2_1 C2_2 C2_3 C2_4')
q2 = q*rect(10,16)                           # restriccion de q al tramo 2   
V2 = sp.integrate(q2,x,       meijerg=False) + C2_1
M2 = sp.integrate(V2,x,       meijerg=False) + C2_2
t2 = sp.integrate(M2/(E*I),x, meijerg=False) + C2_3
v2 = sp.integrate(t2,x,       meijerg=False) + C2_4

# Tramo 3 
C3_1, C3_2, C3_3, C3_4 = sp.symbols('C3_1 C3_2 C3_3 C3_4')
q3 = q*rect(16,19)                           # restriccion de q al tramo 3   
V3 = sp.integrate(q3,x,       meijerg=False) + C3_1
M3 = sp.integrate(V3,x,       meijerg=False) + C3_2
t3 = sp.integrate(M3/(E*I),x, meijerg=False) + C3_3
v3 = sp.integrate(t3,x,       meijerg=False) + C3_4

# %% Se encuentran las constantes de integracion que satisfacen las 
# condiciones de frontera 
sol = sp.solve([ 
sp.Eq(v1.subs(x,0), 0),              # despl vert en apoyo en x=0 es 0  
sp.Eq(t1.subs(x,0), 0),              # theta en apoyo en x=0 es 0       

sp.Eq(v1.subs(x,10), 0),             # despl vert en apoyo en x=10 es 0 
sp.Eq(v2.subs(x,10), 0),             # despl vert en apoyo en x=10 es 0 
sp.Eq(t1.subs(x,10), t2.subs(x,10)), # continuidad en theta en x=10     
sp.Eq(M1.subs(x,10), M2.subs(x,10)), # continuidad en M     en x=10     

sp.Eq(v2.subs(x,16), 0),             # despl vert en apoyo en x=16 es 0 
sp.Eq(v3.subs(x,16), 0),             # despl vert en apoyo en x=16 es 0 
sp.Eq(t2.subs(x,16), t3.subs(x,16)), # continuidad en theta en x=16     
sp.Eq(M2.subs(x,16), M3.subs(x,16)), # continuidad en M     en x=16     

sp.Eq(M3.subs(x,19), 0),             # momento flector en x=19 es 0     
sp.Eq(V3.subs(x,19), 15) ],          # fuerza cortante en x=19 es 15    
[ C1_1, C1_2, C1_3, C1_4, 
  C2_1, C2_2, C2_3, C2_4, 
  C3_1, C3_2, C3_3, C3_4 ])

# %% Se fusionan las fórmulas y se reemplaza el valor de las constantes
V = (V1*rect(0,10) + V2*rect(10,16) + V3*rect(16,19)).subs(sol)
M = (M1*rect(0,10) + M2*rect(10,16) + M3*rect(16,19)).subs(sol)
t = (t1*rect(0,10) + t2*rect(10,16) + t3*rect(16,19)).subs(sol)
v = (v1*rect(0,10) + v2*rect(10,16) + v3*rect(16,19)).subs(sol)

V = sp.piecewise_fold(V.rewrite(sp.Piecewise))
M = sp.piecewise_fold(M.rewrite(sp.Piecewise))
t = sp.piecewise_fold(t.rewrite(sp.Piecewise))
v = sp.piecewise_fold(v.rewrite(sp.Piecewise))

# %% Se imprimen los resultados 
print("\n\nV(x) = "); sp.pprint(V)
print("\n\nM(x) = "); sp.pprint(M)
print("\n\nt(x) = "); sp.pprint(t)
print("\n\nv(x) = "); sp.pprint(v)

# %% Se grafican los resultados 
x_xmin_xmax = (x, 0+0.001, 19-0.001)
sp.plot(V, x_xmin_xmax, xlabel='x', ylabel='V(x)')
sp.plot(M, x_xmin_xmax, xlabel='x', ylabel='M(x)')
sp.plot(t, x_xmin_xmax, xlabel='x', ylabel='t(x)')
sp.plot(v, x_xmin_xmax, xlabel='x', ylabel='v(x)')

# %% Se calculan las reacciones en la viga 
'''
print("M(x= 0)  = ") -M1,      sol, x= 0, numer; # mom en x=0 
print("Fy(x= 0) = ") V1,       sol, x= 0, numer; # Ry en x= 0 
print("Fy(x=10) = ") V2-V1-25, sol, x=10, numer; # Ry en x=10 
print("Fy(x=16) = ") V3-V2,    sol, x=16, numer; # Ry en x=16 
'''
