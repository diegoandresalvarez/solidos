import numpy as np
import matplotlib.pyplot as plt

def comet(x,y=None, time=1e-7):
    """
    Displays a comet plot
 
    # https://sukhbinder.wordpress.com/2021/09/15/comet-plot-in-python/
    """
    x = np.asarray(x)
    plt.ion()
    plt.xlim(x.min(), x.max())
    if y is not None:
        y = np.asarray(y)
        plt.ylim(y.min(), y.max())
    else:
        plt.ylim(0, len(x))
    if y is not None:
        plot = plt.plot(x[0], y[0])[0]
    else:
        plot = plt.plot(x[0])[0]
 
    for i in range(len(x)+1):
        if y is not None:
            plot.set_data(x[0:i], y[0:i])
        else:
            plot.set_xdata(x[0:i])
        plt.draw()
        plt.pause(time)
    plt.ioff()


t = np.linspace(0, 2*np.pi, 1000)
x = np.cos(5*t)
y = np.sin(7*t)

plt.figure()
plt.xlabel('x(t)')
plt.ylabel('y(t)')
plt.title('Ecuación paramétrica de Lissajous');
plt.gca().set_aspect('equal', adjustable='box')
plt.plot(x, y);      # grafica la curva paramétrica
comet(x, y);         # este comando muestra el sentido de la curva
plt.show()
