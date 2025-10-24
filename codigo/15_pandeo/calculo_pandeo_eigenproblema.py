import numpy as np
from scipy.linalg import eigh
import matplotlib.pyplot as plt

# Raíces precalculadas de tan(x)=x para el caso empotrado-articulado
phi = [np.nan, 4.4934094579, 7.7252518369, 10.9041216594, 14.0661939128]

# Raíces de 2 - kL*sin(kL) - 2cos(kL) = 0 para el caso empotrado-empotrado
knL_ee = [np.nan, 2*np.pi, 2*phi[1], 4*np.pi, 2*phi[2]]

# %% Cálculo de carga crítica analítica
def P_cr_analitico(cond_apoyo, n, L=1.0, E=1.0, I=1.0):
    match cond_apoyo:
        case 'articulado-articulado':
            P_cr = (n**2 * np.pi**2 * E*I)/L**2
        case 'empotrado-empotrado':
            P_cr = (knL_ee[n]**2 * E*I)/L**2
        case 'empotrado-libre':
            P_cr = ((2*n-1)**2 * np.pi**2 * E*I)/(4*L**2)
        case 'empotrado-articulado':
            P_cr = (phi[n]**2 * E*I)/L**2
        case _:
            raise ValueError("Tipo de condición de apoyo desconocida")
    return P_cr

# %% Modo de pandeo analítico
def modo_pandeo_analitico(cond_apoyo, x, n, L=1.0):
    match cond_apoyo:
        case 'articulado-articulado':
            vx = np.sin(n*np.pi*x/L)
        case 'empotrado-empotrado':
            knL = knL_ee[n]
            kn = knL/L
            if n%2 != 0:  # n = 1, 3, 5, 7, ...
                # Forma modal simplificada
                vx = np.cos(kn*x) - 1
            else:         # n = 2, 4, 6, 8, ...
                # Forma modal general
                vx = np.cos(kn*x) - 1 - \
                    ((np.sin(kn*x) - kn*x)/(np.sin(knL) - knL))*(np.cos(knL) - 1)
        case 'empotrado-libre':
            vx = np.cos((2*n - 1)*np.pi*x/(2*L)) - 1
        case 'empotrado-articulado':
            kn = phi[n]/L
            vx = np.sin(kn*x) - kn*L*np.cos(kn*x) + kn*(L - x)
        case _:
            raise ValueError("Tipo de condición de apoyo desconocida")
    return vx

# %% Resolver el problema de pandeo
def resolver_pandeo(cond_apoyo, N, L=1.0, E=1.0, I=1.0):
    """
    Resuelve el problema de pandeo de columna para los primeros cuatro modos
    usando el método de las diferencias finitas.

    Calcula numéricamente las cargas críticas y los modos de pandeo asociados
    """
    # Definición del paso de la malla
    h = L/(N + 1)

    # Extraer condiciones de apoyo izquierda y derecha
    apoyo_izq, apoyo_der = cond_apoyo.split('-')

    # Construcción de las matrices de rigidez elástica y geométrica Ke y Kg
    if apoyo_der == 'libre':
        Ke = np.zeros((N+1, N+1))
        Kg = np.zeros((N+1, N+1))
    else:
        Ke = np.zeros((N, N))
        Kg = np.zeros((N, N))

    # Condición de apoyo izquierda
    match apoyo_izq:
        case 'articulado':
            Ke[0, [0, 1, 2   ]] = [5, -4, 1]
            Ke[1, [0, 1, 2, 3]] = [-4, 6, -4, 1]
            Kg[0, [0, 1      ]] = [2, -1]
        case 'empotrado':
            Ke[0, [0, 1, 2   ]] = [7, -4, 1]
            Ke[1, [0, 1, 2, 3]] = [-4, 6, -4, 1]
            Kg[0, [0, 1      ]] = [2, -1]
        case _:
            raise ValueError("Condición de apoyo izquierda desconocida")

    # Discretización de la ecuación diferencial con diferencias finitas
    # para el nodo interior "i"
    if apoyo_der == 'libre':
        for i in range(2, N-1):
            Ke[i, i-2:i+3] = [1, -4, 6, -4, 1]
        for i in range(1, N):
            Kg[i, i-1:i+2] = [-1, 2, -1]
    else:
        for i in range(2, N-2):
            Ke[i, i-2:i+3] = [1, -4, 6, -4, 1]
        for i in range(1, N-1):
            Kg[i, i-1:i+2] = [-1, 2, -1]

    # Condición de apoyo derecha
    match apoyo_der:
        case 'articulado':
            Ke[N-1, [     N-3, N-2, N-1]] = [1, -4, 5]
            Ke[N-2, [N-4, N-3, N-2, N-1]] = [1, -4, 6, -4]
            Kg[N-1, [          N-2, N-1]] = [-1, 2]
        case 'empotrado':
            Ke[N-1, [     N-3, N-2, N-1]] = [1, -4, 7]
            Ke[N-2, [N-4, N-3, N-2, N-1]] = [1, -4, 6, -4]
            Kg[N-1, [          N-2, N-1]] = [-1, 2]
        case 'libre':
            Ke[  N, [     N-2, N-1, N  ]] = [1, -2, 1]
            Ke[N-1, [N-3, N-2, N-1, N  ]] = [1, -4, 5, -2]
            Kg[  N, [          N-1, N  ]] = [-1, 1]
        case _:
            raise ValueError("Condición de apoyo derecha desconocida")

    # Escalar las matrices de rigidez
    Ke *= E*I/h**4
    Kg *= 1/h**2

    # Resolver problema de eigenvalores generalizado
    # Con eigh() los valores propios ya son reales y están ordenados
    valp, vecp = eigh(Ke, Kg)

    # Seleccionar los primeros 4 modos de pandeo
    P_cr         = valp[  :4]
    modos_pandeo = vecp[:,:4]

    # Normalizar los modos de pandeo
    for i in range(4):
        modos_pandeo[:, i] /= np.max(np.abs(modos_pandeo[:, i]))

    return P_cr, modos_pandeo

# Se definen los parámetros del problema
N = 50          # Número de nodos internos en la discretización
E = 200e9       # [Pa]  Módulo de Young para el acero (200 GPa)
I = 0.01**4/12  # [m^4] Momento de inercia (sección cuadrada 1cm x 1cm)
L = 1.0         # [m]   Longitud de la viga

# Casos de condiciones de apoyo
casos = [ 'articulado-articulado', 'empotrado-empotrado', 
          'empotrado-libre', 'empotrado-articulado'      ]

# %% Resolver y graficar para cada caso de condiciones de apoyo
for caso in casos:
    print(f"\n--- CASO {caso.upper()} ---")

    # Obtener solución numérica
    P_cr_numerica, modos_pandeo = resolver_pandeo(caso, N=N, L=L, E=E, I=I)

    # Calcular soluciones analíticas
    P_cr_analitica = np.zeros(4)
    for i in range(4):
        P_cr_analitica[i] = P_cr_analitico(caso, n=i+1, L=L, E=E, I=I)

    # Tabla comparativa entre Pcr numérica y analítica
    print(f"{'Modo':>4} | {'P_cr Numérica (kN)':>20} | "
          f"{'P_cr Analítica (kN)':>20} | {'Error (%)':>10}")
    print("-" * 65)
    error = 100*abs(P_cr_numerica - P_cr_analitica)/P_cr_analitica
    for i in range(4):
        print(f"{i+1:>4} | {P_cr_numerica[i]/1000:>20.5f} | "
              f"{P_cr_analitica[i]/1000:>20.5f} | {error[i]:>10.5f}")

    # Se grafica la comparación analítica vs numérica de los modos de pandeo
    fig, axs = plt.subplots(2, 2, figsize=(12, 8), sharex=True)
    fig.suptitle(f'Primeros cuatro modos de pandeo: {caso.title()}', fontsize=16)

    for i in range(4):
        ax = axs.flat[i]

        # Solución analítica (línea azul)
        x = np.linspace(0, L, N+2)
        y_an = modo_pandeo_analitico(caso, x, n=i+1, L=L)

        # Normalizar y graficar la forma analítica
        y_an_normalizada = y_an/np.max(np.abs(y_an))
        ax.plot(x, y_an_normalizada, 'b-', label='Solución analítica')

        # Solución numérica (puntos rojos)
        if caso == 'empotrado-libre':
            y_num = np.hstack([0, modos_pandeo[:, i]])
        else:
            y_num = np.hstack([0, modos_pandeo[:, i], 0])

        # Voltear si es necesario para coincidir con la orientación del modo
        # numérico. Si y_an y y_num tienen la misma orientación, los
        # productos son positivos; si tienen orientaciones opuestas, los
        # productos son negativos
        if np.sum(y_an * y_num) < 0:
            y_num *= -1
        ax.plot(x, y_num, 'r.', markersize=4, label='Diferencias finitas')

        ax.set_title(f'Modo de pandeo {i+1}')
        ax.grid(True)
        ax.set_ylabel("Deflexión Normalizada")

    axs.flat[0].legend()
    axs.flat[2].set_xlabel("Posición a lo largo de la columna (m)")
    axs.flat[3].set_xlabel("Posición a lo largo de la columna (m)")
    plt.tight_layout()
    plt.show()