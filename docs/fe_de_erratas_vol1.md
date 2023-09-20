# Fe de erratas

A continuación presento la *fe de erratas* del libro

> Álvarez-Marín, D. A. (2023a). Teoría de la Elasticidad usando Matlab y Maxima (volumen 1: fundamentos). Departamento de Ingeniería Civil, Facultad de Ingeniería y Arquitectura, Universidad Nacional de Colombia - Sede Manizales. ISBN 978-958-505-376-2. https://repositorio.unal.edu.co/handle/unal/84682


## Página 208

**En vez de:**

Considere una condición ... y $\gamma_{xy} = 2xy$, donde $a$ ...

**Debe decir:**

Considere una condición ... y $\gamma_{xy} = 4xy$, donde $a$ ...

## Página 227

**En vez de:**
```
df_dy : expand(ev(df_dy_dg_dx, x=0)) + w0;
dg_dx : expand(ev(df_dy_dg_dx, y=0)) - w0;
```

**Debe decir:**
```
terminos_constantes : ev(df_dy_dg_dx, x=0, y=0);
terminos_en_y       : ev(df_dy_dg_dx, x=0) - terminos_constantes;
terminos_en_x       : ev(df_dy_dg_dx, y=0) - terminos_constantes;
df_dy : expand(terminos_en_y + terminos_constantes) + w0;
dg_dx : expand(terminos_en_x) - w0;
```

## Página 242

**En vez de:**
```
df_dy : expand(df_dy_dg_dx) + w0, x=0;
dg_dx : expand(df_dy_dg_dx) - w0, y=0;
```

**Debe decir:**
```
terminos_constantes : ev(df_dy_dg_dx, x=0, y=0);
terminos_en_y       : ev(df_dy_dg_dx, x=0) - terminos_constantes;
terminos_en_x       : ev(df_dy_dg_dx, y=0) - terminos_constantes;
df_dy : expand(terminos_en_y + terminos_constantes) + w0;
dg_dx : expand(terminos_en_x) - w0;
```

## Página 243

**En vez de:**
$$v(x,y) = \frac{q x}{80 c^3E} \left(-48 c^2 x-30 c^2 \nu x+5 x^3+30 \nu x y^2+120 c^2 L+120 c^2 \nu L \right. \ldots$$

**Debe decir:**
$$v(x,y) = \frac{q x}{80 c^3E} \left(-48 c^2 x-30 c^2 \nu x+5 x^3+30 \nu x y^2+60 c^2 L+60 c^2 \nu L \right. \ldots$$
