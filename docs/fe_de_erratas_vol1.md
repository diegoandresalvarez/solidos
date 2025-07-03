# Fe de erratas

A continuación presento la *fe de erratas* del libro

> Álvarez-Marín, D. A. (2023). Teoría de la Elasticidad usando Matlab y Maxima (volumen 1: fundamentos). Departamento de Ingeniería Civil, Facultad de Ingeniería y Arquitectura, Universidad Nacional de Colombia - Sede Manizales. ISBN 978-958-505-376-2. https://repositorio.unal.edu.co/handle/unal/84682

## Página 63

**En vez de:**

Luego, el ángulo $2\theta_1$ está dado por $\arctan(-6/-3) + \pi$, es decir, $4.2487$ radianes o alternativamente $4.2487 - 2\pi = -2.0344$ radianes; así, $\theta_1 = 2.1244$ radianes $\equiv$ $-1.0172$ radianes (o sea, $121.72^\circ$ o $-58.28^\circ$).

**Debe decir:**
Luego, el ángulo $2\theta_1$ está dado por $\arctan(-6/-3) - \pi$, es decir, $-2.0344$ radianes; así, $\theta_1 = -1.0172 \text{ radianes } \equiv -58.28^\circ$.


## Página 72

**En vez de:**

en Gere y Timoshenko (1986, sección 79) ...

**Debe decir:**

en Timoshenko y Goodier (1970, sección 79) ...



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

## Página 271

**En vez de:**

Caso 1: ... se tiene que $b_z = 0$ y que $\sigma_z$ es constante y no necesariamente igual a cero, pues de lo contrario existiría una variación de $\sigma_z$ con $z$ ...

**Debe decir:**

Caso 1: ... se tiene que $b_z = 0$, pues de lo contrario existiría una variación de $\sigma_z$ con $z$ ...

---

**En vez de:**

Caso 2: ... De lo anterior se deduce que $b_\theta = 0$ y que $\sigma_\theta$ es constante, pues de lo contrario existiría una variación de $\sigma_\theta$ con $\theta$ ...

**Debe decir:**

Caso 2: ... De lo anterior se deduce que $b_\theta = 0$, pues de lo contrario existiría una variación de $\sigma_\theta$ con $\theta$ ...

## Página 272

**En vez de:**

Caso 3: ... En consecuencia, se tendrá que tanto $\sigma_z$ como $\sigma_\theta$ son constantes y que $b_z=b_\theta=0$ y ...

**Debe decir:**

Caso 3: ... En consecuencia, se tendrá que $b_z=b_\theta=0$ y ...

## Página 294

**En vez de:**

Caso 1: Recuerde que, en este caso, $\sigma_z = \text{constante}$ y $\tau_{rz} = \tau_{\theta z} = 0$.

**Debe decir:**

Caso 1: Recuerde que, en este caso, $\tau_{rz} = \tau_{\theta z} = 0$.

**En vez de:**

Caso 2: Recuerde que, en este caso, $\sigma_\theta = \text{constante}$ y $\tau_{r\theta} = \tau_{\theta z} = 0$.

**Debe decir:**

Caso 2: Recuerde que, en este caso, $\tau_{r\theta} = \tau_{\theta z} = 0$.
