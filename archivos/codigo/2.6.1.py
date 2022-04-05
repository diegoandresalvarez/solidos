import sympy as sp

sp.init_printing()

# Se definen las variables
#sx, sy, sz, txy, txz, tyz = sp.symbols('sx, sy, sz, txy, txz, tyz')
sx,  sy,  sz  = sp.symbols('sigma_x, sigma_y, sigma_z')
txy, txz, tyz = sp.symbols('tau_xy, tau_xz, tau_yz')
alpha1, alpha2, alpha3    = sp.symbols('alpha1:4')
beta1,  beta2,  beta3     = sp.symbols('beta1:4')
gamma1, gamma2, gamma3    = sp.symbols('gamma1:4')

# Se define la matriz de tensiones en coordenadas rectangulares sigma
sigma = sp.Matrix([[ sx,  txy, txz ],
                   [ txy, sy,  tyz ],
                   [ txz, tyz, sz  ]])

# Se define la matriz de transformación T
T = sp.Matrix([[ alpha1, alpha2, alpha3 ],
               [ beta1,  beta2,  beta3  ],
               [ gamma1, gamma2, gamma3 ]])

# Se calcula la matriz de tensiones sigmaP en el sistema de coordenadas
# especificado por los vectores definidos en la matriz T
sigmaP = T.T * sigma * T

# Se extraen los términos de la matriz de tensiones sigmaP
sxp   = sp.expand(sigmaP[1-1, 1-1]) # elemento 1,1 de la matriz sigmaP
syp   = sp.expand(sigmaP[2-1, 2-1])
szp   = sp.expand(sigmaP[3-1, 3-1])
typzp = sp.expand(sigmaP[2-1, 3-1]) # elemento 2,3 de la matriz sigmaP
txpzp = sp.expand(sigmaP[1-1, 3-1])
txpyp = sp.expand(sigmaP[1-1, 2-1])

# Se organizan las ecuaciones anteriores en una matriz
T_sigma, _ = sp.linear_eq_to_matrix([sxp, syp, szp, typzp, txpzp, txpyp],
                                                   [sx, sy, sz, tyz, txz, txy])
