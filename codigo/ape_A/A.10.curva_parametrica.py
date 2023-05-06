import numpy as np
import matplotlib.pyplot as plt
# %matplotlib qt5
import scipy.interpolate as interpolate

# Input the data points
n = 15           #number of data points

plt.figure()
plt.title(f'Click with the mouse {n} times. The interpolation will pass through those points')
plt.axis([-5, 5, -5, 5])
pts = np.asarray(plt.ginput(n, timeout=-1, mouse_stop=None))
xi, yi = pts[:,0], pts[:,1]
plt.close()

ti = np.linspace(0, 1, n)
t  = np.linspace(0, 1, 501)

x = interpolate.interp1d(ti, xi, kind='cubic')(t)
y = interpolate.interp1d(ti, yi, kind='cubic')(t)

plt.plot(xi, yi, 'ro', x, y, 'b-')

plt.legend(loc='best')
plt.ylim([-5, 5])
plt.show()
